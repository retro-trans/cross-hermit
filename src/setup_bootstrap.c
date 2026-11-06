#define UNICODE
#define _UNICODE
#include <windows.h>
#include <shellapi.h>
#include <wchar.h>

static int setup_exists(const wchar_t *root) {
 wchar_t p[32768];
 _snwprintf(p,32768,L"%ls\\ENSETUP\\SETUP.PS1",root);
 DWORD a=GetFileAttributesW(p);
 return a!=INVALID_FILE_ATTRIBUTES && !(a&FILE_ATTRIBUTE_DIRECTORY);
}

int WINAPI wWinMain(HINSTANCE a,HINSTANCE b,PWSTR c,int d) {
 wchar_t root[32768],powershell[32768],command[32768],log[32768],message[32768];
 wchar_t *probe=NULL; int argc=0; LPWSTR *argv=CommandLineToArgvW(GetCommandLineW(),&argc);
 (void)a;(void)b;(void)c;(void)d;
 if(!GetModuleFileNameW(NULL,root,32768))return 1;
 wchar_t *p=wcsrchr(root,L'\\');if(!p)return 2;
 if(p==root+2 && root[1]==L':')p[1]=0;else *p=0;
 int explicit_source=0;
 for(int i=1;i<argc;i++) {
  if(!wcscmp(argv[i],L"--source") && i+1<argc) {
   if(wcslen(argv[++i])>=32760)return 2;
   wcscpy(root,argv[i]);explicit_source=1;
  } else if(!wcscmp(argv[i],L"--startup-probe") && i+1<argc)probe=argv[++i];
  else return 2;
 }
 /* The standalone repair can use the one mounted English disc. */
 if(!explicit_source && !setup_exists(root)) {
  wchar_t drives[256],found[4]=L""; int matches=0;
  DWORD n=GetLogicalDriveStringsW(256,drives);
  if(n && n<256)for(wchar_t *drive=drives;*drive;drive+=wcslen(drive)+1) {
   if(GetDriveTypeW(drive)==DRIVE_CDROM && setup_exists(drive)) {wcscpy(found,drive);matches++;}
  }
  if(matches==1)wcscpy(root,found);
 }
 if(!setup_exists(root)) {
  MessageBoxW(NULL,L"Mount the patched English ISO, then run SETUP.EXE from that disc.",L"Cross Hermit setup",MB_OK|MB_ICONERROR);
  return 3;
 }
 GetSystemDirectoryW(powershell,32768);
 wcscat(powershell,L"\\WindowsPowerShell\\v1.0\\powershell.exe");
 if(GetTempPathW(32768,log)==0)return 4;
 p=log+wcslen(log);
 _snwprintf(p,32768-wcslen(log),L"CrossHermit-Setup-%lu-%llu.log",GetCurrentProcessId(),GetTickCount64());
 SECURITY_ATTRIBUTES sa={sizeof(sa),NULL,TRUE};
 HANDLE output=CreateFileW(log,GENERIC_WRITE,FILE_SHARE_READ,&sa,CREATE_NEW,FILE_ATTRIBUTE_NORMAL,NULL);
 HANDLE input=CreateFileW(L"NUL",GENERIC_READ,FILE_SHARE_READ|FILE_SHARE_WRITE,&sa,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL);
 if(output==INVALID_HANDLE_VALUE || input==INVALID_HANDLE_VALUE)return 4;
 int count=_snwprintf(command,32768,L"\"%ls\" -NoProfile -STA -ExecutionPolicy Bypass -File \"%ls\\ENSETUP\\SETUP.PS1\"",powershell,root);
 if(count<0 || (probe && _snwprintf(command+count,32768-count,L" -StartupProbe \"%ls\"",probe)<0))return 5;
 /* Use the stock Windows PowerShell modules, without changing the system environment. */
 SetEnvironmentVariableW(L"PSModulePath",NULL);
 STARTUPINFOW si={0};PROCESS_INFORMATION pi={0};si.cb=sizeof(si);
 si.dwFlags=STARTF_USESTDHANDLES;si.hStdInput=input;si.hStdOutput=output;si.hStdError=output;
 /* CREATE_NO_WINDOW removes only the console. SW_HIDE also hid the WinForms installer. */
 BOOL started=CreateProcessW(powershell,command,NULL,NULL,TRUE,CREATE_NO_WINDOW,NULL,root,&si,&pi);
 DWORD error=GetLastError();CloseHandle(input);CloseHandle(output);
 if(!started) {
  _snwprintf(message,32768,L"Could not start setup (Windows error %lu).",error);
  MessageBoxW(NULL,message,L"Cross Hermit setup",MB_OK|MB_ICONERROR);return 6;
 }
 CloseHandle(pi.hThread);WaitForSingleObject(pi.hProcess,INFINITE);
 DWORD code=1;GetExitCodeProcess(pi.hProcess,&code);CloseHandle(pi.hProcess);
 if(code) {
  _snwprintf(message,32768,L"Setup could not finish. Details were saved to:\n\n%ls",log);
  MessageBoxW(NULL,message,L"Cross Hermit setup",MB_OK|MB_ICONERROR);
 } else if(GetFileAttributesW(log)!=INVALID_FILE_ATTRIBUTES) {
  WIN32_FILE_ATTRIBUTE_DATA info;
  if(GetFileAttributesExW(log,GetFileExInfoStandard,&info) && !info.nFileSizeHigh && !info.nFileSizeLow)DeleteFileW(log);
 }
 LocalFree(argv);return (int)code;
}
