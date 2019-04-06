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
    Context "Measure-PSPFolderFileSizes" {

        $FolderPath = @(
            "C:\SomeFolder"
            "C:\SomeFolder1"
        )

        It "Should be of type Int64" {
            Mock -CommandName "Get-ChildItem" -MockWith { }
            Mock -CommandName "Measure-Object" -MockWith {
                return [PSCustomObject]@{
                    Sum = 89473059
                }
            }

            $retval = Measure-PSPFolderFileSizes -FolderPath $FolderPath

            $retval | Should -BeOfType System.uint64
            Assert-MockCalled -CommandName "Get-ChildItem" -Exactly 2
        }
    }
}