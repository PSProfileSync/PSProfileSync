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
    Context "Save-PSPProfilesToFile" {
        It "Saves Modules to file correctly: No Profiles were returned" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\SomeFolder"
            }
            Mock -CommandName "Get-PSPProfiles" -MockWith {
                return $null
            }

            $retval = Save-PSPProfilesToFile
            $retval | Should -BeNullOrEmpty
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 12
            Assert-MockCalled -CommandName "Get-PSPProfiles" -Exactly 3
        }

        It "Saves Modules to file correctly: Profiles were returned" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "TestDrive:\SomeFolder"
            }
            Mock -CommandName "Get-PSPProfiles" -MockWith {
                return [PSCustomObject]@{
                    Name = "SomeName"
                }
            }
            Mock -CommandName "ConvertTo-Json" -MockWith { }
            Mock -CommandName "Out-File" -MockWith { }

            Save-PSPProfilesToFile

            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 24
            Assert-MockCalled -CommandName "Get-PSPProfiles" -Exactly 6
            Assert-MockCalled -CommandName "ConvertTo-Json" -Exactly 3
        }
    }
}