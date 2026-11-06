param([string]$Destination='', [string]$SourceRoot='', [switch]$Plan, [switch]$NoGui,
      [switch]$NoRegister, [switch]$NoShortcut, [string]$RenderPreview='', [string]$StartupProbe='')
$ErrorActionPreference='Stop'
if(-not $SourceRoot){$SourceRoot=Split-Path -Parent $PSScriptRoot}
$SourceRoot=[IO.Path]::GetFullPath($SourceRoot)
$setup=Join-Path $SourceRoot 'ENSETUP'
$manifest=Get-Content -LiteralPath (Join-Path $setup 'MANIFEST.JSN') -Raw|ConvertFrom-Json
. (Join-Path $setup 'DISCSUP.PS1')
if(-not $Destination){$Destination=Join-Path $env:LOCALAPPDATA 'Programs\Cross Hermit English'}
function Write-CHSetupStatus233([string]$Text){if($script:status){$script:status.Text=$Text;[Windows.Forms.Application]::DoEvents()}else{Write-Output $Text}}
function Assert-CHHash233([string]$Path,[string]$Hash){if(-not(Test-Path -LiteralPath $Path -PathType Leaf) -or (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -ine $Hash){throw ('File verification failed: '+[IO.Path]::GetFileName($Path))}}
function Expand-CHZip233([string]$Path,[string]$Target) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip=[IO.Compression.ZipFile]::OpenRead($Path);$seen=@{};$prefix=[IO.Path]::GetFullPath($Target).TrimEnd('\')+'\'
    try {foreach($entry in $zip.Entries){
        $name=$entry.FullName.Replace('/','\')
        if([IO.Path]::IsPathRooted($name) -or $name.Contains(':') -or @($name.Split('\')|Where-Object {$_ -in @('.','..')}).Count){throw 'Unsafe ZIP path.'}
        $dest=[IO.Path]::GetFullPath((Join-Path $Target $name));if(-not $dest.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)){throw 'ZIP path escapes destination.'}
        if($seen.ContainsKey($dest)){throw 'Duplicate ZIP path.'};$seen[$dest]=$true
        if(-not $entry.Name){$null=[IO.Directory]::CreateDirectory($dest);continue}
        if($name -match '^(SaveData\\|Option\.bin$|EnglishPatch\\(settings|compatibility)\.json$)'){throw 'Package unexpectedly contains user files.'}
        $null=[IO.Directory]::CreateDirectory((Split-Path -Parent $dest));[IO.Compression.ZipFileExtensions]::ExtractToFile($entry,$dest,$true)
    }}finally{$zip.Dispose()}
}
function Set-CHShortcuts234([string]$GameFolder,[string]$Desktop=[Environment]::GetFolderPath('Desktop'),[string]$Programs=[Environment]::GetFolderPath('Programs')) {
    $shell=New-Object -ComObject WScript.Shell
    $menu=Join-Path $Programs 'Cross Hermit English';$null=[IO.Directory]::CreateDirectory($menu)
    foreach($row in @(@((Join-Path $Desktop 'Cross Hermit English.lnk'),'Launcher.exe',''),@((Join-Path $menu 'Cross Hermit English.lnk'),'Launcher.exe',''),@((Join-Path $menu 'Configure Cross Hermit.lnk'),'Launcher.exe','--settings'),@((Join-Path $menu 'Uninstall Cross Hermit.lnk'),'Uninstall.exe',''))){
        $link=$shell.CreateShortcut($row[0]);$link.TargetPath=Join-Path $GameFolder $row[1];$link.Arguments=$row[2]
        $link.WorkingDirectory=$GameFolder;$link.IconLocation=(Join-Path $GameFolder 'Launcher.exe')+',0';$link.Description='Cross Hermit English';$link.Save()
    }
}
function Register-CHUninstall080([string]$GameFolder,[string]$RegistryPath='HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\CrossHermitEnglish') {
    $null=New-Item -Path $RegistryPath -Force
    $values=@{DisplayName='Cross Hermit English';DisplayVersion='0.8.0';Publisher='Retro Trans';InstallLocation=$GameFolder;DisplayIcon=(Join-Path $GameFolder 'Launcher.exe');UninstallString=('"'+(Join-Path $GameFolder 'Uninstall.exe')+'"');QuietUninstallString=('"'+(Join-Path $GameFolder 'Uninstall.exe')+'" --quiet')}
    foreach($n in $values.Keys){$null=New-ItemProperty -LiteralPath $RegistryPath -Name $n -Value $values[$n] -PropertyType String -Force}
    foreach($n in @('NoModify','NoRepair')){$null=New-ItemProperty -LiteralPath $RegistryPath -Name $n -Value 1 -PropertyType DWord -Force}
}
function Install-CH233([string]$Target) {
    if(Get-Process -Name 'Cross Hermit' -ErrorAction SilentlyContinue){throw 'Close Cross Hermit before installing.'}
    $targetPath=[IO.Path]::GetFullPath($Target).TrimEnd('\')
    if(Test-Path -LiteralPath $targetPath){throw 'Choose a new folder. Setup keeps existing installations and saves untouched.'}
    if($targetPath.StartsWith($SourceRoot.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Choose an installation folder on your hard drive.'}
    $parent=Split-Path -Parent $targetPath
    $drive=[IO.DriveInfo]::new([IO.Path]::GetPathRoot($targetPath));if($drive.AvailableFreeSpace -lt 2300000000){throw 'Setup needs at least 2.3 GB of free space.'}
    Write-CHSetupStatus233 'Checking the disc and setup files...'
    Assert-CHHash233 (Join-Path $SourceRoot 'data.z') $manifest.archive_sha256
    foreach($file in $manifest.files){Assert-CHHash233 (Join-Path $setup $file.path) $file.sha256}
    $null=[IO.Directory]::CreateDirectory($parent)
    $stage=$targetPath+'.installing-'+[Guid]::NewGuid().ToString('N')
    $log=$stage+'.log';$errorLog=$stage+'.errors.log'
    Write-CHSetupStatus233 'Extracting and checking 7,865 original game files...'
    $process=Start-Process -FilePath (Join-Path $setup 'EXTRACT.EXE') -ArgumentList @(('"'+(Join-Path $SourceRoot 'data.z')+'"'),('"'+(Join-Path $setup 'INDEX.BIN')+'"'),('"'+$stage+'"')) -WindowStyle Hidden -RedirectStandardOutput $log -RedirectStandardError $errorLog -PassThru
    $processHandle=$process.Handle
    while(-not $process.WaitForExit(150)){if($script:status){$last=Get-Content -LiteralPath $log -Tail 1 -ErrorAction SilentlyContinue;Write-CHSetupStatus233 ('Extracting original files: '+$last)}}
    $process.WaitForExit();if($process.ExitCode -ne 0){throw ('Extraction failed. Details: '+$errorLog)}
    Write-CHSetupStatus233 'Applying and verifying the English translation and compatibility fixes...'
    Expand-CHZip233 (Join-Path $setup 'ENFILES.ZIP') $stage
    $patch=Get-Content -LiteralPath (Join-Path $stage 'PATCH-MANIFEST.json') -Raw|ConvertFrom-Json
    foreach($file in $patch.game_files){Assert-CHHash233 (Join-Path $stage $file.path) $file.sha256}
    foreach($file in $patch.package_files.PSObject.Properties){Assert-CHHash233 (Join-Path $stage $file.Name) $file.Value.sha256}
    Expand-CHZip233 (Join-Path $setup 'ADDONS.ZIP') $stage
    foreach($file in $manifest.additions){Assert-CHHash233 (Join-Path $stage $file.path) $file.sha256}
    # Generate a new settings file, never copy preferences from the developer's game.
    $option=[byte[]]::new(40);$defaults=@(0,0,0,1,1,1,1,6,4,9)
    for($i=0;$i -lt 10;$i++){[Array]::Copy([BitConverter]::GetBytes([int]$defaults[$i]),0,$option,4*$i,4)}
    [IO.File]::WriteAllBytes((Join-Path $stage 'Option.bin'),$option)
    $isoPath='';try{$image=Get-Volume -FilePath (Join-Path $SourceRoot 'data.z')|Get-DiskImage -ErrorAction Stop;$isoPath=$image.ImagePath}catch{}
    $record=[ordered]@{setup_version='0.8.0';game_version='0.8.0';disc_check_sha256=$manifest.disc_check_sha256;iso_path=$isoPath;installed_at_utc=[DateTime]::UtcNow.ToString('o');disc_required=$false;last_update='0.8.0'}
    [IO.File]::WriteAllText((Join-Path $stage 'EnglishPatch\installation.json'),($record|ConvertTo-Json),[Text.UTF8Encoding]::new($false))
    $resolvedStage=[IO.Path]::GetFullPath($stage)
    if(-not $resolvedStage.StartsWith($targetPath+'.installing-',[StringComparison]::OrdinalIgnoreCase) -or (Split-Path -Parent $resolvedStage) -ine $parent){throw 'Unexpected staging path; installation stopped.'}
    Move-Item -LiteralPath $resolvedStage -Destination $targetPath
    if(-not $NoRegister){$null=Set-CHPaths233 $targetPath $targetPath;Register-CHUninstall080 $targetPath}
    if(-not $NoShortcut){Set-CHShortcuts234 $targetPath}
    $result=[ordered]@{setup_version='0.8.0';game_version='0.8.0';destination=$targetPath;original_files_verified=7865;registry_written=(-not $NoRegister);shortcut_written=(-not $NoShortcut);game_started=$false;passed=$true}
    $result|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $targetPath 'EnglishPatch\setup-report.json') -Encoding UTF8
    $owned=@(Get-ChildItem -LiteralPath $targetPath -File -Recurse|ForEach-Object {$_.FullName.Substring($targetPath.Length+1).Replace('\','/')})+'EnglishPatch/install-owned.json'
    [IO.File]::WriteAllText((Join-Path $targetPath 'EnglishPatch/install-owned.json'),([ordered]@{product='CrossHermitEnglish';install_root=$targetPath;version='0.8.0';files=$owned}|ConvertTo-Json -Depth 5),[Text.UTF8Encoding]::new($false))
    Write-CHSetupStatus233 'Installed. Open Launcher.exe or the Cross Hermit English shortcut to play.'
    return [pscustomobject]$result
}
if($Plan){[ordered]@{version='0.8.0';destination=$Destination;source=$SourceRoot;original_archive_preserved=$true;original_files=7865;game_version='0.8.0';registry_written=$false;game_started=$false;destination_written=$false}|ConvertTo-Json;return}
if($NoGui){Install-CH233 $Destination;return}
Add-Type -AssemblyName System.Windows.Forms,System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()
[Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)
$form=[Windows.Forms.Form]::new();$form.Text='Cross Hermit English · Setup 0.8.0';$form.ClientSize=[Drawing.Size]::new(660,332);$form.Font=[Drawing.Font]::new('Segoe UI',9);$form.AutoScaleDimensions=[Drawing.SizeF]::new(7,15);$form.AutoScaleMode='Font';$form.StartPosition='CenterScreen';$form.FormBorderStyle='FixedDialog';$form.MaximizeBox=$false;$form.BackColor=[Drawing.SystemColors]::Control
$overview=[Windows.Forms.GroupBox]::new();$overview.Text='Cross Hermit English';$overview.SetBounds(12,12,636,102);$form.Controls.Add($overview)
$intro=[Windows.Forms.Label]::new();$intro.Text="English translation, game fixes and Japanese compatibility are included.`r`nThe disc image is not needed after installation.";$intro.SetBounds(14,24,608,38);$overview.Controls.Add($intro)
$version=[Windows.Forms.Label]::new();$version.Text='Setup version: 0.8.0   ·   Game version: 0.8.0';$version.ForeColor=[Drawing.SystemColors]::GrayText;$version.SetBounds(14,70,608,22);$overview.Controls.Add($version)
$location=[Windows.Forms.GroupBox]::new();$location.Text='Install location';$location.SetBounds(12,126,636,95);$form.Controls.Add($location)
$folder=[Windows.Forms.TextBox]::new();$folder.Text=$Destination;$folder.SetBounds(14,27,494,24);$folder.TabIndex=0;$location.Controls.Add($folder)
$browse=[Windows.Forms.Button]::new();$browse.Text='Browse...';$browse.SetBounds(520,24,102,28);$browse.UseVisualStyleBackColor=$true;$browse.TabIndex=1;$location.Controls.Add($browse)
$hint=[Windows.Forms.Label]::new();$hint.Text='Choose a new folder. Existing installations and saves are kept.';$hint.SetBounds(14,63,608,22);$location.Controls.Add($hint)
$script:status=[Windows.Forms.Label]::new();$script:status.Text='About 1.8 GB installed. At least 2.3 GB of free space is required.';$script:status.SetBounds(16,235,632,42);$script:status.AutoEllipsis=$true;$form.Controls.Add($script:status)
$install=[Windows.Forms.Button]::new();$install.Text='Install';$install.SetBounds(450,290,90,30);$install.UseVisualStyleBackColor=$true;$install.TabIndex=2;$form.Controls.Add($install)
$close=[Windows.Forms.Button]::new();$close.Text='Close';$close.SetBounds(552,290,96,30);$close.UseVisualStyleBackColor=$true;$close.TabIndex=3;$close.DialogResult='Cancel';$form.Controls.Add($close)
$form.AcceptButton=$install;$form.CancelButton=$close
$script:busy233=$false;$form.Add_FormClosing({if($script:busy233){$_.Cancel=$true}})
$close.Add_Click({$form.Close()})
$browse.Add_Click({$dialog=[Windows.Forms.FolderBrowserDialog]::new();$dialog.Description='Choose a parent folder; setup will create Cross Hermit English inside it.';if($dialog.ShowDialog() -eq 'OK'){$folder.Text=Join-Path $dialog.SelectedPath 'Cross Hermit English'}})
$install.Add_Click({$script:busy233=$true;$install.Enabled=$false;$browse.Enabled=$false;$folder.Enabled=$false;$close.Enabled=$false;try{$null=Install-CH233 $folder.Text;$install.Text='Installed'}catch{$script:status.Text=$_.Exception.Message;$install.Enabled=$true;$browse.Enabled=$true;$folder.Enabled=$true}finally{$script:busy233=$false;$close.Enabled=$true}})
function Initialize-CHSetupPreview263([Windows.Forms.Control]$Control){$null=$Control.Handle;foreach($child in $Control.Controls){Initialize-CHSetupPreview263 $child}}
if($RenderPreview){Initialize-CHSetupPreview263 $form;$form.PerformLayout();$bitmap=[Drawing.Bitmap]::new($form.Width,$form.Height);$form.DrawToBitmap($bitmap,[Drawing.Rectangle]::new(0,0,$form.Width,$form.Height));$bitmap.Save($RenderPreview,[Drawing.Imaging.ImageFormat]::Png);$bitmap.Dispose();$form.Dispose();return}
if($StartupProbe){
    $timer=[Windows.Forms.Timer]::new();$timer.Interval=300
    $timer.Add_Tick({
        $timer.Stop()
        [ordered]@{visible=$form.Visible;title=$form.Text;source=$SourceRoot;destination_written=$false;game_started=$false}|ConvertTo-Json|Set-Content -LiteralPath $StartupProbe -Encoding UTF8
        $form.Close()
    })
    $form.Add_Shown({$timer.Start()})
}
$null=$form.ShowDialog()
if($timer){$timer.Dispose()}
