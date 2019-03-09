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
    Context "New-PSPGitAuthFile" {

        $UserName = "testuser"
        $PatToken = "00000"
        $GistId = "3467834879589764235897"

        It "If path does not exist, It will be created" {
            Mock -CommandName Export-Clixml -MockWith {}
            Mock -CommandName New-Item -MockWith {return $null}
            Mock -CommandName "Test-Path" -MockWith {return $false}

            $Path = "TestDrive:\MyPath"
            $obj = [PSCustomObject]@{
                Name = "Value"
            }

            $return = New-PSPGitAuthFile -GistId $GistId -PATToken $PatToken -UserName $UserName
            $return | Should -be $null
            Assert-MockCalled -CommandName New-Item -Exactly 1
        }
    }
}