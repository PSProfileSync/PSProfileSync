function Get-PSPGitHubGistId
{
    <#
    .SYNOPSIS
        Gets the GitHub Gist Id of the ..PSProfileSync gist that is used in this module
    .DESCRIPTION
        Gets the GitHub Gist Id of the ..PSProfileSync gist that is used in this module.

        Gets all Gists of UserName in GitHub and returns the Gist Id of ..PSProfileSync
    .EXAMPLE
        PS C:\> Get-PSPGitHubGistId -UserName $UserName -PATToken $PATToken
        Returns the GistId of ..PSProfileSync
    .PARAMETER UserName
        The GitHub Username
    .PARAMETER PATToken
        The Personal Access token of the GitHub Username
    .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 01.03.2019
    #>

    [CmdletBinding()]
    param
    (
        # the GitHubUserName
        [Parameter(Mandatory)]
        [string]
        $UserName,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )

    $GistDescription = Get-PSFConfigValue -FullName "PSProfileSync.gist.gistdescription"

    $Uri = ("https://api.github.com/users/{0}/gists" -f $UserName)

    $invokePSPGitHubApiGETSplat = @{
        UserName = $UserName
        Method   = "GET"
        PATToken = $PATToken
        Uri      = $Uri
    }
    $AllUserGists = Invoke-PSPGitHubApiGET @invokePSPGitHubApiGETSplat

    $searchPSPGitHubGistSplat = @{
        AllUserGists    = $AllUserGists
        GistDescription = $GistDescription
    }
    $Gist = Search-PSPGitHubGist @searchPSPGitHubGistSplat

    $GistId = $Gist.id
    return $GistId
}