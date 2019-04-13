function Invoke-PSPEncodePSCoreProfileArchive
{
    $PSProfilePSCoreArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepscorearchivefolderpathzip"
    $EncodedPSProfilePSCoreArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedpsprofilepscorearchivefolderpathzip"

    Invoke-PSPEncodeCertUtil -SourcePath $PSProfilePSCoreArchiveFolderPathZip -TargetPath $EncodedPSProfilePSCoreArchiveFolderPathZip
}