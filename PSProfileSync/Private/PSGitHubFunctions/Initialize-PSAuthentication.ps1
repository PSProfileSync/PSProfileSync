function Initialize-PSAuthentication
{
    [CmdletBinding()]
    param
    (
        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken,

        # the github username
        [Parameter(Mandatory)]
        [string]
        $UserName
    )

    # If GitAuthFile exists import It
    # If not we have to check if gist exists.
    # If thats the case we get the gist id and create a new authfile.
    # If not we have to create a new gist get the gistid and create a new authfile.
    if (Test-PSForGitAuthFile)
    {
        Import-PSGitAuthFile
    }
    else
    {
        # TODO: Replace with PSFramwork (GistDescription)
        $GistDescription = "..PSPROFILESYNC"

        # Test if gist already exist
        $Uri = ("https://api.github.com/users/{0}/gists" -f $UserName)
        $AllUserGists = Invoke-PSGitHubApiGET -Uri $Uri -Method "GET" -PATToken $PATToken -UserName $UserName

        $GistId = Search-PSGitHubGist -AllUserGists $AllUserGists -GistDescription $GistDescription
        if ($null -eq $GistId)
        {
            $GistId = New-PSGitHubGist -UserName $UserName -PATToken $PATToken
            New-PSGitAuthFile -GistId $GistId -PATToken $PATToken -UserName $UserName
        }
        else
        {
            New-PSGitAuthFile -GistId $GistId -PATToken $PATToken -UserName $UserName
        }
    }
}