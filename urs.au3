#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=urs.exe
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=URS
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=Universal ROM Sorter
#AutoIt3Wrapper_Res_ProductVersion=3.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=© 2025 Asphodel
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; UNIVERSAL ROM SORTER
;
; Copyright (C) 2025 Asphodel
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License version 3
; as published by the Free Software Foundation.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
; Repository: https://github.com/whiteasphodel/universalromsorter
; Contact: whiteasphodel@outlook.com

; TRAY SETTINGS
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
TraySetToolTip("Universal ROM Sorter")

; MAIN
#include <Array.au3>
#include <File.au3>
#include <Functions\MoveBaseToRev.au3>
#include <Functions\MoveRevToBase.au3>
#include <Functions\ProcessFiles.au3>
#include <Functions\ProcessFolders.au3>
#include <Functions\SortFiles.au3>

; PARAMETERS
If Not $CmdLine[0] Then
    $Roms = FileSelectFolder("", "", 1)
    If @error Or $Roms = "" Then Exit
Else
    $Roms = $CmdLine[1]
EndIf

If $CmdLine[0] >= 2 And StringStripWS($CmdLine[2], 3) <> "" Then
    $IniFile = $CmdLine[2]
Else
    $IniFile = @ScriptDir & "\urs.ini"
EndIf

; DEFINE SETTINGS
$FileLimit = IniRead($IniFile, "Settings", "FileLimit", 0)
$PreferRevisions = IniRead($IniFile, "Settings", "PreferRevisions", 1)

; DEFINE PATHS
$Usa = $Roms & "\" & IniRead($IniFile, "Folders", "USA", "1 USA")
$World = $Roms & "\" & IniRead($IniFile, "Folders", "World", "1 World")
$Europe = $Roms & "\" & IniRead($IniFile, "Folders", "Europe", "2 Europe")
$Japan = $Roms & "\" & IniRead($IniFile, "Folders", "Japan", "2 Japan")
$Other = $Roms & "\" & IniRead($IniFile, "Folders", "OtherRegions", "2 Other Regions")
$Revision = $Roms & "\" & IniRead($IniFile, "Folders", "Revisions", "2 Revisions")
$DeveloperCollection = $Roms & "\" & IniRead($IniFile, "Folders", "DeveloperCollections", "3 Collections\Developers")
$GameCollection = $Roms & "\" & IniRead($IniFile, "Folders", "GameCollections", "3 Collections\Game Series")
$PublisherCollection = $Roms & "\" & IniRead($IniFile, "Folders", "PublisherCollections", "3 Collections\Publishers")
$SystemCollection = $Roms & "\" & IniRead($IniFile, "Folders", "SystemCollections", "3 Collections\Systems")
$VariousCollection = $Roms & "\" & IniRead($IniFile, "Folders", "VariousCollections", "3 Collections\Various")
$SegaCd32x = $Roms & "\" & IniRead($IniFile, "Folders", "SegaCD32X", "3 Sega CD 32X")
$Beta = $Roms & "\" & IniRead($IniFile, "Folders", "Betas", "4 Betas & Protos\Betas")
$Demo = $Roms & "\" & IniRead($IniFile, "Folders", "Demos", "4 Demos & Samples\Demos")
$MultiGameDemo = $Roms & "\" & IniRead($IniFile, "Folders", "MultiGameDemos", "4 Demos & Samples\Multi-Game Demos")
$Promo = $Roms & "\" & IniRead($IniFile, "Folders", "Promos", "4 Demos & Samples\Promos")
$Proto = $Roms & "\" & IniRead($IniFile, "Folders", "Protos", "4 Betas & Protos\Protos")
$Sample = $Roms & "\" & IniRead($IniFile, "Folders", "Samples", "4 Demos & Samples\Samples")
$Pirate = $Roms & "\" & IniRead($IniFile, "Folders", "Pirate", "4 Pirate")
$Program = $Roms & "\" & IniRead($IniFile, "Folders", "Programs", "4 Programs")
$Aftermarket = $Roms & "\" & IniRead($IniFile, "Folders", "Aftermarket", "4 Unlicensed\Aftermarket")
$Unlicensed = $Roms & "\" & IniRead($IniFile, "Folders", "Unlicensed", "4 Unlicensed\Unlicensed")
$Various = $Roms & "\" & IniRead($IniFile, "Folders", "Various", "4 Various")
$Hack = $Roms & "\" & IniRead($IniFile, "Folders", "Hacks", "5 Hacks")
$Translation = $Roms & "\" & IniRead($IniFile, "Folders", "Translations", "5 Translations")
$Bios = $Roms & "\" & IniRead($IniFile, "Folders", "BIOS", "6 BIOS")

