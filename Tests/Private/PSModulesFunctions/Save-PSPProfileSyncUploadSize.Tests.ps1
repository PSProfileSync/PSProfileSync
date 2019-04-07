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
    Context "Save-PSPProfileSyncModuleUploadSize" {
        It "Saves to File correctly" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\SomeFolder"
            }
            Mock -CommandName "Measure-PSPModulesSyncUploadSize" -MockWith {
                return 845697
            }
            Mock -CommandName "ConvertTo-Json" -MockWith { }
            Mock -CommandName "Out-File" -MockWith { }

            Save-PSPProfileSyncModuleUploadSize

            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 2
            Assert-MockCalled -CommandName "Measure-PSPModulesSyncUploadSize" -Exactly 1
            Assert-MockCalled -CommandName "ConvertTo-Json" -Exactly 1
        }
    }
}