# Copy-Images.ps1

Powershell script to copy files from memory card to folder on disk. By default
the script will copy **.NEF** and **.JPG** files.

Default is to copy all new files. Nothing will be overwritten, **inDir** and
 **outDir** must be specified if other than default.

## Usage examples
<code>
.\copy-images.ps1 -indir "e:" -outdir "c:\images" -today
</code>

<code>
.\copy-images.ps1 -indir "e:" -outdir "c:\images" -from "2015-01-01" -to "2015-02-28"
</code>

## Raw/NEF files
**.NEF** files will be placed in **outdir\Raw** with the same year/month/date
structure as JPG files.

## ymdPath
<code>
-ymdPath
</code>

When set to **true**, create paths in **outdir** on the format **\yyyy\mm\dd**
(year (4 digits)/month (2 digits)/day of month (2 digits)). This is the default
behavior. Set to **false** if you want paths of format **yyyy-mm-dd**.

# Clean-Raw.ps1

If you're taking JPG+RAW images when photographing it can be easy to go
through the JPG files and erase bad images. Then this script can be used to
delete RAW files belonging the manually deleted JPG files.

<code>
.\clean-raw.ps1 -jpgPath "c:\images\2015\06\30" -rawPath "c:\images\Raw\2015\06\30"
</code>

If **c:\images\2015\06\30** is a folder where we have deleted bad images the
corresponding raw files will be deleted from **c:\images\Raw\2015\06\30**.

**Please be extremely careful when using this script**


## Possible improvements
* Handle more raw file extensions
* Start cmdlet when memory card is inserted
* Handle more camera models if needed (tested with Nikon D40 and Sony RX100)
* Improve dry-run output
* Log to file as default
* Auto detect memory card path
* Remember input and output dir
* Config file for input/output dir
