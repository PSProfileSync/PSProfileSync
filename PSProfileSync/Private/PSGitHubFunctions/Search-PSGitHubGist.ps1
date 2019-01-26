function Search-PSGitHubGist
{
    [CmdletBinding()]
    param
    (
        # all gists of the user
        [Parameter(Mandatory)]
        [object[]]
        $AllUserGists,

        # the description of the gist
        [Parameter(Mandatory)]
        [string]
        $GistDescription
    )

    $Gist = ($AllUserGists).where{$_.description -eq $GistDescription}
    if ($Gist)
    {
        return $Gist
    }
    return $null
}