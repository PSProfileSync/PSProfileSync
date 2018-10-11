using namespace System

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
    [string]$PSProfileSyncFullPath = "$env:APPDATA\PSProfileSync\GitAuthFile.xml"
    [string]$GistDescription = "PSProfileSync"
    # the modules that need to be excluded out of the box
    [string[]]$ExcludedModules = @(
        "PowerShellGet",
        "PackageManagement",
        "Microsoft.PowerShell.Operation.Validation",
        "Pester",
        "PSReadline"
    )

    # the repository that that needs to be excluded out of the box
    [string]$ExcludedRepositories = "PSGallery"
    [string]$PSGalleryPath = "$env:APPDATA\PSProfileSync\PSGallery.json"

    PSProfileSync($UserName, $PATToken)
    {
        $this.UserName = $UserName
        $this.PATToken = $PATToken
    }

    #region GitHub Rest
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

    [Object[]] SearchGitHubGist([object[]]$AllUserGists)
    {
        $Gist = ($AllUserGists).where{$_.description -eq $this.GistDescription}
        if ($Gist)
        {
            return $Gist
        }
        return $null
    }

    [string] CreateGitHubGist()
    {
        # Test if gist already exist
        $Uri = ("https://api.github.com/users/{0}/gists" -f $this.UserName)
        $AllUserGists = $this.CallGitHubApiGET($Uri, "GET")
        $Gist = $this.SearchGitHubGist($AllUserGists)

        if ($Gist)
        {
            Write-Output -InputObject "Gist is already available. No action needed."
            $GistId = $Gist.id
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
    #endregion

    #region Settings File methods
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

    [void] CreateGitAuthFile([pscustomobject]$AuthFileObject, [string]$Path = $this.PSProfileSyncFullPath)
    {
        If (-not($this.TestForGitAuthFile($Path)))
        {
            New-Item -ItemType Directory -Force -Path $this.PSProfileSyncPath
        }

        $AuthFileObject | Export-Clixml -Path $this.PSProfileSyncFullPath -Force
    }

    [PSCustomObject] ImportGitAuthFile([string]$XmlPath = $this.PSProfileSyncFullPath)
    {
        $XmlFile = Import-Clixml -Path $XmlPath
        $returnObject = [PSCustomObject]@{
            UserName = $XmlFile.GitHubCredential.UserName
            PATToken = $XmlFile.GitHubCredential.GetNetworkCredential().Password
            GistId   = $XmlFile.GistId
        }
        return $returnObject
    }
    #endregion

    #region SaveSettings
    #region PSRepository
    [Object[]] GetPSRepository()
    {
        return Get-PSRepository
    }

    [void]SavePSRepositoriesToFile()
    {
        $AllRepos = $this.GetPSRepository()
        $AllRepos | ConvertTo-Json | Out-File -FilePath $this.PSGalleryPath
    }

    #endregion
    #endregion

    #region HelperMethods
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

    [void]ConverttoZipArchive([string]$SourePath, [String]$TargetPath)
    {
        Compress-Archive -Path $SourePath -DestinationPath $TargetPath -CompressionLevel Optimal
    }

    [void] ExecuteCertUtil([string]$SourePath, [string]$TargetPath)
    {
        Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-encode", $SourePath, $TargetPath
    }
    #endregion
}