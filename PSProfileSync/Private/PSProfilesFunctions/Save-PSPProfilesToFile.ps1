function Save-PSPProfilesToFile
{
    # Config Values for WPS
    $IncludedPSProfilePathsWPS = Get-PSFConfigValue -FullName "PSProfileSync.profile.includedpsprofilepathswps"
    $PSProfileWPSArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilewpsarchivefolderpathzip"
    $PSProfileArchiveWPSFolderPath = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilearchivewpsfolderpath"
    $PSProfilePathWPS = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepathwps"

    # Config Values for PSCore
    $IncludedPSProfilePathsPSCore = Get-PSFConfigValue -FullName "PSProfileSync.profile.includedpsprofilepathspscore"
    $PSProfilePSCoreArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepscorearchivefolderpathzip"
    $PSProfileArchivePSCoreFolderPath = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilearchivepscorefolderpath"
    $PSProfilePathPSCore = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepathpscore"

    # Config Values for DevEnv
    $IncludedPSProfilePathsDevEnv = Get-PSFConfigValue -FullName "PSProfileSync.profile.includedpsprofilepathsdevenv"
    $PSProfileDevEnvArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.profiledevenvarchivefolderpathzip"
    $PSProfileArchiveDevEnvFolderPath = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilearchivedevenvfolderpath"
    $PSProfilePathDevEnv = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilepathdevenv"

    $getPSPProfilesSplat = @{
        ZipName        = "ProfileArchiveWPS"
        FolderToRemove = $PSProfileArchiveWPSFolderPath
        ZipFilePath    = $PSProfileWPSArchiveFolderPathZip
        ProfilePaths   = $IncludedPSProfilePathsWPS
    }
    $ProfilesWPS = Get-PSPProfiles @getPSPProfilesSplat

    $getPSPProfilesSplat = @{
        ZipName        = "ProfileArchivePSCore"
        FolderToRemove = $PSProfileArchivePSCoreFolderPath
        ZipFilePath    = $PSProfilePSCoreArchiveFolderPathZip
        ProfilePaths   = $IncludedPSProfilePathsPSCore
    }
    $ProfilesWPS = Get-PSPProfiles @getPSPProfilesSplat

    $getPSPProfilesSplat = @{
        ZipName        = "ProfileArchiveDevEnv"
        FolderToRemove = $PSProfileArchiveDevEnvFolderPath
        ZipFilePath    = $PSProfileDevEnvArchiveFolderPathZip
        ProfilePaths   = $IncludedPSProfilePathsDevEnv
    }
    $ProfilesWPS = Get-PSPProfiles @getPSPProfilesSplat

    if ($ProfilesWPS.Count -eq 0)
    {
        #TODO: Logfile
    }
    else
    {
        $ProfilesWPS | ConvertTo-Json | Out-File -FilePath $PSProfilePathWPS
    }

    if ($ProfilesPSCore.Count -eq 0)
    {
        #TODO: Logfile
    }
    else
    {
        $ProfilesPSCore | ConvertTo-Json | Out-File -FilePath $PSProfilePathPSCore
    }

    if ($ProfilesDevEnv.Count -eq 0)
    {
        #TODO: Logfile
    }
    else
    {
        $ProfilesDevEnv | ConvertTo-Json | Out-File -FilePath $PSProfilePathDevEnv
    }
}