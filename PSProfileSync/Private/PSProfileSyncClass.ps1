using namespace System
using namespace System.Text

enum MethodEnum
{
    GET
    POST
    PATCH
}

class PSProfileSync
{
    [string]$UserName
    [string]$PATToken
    [string]$PSProfileSyncPath = "$env:APPDATA\PSProfileSync"
    [string]$PSProfileSyncFullPath = (Join-Path -Path $this.PSProfileSyncPath -ChildPath "GitAuthFile.xml")
    [string]$GistDescription = "PSProfileSync"

    PSProfileSync($UserName, $PATToken)
    {
        $this.UserName = $UserName
        $this.PATToken = $PATToken
    }

    # Get Implementation for the GitHubApi
    [Object[]] CallGitHubApiGET([string]$Uri, [MethodEnum]$Method)
    {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $this.UserName, $this.PATToken)))
        $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}

        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Header
        return $result
    }

    # Post / Patch implementation for the GitHubApi
    [Object[]] CallGitHubApiPOST([string]$Uri, [MethodEnum]$Method, [hashtable]$ApiBody)
    {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $this.UserName, $this.PATToken)))
        $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}

        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Header -Body $ApiBody
        return $result
    }

    [pscustomobject] NewAuthFileObject([string]$GistId)
    {
        # Build the credential object
        $PATTokenSecure = ConvertTo-SecureString -String $this.PATToken -AsPlainText -Force
        $GitHubCredential = New-Object -TypeName System.Management.Automation.PSCredential($this.UserName, $PATTokenSecure)

        # Create the object for the file
        $FileObject = [PSCustomObject]@{
            GitHubCredential = $GitHubCredential
            GistId           = $GistId
        }
        return $FileObject
    }

    [void] CreateGitAuthFile([pscustomobject]$AuthFileObject)
    {
        If (-not($this.TestForGitAuthFile($this.PSProfileSyncPath)))
        {
            New-Item -ItemType Directory -Force -Path $this.PSProfileSyncPath
        }

        $AuthFileObject | Export-Clixml -Path $this.PSProfileSyncFullPath -Force
    }

    [string] CreateGitHubGist()
    {
        # Test if gist already exist
        $Uri = ("https://api.github.com/users/{0}/gists" -f $this.UserName)
        $AllUserGists = $this.CallGitHubApiGET($Uri, "GET")

        if (($AllUserGists).where{$_.description -eq $this.GistDescription})
        {
            Write-Output -InputObject "Gist is already available. No action needed."
            $GistId = (($AllUserGists).where{$_.description -eq $this.GistDescription}).id
        }
        else
        {
            Write-Output -InputObject ("Creation of Gist {0} started." -f $this.GistDescription)
            # Create the gist
            [HashTable]$Body = @{
                description = $this.GistDescription
                public      = $false
                files       = @{
                    $this.GistDescription = @{
                        content = "This is Created by the PSProfileSync module"
                    }
                }
            }

            $GitHubApiResult = $this.CallGitHubApiPOST($Uri, "POST", $Body)
            $GistId = $GitHubApiResult.id
        }

        return $GistId
    }

    [bool] TestForGitAuthFile([string]$PathAuthFile)
    {
        if (Test-Path -Path $PathAuthFile)
        {
            return $true
        }
        else
        {
            return $false
        }
    }
}