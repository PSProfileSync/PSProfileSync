function Push-PSProfile
{
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $Username,

        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )
    $obj = [PSProfileSync]::new($Username, $PATToken)

    $Authfile = $obj.ImportGitAuthFile($obj.PSProfileSyncFullPath)
    $GistId = $Authfile.GistId

    # Calculate Freespace on SystemDrive
    $obj.SaveCalculateFreespaceOnSystemDrive()

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
    $obj.ExecuteEncodeCertUtil($obj.PSProfilePathDevEnvo, $obj.EncodedPSProfilePathDevEnv)
    $obj.ExecuteEncodeCertUtil($obj.PSProfileWPSArchiveFolderPathZip, $obj.EncodedPSProfileWPSArchiveFolderPathZip)
    $obj.ExecuteEncodeCertUtil($obj.PSProfilePSCoreArchiveFolderPathZip, $obj.EncodedPSProfilePSCoreArchiveFolderPathZip)
    $obj.ExecuteEncodeCertUtil($obj.PSProfileDevEnvArchiveFolderPathZip, $obj.EncodedPSProfileDevEnvArchiveFolderPathZip)

    #TODO: Only Upload if file is not available
    # Upload to Gist
    #$obj.EditGitHubGist($GistId, $obj.PSFreeSpacePath)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSGalleryPath)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSModulePath)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSModuleArchiveFolderPathZip)

    $obj.EditGitHubGist($GistId, $obj.EncodedPSProfilePathWPS)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSProfilePathPSCore)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSProfilePathDevEnv)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSProfileWPSArchiveFolderPathZip)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSProfilePSCoreArchiveFolderPathZip)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSProfileDevEnvArchiveFolderPathZip)

}