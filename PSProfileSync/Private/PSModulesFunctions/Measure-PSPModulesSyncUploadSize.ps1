function Measure-PSPModulesSyncUploadSize
{
    [CmdletBinding()]
    param (
        # all included PSModulePaths
        [Parameter(Mandatory)]
        [string[]]
        $IncludedPSModulePaths
    )


    $PSModulePathSize = Measure-PSPFolderFileSizes -FolderPath $IncludedPSModulePaths
    $returnvalue = [PSCustomObject]@{
        PSProfileSyncUploadSize = $PSModulePathSize
    }
    return $returnvalue
}