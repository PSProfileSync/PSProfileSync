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
    Context "Get-PSPRepository" {

        $ExcludendRepos = @(
            "Test"
            "Test1"
        )

        It "Gets an object back" {
            $obj = New-MockObject -Type System.Object
            Mock -CommandName "Get-PSRepository" -MockWith {
                return $obj
            }

            $returnvalue = Get-PSPRepository -ExcludedRepositories $ExcludendRepos
            $returnvalue | Should -BeOfType System.Object
            Assert-MockCalled -CommandName "Get-PSRepository" -Exactly 1
        }
    }
}