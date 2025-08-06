# Universal ROM Sorter

**Universal ROM Sorter (URS)** is a tool designed to sort a ROM collection (No-Intro naming convention) into an organized folder structure.

The folder structure is generated based on the ROM files provided, and each ROM is moved into its proper location automatically.

---

## How to Use

The usage is very simple. There are three ways to run **Universal ROM Sorter**:

1. **Drag and drop** the folder containing your ROM set onto `urs.exe`
2. **Double-click** `urs.exe` and navigate to the folder with the ROM set you want to sort
3. **Via command line**:
   ```bash
   urs.exe <path-to-roms> <optional-ini-file>
   ```
_While URS is running an icon will appear in your system tray. Wait for the icon to disappear, this indicates that the sorting process has completed._

---

## Example Output

The input ROM directory usually has all files in a flat structure. After organizing with URS, a typical output folder can look like this:

```
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
```

_Depending on the set you are sorting and the configuration you use, not all folders may be created._  
_Also, depending on the number of files in a folder, files may be sorted into alphabetical subfolders to make navigation easier._  
_The sorting process can take several minutes._

---

## INI File

There is an optional INI file that can be used to customize a few aspects of the sorting.

If `urs.ini` is present, the values from that file will be used. Otherwise, URS will fall back to default values.

You can run `urs.exe` from the command line and specify a custom INI file. This lets you create and use different presets. Default, Compact and Tiny presets are available in the **Presets** folder.


### Default INI:

```ini
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
```

---

## [Settings] Section

In the **[Settings]** section, you can adjust the following options:

- **FileLimit**  
  Defines the number of files a folder must contain before they are automatically moved into alphabetical subfolders.  
  **Set to `0` to disable.** Disabled by default.

- **PreferRevisions**  
  If enabled, base versions in the main folders will be replaced with their latest revisions.
  **Set to `0` to disable.** Enabled by default.

---

## [Folders] Section

In the **[Folders]** section, you can adjust the names of all main folders that can be created.  
This also allows you to restructure the output layout.

---

## [Rules] Section

In the **[Rules]** section, you can define custom rules to:

- Support tags that are not yet implemented
- Gain greater flexibility in how your files are organized

### Simple string matching:

```ini
0 Favorites = Doom
```

_This will move all files containing the string `Doom` into a new folder called `0 Favorites`._

### Regex-based rule:

```ini
0 Favorites = ^(Final )?Doom(?: [^()]*)?\s*\([^)]*USA[^)]*\)
```

_This will only move `Doom` games with the `(USA)` region tag into the folder `0 Favorites`._

---

© 2025 Asphodel  
This software is licensed under the [GNU GPL v3](LICENSE).  
GitHub Repository: [universalromsorter](https://github.com/whiteasphodel/universalromsorter)  
Contact: [whiteasphodel@outlook.com](mailto:whiteasphodel@outlook.com)