; BUILT-IN PRESETS
If $IniFile = "c" Or $IniFile = "compact" Then
	$Beta = $Roms & "\4 Miscellaneous\Betas"
	$Demo = $Roms & "\4 Miscellaneous\Demos"
	$MultiGameDemo = $Roms & "\4 Miscellaneous\Multi-Game Demos"
	$Program = $Roms & "\4 Miscellaneous\Programs"
	$Promo = $Roms & "\4 Miscellaneous\Promos"
	$Proto = $Roms & "\4 Miscellaneous\Protos"
	$Sample = $Roms & "\4 Miscellaneous\Samples"
	$Various = $Roms & "\4 Miscellaneous\Various"
	$Bios = $Roms & "\4 Miscellaneous\Various\BIOS"
EndIf

; DEFINE ARRAYS
; HACKS AND TRANSLATIONS
Global $aNtscHack = [ _
    "PAL-to-NTSC", _
    "PAL to NTSC" _
]
Global $aColorHack = [ _
    "Color hack", _
    "Color fix", _
    "Color & SFX hack", _
    "Arcade Colors", _
    "Arcade Edition by" _
]
Global $aSpeedHack = [ _
    "FastROM hack", _
    "FastROM & Restoration hack", _
    "SlowROM hack", _
    "HiROM hack", _
    "SA1 hack", _
    "SuperFX hack", _
    "SuperFX2 hack", _
    "Optimized by" _
]
Global $aHack = [ _
    "[h]", _
    "[Hack]", _
    "(Hack)" _
]
Global $aTranslation = [ _
    "T-En", _
    "[n]", _
    "Un-Worked Design" _
]
; EXCEPTIONS
Global $aExceptionJapan = [ _
    "(Japan) (Disc 1) (Arcade)", _
    "(Japan, Asia) (Disc 1) (Arcade)" _
]
Global $aExceptionDemo = ["(Demo) (Switch) (Aftermarket)"]
Global $aExceptionAftermarket = [ _
    "(Retro-Bit Generations) (Aftermarket)", _
    "(Switch) (Aftermarket)" _
]
; BIOS
Global $aBios = [ _
    "[BIOS]", _
    "(Enhancement Chip)" _
]
; DEVELOPER COLLECTIONS
Global $aDevColAtariAnthology = ["(Atari Anthology)"]
Global $aDevColActivisionAnthologyRemix = ["(Activision Anthology - Remix Edition)"]
Global $aDevColCapcomClassicsMiniMix = ["(Capcom Classics Mini Mix)"]
Global $aDevColCapcomTown = ["(Capcom Town)"]
Global $aDevColKonamiCollectorsSeries = ["(Konami Collector's Series)"]
Global $aDevColNamcoAnthology1 = ["(Namco Anthology 1)"]
Global $aDevColNamcoMuseumArchives = [ _
    "(Namco Museum Archives Vol 1)", _
    "(Namco Museum Archives Vol 2)" _
]
Global $aDevColNamcotCollection = [ _
    "(Namcot Collection)", _
    "(Namcot Collection, Namco Museum Archives Vol 1)", _
    "(Namcot Collection, Namco Museum Archives Vol 2)" _
]
Global $aDevColQUByteClassics = ["(QUByte Classics)"]
Global $aDevColSega3DClassics = ["(Sega 3D Classics)"]
Global $aDevColSega3DClassicsCollection = ["(Sega 3D Classics Collection)"]
Global $aDevColSega3DFukkokuAkaibusu = ["(Sega 3D Fukkoku Akaibusu)"]
Global $aDevColSegaAges = ["(Sega Ages)"]
Global $aDevColSegaClassic = ["(Sega Classic)"]
Global $aDevColSegaSmashPack = ["(Sega Smash Pack)"]
Global $aDevColSegaSmashPack2 = ["(Sega Smash Pack 2)"]
Global $aDevColSNK40thAnniversaryCollection = ["(SNK 40th Anniversary Collection)"]
; GAME COLLECTIONS
Global $aGamColAlesteCollection = ["(Aleste Collection)"]
Global $aGamColAnimalCrossing = ["(Animal Crossing)"]
Global $aGamColBombermanCollection = ["(Bomberman Collection)"]
Global $aGamColCastlevaniaAdvanceCollection = ["(Castlevania Advance Collection)"]
Global $aGamColCastlevaniaAnniversaryCollection = ["(Castlevania Anniversary Collection)"]
Global $aGamColCollectionOfMana = [ _
    "(Collection of Mana)", _
    "(Seiken Densetsu Collection)" _
]
Global $aGamColCollectionOfSaGa = ["(Collection of SaGa)"]
Global $aGamColContraAnniversaryCollection = ["(Contra Anniversary Collection)"]
Global $aGamColDariusCozmicCollection = ["(Darius Cozmic Collection)"]
Global $aGamColDisneyClassicGames = ["(Disney Classic Games)"]
Global $aGamColGameNoKanzume = [ _
    "(Game no Kanzume Vol. 1)", _
    "(Game no Kanzume Vol. 2)", _
    "(Game no Kanzume Otokuyou)" _
]
Global $aGamColMegaManBattleNetworkLegacyCollection = ["(Mega Man Battle Network Legacy Collection)"]
Global $aGamColMegaManLegacyCollection = ["(Mega Man Legacy Collection)"]
Global $aGamColMegaManXLegacyCollection = ["(Mega Man X Legacy Collection)"]
Global $aGamColMetalGearSolidCollection = ["(Metal Gear Solid Collection)"]
Global $aGamColNinjaJaJaMaruRetroCollection = ["(Ninja JaJaMaru Retro Collection)"]
Global $aGamColRetroCollection = ["(Retro Collection)"]
Global $aGamColSEGAClassicCollection = ["(SEGA Classic Collection)"]
Global $aGamColSonicClassicCollection = ["(Sonic Classic Collection)"]
Global $aGamColSonicCompilationSonicClassics = ["(Sonic Compilation ~ Sonic Classics)"]
Global $aGamColSonicMegaCollection = ["(Sonic Mega Collection)"]
Global $aGamColTheCowabungaCollection = [ _
    "(The Cowabunga Collection)", _
    "(Cowabunga Collection, The)" _
]
Global $aGamColTheDisneyAfternoonCollection = ["(The Disney Afternoon Collection)"]
; PUBLISHER COLLECTIONS
Global $aPubColIam8bit = ["(iam8bit)"]
Global $aPubColColumbusCircle = ["(Columbus Circle)"]
Global $aPubColLimitedRunGames = ["(Limited Run Games)"]
Global $aPubColPikoInteractive = ["(Piko Interactive)"]
Global $aPubColPixelHeart = ["(Pixel Heart)"]
Global $aPubColRedArtGames = ["(Red Art Games)"]
Global $aPubColRetroBit = ["(Retro-Bit)"]
Global $aPubColStrictlyLimitedGames = ["(Strictly Limited Games)"]
; SYSTEM COLLECTIONS
Global $aSysColArcade = ["(Arcade)"]
Global $aSysColClassicMiniSwitchOnline = ["(Classic Mini, Switch Online)"]
Global $aSysColGameCube = [ _
    "(GameCube)", _
    "(GameCube, Zelda Collection)", _
    "(GameCube Edition)" _
]
Global $aSysColGOG = ["(GOG)"]
Global $aSysColEReaderEdition = [ _
    "(e-Reader Edition)", _
    "(e-Reader)" _
]
Global $aSysColEvercade = [ _
    "(Evercade)", _
    "(Evercade, GOG)", _
    "(Evercade, Steam)", _
    "(Kickstarter, Evercade)" _
]
Global $aSysColFamicom3DSystem = ["(Famicom 3D System)"]
Global $aSysColFamicomBox = ["(FamicomBox)"]
Global $aSysColHeartBeatCatalyst = ["(HeartBeat Catalyst)"]
Global $aSysColLodgeNet = ["(LodgeNet)"]
Global $aSysColMegaDrive4 = ["(Mega Drive 4)"]
Global $aSysColMegaDriveMini = [ _
    "(Mega Drive Mini)", _
    "(Genesis Mini)", _
    "(Genesis Mini, Mega Drive Mini)", _
    "(Mega Drive Mini 2)", _
    "(Mega Drive Mini 2, Genesis Mini 2)" _
]
Global $aSysColMegaDrivePlayTV = ["(Mega Drive PlayTV)"]
Global $aSysColModRetroChromatic = ["(ModRetro Chromatic)"]
Global $aSysColNintendoPower = ["(NP)"]
Global $aSysColPCEngineMini = ["(PC Engine Mini)"]
Global $aSysColRetroBitGenerations = ["(Retro-Bit Generations)"]
Global $aSysColSegaChannel = ["(Sega Channel)"]
Global $aSysColSegaGameToshokan = ["(Sega Game Toshokan)"]
Global $aSysColSegaGopher = ["(Sega Gopher)"]
Global $aSysColSegaReactor = ["(Sega Reactor)"]
Global $aSysColSteam = ["(Steam)"]
Global $aSysColSwitch = [ _
    "(Switch)", _
    "(Switch, PS Vita)", _
    "(Original Translation, Switch)", _
    "(RCG Translation, Switch)" _
]
Global $aSysColSwitchOnline = ["(Switch Online)"]
Global $aSysColGameAndWatchSuperMarioBros = ["(Game & Watch - Super Mario Bros.)"]
Global $aSysColVirtualConsole = [ _
    "(Virtual Console)", _
    "(Virtual Console, Switch Online)", _
    "(Virtual Console, Classic Mini, Switch Online)", _
    "(3DS Virtual Console)", _
    "(Wii Virtual Console)", _
    "(Wii U Virtual Console)", _
    "(Wii and Wii U Virtual Console)", _
    "(USA Wii Virtual Console, Wii U Virtual Console)", _
    "GameCube, Virtual Console", _
    "(GameCube, Wii and Wii U Virtual Console)", _
    "(Wii)" _
]
; VARIOUS COLLECTIONS
Global $aVarColSongbird = ["(Songbird)"]
Global $aVarColCompetitionCart = [ _
    "(Competition Cart)", _
    "(Competition Cart, Nintendo Power mail-order)" _
]
Global $aVarColLockOnCombination = ["(Lock-on Combination)"]
Global $aVarColNESConversion = ["(NES Conversion)"]
Global $aVarColSunsoftDevDiskLot = ["Sunsoft Dev Disk Lot"]
; BETAS & PROTOS
Global $aBeta = [ _
    "(Beta)", _
    "(Beta ", _
    "(Debug)", _
    "(Debug Version)" _
]
Global $aProto = [ _
    "(Proto)", _
    "(Proto ", _
    "(Possible Proto)", _
    "(Putative Proto)", _
    "[Prototype]" _
]
; DEMOS & SAMPLES
Global $aDemo = [ _
    "(Auto Demo)", _
    "(Demo)", _
    "(Demo ", _
    "(One Level Demo Disc)", _
    "(Kiosk)", _
    "(Taikenban)", _
    "(Tech Demo)", _
    "(Tech Demo, Game)", _
    "(Tech Demo, Soaker)", _
    "(Tech Demo, Viewer)", _
    "(Cheheompan)", _
    "(National Tax Agency Demo)", _
    "(Trade Demo)", _
    "[Demo]" _
]
Global $aMultiGameDemo = [ _
    "Sampler Disc", _
    "Interactive CD Sampler", _
    "Interactive Sampler CD", _
    "DemoDemo PlayStation", _
    "Euro Demo", _
    "Play Fun", _
    "Play Zone", _
    "PlayStation Zone", _
    "PlayStation Underground", _
    "Demo Disc", _
    "Demo CD", _
    "Demo One", _
    "Registered User Demo", _
    "McDonald's - Demo", _
    "Demos", _
    "PSone - Wherever, Whenever, Forever", _
    "Pizza Hut Disc", _
    "Pizza Hut Demo", _
    "Squaresoft on PlayStation", _
    "PS One Winter", _
    "PlayStation Picks", _
    "E3 Demo", _
    "Essential PlayStation", _
    "Kids Demo", _
    "PS One Kids", _
    "PS One Special Demo", _
    "Namco Demo", _
    "Next Demo", _
    "Next Station", _
    "Jampack Vol", _
    "OPSM Best", _
	"radicalgames@psygnosis" _
]
Global $aSample = [ _
    "(Sample)", _
    "(Taikenban Sample ROM)" _
]
Global $aPromo = [ _
    "(Promo)", _
    "(Doritos Promo)", _
    "(Movie Promo)", _
    "(Caravan You Taikenban)", _
    "(JR Nishi-Nihon Presents)" _
]
; PROGRAMS
Global $aProgram = [ _
    "(Program)", _
    "(Test Program)", _
    "(Menu Cart)", _
    "Sample Program", _
    "Check Program", _
    "Wide-Boy64", _
    "Aging Cartridge", _
    "Minolta", _
    "XBAND", _
    "SNSP Aging", _
    "Test Cartridge", _
    "Controller Test Cassette", _
    "Super NES Control Deck Tester", _
    "Color & Switch Test", _
    "Super Game Boy", _
    "Game Boy Controller Kensa Cartridge", _
    "Game Boy Camera", _
	"Analog Controller Service Disc" _
]
; UNLICENSED
Global $aPirate = ["(Pirate)"]
Global $aAftermarket = [ _
    "(Aftermarket)", _
    "(Kickstarter)" _
]
Global $aUnlicensed = [ _
    "(Unl)", _
    "(Homebrew)", _
    "[Homebrew]", _
    "(Unlicensed)", _
    "[Unlicensed]" _
]
; VARIOUS
Global $aAlternatives = [ _
    "(Alt)", _
    "(Alt ", _
    "(SNS-XM)", _
    "(SCUS-94290)", _
    "(SCUS-94439)", _
    "(SLUS-00612)", _
    "(A8FE)" _
]
Global $aBadDumps = ["[b]"]
Global $aBonusDiscs = [ _
    "(Bonus Disc)", _
    "(Bonus PlayStation Disc)" _
]
Global $aEDC = ["(EDC)"]
; SEGA CD SPECIFIC
Global $aSegaCd32x = [ _
    "(Sega CD 32X)", _
    "(Mega-CD 32X)" _
]
; REVISIONS
Global $aRevision = ["(Rev "]
; MAIN REGIONS
Global $aWorld = ["(World)"]
Global $aUsa = [ _
    "(USA)", _
    "(USA, Europe)", _
    "(USA, Europe, Asia)", _
    "(USA, Europe, Brazil)", _
    "(USA, Europe, Korea)", _
    "(USA, Asia)", _
    "(USA, Australia)", _
    "(USA, Brazil)", _
    "(USA, Canada)", _
    "(USA, Germany)", _
    "(USA, Japan)", _
    "(USA, Korea)", _
    "(USA, Taiwan)", _
    "(Japan, USA)", _
    "(Japan, USA, Brazil)", _
    "(Japan, USA, Korea)" _
]
Global $aEurope = [ _
    "(Europe)", _
    "(Europe, Asia)", _
    "(Europe, Australia)", _
    "(Europe, Brazil)", _
    "(Europe, Canada)", _
    "(Europe, Germany)", _
    "(Europe, Hong Kong)", _
    "(Europe, India)", _
    "(Europe, Korea)", _
    "(Japan, Europe)", _
    "(Japan, Europe, Australia)", _
    "(Japan, Europe, Brazil)", _
    "(Japan, Europe, Korea)", _
    "(Japan, Europe, Australia, New Zealand)" _
]
Global $aJapan = [ _
    "(Japan)", _
    "(Japan, Australia)", _
    "(Japan, Brazil)", _
    "(Japan, Korea)", _
    "(Japan, Hong Kong)", _
    "(Japan, New Zealand)", _
    "(Japan, Australia, New Zealand)", _
    "(Japan, Asia)" _
]
; DEFINE DESTINATION FOLDERS
; MINOR SETS
Global $MinorSets = [ _
        [$aNtscHack, $Hack & "\PAL-to-NTSC Hacks"], _
        [$aColorHack, $Hack & "\Color Hacks"], _
        [$aSpeedHack, $Hack & "\Speed Hacks"], _
        [$aHack, $Hack], _
        [$aTranslation, $Translation], _
        [$aExceptionJapan, $Japan], _
        [$aExceptionDemo, $Demo], _
        [$aExceptionAftermarket, $Aftermarket], _
        [$aBios, $Bios] _
        ]
