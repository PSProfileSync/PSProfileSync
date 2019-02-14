function Invoke-PSPEncodeWPSProfilePaths
{
    $PSProfilePathWPS = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepathwps"
    $EncodedPSProfilePathWPS = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedprofilepathwps"

    Invoke-PSPEncodeCertUtil -SourcePath $PSProfilePathWPS -TargetPath $EncodedPSProfilePathWPS
}