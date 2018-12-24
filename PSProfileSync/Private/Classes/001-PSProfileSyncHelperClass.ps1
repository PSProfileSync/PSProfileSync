using Namespace System

class PSProfileSyncHelperClass
{
    [string]$PSProfileSyncPath = "$env:APPDATA\PSProfileSync"

    [void] ConverttoZipArchive([string]$SourePath, [String]$TargetPath)
    {
        if (-not( Test-Path -Path $TargetPath ) )
        {
            Compress-Archive -Path $SourePath -DestinationPath $TargetPath -CompressionLevel Optimal
        }
        else
        {
            $this.UpdateZipArchive($TargetPath, $SourePath)
        }
    }

    [void]UpdateZipArchive([string]$ZipPath, [string]$SourePath)
    {
        Compress-Archive -Path $SourePath -Update -DestinationPath $ZipPath
    }

    [void] ExecuteEncodeCertUtil([string]$SourePath, [string]$TargetPath)
    {
        Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-encode", $SourePath, $TargetPath
    }

    [void] ExecuteDecodeCertUtil([string]$SourePath, [string]$TargetPath)
    {
        Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-decode", $SourePath, $TargetPath -Wait
    }

    [uint64]CalculateFolderFileSizes([string[]]$FolderPaths)
    {
        [uint64]$Foldersize = 0
        foreach ($Folder in $FolderPaths)
        {
            $Foldersize += ((Get-ChildItem -Path $Folder -Recurse | Measure-Object -Property length -Sum).sum)
        }
        return $Foldersize
    }

    [uint64]CalculateFreespaceOnSystemDrive()
    {
        [uint64]$freespace = (Get-Volume -DriveLetter $env:SystemDrive).SizeRemaining
        return $freespace
    }

    [void]CreateEmptyFolder([string]$Path, [string]$FolderName)
    {
        $FullPath = Join-Path -Path $Path -ChildPath $FolderName

        if ( -not (Test-Path -Path $FullPath) )
        {
            New-Item -ItemType Directory -Path $Path -Name $FolderName
        }
    }

    [void]RemoveEmptyFolder([string]$FolderName)
    {
        Remove-Item -Path $FolderName -Force
    }
}