; DEVELOPER COLLECTIONS
Global $DeveloperCollections = [ _
        [$aDevColAtariAnthology, $DeveloperCollection & "\Atari\Atari Anthology"], _
        [$aDevColActivisionAnthologyRemix, $DeveloperCollection & "\Activision\Activision Anthology"], _
        [$aDevColCapcomClassicsMiniMix, $DeveloperCollection & "\Capcom\Capcom Classics Mini Mix"], _
        [$aDevColCapcomTown, $DeveloperCollection & "\Capcom\Capcom Town"], _
        [$aDevColKonamiCollectorsSeries, $DeveloperCollection & "\Konami\Konami Collector's Series"], _
        [$aDevColNamcoAnthology1, $DeveloperCollection & "\Namco\Namco Anthology"], _
        [$aDevColNamcoMuseumArchives, $DeveloperCollection & "\Namco\Namco Museum Archives"], _
        [$aDevColNamcotCollection, $DeveloperCollection & "\Namco\Namcot Collection"], _
        [$aDevColQUByteClassics, $DeveloperCollection & "\QUByte\QUByte Classics"], _
        [$aDevColSega3DClassics, $DeveloperCollection & "\Sega\Sega 3D Classics"], _
        [$aDevColSega3DClassicsCollection, $DeveloperCollection & "\Sega\Sega 3D Classics Collection"], _
        [$aDevColSega3DFukkokuAkaibusu, $DeveloperCollection & "\Sega\Sega 3D Fukkoku Akaibusu"], _
        [$aDevColSegaAges, $DeveloperCollection & "\Sega\Sega Ages"], _
        [$aDevColSegaClassic, $DeveloperCollection & "\Sega\Sega Classic"], _
        [$aDevColSegaSmashPack, $DeveloperCollection & "\Sega\Sega Smash Pack"], _
        [$aDevColSegaSmashPack2, $DeveloperCollection & "\Sega\Sega Smash Pack 2"], _
        [$aDevColSNK40thAnniversaryCollection, $DeveloperCollection & "\SNK\SNK 40th Anniversary Collection"] _
        ]
