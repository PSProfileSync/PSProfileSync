function Invoke-PSGitHubApi
{
    <#
    .SYNOPSIS
        Call the GitHub Api
    .DESCRIPTION
        Call the GitHub Api to Get / Add information.

    .PARAMETER PersonalAccessToken
    The personal accesstoken of the user

    .PARAMETER UserName
    the username of the user

    .PARAMETER Method
    The method. This can be Get / Post / Patch

    .PARAMETER Uri
    the Uri of the GitHub Api that you want to call

    .EXAMPLE
        PS C:\> Invoke-PsGitHubApi -UserName testuser -PersonalAccessToken 00000 -Method Get -Uri https://api.github.com/user
        Authenticate user testuser with his PAT of 00000 to the github Api and gets his userinformation back.

    .OUTPUTS
        JSon-Object
    .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 03.10.2018
    #>


    [CmdletBinding()]
    param (
        # the PAT
        [Parameter(Mandatory)]
        [string]
        $PersonalAccessToken,

        # the username of the user that want to access the Git Hub API
        [Parameter(Mandatory)]
        [string]
        $UserName,

        # the method
        [Parameter(Mandatory)]
        [ValidateSet('GET', 'POST', 'PATCH')]
        [string]
        $Method,

        # the uri to ask
        [Parameter(Mandatory)]
        [string]
        $Uri
    )

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName, $PersonalAccessToken)))
    $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}

    # UseBasicParsing because of IE issues in PowerShell Version 5.1
    Invoke-RestMethod -Headers $Header -Uri $Uri -Method $Method -UseBasicParsing
}