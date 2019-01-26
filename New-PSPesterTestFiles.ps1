function New-PSPesterTestFiles
{
    <#
        .SYNOPSIS
        Creates Pester Tests Files of PowerShell function Files

        .DESCRIPTION
        Creates Pester Tests Files of PowerShell function Files
        in a specific folder.

        .PARAMETER SourePath
        The folder were the PowerShell function files are in

        .PARAMETER TargetPath
        The folder were the PowerShell pester Test files will be stored

        .EXAMPLE
        PS C:\> New-PSPPesterTestFiles -SourcePath $SourcePath -TargetPath $TargetPath
        Explanation of what the example does

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [string]
        $SourcePath,

        [Parameter(Mandatory)]
        [string]
        $TargetPath
    )

    $Files = Split-Path ((Get-ChildItem -Path $SourcePath).name) -LeafBase

    foreach ($File in $Files)
    {
        $TestFileName = [string]::Concat($File, ".Tests.ps1")
        $Content = @"
`$ModuleManifestName = 'PSProfileSync.psd1'
`$Root = (Get-Item `$PSScriptRoot).Parent.Parent.Parent.FullName
`$ModuleManifestPath = Join-Path `$Root -ChildPath "PSProfileSync\`$ModuleManifestName"

if (Get-Module PSProfileSync)
{
    Remove-Module PSProfileSync
    Import-Module `$ModuleManifestPath
}
else
{
    Import-Module `$ModuleManifestPath
}

InModuleScope PSProfileSync {

}
"@
        New-Item -ItemType File -Path $TargetPath -Name $TestFileName -Value $Content
    }
}
