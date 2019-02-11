function New-PSGitHubGist
{
    [CmdletBinding()]
    param
    (
        # the name of the github user
        [Parameter(Mandatory)]
        [string]
        $UserName,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )

    # TODO: Replace with PSFramwork
    $GistDescription = "..PSPROFILESYNC"

    # Test if gist already exist
    $Uri = ("https://api.github.com/users/{0}/gists" -f $UserName)
    $AllUserGists = Invoke-PSGitHubApiGET -Uri $Uri -Method "GET" -PATToken $PATToken -UserName $UserName
    $Gist = Search-PSGitHubGist -AllUserGists $AllUserGists -GistDescription $GistDescription

    if ($Gist)
    {
        Write-Output -InputObject "Gist is already available. No action needed."
        $GistId = $Gist.id
        return $GistId
    }
    else
    {
        Write-Output -InputObject ("Creation of Gist {0} started." -f $GistDescription)
        # Create the gist
        [HashTable]$Body = @{
            description = $GistDescription
            public      = $false
            files       = @{
                $GistDescription = @{
                    content = "This is Created by the PSProfileSync module"
                }
            }
        }

        $GitHubApiResult = Invoke-PSGitHubApiPOST -Uri $Uri -Method "POST" -ApiBody $Body -PATToken $PATToken -UserName $UserName
        $GistId = $GitHubApiResult.id
        return $GistId
    }
}