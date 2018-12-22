class PSProfileSyncRepositoriesClass
{
    # Repositories that needs to be excluded out of the box
    [string]$ExcludedRepositories = "PSGallery"

    # Repositories
    [string]$PSGalleryPath = "$env:APPDATA\PSProfileSync\PSGallery.json"

    # Encoded repositories
    [string]$EncodedPSGalleryPath = "$env:APPDATA\PSProfileSync\PSGallery.txt"


    [Object[]] GetPSRepository()
    {
        $repositories = Get-PSRepository | Where-Object {$_.Name -ne $($this.ExcludedRepositories)}
        return $repositories
    }

    [object]SavePSRepositoriesToFile()
    {
        $AllRepos = $this.GetPSRepository()
        if ($AllRepos -eq $null)
        {
            return $null
            #TODO: Logfile
        }
        else
        {
            $AllRepos | ConvertTo-Json | Out-File -FilePath $this.PSGalleryPath
        }
        return $null
    }
}