using Namespace System

class PSProfileSyncProfilesClass
{
    [string]$MyDocuments = [Environment]::GetFolderPath("MyDocuments")

    # Profile paths
    [string]$PSProfilePathWPS = "$env:APPDATA\PSProfileSync\ProfilesListAvailableWPS.json"
    [string]$PSProfilePathPSCore = "$env:APPDATA\PSProfileSync\ProfilesListAvailablePSCore.json"
    [string]$PSProfilePathDevEnv = "$env:APPDATA\PSProfileSync\ProfilesListAvailableDevEnv.json"

    # Encoded profiles
    [string]$EncodedPSProfilePathWPS = "$env:APPDATA\PSProfileSync\ProfilesListAvailableWPS.txt"
    [string]$EncodedPSProfilePathPSCore = "$env:APPDATA\PSProfileSync\ProfilesListAvailablePSCore.txt"
    [string]$EncodedPSProfilePathDevEnv = "$env:APPDATA\PSProfileSync\ProfilesListAvailableDevEnv.txt"

    [string]$EncodedPSProfileWPSArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ProfileArchiveWPS.txt"
    [string]$EncodedPSProfilePSCoreArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ProfileArchivePSCore.txt"
    [string]$EncodedPSProfileDevEnvArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ProfileArchiveDevEnv.txt"

    [string]$PSProfileArchiveWPSFolderPath = "$env:APPDATA\PSProfileSync\ProfileArchiveWPS"
    [string]$PSProfileArchivePSCoreFolderPath = "$env:APPDATA\PSProfileSync\ProfileArchivePSCore"
    [string]$PSProfileArchiveDevEnvFolderPath = "$env:APPDATA\PSProfileSync\ProfileArchiveDevEnv"

    [string]$PSProfileWPSArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ProfileArchiveWPS.zip"
    [string]$PSProfilePSCoreArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ProfileArchivePSCore.zip"
    [string]$PSProfileDevEnvArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ProfileArchiveDevEnv.zip"

    # Required disk space
    [string]$PSPProfileSyncProfileFolderSizePath = "$env:APPDATA\PSProfileSync\PSProfileSyncProfileFolderSize.json"

    [string[]]$IncludedPSProfilePathsWPS = @(
        "$($this.MyDocuments)\WindowsPowerShell\profile.ps1"
        "$($this.MyDocuments)\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
        "$env:windir\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1"
        "$env:windir\System32\WindowsPowerShell\v1.0\profile.ps1"
    )

    [string[]]$IncludedPSProfilePathsPSCore = @(
        "$($this.MyDocuments)\PowerShell\Microsoft.PowerShell_profile.ps1"
        "$($this.MyDocuments)\PowerShell\profile.ps1"
        "$env:ProgramFiles\PowerShell\6\Microsoft.PowerShell_profile.ps1"
        "$env:ProgramFiles\PowerShell\6\profile.ps1"
    )

    [string[]]$IncludedPSProfilePathsDevEnv = @(
        "$($this.MyDocuments)\PowerShell\Microsoft.VSCode_profile.ps1"
        "$($this.MyDocuments)\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
    )

    [void]SavePSProfilesToFile()
    {
        $ProfilesWPS = $this.GetPSProfiles(
            "ProfileArchiveWPS",
            $this.IncludedPSProfilePathsWPS,
            $this.PSProfileWPSArchiveFolderPathZip,
            $this.PSProfileArchiveWPSFolderPath
        )

        $ProfilesPSCore = $this.GetPSProfiles(
            "ProfileArchivePSCore",
            $this.IncludedPSProfilePathsPSCore,
            $this.PSProfilePSCoreArchiveFolderPathZip,
            $this.PSProfileArchivePSCoreFolderPath
        )

        $ProfilesDevEnv = $this.GetPSProfiles(
            "ProfileArchiveDevEnv",
            $this.IncludedPSProfilePathsDevEnv,
            $this.PSProfileDevEnvArchiveFolderPathZip,
            $this.PSProfileArchiveDevEnvFolderPath
        )

        if ($ProfilesWPS.Count -eq 0)
        {
            #TODO: Logfile
        }
        else
        {
            $ProfilesWPS | ConvertTo-Json | Out-File -FilePath $this.PSProfilePathWPS
        }

        if ($ProfilesPSCore.Count -eq 0)
        {
            #TODO: Logfile
        }
        else
        {
            $ProfilesPSCore | ConvertTo-Json | Out-File -FilePath $this.PSProfilePathPSCore
        }

        if ($ProfilesDevEnv.Count -eq 0)
        {
            #TODO: Logfile
        }
        else
        {
            $ProfilesDevEnv | ConvertTo-Json | Out-File -FilePath $this.PSProfilePathDevEnv
        }
    }

    [Collections.ArrayList] GetPSProfiles([string]$ZipName, [pscustomobject]$ProfilePaths, [string]$ZipFilePath, [string]$FolderToRemove)
    {
        $objHelperFunctionClass = [PSProfileSyncHelperClass]::new()

        $AllProfiles = New-Object -TypeName System.Collections.ArrayList
        $AllProfilesFileSize = $objHelperFunctionClass.CalculateFolderFileSizes($ProfilePaths)
        $SystemDriveFreespace = $objHelperFunctionClass.CalculateFreespaceOnSystemDrive()
        $objHelperFunctionClass.CreateEmptyFolder($objHelperFunctionClass.PSProfileSyncPath, $ZipName)

        if ($SystemDriveFreespace -lt $AllProfilesFileSize)
        {
            throw "We cannot create the zip archive, because the System drive has not enough free disk space."
        }
        else
        {
            foreach ($Path in $ProfilePaths)
            {
                if (-not ( Test-Path -Path $Path ) )
                {
                    #TODO: Logfile
                }
                else
                {
                    $AllProfiles.Add($Path)

                    $objHelperFunctionClass.ConverttoZipArchive($Path, $ZipFilePath)
                }
            }
            $objHelperFunctionClass.RemoveEmptyFolder($FolderToRemove)
            return $AllProfiles
        }
    }

    [pscustomobject]CalculatePSProfileUploadSize()
    {
        $objHelperFunctionClass = [PSProfileSyncHelperClass]::new()
        [uint64]$total = 0
        $PSModuleDevEnvPathSize = $objHelperFunctionClass.CalculateFolderFileSizes($this.IncludedPSProfilePathsDevEnv)
        $PSModulePSCorePathSize = $objHelperFunctionClass.CalculateFolderFileSizes($this.IncludedPSProfilePathsPSCore)
        $PSModuleWPSPathSize = $objHelperFunctionClass.CalculateFolderFileSizes($this.IncludedPSProfilePathsWPS)
        $total = $PSModuleDevEnvPathSize + $PSModulePSCorePathSize + $PSModuleWPSPathSize
        $returnvalue = [PSCustomObject]@{
            PSProfileSyncUploadSize = $total
        }
        return $returnvalue
    }

    [void]SavePSProfileSyncUploadSize()
    {
        $freespace = $this.CalculatePSProfileUploadSize()
        $freespace | ConvertTo-Json | Out-File -FilePath $this.PSPProfileSyncProfileFolderSizePath
    }
}