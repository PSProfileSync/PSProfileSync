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
    Context "Measure-PSPProfileUploadSize" {
        It "Measures the uploadsize correctly" {
            Mock -CommandName "Measure-PSPFolderFileSizes" -MockWith {
                return 84576
            }
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\Value"
            }

            $retval = Measure-PSPProfileUploadSize -IncludedPSModulePaths $IncludedPSModulePaths

            $retval | Should -BeOfType System.Management.Automation.PSCustomObject

            Assert-MockCalled -CommandName "Measure-PSPFolderFileSizes" -Exactly 3
        }
    }
}