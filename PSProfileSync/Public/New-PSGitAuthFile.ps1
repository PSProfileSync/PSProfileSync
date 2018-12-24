function New-PSGitAuthFile
{
    param (
        # The GistId
        [Parameter(Mandatory)]
        [string]
        $GistId,

        # The username
        [Parameter(Mandatory)]
        [string]
        $Username,

        # the pattoken
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )

    $obj = [PSProfileSyncGitHubClass]::new()

    if (-not ($obj.TestForGitAuthFile($obj.PSProfileGitAuthFilePath)))
    {
        $obj.CreateGitAuthFile($GistId, $PATToken, $Username)
    }
}