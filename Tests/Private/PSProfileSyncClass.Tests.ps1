$ModuleManifestName = 'PSProfileSync.psd1'
$Root = (Get-Item $PSScriptRoot).Parent.Parent.FullName
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
    Describe "PSProfileSyncClassTests" {

        $UserName = "testuser"
        $PatToken = "00000"
        $GistId = "3467834879589764235897"
        $Uri = "http://test.io"
        $PSProfileSyncClass = [PSProfileSync]::new($UserName, $PatToken)

        Context "CallGitHubApiGET" {
            It "Invoke-RestMethod GET Case works as expected" {
                $Method = "Get"
                Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
                $result = $PSProfileSyncClass.CallGitHubApiGET($Uri, $Method)
                $result | Should -Be "Success"
                Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1
            }
        }

        Context "CallGitHubApiPOST" {
            It "Invoke-RestMethod POST/PATCH Case works as expected" {
                $Method = "POST"
                $Uri = "http://test.io"
                $body = @{Test = "Test"}
                Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
                $result = $PSProfileSyncClass.CallGitHubApiPOST($Uri, $Method, $body)
                $result | Should -Be "Success"
                Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1
            }
        }

        Context "TestForGitAuthFile" {
            Context "Path to Git Authfile exist" {
                Mock -CommandName Test-Path -MockWith {return $true}
                $result = $PSProfileSyncClass.TestForGitAuthFile("TestDrive:\testfile.xml")

                It "Path to Git Authfile exist" {
                    $result | Should -Be $true
                    Assert-MockCalled -CommandName Test-Path -Exactly 1
                }
            }

            Context "Path to Git Authfile does not exist" {
                Mock -CommandName Test-Path -MockWith {return $false}
                $result = $PSProfileSyncClass.TestForGitAuthFile("TestDrive:\testfile.xml")

                It "Path to Git Authfile does not exist" {
                    $result | Should -Be $false
                    Assert-MockCalled -CommandName Test-Path -Exactly 1
                }
            }
        }

        Context "NewAuthFileObject" {
            It "Method returns a PSCustomObject" {
                $return = $PSProfileSyncClass.NewAuthFileObject($GistId)
                $return | Should -BeOfType System.Management.Automation.PSCustomObject
            }
        }

        Context "CreateGitAuthFile" {
            It "If path does not exist, It will be created" {
                Mock -CommandName Export-Clixml -MockWith {"Export-Clixml was called"}
                Mock -CommandName New-Item -MockWith {return $null}

                $obj = [PSCustomObject]@{
                    Name = "Value"
                }

                $return = $PSProfileSyncClass.CreateGitAuthFile($obj)
                $return | Should -be $null
                Assert-MockCalled -CommandName New-Item -Exactly 1
            }
        }

        Context "CreateGitHubGist" {
            It "Creates a GitHub gist successfully" {
                Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
                $result = $PSProfileSyncClass.CallGitHubApiGET($Uri, "Get")
                $result | Should -Be "Success"
                Mock -CommandName Write-Output -MockWith {return $true}
                $PSProfileSyncClass.CreateGitHubGist()
                Assert-MockCalled -CommandName Write-Output -Exactly 1
            }

            It "GitHub gist exists already and returns a valid gist id" {
                Mock -CommandName Invoke-RestMethod -MockWith {return @{
                        description = "PSProfileSync"
                        id          = "00000"
                    }
                }
                $result = $PSProfileSyncClass.CallGitHubApiGET($Uri, "Get")
                $result | Should -Be $true
                Mock -CommandName Write-Output -MockWith {"Write-Output was called"}
                $result = $PSProfileSyncClass.CreateGitHubGist()
                $result | Should -Be "00000"
                Assert-MockCalled -CommandName Write-Output -Exactly 2
            }
        }
    }
}