param (
	[Parameter(Mandatory=$true)]
    [string]$jpgPath,
	[Parameter(Mandatory=$true)]
    [string]$rawPath,
	[switch]$printConfig = $false
 )

trap
{
	write-output $_
	exit 1
}

$rawFiles = "*.NEF"

echo "Starting..."
echo "jpg path:    $jpgPath"
echo "raw path:   $rawPath"

if ($printConfig)
{
	exit
}

$jpgFiles = gci -Recurse -Path $jpgPath -include $jpgFiles
$rawFiles = gci -Recurse -Path $rawPath -include $rawFiles

$filesToRemove = @()

foreach ($rawFile in $rawFiles)
{
	$filename = $rawFile.BaseName + ".JPG"
	$jpgFile = join-path -Path $jpgPath -ChildPath $filename

	write-host "Jpg path: $jpgFile"
	if (!(Test-Path -Path $jpgFile))
	{ 
		$filesToRemove += $rawFile.FullName
	}
}

write-host "Going to remove:"
$filesToRemove | %{ write-host $_ }
$r = read-host "Press 'y' to continue"

if ($r -eq "y")
{
	$filesToRemove | %{ remove-item $_ }
}
else
{
	write-host "Aborting"
}


	