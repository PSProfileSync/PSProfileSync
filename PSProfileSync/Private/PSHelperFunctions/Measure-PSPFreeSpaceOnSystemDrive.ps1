function Measure-PSPFreeSpaceOnSystemDrive
{
    <#
        .SYNOPSIS
        Calculates the free space on the system drive

        .DESCRIPTION
        Calculates the free space on the system drive

        .EXAMPLE
        PS C:\> Measure-PSPFreeSpaceOnSystemDrive
        Get the free space on the system drive

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [uint64]$freespace = (Get-Volume -DriveLetter $env:SystemDrive).SizeRemaining
    return $freespace
}