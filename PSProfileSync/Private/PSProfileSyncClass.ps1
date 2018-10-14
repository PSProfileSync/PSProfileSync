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
    [string]$LocalGistPath = "$env:APPDATA\PSProfileSync\Gist"
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
    [string]$EncodedPSRepotitoryPath = "$env:APPDATA\PSProfileSync\PSGallery.txt"

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
    [Object[]] CallGitHubApiPOST([string]$Uri, [MethodEnum]$Method, [string]$ApiBody)
    {
        $Token = ConvertTo-SecureString -String $this.PATToken -AsPlainText -Force
        $cred = New-Object -TypeName System.Management.Automation.PSCredential($this.UserName, $Token)
        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Body $ApiBody -Authentication Basic -Credential $cred
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

    [void] EditGitHubGist([string]$GistId, [string]$FilePath)
    {
        $Uri = ("https://api.github.com/gists/{0}" -f $GistId)
        $GistObject = $this.CallGitHubApiGET($Uri, "GET")
        $FileName = Split-Path -Path $FilePath -Leaf
        if ((Test-Path -Path $this.LocalGistPath))
        {
            Remove-Item $this.LocalGistPath -Recurse -Force
            git clone $GistObject.git_pull_url $this.LocalGistPath
        }
        else
        {
            git clone $GistObject.git_pull_url $this.LocalGistPath
        }

        Copy-Item -Path $FilePath -Destination $this.LocalGistPath
        Set-Location -Path $this.LocalGistPath
        git add .\$FileName
        git commit -m "$FilePath added."
        git push
    }

    <# [void] EditGitHubGist([string]$GistId, [string]$FilePath)
    {
        $Uri = ("https://api.github.com/gists/{0}" -f $GistId)

        $GistObject = $this.CallGitHubApiGET($Uri, "GET")

        $FileObject = [PSCustomObject]@{
            filename = $FilePath
            content = ((Get-Content -Path $FilePath -Raw).PSObject.BaseObject)
        }

        $GistObject.files | Add-Member -MemberType NoteProperty -Name $FilePath -Value $FileObject

        $BodyJSON = ConvertTo-Json -InputObject $GistObject -Compress
        $Method = "PATCH"

        ($this.CallGitHubApiPOST($Uri, $Method, $BodyJSON))
    } #>
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

    [string[]]GetPSRepositoryFile()
    {
        $content = Get-Content -Path $this.EncodedPSRepotitoryPath -Raw
        return $content
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

    [void] ConverttoZipArchive([string]$SourePath, [String]$TargetPath)
    {
        Compress-Archive -Path $SourePath -DestinationPath $TargetPath -CompressionLevel Optimal
    }

    [void] ExecuteEncodeCertUtil([string]$SourePath, [string]$TargetPath)
    {
        Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-encode", $SourePath, $TargetPath
    }

    [void] ExecuteDecodeCertUtil([string]$SourePath, [string]$TargetPath)
    {
        Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-decode", $SourePath, $TargetPath -Wait
    }

    [bool]IsGitInstalled()
    {
        try
        {
            $null = git
            return $true
        }
        catch [System.Management.Automation.CommandNotFoundException]
        {
            Write-Error -Message "Git is not installed. Message is $_"
            return $false
        }
    }
    #endregion
}