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
    Context "Test-PSPForGitAuthFile" {
        Context "Path to Git Authfile exist" {
            Mock -CommandName Test-Path -MockWith {return $true}
            $result = Test-PSPForGitAuthFile -PathAuthFile "TestDrive:\testfile.xml"

            It "Path to Git Authfile exist" {
                $result | Should -Be $true
                Assert-MockCalled -CommandName Test-Path -Exactly 1
            }
        }

        Context "Path to Git Authfile does not exist" {
            Mock -CommandName Test-Path -MockWith {return $false}
            $result = Test-PSPForGitAuthFile -PathAuthFile "TestDrive:\testfile.xml"

            It "Path to Git Authfile does not exist" {
                $result | Should -Be $false
                Assert-MockCalled -CommandName Test-Path -Exactly 1
            }
        }
    }
}