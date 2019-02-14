function Invoke-PSPWPSProfileArchive
{
    $PSProfileWPSArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilewpsarchivefolderpathzip"
    $EncodedPSProfileWPSArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedpsprofilewpsarchivefolderpathzip"

    Invoke-PSPEncodeCertUtil -SourcePath $PSProfileWPSArchiveFolderPathZip -TargetPath $EncodedPSProfileWPSArchiveFolderPathZip
}