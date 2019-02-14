function Invoke-PSPEncodeGalleriesListAvailable
{
    $PSGalleryPath = Get-PSFConfigValue -FullName "PSProfileSync.repository.gallerypath"
    $EncodedPSGalleryPath = Get-PSFConfigValue -FullName "PSProfileSync.repository.encodedpsgallerypath"

    Invoke-PSPEncodeCertUtil -SourcePath $PSGalleryPath -TargetPath $EncodedPSGalleryPath
}