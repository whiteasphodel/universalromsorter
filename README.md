# Universal ROM Sorter
Universal ROM Sorter (URS) is a tool designed to sort a ROM collection (No-Intro or Redump) into an organized folder structure. The folder structure is created based on the ROM files that are provided and each ROM is then moved into its proper location.


##### How to use
The usage is very simple. You can either drag and drop the folder containing your ROM set onto urs.exe or run it via command line:
```
urs.exe <path-to-roms>
```

_Depending on the amount of files the sorting process can take several minutes._


##### Example output

The input ROM directory usually has all files in a flat structure. After organizing with URS a typical output folder can look like this:
```
1 USA
1 World
2 Europe
2 Japan
2 Other Regions
2 Revisions
3 Collections
4 Betas & Protos
4 Demos & Samples
4 Pirate
4 Programs
4 Unlicensed
4 Various
5 Hacks
5 Translations
6 BIOS
```

_This is a simplified view. Some of these folders contain additional sub folders. Also, depending on the amount of files in a folder the files will be sorted into alphabetical sub folders to make navigation easier._

##### Customization
There is an optional INI file (urs.ini ) that can be used to customize a few aspects:

```
[Settings]
FileLimit = 384

[Folders]
USA = 1 USA
World = 1 World
Europe = 2 Europe
Japan = 2 Japan
OtherRegions = 2 Other Regions
Revisions = 2 Revisions
DeveloperCollections = 3 Collections\Developers
GameCollections = 3 Collections\Game Series
PublisherCollections = 3 Collections\Publishers
SystemCollections = 3 Collections\Systems
VariousCollections = 3 Collections\Various
Betas = 4 Betas & Protos\Betas
Protos = 4 Betas & Protos\Protos
Demos = 4 Demos & Samples\Demos
Samples = 4 Demos & Samples\Samples
Pirate = 4 Pirate
Programs = 4 Programs
Aftermarket = 4 Unlicensed\Aftermarket
Unlicensed = 4 Unlicensed\Unlicensed
Various = 4 Various
Hacks = 5 Hacks
Translations = 5 Translations
BIOS = 6 BIOS

[Rules]
```

In the [Settings] section you can adjust FileLimit. This is the threshold of files that are considered for alphabetical sorting. If a folder contains more files the alphabetical folders will be created and the files sorted accordingly.

In [Folders] you can adjust the names of all main folders that can be created. This also allows for restructuring the output.

_As the  INI file is optional you can run URS without the file, in that case the default values will be used._

