function Get-PSPMajorPSVersion
{
    $Version = ($PSVersionTable).PSVersion.Major
    return $Version
}