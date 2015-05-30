# CopyImages

Powershell script to copy files from memory card to folder on disk.

## Usage:
<code>
.\copy-images.ps1 -indir "e:" -outdir "c:\images" -today
</code>

<code>
.\copy-images.ps1 -indir "e:" -outdir "c:\images" -from "2015-01-01" -to "2015-02-28"
</code>

## Optional switches
<code>
-ymdPath
</code>

When set to **true**, create paths in **outdir** on the format **\yyyy\mm\dd**
(year (4 digits)/month (2 digits)/day of month (2 digits)). This is the default
behavior. Set to **false** if you want paths of format **yyyy-mm-dd**.

## Possible improvements
* Handle more raw file extensions
* Start cmdlet when memory card is inserted
* Handle more camera models if needed (tested with Nikon D40 and Sony RX100)
* Improve dry-run output
* Log to file as default
* Auto detect memory card path
* Remember input and output dir
* Config file for input/output dir
