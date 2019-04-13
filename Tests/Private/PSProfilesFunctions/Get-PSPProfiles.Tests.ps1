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
    Context "Get-PSPProfiles" {

        $ZipName = "Profiles.zip"
        $ProfilePaths = @(
            "TestDrive:\SomePath"
        )
        $ZipFilePath = "TestDrive:\$ZipName"
        $FolderToRemove = "Profiles"

        It "SystemDrive Freespace is less then AllModules Folder Size" {
            Mock -CommandName "Measure-PSPFolderFileSizes" -MockWith {
                return 4875
            }
            Mock -CommandName "Measure-PSPFreespaceOnSystemDrive" -MockWith {
                return 56
            }
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\PSProfileSync"
            }
            Mock -CommandName "New-PSPEmptyFolder" -MockWith { }

            $splat = @{
                ZipName        = $ZipName
                ProfilePaths   = $ProfilePaths
                ZipFilePath    = $ZipFilePath
                FolderToRemove = $FolderToRemove
            }

            { Get-PSPProfiles @splat } | Should -Throw

            Assert-MockCalled -CommandName "Measure-PSPFolderFileSizes" -Exactly 1
            Assert-MockCalled -CommandName "Measure-PSPFreespaceOnSystemDrive" -Exactly 1
            Assert-MockCalled -CommandName "New-PSPEmptyFolder" -Exactly 1
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 1
        }

        It "SystemDrive Freespace is not less then AllModules Folder Size but no modules where returned" {
            Mock -CommandName "Measure-PSPFolderFileSizes" -MockWith {
                return 4875
            }
            Mock -CommandName "Measure-PSPFreespaceOnSystemDrive" -MockWith {
                return 5665778
            }
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\PSProfileSync"
            }
            Mock -CommandName "New-PSPEmptyFolder" -MockWith { }
            Mock -CommandName "Test-Path" -MockWith {
                return $false
            }

            $splat = @{
                ZipName        = $ZipName
                ProfilePaths   = $ProfilePaths
                ZipFilePath    = $ZipFilePath
                FolderToRemove = $FolderToRemove
            }

            Get-PSPProfiles @splat | Should -BeNullOrEmpty
            Assert-MockCalled -CommandName "Measure-PSPFolderFileSizes" -Exactly 2
            Assert-MockCalled -CommandName "Measure-PSPFreespaceOnSystemDrive" -Exactly 2
            Assert-MockCalled -CommandName "New-PSPEmptyFolder" -Exactly 2
            Assert-MockCalled -CommandName "Test-Path" -Exactly 1
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 2
        }

        It "SystemDrive Freespace is not less then AllModules Folder Size and modules where returned" {
            Mock -CommandName "Measure-PSPFolderFileSizes" -MockWith {
                return 4875
            }
            Mock -CommandName "Measure-PSPFreespaceOnSystemDrive" -MockWith {
                return 5665778
            }
            Mock -CommandName "Test-Path" -MockWith {
                return $true
            }
            Mock -CommandName "New-PSPEmptyFolder" -MockWith { }
            Mock -CommandName "Convertto-PSPZipArchive" -MockWith { }
            Mock -CommandName "Remove-PSPEmptyFolder" -MockWith { }

            $splat = @{
                ZipName        = $ZipName
                ProfilePaths   = $ProfilePaths
                ZipFilePath    = $ZipFilePath
                FolderToRemove = $FolderToRemove
            }

            $retval = Get-PSPProfiles @splat
            $retval | Should -BeOfType System.Object

            Assert-MockCalled -CommandName "Measure-PSPFolderFileSizes" -Exactly 3
            Assert-MockCalled -CommandName "Measure-PSPFreespaceOnSystemDrive" -Exactly 3
            Assert-MockCalled -CommandName "New-PSPEmptyFolder" -Exactly 3
            Assert-MockCalled -CommandName "Test-Path" -Exactly 2
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 3
            Assert-MockCalled -CommandName "Convertto-PSPZipArchive" -Exactly 1
            Assert-MockCalled -CommandName "Remove-PSPEmptyFolder" -Exactly 1
        }
    }
}