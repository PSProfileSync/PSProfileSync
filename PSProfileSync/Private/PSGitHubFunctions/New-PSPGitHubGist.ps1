function New-PSPGitHubGist
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
        $PATToken,

        # the description of the GitHubGist
        [Parameter(Mandatory)]
        [string]
        $GistDescription
    )

    # Test if gist already exist
    $Uri = ("https://api.github.com/users/{0}/gists" -f $UserName)
    $Uri_create_gist = "https://api.github.com/gists"
    $AllUserGists = Invoke-PSPGitHubApiGET -Uri $Uri -Method "GET" -PATToken $PATToken -UserName $UserName
    $Gist = Search-PSPGitHubGist -AllUserGists $AllUserGists -GistDescription $GistDescription

    if ($Gist)
    {
        Write-PSFMessage -Message "Gist is already available. No action needed." -Level Output
        $GistId = $Gist.id
        return $GistId
    }
    else
    {
        Write-PSFMessage -Message ("Creation of Gist {0} started." -f $GistDescription) -Level Output
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

        $GitHubApiResult = Invoke-PSPGitHubApiPOST -Uri $Uri_create_gist -Method "POST" -ApiBody ($Body | ConvertTo-Json) -PATToken $PATToken -UserName $UserName
        $GistId = $GitHubApiResult.id
        return $GistId
    }
}