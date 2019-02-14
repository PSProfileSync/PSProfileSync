function Save-PSPProfileSyncModuleUploadSize
{
    $IncludedPSModulePaths = Get-PSFConfigValue -FullName "PSProfileSync.modules.includedpsmodulepaths"
    $PSPProfileSyncModulesFolderSizePath = Get-PSFConfigValue -FullName "PSProfileSync.modules.profilesyncmodulesfoldersizepath"
    $freespace = Measure-PSPModulesSyncUploadSize -IncludedPSModulePaths $IncludedPSModulePaths
    $freespace | ConvertTo-Json | Out-File -FilePath $PSPProfileSyncModulesFolderSizePath
}