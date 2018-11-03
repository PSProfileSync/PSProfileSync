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
    [string]$GistDescription = "..PSPROFILESYNC"
    # the modules that need to be excluded out of the box
    [string[]]$ExcludedModules = @(
        "PowerShellGet",
        "PackageManagement",
        "Microsoft.PowerShell.Operation.Validation",
        "Pester",
        "PSReadline"
    )
    [string[]]$IncludedPSModulePaths = @(
        "$($this.GetDocumentsFolder())\PowerShell\Modules",
        "$($this.GetDocumentsFolder())\WindowsPowerShell\Modules",
        "$env:ProgramFiles\PowerShell\Modules",
        "$env:ProgramFiles\WindowsPowerShell\Modules"
    )

    # the repository that that needs to be excluded out of the box
    [string]$ExcludedRepositories = "PSGallery"
    [string]$PSGalleryPath = "$env:APPDATA\PSProfileSync\PSGallery.json"
    [string]$PSModulePath = "$env:APPDATA\PSProfileSync\ModulesListAvailable.json"
    [string]$EncodedPSRepotitoryPath = "$env:APPDATA\PSProfileSync\PSGallery.txt"
    [string]$EncodedPSModulePath = "$env:APPDATA\PSProfileSync\ModulesListAvailable.txt"
    [string]$PSFreeSpacePath = "$env:APPDATA\PSProfileSync\Freespace.json"
    [string]$PSModuleArchiveFolderPath = "$env:APPDATA\PSProfileSync\ModuleArchive"
    [string]$PSModuleArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ModuleArchive.zip"
    [string]$EncodedPSModuleArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ModuleArchive.txt"

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
        $result = Invoke-RestMethod -Uri $Uri -Method $Method -Body $ApiBody -Authentication Basic -Credential $cred -ContentType "application/json"
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

    <# [void] EditGitHubGist([string]$GistId, [string]$FilePath)
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
    } #>

    [void] EditGitHubGist([string]$GistId, [string]$FilePath)
    {
        if (Test-Path $FilePath)
        {
            $Uri = "https://api.github.com/gists/$GistId"
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
            $Token = ConvertTo-SecureString -String $this.PATToken -AsPlainText -Force
            $cred = New-Object -TypeName System.Management.Automation.PSCredential($this.UserName, $Token)
            Invoke-RestMethod -Uri $Uri -Method "PATCH" -Body $ApiBody -Authentication Basic -Credential $cred -ContentType "application/json"
        }
        else
        {
            #TODO: Logfile
        }
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
        If (-not($this.TestPath($Path)))
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
        return (Get-PSRepository).where{$_.Name -ne $($this.ExcludedRepositories)}
    }

    [void]SavePSRepositoriesToFile()
    {
        $AllRepos = $this.GetPSRepository()
        if ([string]::IsNullOrEmpty($AllRepos))
        {
            #TODO: Logfile
        }
        else
        {
            $AllRepos | ConvertTo-Json | Out-File -FilePath $this.PSGalleryPath
        }
    }

    [string[]]GetPSRepositoryFile()
    {
        $content = Get-Content -Path $this.EncodedPSRepotitoryPath -Raw
        return $content
    }

    #endregion

    #region Modules
    [Collections.ArrayList] GetPSModules()
    {
        $AllModules = New-Object -TypeName System.Collections.ArrayList
        $AllModulesFolderSize = $this.CalculateModuleFoldersSize($this.IncludedPSModulePaths)
        $SystemDriveFreespace = $this.CalculateFreespaceOnSystemDrive()
        $this.CreateEmptyFolder($this.PSProfileSyncPath, "ModuleArchive")

        if ($SystemDriveFreespace.Freespace -lt $AllModulesFolderSize)
        {
            throw "We cannot create the zip archive, because the System drive has not enough free disk space."
        }
        else
        {
            foreach ($Path in $this.IncludedPSModulePaths)
            {
                $ModulesInPath = Get-ChildItem -Path $Path -Exclude $this.ExcludedModules

                if ($ModulesInPath -eq $null)
                {
                    #TODO: Logfile
                }
                else
                {
                    $AllModules.Add($ModulesInPath)

                    foreach ($Module in $ModulesInPath)
                    {
                        $this.ConverttoZipArchive($Module, $this.PSModuleArchiveFolderPath)
                    }
                }
            }
            $this.RemoveEmptyFolder($this.PSModuleArchiveFolderPath)
            return $AllModules
        }
    }

    [double]CalculateModuleFoldersSize([string[]]$ModuleFolderPaths)
    {
        [double]$Foldersize = 0
        foreach ($Folderpath in $ModuleFolderPaths)
        {
            $Foldersize += ((Get-ChildItem -path $Folderpath -recurse | measure-object -property length -sum).sum)
        }
        return $Foldersize
    }

    [void]SavePSModulesToFile()
    {
        $Modules = $this.GetPSModules()
        if ($Modules -eq $null)
        {
            #TODO: Logfile
        }
        else
        {
            $Modules | ConvertTo-Json | Out-File -FilePath $this.PSModulePath
        }
    }

    [string[]]GetPSModuleFile()
    {
        $content = Get-Content -Path $this.PSModulePath -Raw
        return $content
    }
    #endregion

    #endregion



    #region HelperMethods
    [bool] TestPath([string]$Path)
    {
        if (Test-Path -Path $Path)
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
        if (-not( $this.TestPath($TargetPath) ) )
        {
            Compress-Archive -Path $SourePath -DestinationPath $TargetPath -CompressionLevel Optimal
        }
        else
        {
            $this.UpdateZipArchive($TargetPath, $SourePath)
        }

    }

    [void]UpdateZipArchive([string]$ZipPath, [string]$SourePath)
    {
        Compress-Archive -Path $SourePath -Update -DestinationPath $ZipPath
    }

    [void] ExecuteEncodeCertUtil([string]$SourePath, [string]$TargetPath)
    {
        Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-encode", $SourePath, $TargetPath
    }

    [void] ExecuteDecodeCertUtil([string]$SourePath, [string]$TargetPath)
    {
        Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-decode", $SourePath, $TargetPath -Wait
    }

    [string]GetDocumentsFolder()
    {
        return [environment]::getfolderpath("mydocuments")
    }

    [PSCustomObject]CalculateFreespaceOnSystemDrive()
    {
        [string]$freespace = (Get-Volume -DriveLetter $env:SystemDrive).SizeRemaining
        $obj = [PSCustomObject]@{
            FreeSpace = $freespace
        }

        return $obj
    }

    [void]SaveCalculateFreespaceOnSystemDrive()
    {
        $freespace = $this.CalculateFreespaceOnSystemDrive()
        $freespace | ConvertTo-Json | Out-File -FilePath $this.PSFreeSpacePath
    }

    [void]CreateEmptyFolder([string]$Path, [string]$FolderName)
    {
        if ( -not ($this.TestPath($this.PSModuleArchiveFolderPath)) )
        {
            New-Item -ItemType Directory -Path $Path -Name $FolderName
        }
    }

    [void]RemoveEmptyFolder([string]$FolderName)
    {
        Remove-Item -Path $FolderName -Force
    }


    <# [bool]IsGitInstalled()
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
    } #>
    #endregion
}   #endregion