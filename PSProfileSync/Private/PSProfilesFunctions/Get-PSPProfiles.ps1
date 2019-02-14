function Get-PSPProfiles
{
    [CmdletBinding()]
    param
    (
        # The Name of the Zip
        [Parameter(Mandatory)]
        [string]
        $ZipName,

        # all the profile paths
        [Parameter(Mandatory)]
        [PSCustomObject]
        $ProfilePaths,

        # the zip file path
        [Parameter(Mandatory)]
        [string]
        $ZipFilePath,

        # the folder to remove
        [Parameter(Mandatory)]
        [string]
        $FolderToRemove
    )

    $AllProfiles = New-Object -TypeName System.Collections.ArrayList
    $AllProfilesFileSize = Measure-PSPFolderFileSizes -FolderPath $ProfilePaths
    $SystemDriveFreespace = Measure-PSPFreespaceOnSystemDrive
    $PSProfileSyncPath = Get-PSFConfigValue -FullName "PSProfileSync.modules.psprofilesyncpath"
    New-PSPEmptyFolder -Path $PSProfileSyncPath -FolderName $ZipName

    if ($SystemDriveFreespace -lt $AllProfilesFileSize)
    {
        throw "We cannot create the zip archive, because the System drive has not enough free disk space."
    }
    else
    {
        foreach ($Path in $ProfilePaths)
        {
            if (-not ( Test-Path -Path $Path ) )
            {
                #TODO: Logfile
            }
            else
            {
                $AllProfiles.Add($Path)

                Convertto-PSPZipArchive -SourcePath $Path -TargetPath $ZipFilePath
            }
        }
        Remove-PSPEmptyFolder -FolderName $FolderToRemove
        return $AllProfiles
    }
}