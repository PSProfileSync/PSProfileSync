function Invoke-PSPDevEnvProfileArchive
{
    $PSProfileDevEnvArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.profiledevenvarchivefolderpathzip"
    $EncodedPSProfileDevEnvArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedpsprofiledevenvarchivefolderpathzip"

    Invoke-PSPEncodeCertUtil -SourcePath $PSProfilePSCoreArchiveFolderPathZip -TargetPath $EncodedPSProfilePSCoreArchiveFolderPathZip
}