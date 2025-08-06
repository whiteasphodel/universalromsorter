Universal ROM Sorter
====================

Universal ROM Sorter (URS) is a tool designed to sort a ROM collection 
(No-Intro naming convention) into an organized folder structure.

The folder structure is generated based on the ROM files provided, 
and each ROM is moved into its proper location automatically.

---------------------------------------------------------------------

How to Use
----------

There are three ways to run Universal ROM Sorter:

1. Drag and drop the folder containing your ROM set onto `urs.exe`
2. Double-click `urs.exe` and navigate to the folder with the ROM set
3. Use the command line:

   urs.exe <path-to-roms> <optional-ini-file>

Note:
- While URS is running an icon will appear in your system tray.
- Once the sorting process is complete, the icon will disappear.

---------------------------------------------------------------------

Example Output
--------------

The input ROM directory usually has all files in a flat structure.
After organizing with URS, a typical output folder might look like:

  1 USA
  1 World
  2 Europe
  2 Japan
  2 Other Regions
  2 Revisions
  3 Collections
    ├── Developers
    ├── Game Series
    ├── Publishers
    ├── Systems
    └── Various
  4 Betas & Protos
    ├── Betas
    └── Protos
  4 Demos & Samples
    ├── Demos
    └── Samples
  4 Pirate
  4 Programs
  4 Unlicensed
    ├── Aftermarket
    └── Unlicensed
  4 Various
  5 Hacks
  5 Translations
  6 BIOS

Note:
- Depending on the set and configuration, not all folders may be created.
- Folders with many files may be split into alphabetical subfolders.
- Sorting can take several minutes.

---------------------------------------------------------------------

INI File
--------

You can customize the sorting behavior using an optional INI file.

- If `urs.ini` is present, it will be used.
- Otherwise, default values are applied.
- You can also specify a custom INI file via the command line.

Presets are available in the "Presets" folder.
https://github.com/whiteasphodel/universalromsorter/tree/main/presets

Default INI:
------------

[Settings]
FileLimit            = 0
PreferRevisions      = 1

[Folders]
USA                  = 1 USA
World                = 1 World
Europe               = 2 Europe
Japan                = 2 Japan
OtherRegions         = 2 Other Regions
Revisions            = 2 Revisions
DeveloperCollections = 3 Collections\Developers
GameCollections      = 3 Collections\Game Series
PublisherCollections = 3 Collections\Publishers
SystemCollections    = 3 Collections\Systems
VariousCollections   = 3 Collections\Various
Betas                = 4 Betas & Protos\Betas
Protos               = 4 Betas & Protos\Protos
Demos                = 4 Demos & Samples\Demos
Samples              = 4 Demos & Samples\Samples
Pirate               = 4 Pirate
Programs             = 4 Programs
Aftermarket          = 4 Unlicensed\Aftermarket
Unlicensed           = 4 Unlicensed\Unlicensed
Various              = 4 Various
Hacks                = 5 Hacks
Translations         = 5 Translations
BIOS                 = 6 BIOS

[Rules]

---------------------------------------------------------------------

[Settings] Section
------------------

- FileLimit
  Number of files a folder must have before being split alphabetically.
  Set to 0 to disable (default: disabled).

- PreferRevisions
  Replace base versions with their latest revisions when available.
  Set to 0 to disable (default: enabled).

---------------------------------------------------------------------

[Folders] Section
-----------------

Customize folder names and the output structure here.

---------------------------------------------------------------------

[Rules] Section
---------------

Use this section to define custom sorting rules.

Simple string match:
  0 Favorites = Doom

This moves all files with "Doom" into the "0 Favorites" folder.

Regex rule:
  0 Favorites = ^(Final )?Doom(?: [^()]*)?\s*\([^)]*USA[^)]*\)

This moves only "Doom" games tagged with (USA) into "0 Favorites".

---------------------------------------------------------------------

© 2025 Asphodel  
This software is licensed under the GNU GPL v3. See the LICENSE file for details.  
GitHub Repository: https://github.com/whiteasphodel/universalromsorter  
Contact: whiteasphodel@outlook.com
