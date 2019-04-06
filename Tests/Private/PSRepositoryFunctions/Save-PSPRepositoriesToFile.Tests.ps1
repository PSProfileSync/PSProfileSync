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
    Context "Save-PSPRepositoriesToFile" {
        It "Repositories are null" {

            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "Some values"
            }
            Mock -CommandName "Get-PSRepository" -MockWith {
                return $null
            }

            $returnvalue = Save-PSPRepositoriesToFile
            $returnvalue | Should -BeNullOrEmpty

            Assert-MockCalled -CommandName Get-PSFConfigValue -Exactly 2
            Assert-MockCalled -CommandName Get-PSRepository -Exactly 1
        }

        It "Repositories are not null" {
            Mock -CommandName "ConvertTo-Json" -MockWith { }
            Mock -CommandName "Out-File" -MockWith { }
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "Some values"
            }
            Mock -CommandName "Get-PSRepository" -MockWith {
                $obj = New-Object -TypeName System.Object
                return $obj
            }

            $returnvalue = Save-PSPRepositoriesToFile
            $returnvalue | Should -Not -BeNullOrEmpty

            Assert-MockCalled -CommandName ConvertTo-Json -Exactly 1
            Assert-MockCalled -CommandName Get-PSFConfigValue -Exactly 4
            Assert-MockCalled -CommandName Get-PSRepository -Exactly 2
        }
    }
}