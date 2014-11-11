# Förbättringar
# -Hantera raw-filer
# -Kommandorads-parametrar för $indir och $outdir
# -Starta kommando-prompt från någon typ av event
#  när man stoppar in minneskort...
# -Hantera bilder från sony-kameran
# -Förbättra dry-run output
# -Logga till fil som default
# -Log levels


param (
    [switch]$dryRun = $false,
    [string]$indir = "e:\",
    [string]$outdir = "c:\bilder2",
	[switch]$isNef = $false, 
	[switch]$printConfig = $false
 )

if ($isNef)
{
	$type = "*.nef"
	$outdir = join-path -Path $outdir -ChildPath "Raw"
}
else
{
	$type = "*.jpg"
}
 
echo "Starting..."
echo "In dir:    $indir"
echo "Out dir:   $outdir"
echo "File type: $type"
echo "Dry run:   $dryRun"

if ($printConfig)
{
	exit
}

echo "Getting file list form $indir"

$files = gci -Recurse -Path $indir $type

$i = 1
foreach ($item in $files)
{
	$nofFiles = $files.count
	echo "$i of $nofFiles"
	$i += 1
	$date = $item | get-date
	$shortDate = $date.ToShortDateString()
	$fullName = $item.FullName
	$name = $item.Name
	
	
	$destPath = join-path -Path $outdir -ChildPath $shortDate

	if (!(Test-Path -Path $destPath))
	{
		echo "Creating directory $destPath..."
		if (!$dryRun)
		{
			mkdir $destPath
		}
	}
	
	$destFile = join-path -Path $destPath -ChildPath $name
	
	if (!(Test-Path -Path $destFile))
	{
		echo "Copying $fullName to $destFile..."
		if (!$dryRun)
		{
			copy-item $fullName $destFile
		}
	}
}
	