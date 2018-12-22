function Push-PSProfile
{
    $obj = [PSProfileSync]::new()
    $obj.AuthenticationPrereqs()

    # Calculate Freespace on SystemDrive
    $obj.SavePSProfileSyncUploadSize()

    # Repository
    $obj.SavePSRepositoriesToFile()
    $obj.ExecuteEncodeCertUtil($obj.PSGalleryPath, $obj.EncodedPSGalleryPath)

    # Modules
    $obj.SavePSModulesToFile()
    $obj.ExecuteEncodeCertUtil($obj.PSModulePath, $obj.EncodedPSModulePath)
    $obj.ExecuteEncodeCertUtil($obj.PSModuleArchiveFolderPathZip, $obj.EncodedPSModuleArchiveFolderPathZip)

    # Profiles
    $obj.SavePSProfilesToFile()
    $obj.ExecuteEncodeCertUtil($obj.PSProfilePathWPS, $obj.EncodedPSProfilePathWPS)
    $obj.ExecuteEncodeCertUtil($obj.PSProfilePathPSCore, $obj.EncodedPSProfilePathPSCore)
    $obj.ExecuteEncodeCertUtil($obj.PSProfilePathDevEnv, $obj.EncodedPSProfilePathDevEnv)
    $obj.ExecuteEncodeCertUtil($obj.PSProfileWPSArchiveFolderPathZip, $obj.EncodedPSProfileWPSArchiveFolderPathZip)
    $obj.ExecuteEncodeCertUtil($obj.PSProfilePSCoreArchiveFolderPathZip, $obj.EncodedPSProfilePSCoreArchiveFolderPathZip)
    $obj.ExecuteEncodeCertUtil($obj.PSProfileDevEnvArchiveFolderPathZip, $obj.EncodedPSProfileDevEnvArchiveFolderPathZip)

    # Upload to Gist
    $obj.EditGitHubGist($obj.PSPProfileSyncFolderSizePath)
    $obj.EditGitHubGist($obj.EncodedPSGalleryPath)
    $obj.EditGitHubGist($obj.EncodedPSModulePath)
    $obj.EditGitHubGist($obj.EncodedPSModuleArchiveFolderPathZip)

    $obj.EditGitHubGist($obj.EncodedPSProfilePathWPS)
    $obj.EditGitHubGist($obj.EncodedPSProfilePathPSCore)
    $obj.EditGitHubGist($obj.EncodedPSProfilePathDevEnv)
    $obj.EditGitHubGist($obj.EncodedPSProfileWPSArchiveFolderPathZip)
    $obj.EditGitHubGist($obj.EncodedPSProfilePSCoreArchiveFolderPathZip)
    $obj.EditGitHubGist($obj.EncodedPSProfileDevEnvArchiveFolderPathZip)
}