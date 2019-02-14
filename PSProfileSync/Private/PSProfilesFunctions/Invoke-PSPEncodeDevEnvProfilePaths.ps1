function Invoke-PSPEncodeDevEnvProfilePaths
{
    $PSProfilePathDevEnv = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepathdevenv"
    $EncodedPSProfilePathDevEnv = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedprofilepathdevenv"

    Invoke-PSPEncodeCertUtil -SourcePath $PSProfilePathDevEnv -TargetPath $EncodedPSProfilePathDevEnv
}