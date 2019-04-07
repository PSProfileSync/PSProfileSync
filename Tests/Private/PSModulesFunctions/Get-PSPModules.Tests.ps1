$ModuleManifestName = 'PSProfileSync.psd1'
$Root = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
$ModuleManifestPath = Join-Path $Root -ChildPath "PSProfileSync\$ModuleManifestName"

if (Get-Module PSProfileSync)
{
    Remove-Module PSProfileSync
    Import-Module $ModuleManifestPath
}
else
{
    Import-Module $ModuleManifestPath
}

InModuleScope PSProfileSync {
    Context "Get-PSPModules" {

        $IncludedPSModulePaths = @(
            "InclModule"
            "InclModule1"
        )
        $ExcludedModules = @(
            "ExclModule"
            "ExclModule1"
        )
        $PSModuleArchiveFolderPath = "TestDrive:\Archive.zip"
        $PSProfileSyncPath = "PSPPath"

        It "SystemDrive Freespace is less then AllModules Folder Size" {
            Mock -CommandName "Measure-PSPFolderFileSizes" -MockWith {
                return 4875
            }
            Mock -CommandName "Measure-PSPFreespaceOnSystemDrive" -MockWith {
                return 56
            }
            Mock -CommandName "New-PSPEmptyFolder" -MockWith { }

            $splat = @{
                IncludedPSModulePaths     = $IncludedPSModulePaths
                ExcludedModules           = $ExcludedModules
                PSModuleArchiveFolderPath = $PSModuleArchiveFolderPath
                PSProfileSyncPath         = $PSProfileSyncPath
            }

            { Get-PSPModules @splat } | Should -Throw
            Assert-MockCalled -CommandName "Measure-PSPFolderFileSizes" -Exactly 1
            Assert-MockCalled -CommandName "Measure-PSPFreespaceOnSystemDrive" -Exactly 1
            Assert-MockCalled -CommandName "New-PSPEmptyFolder" -Exactly 1
        }

        It "SystemDrive Freespace is not less then AllModules Folder Size but no modules where returned" {
            Mock -CommandName "Measure-PSPFolderFileSizes" -MockWith {
                return 4875
            }
            Mock -CommandName "Measure-PSPFreespaceOnSystemDrive" -MockWith {
                return 5665778
            }
            Mock -CommandName "New-PSPEmptyFolder" -MockWith { }
            Mock -CommandName "Get-ChildItem" -MockWith {
                return $null
            }

            $splat = @{
                IncludedPSModulePaths     = $IncludedPSModulePaths
                ExcludedModules           = $ExcludedModules
                PSModuleArchiveFolderPath = $PSModuleArchiveFolderPath
                PSProfileSyncPath         = $PSProfileSyncPath
            }

            Get-PSPModules @splat | Should -BeNullOrEmpty
            Assert-MockCalled -CommandName "Measure-PSPFolderFileSizes" -Exactly 2
            Assert-MockCalled -CommandName "Measure-PSPFreespaceOnSystemDrive" -Exactly 2
            Assert-MockCalled -CommandName "New-PSPEmptyFolder" -Exactly 2
            Assert-MockCalled -CommandName "Get-ChildItem" -Exactly 1
        }

        It "SystemDrive Freespace is not less then AllModules Folder Size and modules where returned" {
            Mock -CommandName "Measure-PSPFolderFileSizes" -MockWith {
                return 4875
            }
            Mock -CommandName "Measure-PSPFreespaceOnSystemDrive" -MockWith {
                return 5665778
            }
            Mock -CommandName "New-PSPEmptyFolder" -MockWith { }
            Mock -CommandName "Get-ChildItem" -MockWith {
                @(
                    [PSCustomObject]@{ FullName = 'TestDrive:\shouldbecopied' },
                    [PSCustomObject]@{ FullName = 'TestDrive:\shouldbecopiedalso' }
                )
            }
            Mock -CommandName "Convertto-PSPZipArchive" -MockWith { }
            Mock -CommandName "Remove-PSPEmptyFolder" -MockWith { }

            $splat = @{
                IncludedPSModulePaths     = $IncludedPSModulePaths
                ExcludedModules           = $ExcludedModules
                PSModuleArchiveFolderPath = $PSModuleArchiveFolderPath
                PSProfileSyncPath         = $PSProfileSyncPath
            }

            $retval = Get-PSPModules @splat
            $retval | Should -BeOfType System.Object

            Assert-MockCalled -CommandName "Measure-PSPFolderFileSizes" -Exactly 3
            Assert-MockCalled -CommandName "Measure-PSPFreespaceOnSystemDrive" -Exactly 3
            Assert-MockCalled -CommandName "New-PSPEmptyFolder" -Exactly 3
            Assert-MockCalled -CommandName "Get-ChildItem" -Exactly 3
            Assert-MockCalled -CommandName "Convertto-PSPZipArchive" -Exactly 4
            Assert-MockCalled -CommandName "Remove-PSPEmptyFolder" -Exactly 1
        }
    }
}