function Set-CHPaths233([string]$GameFolder,[string]$DiscRoot,[string]$RegistryPath='HKCU:\Software\Enterbrain\Cross Hermit',[switch]$Plan) {
    $game=[IO.Path]::GetFullPath($GameFolder).TrimEnd('\')+'\'
    $disc=[IO.Path]::GetFullPath($DiscRoot).TrimEnd('\')+'\'
    $values=[ordered]@{'Ver.'=65536;InstallPath=$game;VoicePath=$game;CdromPath=$disc}
    if($Plan){return [pscustomobject]@{registry=$RegistryPath;values=$values;registry_written=$false}}
    $existed=Test-Path -LiteralPath $RegistryPath
    $old=@{};if($existed){$props=Get-ItemProperty -LiteralPath $RegistryPath;foreach($name in $values.Keys){if($props.PSObject.Properties[$name]){$old[$name]=$props.$name}}}
    try {
        $null=New-Item -Path $RegistryPath -Force
        foreach($name in $values.Keys){$type='String';if($name -eq 'Ver.'){$type='DWord'};$null=New-ItemProperty -LiteralPath $RegistryPath -Name $name -Value $values[$name] -PropertyType $type -Force}
    } catch {
        foreach($name in $values.Keys){if($old.ContainsKey($name)){$type='String';if($name -eq 'Ver.'){$type='DWord'};$null=New-ItemProperty -LiteralPath $RegistryPath -Name $name -Value $old[$name] -PropertyType $type -Force}else{Remove-ItemProperty -LiteralPath $RegistryPath -Name $name -ErrorAction SilentlyContinue}}
        throw
    }
}
function Initialize-CHDisc233([string]$GameFolder) {
    # 0.1.252: all runtime assets come from the installed game folder.
    $null=Set-CHPaths233 $GameFolder $GameFolder
}
