param([Parameter(Mandatory=$true)][string]$GameIcon,[string]$OutputDirectory=(Join-Path $PSScriptRoot 'build'))
$ErrorActionPreference='Stop'
$csc=Join-Path $env:WINDIR 'Microsoft.NET/Framework/v4.0.30319/csc.exe'
$null=New-Item -ItemType Directory -Path $OutputDirectory -Force
foreach($name in @('Launcher','Uninstall')){
    & $csc /nologo /target:winexe /platform:x86 /optimize+ "/win32manifest:$(Join-Path $PSScriptRoot ($name+'.manifest'))" "/win32icon:$GameIcon" /r:System.Windows.Forms.dll /r:System.Drawing.dll /r:System.Web.Extensions.dll /r:Microsoft.CSharp.dll "/out:$(Join-Path $OutputDirectory ($name+'.exe'))" (Join-Path $PSScriptRoot 'Common.cs') (Join-Path $PSScriptRoot ($name+'.cs'))
    if($LASTEXITCODE -ne 0){throw "Failed to compile $name"}
}
