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
    $obj.ExecuteEncodeCertUtil($obj.PSGalleryPath, $obj.EncodedPSRepotitoryPath)

    # Modules
    $obj.SavePSModulesToFile()
    $obj.ExecuteEncodeCertUtil($obj.PSModulePath, $obj.EncodedPSModulePath)
    $obj.ExecuteEncodeCertUtil($obj.PSModuleArchiveFolderPathZip, $obj.EncodedPSModuleArchiveFolderPathZip)

    # Upload to Gist
    $obj.EditGitHubGist($GistId, $obj.PSFreeSpacePath)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSRepotitoryPath)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSModulePath)
    $obj.EditGitHubGist($GistId, $obj.EncodedPSModuleArchiveFolderPathZip)
}