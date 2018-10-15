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
    $AllRepositories = $obj.SavePSRepositoriesToFile()
    $obj.ExecuteEncodeCertUtil($obj.PSGalleryPath, $obj.EncodedPSRepotitoryPath)
    $GistId = $Authfile.GistId
    $obj.EditGitHubGist($GistId, $obj.EncodedPSRepotitoryPath)

}