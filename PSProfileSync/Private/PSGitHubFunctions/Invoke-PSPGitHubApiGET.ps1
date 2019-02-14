function Invoke-PSPGitHubApiGET
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Uri,

        # the method for the API
        [Parameter(Mandatory)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string]
        $Method,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken,

        # the github username
        [Parameter(Mandatory)]
        [string]
        $UserName
    )

    if (($PSVersionTable.PSVersion.Major) -eq 6)
    {
        $Token = ConvertTo-SecureString -String $PATToken -AsPlainText -Force
        $cred = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $Token)
        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Authentication Basic -Credential $cred -ContentType "application/json"
    }
    else
    {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName, $PATToken)))
        $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}
        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Header
    }

    return $result
}