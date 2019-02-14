function Initialize-PSPProfileSyncSettings
{
    #region Modules Config
    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.psprofilesyncpath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync"
        Description = "The RootPath of PSProfileSync."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.mydocumentspath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync"
        Description = "The MyDocuments path that Is needed for PSProfileSync."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.modulearchivefolderpath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ModuleArchive"
        Description = "The path for the module archive folder."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.modulepath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ModulesListAvailable.json"
        Description = "The path for the json file with all modules available in the system."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.encodedpsmodulepath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ModulesListAvailable.txt"
        Description = "The encoded version of the json file of all modules available on the system."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.encodedpsmodulearchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ModuleArchive.txt"
        Description = "The encoded zip-file path of all modules available on the system."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.modulearchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ModuleArchive.zip"
        Description = "The unencoded zip-file path of all modules available on the system."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.profilesyncmodulesfoldersizepath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\PSProfileSyncModulesFolderSize.json"
        Description = "The size of the modules folder as json."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.excludedmodules"
        Validation  = 'string'
        Value       = "PowerShellGet", "PackageManagement", "Microsoft.PowerShell.Operation.Validation", "Pester", "PSReadline"
        Description = "The list of the modules that are not needed for invetory."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $MyDocuments = Get-PSFConfigValue -FullName psprofilesync.modules.mydocumentspath

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "modules.includedpsmodulepaths"
        Validation  = 'string'
        Value       = "$MyDocuments\PowerShell\Modules",
        "$MyDocuments\WindowsPowerShell\Modules",
        "$env:ProgramFiles\PowerShell\Modules",
        "$env:ProgramFiles\WindowsPowerShell\Modules"
        Description = "The module paths were modules should be inventoried."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat
    #endregion

    #region Repositories Config
    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "repository.excludedrepositories"
        Validation  = 'string'
        Value       = "PSGallery"
        Description = "The excluded repositories."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "repository.gallerypath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\PSGallery.json"
        Description = "The json file with all inventoried repositories in It."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "repository.encodedpsgallerypath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\PSGallery.txt"
        Description = "The encoded json file with all inventoried repositories in It."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat
    #endregion

    #region Profile Config
    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilepathwps"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfilesListAvailableWPS.json"
        Description = "The unencoded Windows PowerShell profiles as json file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilepathpscore"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfilesListAvailablePSCore.json"
        Description = "The unencoded PowerShell Core profiles as json file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilepathdevenv"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfilesListAvailableDevEnv.json"
        Description = "The unencoded Developer Environment (VSCode, PowerShell ISE) profiles as json file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.encodedprofilepathwps"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfilesListAvailableWPS.txt"
        Description = "The encoded Windows PowerShell profiles as json file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.encodedprofilepathpscore"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfilesListAvailablePSCore.txt"
        Description = "The encoded PowerShell Core profiles as json file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.encodedprofilepathdevenv"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfilesListAvailableDevEnv.txt"
        Description = "The encoded Developer Environment (VSCode, PowerShell ISE) profiles as json file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.encodedpsprofilewpsarchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchiveWPS.txt"
        Description = "The encoded Windows PowerShell archive as zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.encodedpsprofilepscorearchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchivePSCore.txt"
        Description = "The encoded PowerShell Core archive as zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.encodedpsprofiledevenvarchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchiveDevEnv.txt"
        Description = "The encoded Developer Environment (VSCode, PowerShell ISE) archive as zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilearchivewpsfolderpath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchiveWPS"
        Description = "The help folder path for Windows PowerShell zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilearchivepscorefolderpath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchivePSCore"
        Description = "The help folder path for PowerShell Core zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilearchivedevenvfolderpath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchiveDevEnv"
        Description = "The help folder path for Developer Environment (VSCode, PowerShell ISE) zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilewpsarchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchiveWPS.zip"
        Description = "The path of all Windows PowerShell profiles as zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilepscorearchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchivePSCore.zip"
        Description = "The path of all PowerShell Core profils as zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profiledevenvarchivefolderpathzip"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\ProfileArchiveDevEnv.zip"
        Description = "The path of all Developer Environment (VSCode, PowerShell ISE) profiles as zip file."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.profilesyncprofilefoldersizepath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\PSProfileSyncProfileFolderSize.json"
        Description = "The path of a json file that contains the size off all PowerShell profiles."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.includedpsprofilepathswps"
        Validation  = 'string'
        Value       = "$MyDocuments\WindowsPowerShell\profile.ps1",
        "$MyDocuments\WindowsPowerShell\Microsoft.PowerShell_profile.ps1",
        "$env:windir\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1",
        "$env:windir\System32\WindowsPowerShell\v1.0\profile.ps1"
        Description = "All Windows PowerShell profile files that got inventoried."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.includedpsprofilepathspscore"
        Validation  = 'string'
        Value       = "$MyDocuments\PowerShell\Microsoft.PowerShell_profile.ps1",
        "$MyDocuments\PowerShell\profile.ps1",
        "$env:ProgramFiles\PowerShell\6\Microsoft.PowerShell_profile.ps1",
        "$env:ProgramFiles\PowerShell\6\profile.ps1"
        Description = "All PowerShell Core profile files that got inventoried."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "profile.includedpsprofilepathsdevenv"
        Validation  = 'string'
        Value       = "$MyDocuments\PowerShell\Microsoft.VSCode_profile.ps1",
        "$MyDocuments\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
        Description = "All PowerShell Core profile files that got inventoried."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat
    #endregion

    #region git
    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "git.gistdescription"
        Validation  = 'string'
        Value       = "..PSPROFILESYNC"
        Description = "The description of the github gist."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat

    $setPSFConfigSplat = @{
        Module      = 'PSProfileSync'
        Name        = "git.profilegitauthfilepath"
        Validation  = 'string'
        Value       = "$env:APPDATA\PSProfileSync\GitAuthFile.xml"
        Description = "The path where the git credential file is stored."
        Initialize  = $true
    }
    Set-PSFConfig @setPSFConfigSplat
    #endregion
}