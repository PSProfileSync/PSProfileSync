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
    Context "Remove-PSPEmptyFolder" {

        $FolderName = "C:\SomeFolder"

        It "Removes the folder" {
            Mock -CommandName "Remove-Item" -MockWith { }

            Remove-PSPEmptyFolder -FolderName $FolderName

            Assert-MockCalled -CommandName "Remove-Item" -Exactly 1
        }
    }
}