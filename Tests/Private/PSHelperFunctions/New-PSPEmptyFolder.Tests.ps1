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
    Context "New-PSPEmptyFolder" {

        $Path = "C:\SomePath"
        $FolderName = "SomeFolderName"

        It "Folder should get created if It is not there" {
            Mock -CommandName "Join-Path" -MockWith {
                return "C:\SomePath\SomeFolderName"
            }
            Mock -CommandName "Test-Path" -MockWith {
                return $false
            }
            Mock -CommandName "New-Item" -MockWith { }

            New-PSPEmptyFolder -Path $Path -FolderName $FolderName

            Assert-MockCalled -CommandName "Join-Path" -Exactly 1
            Assert-MockCalled -CommandName "Test-Path" -Exactly 1
            Assert-MockCalled -CommandName "New-Item" -Exactly 1
        }
    }
}