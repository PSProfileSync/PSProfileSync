function Edit-PSGitHubGist
{
    [CmdletBinding()]
    param
    (
        # the ID of the gist that you want to change
        [Parameter(Mandatory)]
        [string]
        $GistId,

        # the complete path of the file that you want to add to the gist
        [Parameter(Mandatory)]
        [string]
        $FilePath,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken,

        # the github username
        [Parameter(Mandatory)]
        [string]
        $UserName
    )

    if (Test-Path $FilePath)
    {
        $Uri = ("https://api.github.com/gists/{0}" -f $GistId)
        $FileName = Split-Path -Path $FilePath -Leaf

        [HashTable]$Body = @{
            files = @{
                "$FileName" = @{
                    content  = (Get-Content -Path $FilePath)
                    filename = "$FileName"
                }
            }
        }

        $ApiBody = ConvertTo-Json -InputObject $Body -Compress

        if (($PSVersionTable.PSVersion.Major) -eq 6)
        {
            $Token = ConvertTo-SecureString -String $PATToken -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $Token)
            $result = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Body $ApiBody -Authentication Basic -Credential $cred -ContentType "application/json"
        }
        else
        {
            $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName, $PATToken)))
            $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}
            $result = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Header -Body $ApiBody
        }
    }
    else
    {
        #TODO: Logfile
    }
}