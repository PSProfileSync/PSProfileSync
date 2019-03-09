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
    $UserName = "testuser"
    $PatToken = "00000"
    $GistId = "3467834879589764235897"
    $FilePath = "TestDrive:\NewFile.txt"
    $FileName = "NewFile.txt"

    Context "Edit-PSPGitHubGist" {
        It "Uploads a file correctly in PowerShell Core 6" {
            Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
            Mock -CommandName Get-PSPMajorPSVersion -MockWith {6}
            Mock -CommandName Test-Path -MockWith {return $true}
            Mock -CommandName Get-Content -MockWith {"This is text"}

            $editPSPGitHubGistSplat = @{
                GistId   = $GistId
                FilePath = $FilePath
                UserName = $UserName
                PATToken = $PatToken
            }
            Edit-PSGitHubGist @editPSPGitHubGistSplat
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1
        }

        It "Uploads a file correctly in PowerShell Core 5" {
            Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
            Mock -CommandName Get-PSPMajorPSVersion -MockWith {5}
            Mock -CommandName Test-Path -MockWith {return $true}
            Mock -CommandName Get-Content -MockWith {"This is text"}

            $editPSPGitHubGistSplat = @{
                GistId   = $GistId
                FilePath = $FilePath
                UserName = $UserName
                PATToken = $PatToken
            }
            Edit-PSGitHubGist @editPSPGitHubGistSplat
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 2
        }
    }
}