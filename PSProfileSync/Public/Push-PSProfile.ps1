function Push-PSProfile
{
    param
    (
        # the github username
        [Parameter(Mandatory)]
        [string]
        $UserName,

        # the github pattoken
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )

    Initialize-PSPAuthentication -UserName $UserName -PATToken $PATToken

    # Calculate Freespace on SystemDrive
    Save-PSPProfileSyncModuleUploadSize
    Save-PSPProfileSyncProfileUploadSize

    # Repositories
    Save-PSPRepositoriesToFile
    Invoke-PSPEncodeGalleriesListAvailable

    # Modules
    Save-PSPModulesToFile
    Invoke-PSPEncodeModulesListAvailable
    Invoke-PSPEncodeModuleArchive

    # Profiles
    Save-PSPProfilesToFile
    Invoke-PSPEncodeWPSProfilePaths
    Invoke-PSPEncodePSCoreProfilePaths
    Invoke-PSPEncodeDevEnvProfilePaths
    Invoke-PSPEncodeWPSProfileArchive
    Invoke-PSPEncodePSCoreProfileArchive
    Invoke-PSPDevEnvProfileArchive

    # Upload to Gist
    Set-PSPProfileGitHubGist -UserName $UserName -PATToken $PATToken
}