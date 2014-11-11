# Possible improvements
# -Handle more raw file formats
# -Start cmdlet when memory card is inserted
# -Handle more camera models
# -Improve dry-run output
# -Log to file as default
# -Log levels for debugging


param (
    [switch]$dryRun = $false,
    [string]$indir = "e:\",
    [string]$outdir = "c:\bilder2",
	[switch]$raw = $false, 
	[switch]$printConfig = $false,
	[switch]$today = $false,
	[string]$from = "",
	[string]$to = ""
 )

trap
{
	write-output $_
	exit 1
}
 
# Raw files or jpg
if ($raw)
{
	$type = "*.nef"
	$outdir = join-path -Path $outdir -ChildPath "Raw"
}
else
{
	$type = "*.jpg"
}
 
# Parse dates
$fromDate = [DateTime]::MinValue
if ($from.length -gt 0)
{
	$fromDate = ([DateTime]::Parse($from)).date
}
$toDate = [DateTime]::MaxValue
if ($to.length -gt 0)
{
	$toDate = ([DateTime]::Parse($to)).date
}

# Today overrides other date filters
if ($today)
{
	$fromDate = (get-date).date
	$toDate = (get-date).date.AddDays(1)
}
 
echo "Starting..."
echo "In dir:    $indir"
echo "Out dir:   $outdir"
echo "File type: $type"
echo "Dry run:   $dryRun"
echo "Today:     $today"
echo "From:      $fromDate"
echo "To:        $toDate"

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
	
	if (($date -gt $fromDate) -and ($date -lt $toDate))
	{
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
}
	