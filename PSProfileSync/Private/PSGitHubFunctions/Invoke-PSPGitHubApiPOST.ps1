function Invoke-PSPGitHubApiPOST
{
    [CmdletBinding()]
    param
    (
        # the POST Uri
        [Parameter(Mandatory)]
        [string]
        $Uri,

        # the method for the API
        [Parameter(Mandatory)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string]
        $Method,

        # the body of the Uri call
        [Parameter(Mandatory)]
        [string]
        $ApiBody,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken,

        # the github username
        [Parameter(Mandatory)]
        [string]
        $UserName
    )

    $Version = Get-PSPMajorPSVersion

    if ($Version -eq 6)
    {
        $Token = ConvertTo-SecureString -String $PATToken -AsPlainText -Force
        $cred = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $Token)
        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Body $ApiBody -Authentication Basic -Credential $cred -ContentType "application/json"
    }
    else
    {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName, $PATToken)))
        $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}
        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Header -Body $ApiBody
    }

    return $result
}