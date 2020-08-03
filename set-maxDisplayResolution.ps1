Function set-maxDisplayResolution {
$maxRes = $(Get-WmiObject -Class CIM_VideoControllerResolution)[-1].caption
$maxWidth = $maxRes.split(" ")[0]
$maxHeight = $maxRes.split(" ")[2]
set-displayresolution -width $maxWidth -height $maxHeight -force
}
