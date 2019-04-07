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
    Context "Save-PSPModulesToFile" {
        It "Saves Modules to file correctly: No modules were returned" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\SomeFolder"
            }
            Mock -CommandName "Get-PSPModules" -MockWith {
                return $null
            }

            $retval = Save-PSPModulesToFile

            $retval | Should -BeNullOrEmpty
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 5
            Assert-MockCalled -CommandName "Get-PSPModules" -Exactly 1
        }

        It "Saves Modules to file correctly: No modules were returned" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\SomeFolder"
            }
            Mock -CommandName "Get-PSPModules" -MockWith {
                return [PSCustomObject]@{
                    Name = "SomeName"
                }
            }
            Mock -CommandName "ConvertTo-Json" -MockWith { }
            Mock -CommandName "Out-File" -MockWith { }

            Save-PSPModulesToFile

            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 10
            Assert-MockCalled -CommandName "Get-PSPModules" -Exactly 2
            Assert-MockCalled -CommandName "ConvertTo-Json" -Exactly 1
        }
    }
}