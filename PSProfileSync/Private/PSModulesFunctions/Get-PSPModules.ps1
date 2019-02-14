function Get-PSPModules
{
    [CmdletBinding()]
    param
    (
        # all included psmodulepaths
        [Parameter(Mandatory)]
        [string[]]
        $IncludedPSModulePaths,

        # all excluded modules as path
        [Parameter(Mandatory)]
        [string[]]
        $ExcludedModules,

        # the modulepath
        [Parameter(Mandatory)]
        [string]
        $PSModuleArchiveFolderPath,

        # the psprofilesyncpath
        [Parameter(Mandatory)]
        [string]
        $PSProfileSyncPath
    )

    $AllModules = New-Object -TypeName System.Collections.ArrayList
    $AllModulesFolderSize = Measure-PSPFolderFileSizes -FolderPath $IncludedPSModulePaths
    $SystemDriveFreespace = Measure-PSPFreespaceOnSystemDrive
    New-PSPEmptyFolder -Path $PSProfileSyncPath -FolderName "ModuleArchive"

    if ($SystemDriveFreespace -lt $AllModulesFolderSize)
    {
        throw "We cannot create the zip archive, because the System drive has not enough free disk space."
    }
    else
    {
        foreach ($Path in $IncludedPSModulePaths)
        {
            $ModulesInPath = Get-ChildItem -Path $Path -Exclude $ExcludedModules

            if ($ModulesInPath -eq $null)
            {
                #TODO: Logfile
            }
            else
            {
                $AllModules.Add($ModulesInPath)

                foreach ($Module in $ModulesInPath)
                {
                    Convertto-PSPZipArchive -SourcePath $Module -TargetPath $PSModuleArchiveFolderPath
                }
            }
        }
        Remove-PSPEmptyFolder -FolderName $PSModuleArchiveFolderPath
        return $AllModules
    }
}