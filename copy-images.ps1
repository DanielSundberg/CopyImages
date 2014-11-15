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
	[switch]$printConfig = $false,
	[switch]$today = $false,
	[string]$from = "",
	[string]$to = "",
	[switch]$ymdPath = $true
 )

trap
{
	write-output $_
	exit 1
}
 
$rawFiles = "*.NEF"
$jpgFiles = "*.JPG"

$rawOutdir = join-path -Path $outdir -ChildPath "Raw"
 
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
echo "YMD path:  $ymdPath"

if ($printConfig)
{
	exit
}

echo "Getting file list form $indir"

$files = gci -Recurse -Path $indir -include $jpgFiles,$rawFiles

$i = 1
foreach ($item in $files)
{
	$nofFiles = $files.count
	echo "$i of $nofFiles"
	$i += 1
	$date = $item | get-date
	
	# Check that file date is in our date interval
	if (($date -gt $fromDate) -and ($date -lt $toDate))
	{
		$shortDate = $date.ToString("yyyy-MM-dd")
		$fullName = $item.FullName
		$name = $item.Name
		
		Write-host "Extension: " $item.Extension.ToUpper()
		if ($item.Extension.ToUpper() -eq ".NEF")
		{
			$destPath = join-path -Path $outdir -ChildPath "Raw"
		}
		else
		{
			$destPath = $outdir
		}
		
		# Create destination path of specified format <out_path>\<date>
		# or <out_path>\year\mm\<date>
		if ($ymdPath)
		{
			$destPath = join-path -Path (join-path -Path (join-path -Path $destPath -ChildPath $date.year) -ChildPath $date.month) -ChildPath $shortDate
		}
		else 
		{
			$destPath = join-path -Path $destPath -ChildPath $shortDate
		}

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
	