Class PSProfileSyncGitHubClass
{
    # Global variables

    [string]$UserName
    [string]$PATToken
    [string]$GistId
    #TODO: PSFramework Settings
    # --------------------------
    [string]$GistDescription = "..PSPROFILESYNC"
    [string]$PSProfileGitAuthFilePath = "$env:APPDATA\PSProfileSync\GitAuthFile.xml"
    # --------------------------

    [Object[]] CallGitHubApiGET([string]$Uri, [MethodEnum]$Method)
    {
        if (($global:PSVersionTable.PSVersion.Major) -eq 6)
        {
            $Token = ConvertTo-SecureString -String $this.PATToken -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential($this.UserName, $Token)
            $result = Invoke-RestMethod -Uri $Uri -Method $Method -Authentication Basic -Credential $cred -ContentType "application/json"
        }
        else
        {
            $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $this.UserName, $this.PATToken)))
            $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}
            $result = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Header
        }

        return $result
    }

    # Post / Patch implementation for the GitHubApi
    [Object[]] CallGitHubApiPOST([string]$Uri, [MethodEnum]$Method, [string]$ApiBody)
    {
        if (($global:PSVersionTable.PSVersion.Major) -eq 6)
        {
            $Token = ConvertTo-SecureString -String $this.PATToken -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential($this.UserName, $Token)
            $result = Invoke-RestMethod -Uri $Uri -Method $Method -Body $ApiBody -Authentication Basic -Credential $cred -ContentType "application/json"
        }
        else
        {
            $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $this.UserName, $this.PATToken)))
            $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}
            $result = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Header -Body $ApiBody
        }

        return $result
    }

    [Object[]] SearchGitHubGist([object[]]$AllUserGists)
    {
        $Gist = ($AllUserGists).where{$_.description -eq $this.GistDescription}
        if ($Gist)
        {
            return $Gist
        }
        return $null
    }

    [void] CreateGitHubGist()
    {
        # Test if gist already exist
        $Uri = ("https://api.github.com/users/{0}/gists" -f $this.UserName)
        $AllUserGists = $this.CallGitHubApiGET($Uri, "GET")
        $Gist = $this.SearchGitHubGist($AllUserGists)

        if ($Gist)
        {
            Write-Output -InputObject "Gist is already available. No action needed."
            $this.GistId = $Gist.id
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
            $this.GistId = $GitHubApiResult.id
        }
    }

    [void] EditGitHubGist([string]$FilePath)
    {
        if (Test-Path $FilePath)
        {
            $Uri = ("https://api.github.com/gists/{0}" -f $this.GistId)
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

            if (($global:PSVersionTable.PSVersion.Major) -eq 6)
            {
                $Token = ConvertTo-SecureString -String $this.PATToken -AsPlainText -Force
                $cred = New-Object -TypeName System.Management.Automation.PSCredential($this.UserName, $Token)
                $result = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Body $ApiBody -Authentication Basic -Credential $cred -ContentType "application/json"
            }
            else
            {
                $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $this.UserName, $this.PATToken)))
                $Header = @{"Authorization" = ("Basic {0}" -f $base64AuthInfo)}
                $result = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Header -Body $ApiBody
            }
        }
        else
        {
            #TODO: Logfile
        }
    }

    [pscustomobject] NewAuthFileObject([string]$GistId, [string]$PATToken, [string]$UserName)
    {
        # Build the credential object
        $PATTokenSecure = ConvertTo-SecureString -String $PATToken -AsPlainText -Force
        $GitHubCredential = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $PATTokenSecure)

        # Create the object for the file
        $FileObject = [PSCustomObject]@{
            GitHubCredential = $GitHubCredential
            GistId           = $GistId
        }
        return $FileObject
    }

    [void] CreateGitAuthFile([string]$GistId, [string]$PATToken, [string]$UserName)
    {
        $objHelperFunctionClass = [PSProfileSyncHelperClass]::new()

        If (-not(Test-Path -Path $this.PSProfileGitAuthFilePath))
        {
            New-Item -ItemType Directory -Force -Path $objHelperFunctionClass.PSProfileSyncPath
        }
        $AuthFileObject = $this.NewAuthFileObject($GistId, $PATToken, $UserName)
        $AuthFileObject | Export-Clixml -Path $this.PSProfileGitAuthFilePath -Force
    }

    [void] ImportGitAuthFile()
    {
        $XmlFile = Import-Clixml -Path $this.PSProfileGitAuthFilePath

        $this.UserName = $XmlFile.GitHubCredential.UserName
        $this.PATToken = $XmlFile.GitHubCredential.GetNetworkCredential().Password
        $this.GistId = $XmlFile.GistId
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

    [void]AuthenticationPrereqs()
    {
        # Import Git Authfile
        $this.ImportGitAuthFile()
    }
}