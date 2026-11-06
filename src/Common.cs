using System;
using System.IO;
using System.Text;
using System.Linq;
using System.Collections.Generic;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Web.Script.Serialization;
using Microsoft.Win32;
[assembly:System.Reflection.AssemblyVersion("0.8.0.0")]
[assembly:System.Reflection.AssemblyFileVersion("0.8.0.0")]
[assembly:System.Reflection.AssemblyCompany("Retro Trans")]
[assembly:System.Reflection.AssemblyProduct("Cross Hermit English")]

namespace CrossHermit {
 public static class Core {
  public const string Version="0.8.0", Product="CrossHermitEnglish";
  public const string GameHash="ab1aea7af2d698488f7cc27a7a32a324c26898e931bbcd5bf7715c168fc02e2b";
  public static readonly JavaScriptSerializer Json=new JavaScriptSerializer {MaxJsonLength=67108864};
  public static readonly UTF8Encoding Utf8=new UTF8Encoding(false);
  public static string Quote(string s) { var b=new StringBuilder("\"");int n=0;foreach(char c in s){if(c=='\\'){n++;continue;}if(c=='"'){b.Append('\\',n*2+1);b.Append('"');}else{b.Append('\\',n);b.Append(c);}n=0;}b.Append('\\',n*2);return b.Append('"').ToString(); }
  public static string Arg(string[] a,string key,string fallback) {int i=Array.IndexOf(a,key);return i>=0&&i+1<a.Length?a[i+1]:fallback;}
  public static bool Has(string[] a,string key){return Array.IndexOf(a,key)>=0;}
  public static string Hash(string p){using(var s=File.OpenRead(p))using(var h=SHA256.Create())return BitConverter.ToString(h.ComputeHash(s)).Replace("-","").ToLowerInvariant();}
  public static Dictionary<string,object> Read(string p){return Json.Deserialize<Dictionary<string,object>>(File.ReadAllText(p));}
  public static void Write(string p,object value){Atomic(p,Utf8.GetBytes(Json.Serialize(value)+"\n"));}
  public static void Atomic(string p,byte[] data){Directory.CreateDirectory(Path.GetDirectoryName(p));string t=p+"."+Guid.NewGuid().ToString("N")+".tmp";try{File.WriteAllBytes(t,data);if(File.Exists(p))File.Replace(t,p,null);else File.Move(t,p);}finally{if(File.Exists(t))File.Delete(t);}}
  public static string Full(string p){return Path.GetFullPath(p).TrimEnd(Path.DirectorySeparatorChar,Path.AltDirectorySeparatorChar);}
  public static bool Same(string a,string b){return !String.IsNullOrEmpty(a)&&!String.IsNullOrEmpty(b)&&String.Equals(Full(a),Full(b),StringComparison.OrdinalIgnoreCase);}
  public static bool Inside(string p,string root){return !String.IsNullOrEmpty(p)&&!String.IsNullOrEmpty(root)&&Full(p).StartsWith(Full(root)+Path.DirectorySeparatorChar,StringComparison.OrdinalIgnoreCase);}
  public static void NoLinks(string p){for(string q=Path.GetFullPath(p);q!=null;q=Path.GetDirectoryName(q)){if((File.Exists(q)||Directory.Exists(q))&&(File.GetAttributes(q)&FileAttributes.ReparsePoint)!=0)throw new IOException("A linked file or folder is not supported: "+q);}}
  public static string Child(string root,string relative){if(String.IsNullOrEmpty(relative)||Path.IsPathRooted(relative)||relative.Contains(":"))throw new IOException("Unsafe relative file path.");string p=Path.GetFullPath(Path.Combine(root,relative.Replace('/',Path.DirectorySeparatorChar)));if(!Inside(p,root))throw new IOException("File path leaves the installation.");NoLinks(p);return p;}
  public static List<string> Files(string root){NoLinks(root);var result=new List<string>();var stack=new Stack<string>();stack.Push(root);while(stack.Count>0){string d=stack.Pop();foreach(string f in Directory.GetFiles(d)){NoLinks(f);result.Add(f);}foreach(string c in Directory.GetDirectories(d)){NoLinks(c);stack.Push(c);}}return result;}
  public static string Relative(string root,string p){if(!Inside(p,root))throw new IOException("Not an installation file.");return Full(p).Substring(Full(root).Length+1).Replace('\\','/');}
  public static bool Personal(string n){n=n.Replace('\\','/').ToLowerInvariant();return n.StartsWith("savedata/")||n=="option.bin"||n=="dgvoodoo.conf"||n=="crosshermitui.ini"||n=="crosshermitskills.ini"||n=="englishpatch/settings.json"||n=="englishpatch/compatibility.json"||n.StartsWith("englishpatch/logs/")||n.StartsWith("englishpatch/dumps/")||n.StartsWith("englishpatch/updatebackups/");}
  public static void AssertGameClosed(){if(Process.GetProcessesByName("Cross Hermit").Length>0||Process.GetProcessesByName("CrossHermit").Length>0)throw new IOException("Save and close Cross Hermit first.");}
  public static void ValidateRoot(string root){root=Full(root);NoLinks(root);if(root.Length<12||Same(root,Path.GetPathRoot(root))||Same(root,Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)))throw new IOException("Unsafe installation location.");if(!File.Exists(Path.Combine(root,"EnglishPatch/installation.json"))||!File.Exists(Path.Combine(root,"Cross Hermit.exe"))||Hash(Path.Combine(root,"Cross Hermit.exe"))!=GameHash)throw new IOException("This is not a supported Cross Hermit English installation.");}
  public static string InstalledVersion(string root){try{string v=Convert.ToString(Read(Path.Combine(root,"EnglishPatch/installation.json"))["game_version"]);if(System.Text.RegularExpressions.Regex.IsMatch(v,@"^0\.\d+\.\d+$"))return v;}catch{}return "Unknown";}
  public static void RegisterPaths(string root){using(var k=Registry.CurrentUser.CreateSubKey(@"Software\Enterbrain\Cross Hermit")){k.SetValue("Ver.",65536,RegistryValueKind.DWord);foreach(string n in new[]{"InstallPath","VoicePath","CdromPath"})k.SetValue(n,Full(root)+"\\");}}
  public static Process Hidden(string exe,string args,string cwd){return Process.Start(new ProcessStartInfo(exe,args){WorkingDirectory=cwd,UseShellExecute=false,CreateNoWindow=true,WindowStyle=ProcessWindowStyle.Hidden});}
  public static string PowerShell {get{return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.System),@"WindowsPowerShell\v1.0\powershell.exe");}}
 }
 public sealed class Settings {
  public string displayMode="borderless",resolution="desktop",battlefield="wide";public bool showOnLaunch=true;
  public static Settings Load(string p){var s=new Settings();if(File.Exists(p)){var d=Core.Read(p);object v;if(d.TryGetValue("displayMode",out v))s.displayMode=Convert.ToString(v);if(d.TryGetValue("resolution",out v))s.resolution=Convert.ToString(v);if(d.TryGetValue("battlefield",out v))s.battlefield=Convert.ToString(v);if(d.TryGetValue("showOnLaunch",out v)){if(!(v is bool))throw new IOException("Invalid launch preference.");s.showOnLaunch=(bool)v;}}s.Validate();return s;}
  public void Validate(){if(displayMode!="borderless"&&displayMode!="windowed")throw new IOException("Invalid display mode.");if(battlefield!="wide"&&battlefield!="classic")throw new IOException("Invalid battlefield layout.");if(resolution!="desktop"){var m=System.Text.RegularExpressions.Regex.Match(resolution,@"^(\d{3,4})x(\d{3,4})$");if(!m.Success)throw new IOException("Invalid resolution.");int w=Int32.Parse(m.Groups[1].Value),h=Int32.Parse(m.Groups[2].Value);if(w<1024||w>7680||h<720||h>4320)throw new IOException("Unsupported resolution.");}}
  public void Save(string p){Validate();Core.Write(p,this);}
  public static string Ini(string text,string section,string key,string value){string newline=text.Contains("\r\n")?"\r\n":"\n";var lines=System.Text.RegularExpressions.Regex.Split(text,"\\r?\\n").ToList();int start=-1,end=lines.Count;for(int i=0;i<lines.Count;i++){if(System.Text.RegularExpressions.Regex.IsMatch(lines[i],@"^\s*\["+System.Text.RegularExpressions.Regex.Escape(section)+@"\]\s*$",System.Text.RegularExpressions.RegexOptions.IgnoreCase)){start=i;continue;}if(start>=0&&System.Text.RegularExpressions.Regex.IsMatch(lines[i],@"^\s*\[")){end=i;break;}}if(start<0){lines.Add("["+section+"]");lines.Add(key+" = "+value);}else{var found=new List<int>();for(int i=start+1;i<end;i++)if(System.Text.RegularExpressions.Regex.IsMatch(lines[i],@"^\s*"+System.Text.RegularExpressions.Regex.Escape(key)+@"\s*=",System.Text.RegularExpressions.RegexOptions.IgnoreCase))found.Add(i);if(found.Count>1)throw new IOException("Duplicate setting: "+section+"/"+key);if(found.Count==1)lines[found[0]]=key+" = "+value;else lines.Insert(end,key+" = "+value);}return String.Join(newline,lines);}
  public Dictionary<string,byte[]> Plan(string root,string desktop){Validate();if(!System.Text.RegularExpressions.Regex.IsMatch(desktop,@"^\d{3,4}x\d{3,4}$"))throw new IOException("Desktop resolution unavailable.");string dg=File.ReadAllText(Path.Combine(root,"dgVoodoo.conf")),ui=File.ReadAllText(Path.Combine(root,"CrossHermitUI.ini"));string[,] rows={{"General","FullScreenMode",displayMode=="windowed"?"false":"true"},{"General","ScalingMode","stretched_ar"},{"General","KeepWindowAspectRatio","true"},{"GeneralExt","FullscreenAttributes","fake"},{"GeneralExt","DesktopResolution",desktop},{"DirectX","Resolution",resolution=="desktop"?desktop:resolution},{"DirectX","AppControlledScreenMode","false"}};for(int i=0;i<rows.GetLength(0);i++)dg=Ini(dg,rows[i,0],rows[i,1],rows[i,2]);ui=Ini(ui,"Display","TitleWidescreen",battlefield=="wide"?"true":"false");return new Dictionary<string,byte[]> {{"dgVoodoo.conf",Core.Utf8.GetBytes(dg)},{"CrossHermitUI.ini",Core.Utf8.GetBytes(ui)}};}
  public void Apply(string root,string desktop){Core.AssertGameClosed();var plan=Plan(root,desktop);var old=new Dictionary<string,byte[]>();var written=new List<string>();foreach(var x in plan)old[x.Key]=File.ReadAllBytes(Path.Combine(root,x.Key));try{foreach(var x in plan){Core.Atomic(Path.Combine(root,x.Key),x.Value);written.Add(x.Key);}}catch{foreach(string n in written)Core.Atomic(Path.Combine(root,n),old[n]);throw;}}
 }
}
