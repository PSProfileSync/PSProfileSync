function Measure-PSPProfileUploadSize
{
    $IncludedPSProfilePathsDevEnv = Get-PSFConfigValue -FullName "PSProfileSync.profile.includedpsprofilepathsdevenv"
    $IncludedPSProfilePathsPSCore = Get-PSFConfigValue -FullName "PSProfileSync.profile.includedpsprofilepathspscore"
    $IncludedPSProfilePathsWPS = Get-PSFConfigValue -FullName "PSProfileSync.profile.includedpsprofilepathswps"

    [uint64]$total = 0
    $PSModuleDevEnvPathSize = Measure-PSPFolderFileSizes -FolderPath $IncludedPSProfilePathsDevEnv
    $PSModulePSCorePathSize = Measure-PSPFolderFileSizes -FolderPath $IncludedPSProfilePathsPSCore
    $PSModuleWPSPathSize = Measure-PSPFolderFileSizes -FolderPath $IncludedPSProfilePathsWPS
    $total = $PSModuleDevEnvPathSize + $PSModulePSCorePathSize + $PSModuleWPSPathSize
    $returnvalue = [PSCustomObject]@{
        PSProfileSyncUploadSize = $total
    }
    return $returnvalue
}