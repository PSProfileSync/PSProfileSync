function Invoke-PSGitHubApi
{
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