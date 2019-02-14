function Invoke-PSPEncodePSCoreProfilePaths
{
    $PSProfilePathPSCore = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepathpscore"
    $EncodedPSProfilePathPSCore = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedprofilepathpscore"

    Invoke-PSPEncodeCertUtil -SourcePath $PSProfilePathPSCore -TargetPath $EncodedPSProfilePathPSCore
}