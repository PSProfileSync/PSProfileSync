class PSProfileSyncModulesClass
{
    [string]$MyDocuments = [Environment]::GetFolderPath("MyDocuments")

    [string]$PSModuleArchiveFolderPath = "$env:APPDATA\PSProfileSync\ModuleArchive"
    [string]$PSModulePath = "$env:APPDATA\PSProfileSync\ModulesListAvailable.json"

    # Encoded modules
    [string]$EncodedPSModulePath = "$env:APPDATA\PSProfileSync\ModulesListAvailable.txt"
    [string]$EncodedPSModuleArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ModuleArchive.txt"
    [string]$PSModuleArchiveFolderPathZip = "$env:APPDATA\PSProfileSync\ModuleArchive.zip"

    # Required disk space
    [string]$PSPProfileSyncModulesFolderSizePath = "$env:APPDATA\PSProfileSync\PSProfileSyncModulesFolderSize.json"

    # Modules that need to be excluded out of the box
    [string[]]$ExcludedModules = @(
        "PowerShellGet",
        "PackageManagement",
        "Microsoft.PowerShell.Operation.Validation",
        "Pester",
        "PSReadline"
    )

    [String[]]$IncludedPSModulePaths = @(
        "$($this.MyDocuments)\PowerShell\Modules",
        "$($this.MyDocuments)\WindowsPowerShell\Modules",
        "$env:ProgramFiles\PowerShell\Modules",
        "$env:ProgramFiles\WindowsPowerShell\Modules"
    )

    [Collections.ArrayList] GetPSModules()
    {
        $objHelperFunctionClass = [PSProfileSyncHelperClass]::new()

        $AllModules = New-Object -TypeName System.Collections.ArrayList
        $AllModulesFolderSize = $objHelperFunctionClass.CalculateFolderFileSizes($this.IncludedPSModulePaths)
        $SystemDriveFreespace = $objHelperFunctionClass.CalculateFreespaceOnSystemDrive()
        $objHelperFunctionClass.CreateEmptyFolder($objHelperFunctionClass.PSProfileSyncPath, "ModuleArchive")

        if ($SystemDriveFreespace -lt $AllModulesFolderSize)
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
                        $objHelperFunctionClass.ConverttoZipArchive($Module, $this.PSModuleArchiveFolderPath)
                    }
                }
            }
            $objHelperFunctionClass.RemoveEmptyFolder($this.PSModuleArchiveFolderPath)
            return $AllModules
        }
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

    [pscustomobject]CalculatePSModulesSyncUploadSize()
    {
        $objHelperFunctionClass = [PSProfileSyncHelperClass]::new()
        $PSModulePathSize = $objHelperFunctionClass.CalculateFolderFileSizes($this.IncludedPSModulePaths)
        $returnvalue = [PSCustomObject]@{
            PSProfileSyncUploadSize = $PSModulePathSize
        }
        return $returnvalue
    }

    [void]SavePSProfileSyncUploadSize()
    {
        $freespace = $this.CalculatePSModulesSyncUploadSize()
        $freespace | ConvertTo-Json | Out-File -FilePath $this.PSPProfileSyncModulesFolderSizePath
    }
}