; GAME COLLECTIONS
Global $GameCollections = [ _
        [$aGamColAlesteCollection, $GameCollection & "\Aleste Collection"], _
        [$aGamColAnimalCrossing, $GameCollection & "\Animal Crossing"], _
        [$aGamColRetroCollection, $GameCollection & "\Bill & Ted's Excellent Retro Collection"], _
        [$aGamColBombermanCollection, $GameCollection & "\Bomberman Collection"], _
        [$aGamColCastlevaniaAdvanceCollection, $GameCollection & "\Castlevania Advance Collection"], _
        [$aGamColCastlevaniaAnniversaryCollection, $GameCollection & "\Castlevania Anniversary Collection"], _
        [$aGamColCollectionOfMana, $GameCollection & "\Collection of Mana"], _
        [$aGamColCollectionOfSaGa, $GameCollection & "\Collection of SaGa"], _
        [$aGamColContraAnniversaryCollection, $GameCollection & "\Contra Anniversary Collection"], _
        [$aGamColDariusCozmicCollection, $GameCollection & "\Darius Cozmic Collection"], _
        [$aGamColDisneyClassicGames, $GameCollection & "\Disney Classic Games"], _
        [$aGamColGameNoKanzume, $GameCollection & "\Game No Kanzume"], _
        [$aGamColMegaManBattleNetworkLegacyCollection, $GameCollection & "\Mega Man Battle Network Legacy Collection"], _
        [$aGamColMegaManLegacyCollection, $GameCollection & "\Mega Man Legacy Collection"], _
        [$aGamColMegaManXLegacyCollection, $GameCollection & "\Mega Man X Legacy Collection"], _
        [$aGamColMetalGearSolidCollection, $GameCollection & "\Metal Gear Solid Collection"], _
        [$aGamColNinjaJaJaMaruRetroCollection, $GameCollection & "\Ninja JaJaMaru Retro Collection"], _
        [$aGamColSEGAClassicCollection, $GameCollection & "\SEGA Classic Collection"], _
        [$aGamColSonicClassicCollection, $GameCollection & "\Sonic Classic Collection"], _
        [$aGamColSonicMegaCollection, $GameCollection & "\Sonic Mega Collection"], _
        [$aGamColSonicCompilationSonicClassics, $GameCollection & "\Sonic Compilation ~ Sonic Classics"], _
        [$aGamColTheCowabungaCollection, $GameCollection & "\The Cowabunga Collection"], _
        [$aGamColTheDisneyAfternoonCollection, $GameCollection & "\The Disney Afternoon Collection"] _
        ]
