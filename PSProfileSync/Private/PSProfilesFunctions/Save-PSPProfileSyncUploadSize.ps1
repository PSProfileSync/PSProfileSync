function Save-PSPProfileSyncUploadSize
{
    $PSPProfileSyncProfileFolderSizePath = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilesyncprofilefoldersizepath"

    $freespace = Measure-PSPProfileUploadSize
    $freespace | ConvertTo-Json | Out-File -FilePath $PSPProfileSyncProfileFolderSizePath
}