function Save-PSPRepositoriesToFile
{
    $ExcludedRepositories = Get-PSFConfigValue -FullName "PSProfileSync.repository.excludedrepositories"
    $PSGalleryPath = Get-PSFConfigValue -FullName "PSProfileSync.repository.gallerypath"

    $AllRepos = Get-PSPRepository -ExcludedRepositories $ExcludedRepositories
    if ($AllRepos -eq $null)
    {
        return $null
        #TODO: Logfile
    }
    else
    {
        $AllRepos | ConvertTo-Json | Out-File -FilePath $PSGalleryPath
        return $AllRepos
    }
}