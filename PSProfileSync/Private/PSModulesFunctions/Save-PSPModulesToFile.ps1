function Save-PSPModulesToFile
{
    $PSModulePath = Get-PSFConfigValue -FullName "PSProfileSync.modules.modulepath"# all included psmodulepaths
    $IncludedPSModulePaths = Get-PSFConfigValue -FullName "PSProfileSync.modules.includedpsmodulepaths"
    $ExcludedModules = Get-PSFConfigValue -FullName "PSProfileSync.modules.excludedmodules"
    $PSModuleArchiveFolderPath = Get-PSFConfigValue -FullName "PSProfileSync.modules.modulearchivefolderpathzip"
    $PSProfileSyncPath = Get-PSFConfigValue -FullName "PSProfileSync.modules.psprofilesyncpath"

    $getPSPModulesSplat = @{
        ExcludedModules           = $ExcludedModules
        PSProfileSyncPath         = $PSProfileSyncPath
        PSModuleArchiveFolderPath = $PSModuleArchiveFolderPath
        IncludedPSModulePaths     = $IncludedPSModulePaths
    }
    $Modules = Get-PSPModules @getPSPModulesSplat

    if ($Modules -eq $null)
    {
        return $null
    }
    else
    {
        $Modules | ConvertTo-Json | Out-File -FilePath $PSModulePath
    }

}