; PUBLISHER COLLECTIONS
Global $PublisherCollections = [ _
        [$aPubColIam8bit, $PublisherCollection & "\iam8bit"], _
        [$aPubColColumbusCircle, $PublisherCollection & "\Columbus Circle"], _
        [$aPubColLimitedRunGames, $PublisherCollection & "\Limited Run Games"], _
        [$aPubColPikoInteractive, $PublisherCollection & "\Piko Interactive"], _
        [$aPubColPixelHeart, $PublisherCollection & "\Pixel Heart"], _
        [$aPubColRedArtGames, $PublisherCollection & "\Red Art Games"], _
        [$aPubColRetroBit, $PublisherCollection & "\Retro-Bit"], _
        [$aPubColStrictlyLimitedGames, $PublisherCollection & "\Strictly Limited Games"] _
        ]
; SYSTEM COLLECTIONS
Global $SystemCollections = [ _
        [$aSysColArcade, $SystemCollection & "\Arcade"], _
        [$aSysColClassicMiniSwitchOnline, $SystemCollection & "\Classic Mini"], _
        [$aSysColGameCube, $SystemCollection & "\GameCube"], _
        [$aSysColGOG, $SystemCollection & "\GOG"], _
        [$aSysColEReaderEdition, $SystemCollection & "\e-Reader"], _
        [$aSysColEvercade, $SystemCollection & "\Evercade"], _
        [$aSysColFamicom3DSystem, $SystemCollection & "\Famicom 3D System"], _
        [$aSysColFamicomBox, $SystemCollection & "\FamicomBox"], _
        [$aSysColHeartBeatCatalyst, $SystemCollection & "\HeartBeat Catalyst"], _
        [$aSysColLodgeNet, $SystemCollection & "\LodgeNet"], _
        [$aSysColMegaDrive4, $SystemCollection & "\Mega Drive 4"], _
        [$aSysColMegaDriveMini, $SystemCollection & "\Mega Drive Mini"], _
        [$aSysColMegaDrivePlayTV, $SystemCollection & "\Mega Drive PlayTV"], _
        [$aSysColModRetroChromatic, $SystemCollection & "\ModRetro Chromatic"], _
        [$aSysColNintendoPower, $SystemCollection & "\Nintendo Power"], _
        [$aSysColPCEngineMini, $SystemCollection & "\PC Engine Mini"], _
        [$aSysColRetroBitGenerations, $SystemCollection & "\Retro-Bit Generations"], _
        [$aSysColSegaChannel, $SystemCollection & "\Sega Channel"], _
        [$aSysColSegaGameToshokan, $SystemCollection & "\Sega Game Toshokan"], _
        [$aSysColSegaGopher, $SystemCollection & "\Sega Gopher"], _
        [$aSysColSegaReactor, $SystemCollection & "\Sega Reactor"], _
        [$aSysColSteam, $SystemCollection & "\Steam"], _
        [$aSysColSwitch, $SystemCollection & "\Switch"], _
        [$aSysColSwitchOnline, $SystemCollection & "\Switch Online"], _
        [$aSysColGameAndWatchSuperMarioBros, $SystemCollection & "\Game & Watch"], _
        [$aSysColVirtualConsole, $SystemCollection & "\Virtual Console"] _
        ]
