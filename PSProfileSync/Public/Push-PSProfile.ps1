function Push-PSProfile
{
    $objProfileClass = [PSProfileSyncProfilesClass]::new()
    $objModulesClass = [PSProfileSyncModulesClass]::new()
    $objHelperClass = [PSProfileSyncHelperClass]::new()
    $objRepositoryClass = [PSProfileSyncRepositoriesClass]::new()
    $objGitHubClass = [PSProfileSyncGitHubClass]::new()
    $objGitHubClass.AuthenticationPrereqs()

    # Calculate Freespace on SystemDrive
    $objModulesClass.SavePSProfileSyncUploadSize()
    $objProfileClass.SavePSProfileSyncUploadSize()

    # Repositories
    $objRepositoryClass.SavePSRepositoriesToFile()
    $objHelperClass.ExecuteEncodeCertUtil($objRepositoryClass.PSGalleryPath, $objRepositoryClass.EncodedPSGalleryPath)

    # Modules
    $objModulesClass.SavePSModulesToFile()
    $objHelperClass.ExecuteEncodeCertUtil($objModulesClass.PSModulePath, $objModulesClass.EncodedPSModulePath)
    $objHelperClass.ExecuteEncodeCertUtil($objModulesClass.PSModuleArchiveFolderPathZip, $objModulesClass.EncodedPSModuleArchiveFolderPathZip)

    # Profiles
    $objProfileClass.SavePSProfilesToFile()
    $objHelperClass.ExecuteEncodeCertUtil($objProfileClass.PSProfilePathWPS, $objProfileClass.EncodedPSProfilePathWPS)
    $objHelperClass.ExecuteEncodeCertUtil($objProfileClass.PSProfilePathPSCore, $objProfileClass.EncodedPSProfilePathPSCore)
    $objHelperClass.ExecuteEncodeCertUtil($objProfileClass.PSProfilePathDevEnv, $objProfileClass.EncodedPSProfilePathDevEnv)
    $objHelperClass.ExecuteEncodeCertUtil($objProfileClass.PSProfileWPSArchiveFolderPathZip, $objProfileClass.EncodedPSProfileWPSArchiveFolderPathZip)
    $objHelperClass.ExecuteEncodeCertUtil($objProfileClass.PSProfilePSCoreArchiveFolderPathZip, $objProfileClass.EncodedPSProfilePSCoreArchiveFolderPathZip)
    $objHelperClass.ExecuteEncodeCertUtil($objProfileClass.PSProfileDevEnvArchiveFolderPathZip, $objProfileClass.EncodedPSProfileDevEnvArchiveFolderPathZip)

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