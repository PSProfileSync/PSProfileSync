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

    Initialize-PSAuthentication -PATToken $PATToken -UserName $UserName

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
    Invoke-PSPWPSProfileArchive
    Invoke-PSPPSCoreProfileArchive
    Invoke-PSPDevEnvProfileArchive

    # Upload to Gist
    $objGitHubClass.EditGitHubGist($objProfileClass.PSPProfileSyncProfileFolderSizePath)
    $objGitHubClass.EditGitHubGist($objModulesClass.PSPProfileSyncModulesFolderSizePath)
    $objGitHubClass.EditGitHubGist($objRepositoryClass.EncodedPSGalleryPath)
    $objGitHubClass.EditGitHubGist($objModulesClass.EncodedPSModulePath)
    $objGitHubClass.EditGitHubGist($objModulesClass.EncodedPSModuleArchiveFolderPathZip)
    $objGitHubClass.EditGitHubGist($objProfileClass.EncodedPSProfilePathWPS)
    $objGitHubClass.EditGitHubGist($objProfileClass.EncodedPSProfilePathPSCore)
    $objGitHubClass.EditGitHubGist($objProfileClass.EncodedPSProfilePathDevEnv)
    $objGitHubClass.EditGitHubGist($objProfileClass.EncodedPSProfileWPSArchiveFolderPathZip)
    $objGitHubClass.EditGitHubGist($objProfileClass.EncodedPSProfilePSCoreArchiveFolderPathZip)
    $objGitHubClass.EditGitHubGist($objProfileClass.EncodedPSProfileDevEnvArchiveFolderPathZip)
}