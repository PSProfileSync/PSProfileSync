function Invoke-PSPEncodeModuleArchive
{
    $PSModuleArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.modules.modulearchivefolderpathzip"
    $EncodedPSModuleArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.modules.encodedpsmodulearchivefolderpathzip"

    Invoke-PSPEncodeCertUtil -SourcePath $PSModuleArchiveFolderPathZip -TargetPath $EncodedPSModuleArchiveFolderPathZip
}