; VARIOUS COLLECTIONS
Global $VariousCollections = [ _
        [$aVarColSongbird, $VariousCollection & "\Songbird"], _
        [$aVarColCompetitionCart, $VariousCollection & "\Competition Carts"], _
        [$aVarColLockOnCombination, $VariousCollection & "\Lock-on Combinations"], _
        [$aVarColNESConversion, $VariousCollection & "\NES Conversions"], _
        [$aVarColSunsoftDevDiskLot, $VariousCollection & "\Sunsoft Dev Disk Lot"] _
        ]
; MAJOR SETS
Global $MajorSets = [ _
        [$aBeta, $Beta], _
        [$aProto, $Proto], _
        [$aDemo, $Demo], _
        [$aMultiGameDemo, $MultiGameDemo], _
        [$aSample, $Sample], _
        [$aPromo, $Promo], _
        [$aProgram, $Program], _
        [$aPirate, $Pirate], _
        [$aAftermarket, $Aftermarket], _
        [$aUnlicensed, $Unlicensed], _
        [$aAlternatives, $Various & "\Alternatives"], _
        [$aBadDumps, $Various & "\Bad Dumps"], _
        [$aBonusDiscs, $Various & "\Bonus Discs"], _
        [$aEDC, $Various & "\EDC"], _
        [$aSegaCd32x, $SegaCd32x], _
        [$aRevision, $Revision] _
        ]
