function Invoke-PSPEncodeModulesListAvailable
{
    $PSModulePath = Get-PSFConfigValue -FullName "PSProfileSync.modules.modulepath"
    $EncodedPSModulePath = Get-PSFConfigValue -FullName "PSProfileSync.modules.encodedpsmodulepath"

    Invoke-PSPEncodeCertUtil -SourcePath $PSModulePath -TargetPath $EncodedPSModulePath
}