; MAIN REGIONS
Global $MainRegions = [ _
        [$aWorld, $World], _
        [$aUsa, $Usa], _
        [$aEurope, $Europe], _
        [$aJapan, $Japan] _
        ]

; COMBINE FOLDER RULES
Global $AllFolderRules = [$MinorSets, $DeveloperCollections, $GameCollections, $PublisherCollections, $SystemCollections, $VariousCollections, $MajorSets, $MainRegions]

; PROCESS FILES
ProcessFiles($Roms, $IniFile, $AllFolderRules, $Other)

; SORT FOLDERS BY REGION
RegionSort($Other)
RegionSort($Revision)
RegionSort($Aftermarket)
RegionSort($Pirate)
RegionSort($Unlicensed)
RegionSort($SegaCd32x)

; SORT FOLDERS BY LICENSE
LicenseSort($Beta)
LicenseSort($Demo)
LicenseSort($Promo)
LicenseSort($Program)
LicenseSort($Proto)
LicenseSort($Sample)

;  SWAP REVISIONS
If $PreferRevisions = 1 Then
    If FileExists($Revision) Then
        Local $aSubDirs = _FileListToArray($Revision, "*", 2)
        If @error = 0 And IsArray($aSubDirs) Then
            For $i = 1 To $aSubDirs[0]

                If $aSubDirs[$i] = "USA" Then
                    $BaseFolder = $Usa
                ElseIf $aSubDirs[$i] = "World" Then
                    $BaseFolder = $World
                ElseIf $aSubDirs[$i] = "Europe" Then
                    $BaseFolder = $Europe
                ElseIf $aSubDirs[$i] = "Japan" Then
                    $BaseFolder = $Japan
                Else
                    $BaseFolder = $Other & "\" & $aSubDirs[$i]
                EndIf

                Local $RevisionFolder = $Revision & "\" & $aSubDirs[$i]

                MoveRevToBase($RevisionFolder, $BaseFolder)
                MoveBaseToRev($BaseFolder, $RevisionFolder)

            Next
        EndIf
    EndIf
EndIf

; SORT FILES INTO ALPHABETICAL FOLDERS
SortByAlphabet($Roms)

; DELETE EMPTY FOLDERS
DeleteEmptyFolders($Roms)

; STREAMLINE FOLDERS
StreamlineFolders($Aftermarket)
StreamlineFolders($Unlicensed)

; DELETE EMPTY FOLDERS
DeleteEmptyFolders($Roms)
