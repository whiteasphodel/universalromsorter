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

; SORT BY REGIONS
Func RegionSort($Folder)
    ; GET ALL FILES
    Local $Files = _FileListToArrayRec($Folder, "*", 1, 0, 1, 2)
    If Not IsArray($Files) Then Return

; DEFINE MAIN REGIONS
Global $aWorld
Global $aUSA
Global $aEurope
Global $aJapan

; DEFINE REGIONS
Local $Albania = ["(Albania)"]
Local $Argentina = ["(Argentina)"]
Local $Asia = ["(Asia)"]
Local $Australia = ["(Australia)", "(Australia, Greece)"]
Local $Austria = ["(Austria)", "(Austria, Switzerland)"]
Local $Belarus = ["(Belarus)"]
Local $Belgium = ["(Belgium)", "(Belgium, Netherlands)"]
Local $Bulgaria = ["(Bulgaria)"]
Local $Brazil = ["(Brazil)", "(Brazil, Portugal)", "(Brazil, Spain)"]
Local $Canada = ["(Canada)"]
Local $China = ["(China)"]
Local $Croatia = ["(Croatia)"]
Local $Czech = ["(Czech)"]
Local $Denmark = ["(Denmark)"]
Local $Estonia = ["(Estonia)"]
Local $Export = ["(Export)"]
Local $Finland = ["(Finland)"]
Local $France = ["(France)", "(France, Spain)"]
Local $Germany = ["(Germany)"]
Local $Greece = ["(Greece)"]
Local $HongKong = ["(Hong Kong)"]
Local $Hungary = ["(Hungary)"]
Local $Iceland = ["(Iceland)"]
Local $India = ["(India)"]
Local $Indonesia = ["(Indonesia)"]
Local $Ireland = ["(Ireland)"]
Local $Israel = ["(Israel)"]
Local $Italy = ["(Italy)"]
Local $Korea = ["(Korea)"]
Local $LatinAmerica = ["(Latin America)"]
Local $Latvia = ["(Latvia)"]
Local $Macedonia = ["(Macedonia)"]
Local $Lithuania = ["(Lithuania)"]
Local $Mexico = ["(Mexico)"]
Local $Netherlands = ["(Netherlands)"]
Local $NewZealand = ["(New Zealand)"]
Local $Norway = ["(Norway)"]
Local $Peru = ["(Peru)"]
Local $Poland = ["(Poland)"]
Local $Portugal = ["(Portugal)"]
Local $Romania = ["(Romania)"]
Local $Russia = ["(Russia)"]
Local $Scandinavia = ["(Scandinavia)"]
Local $Serbia = ["(Serbia)"]
Local $Singapore = ["(Singapore)"]
Local $Slovakia = ["(Slovakia)"]
Local $Slovenia = ["(Slovenia)"]
Local $SouthAfrica = ["(South Africa)"]
Local $Spain = ["(Spain)", "(Spain, Portugal)"]
Local $Switzerland = ["(Switzerland)"]
Local $Sweden = ["(Sweden)"]
Local $Taiwan = ["(Taiwan)"]
Local $Thailand = ["(Thailand)"]
Local $Turkey = ["(Turkey)"]
Local $Ukraine = ["(Ukraine)"]
Local $UAE = ["(United Arab Emirates)"]
Local $UnitedKingdom = ["(United Kingdom)", "(United Kingdom, Sweden)", "(UK)"]
Local $Unknown = ["(Unknown)"]

; SET FOLDERS
Local $RegionRules = [ _
    [$aWorld, "World"], _
    [$aUSA, "USA"], _
    [$aEurope, "Europe"], _
    [$aJapan, "Japan"], _
    [$Albania, "Albania"], _
    [$Argentina, "Argentina"], _
    [$Asia, "Asia"], _
    [$Australia, "Australia"], _
    [$Austria, "Austria"], _
    [$Belarus, "Belarus"], _
    [$Belgium, "Belgium"], _
    [$Bulgaria, "Bulgaria"], _
    [$Brazil, "Brazil"], _
    [$Canada, "Canada"], _
    [$China, "China"], _
    [$Croatia, "Croatia"], _
    [$Czech, "Czech"], _
    [$Denmark, "Denmark"], _
    [$Estonia, "Estonia"], _
    [$Export, "Export"], _
    [$Finland, "Finland"], _
    [$France, "France"], _
    [$Germany, "Germany"], _
    [$Greece, "Greece"], _
    [$HongKong, "Hong Kong"], _
    [$Hungary, "Hungary"], _
    [$Iceland, "Iceland"], _
    [$India, "India"], _
    [$Indonesia, "Indonesia"], _
    [$Ireland, "Ireland"], _
    [$Israel, "Israel"], _
    [$Italy, "Italy"], _
    [$Korea, "Korea"], _
    [$LatinAmerica, "Latin America"], _
    [$Latvia, "Latvia"], _
    [$Macedonia, "Macedonia"], _
    [$Lithuania, "Lithuania"], _
    [$Mexico, "Mexico"], _
    [$Netherlands, "Netherlands"], _
    [$NewZealand, "New Zealand"], _
    [$Norway, "Norway"], _
    [$Peru, "Peru"], _
    [$Poland, "Poland"], _
    [$Portugal, "Portugal"], _
    [$Romania, "Romania"], _
    [$Russia, "Russia"], _
    [$Scandinavia, "Scandinavia"], _
    [$Serbia, "Serbia"], _
    [$Singapore, "Singapore"], _
    [$Slovakia, "Slovakia"], _
    [$Slovenia, "Slovenia"], _
    [$SouthAfrica, "South Africa"], _
    [$Spain, "Spain"], _
    [$Switzerland, "Switzerland"], _
    [$Sweden, "Sweden"], _
    [$Taiwan, "Taiwan"], _
    [$Thailand, "Thailand"], _
    [$Turkey, "Turkey"], _
    [$Ukraine, "Ukraine"], _
    [$UAE, "United Arab Emirates"], _
    [$UnitedKingdom, "United Kingdom"], _
    [$Unknown, "Unknown"] _
]

; PROCESS FILES
    For $f = 1 To $Files[0]
        Local $file = $Files[$f]
        Local $moved = False

        For $k = 0 To UBound($RegionRules) - 1
            Local $patterns = $RegionRules[$k][0]
            Local $regionName = $RegionRules[$k][1]

            For $p = 0 To UBound($patterns) - 1
                If StringInStr($file, $patterns[$p]) Then
                    Local $pos = StringInStr($file, "\", 0, -1)
                    Local $filename = StringTrimLeft($file, $pos)

                    Local $targetFolder = $Folder & "\" & $regionName
                    If Not FileExists($targetFolder) Then DirCreate($targetFolder)

                    FileMove($file, $targetFolder & "\" & $filename, 9)
                    $moved = True
                    ExitLoop 2
                EndIf
            Next

            If $moved Then ExitLoop
        Next
    Next
EndFunc

Func LicenseSort($Folder)
    ; GET ALL FILES
    Local $Files = _FileListToArrayRec($Folder, "*", 1, 0, 1, 2)
    If Not IsArray($Files) Then Return

    ; DEFINE PATTERNS
    Global $aUnlicensed
    Local $LicenseRules = [["Unlicensed", $aUnlicensed]]

    ; TRACK UNLICENSED FILES AND REMAINING FILES
    Local $bUnlicensedFound = False
    Local $RemainingFiles[1] = [0] ; dynamic array for files not matched

    ; FIRST PASS – MOVE UNLICENSED FILES
    For $f = 1 To $Files[0]
        Local $file = $Files[$f]
        Local $moved = False

        For $k = 0 To UBound($LicenseRules) - 1
            Local $licenseName = $LicenseRules[$k][0]
            Local $patterns = $LicenseRules[$k][1]

            For $p = 0 To UBound($patterns) - 1
                If StringInStr($file, $patterns[$p]) Then
                    Local $pos = StringInStr($file, "\", 0, -1)
                    Local $filename = StringTrimLeft($file, $pos)

                    Local $targetFolder = $Folder & "\" & $licenseName
                    If Not FileExists($targetFolder) Then DirCreate($targetFolder)

                    FileMove($file, $targetFolder & "\" & $filename, 9)
                    $moved = True

                    If $licenseName = "Unlicensed" Then $bUnlicensedFound = True
                    ExitLoop 2
                EndIf
            Next
            If $moved Then ExitLoop
        Next

        ; COLLECT FILES NOT MATCHED
        If Not $moved Then
            _ArrayAdd($RemainingFiles, $file)
            $RemainingFiles[0] += 1
        EndIf
    Next

    ; SECOND PASS – MOVE REMAINING FILES IF UNLICENSED FOUND
    If $bUnlicensedFound Then
        Local $LicensedFolder = $Folder & "\Licensed"
        If Not FileExists($LicensedFolder) Then DirCreate($LicensedFolder)

        For $i = 1 To $RemainingFiles[0]
            Local $file = $RemainingFiles[$i]
            Local $pos = StringInStr($file, "\", 0, -1)
            Local $filename = StringTrimLeft($file, $pos)
            FileMove($file, $LicensedFolder & "\" & $filename, 9)
        Next
    EndIf
EndFunc

; SORT BY ALPHABET
Func SortByAlphabet($sFolder)
    ; GET ALL FILES
    Local $aItems = _FileListToArray($sFolder, "*", 2)

    ; CHECK IF THERE ARE ITEMS TO PROCESS
    If @error = 1 Then
        Return
    EndIf

    ; PROCESS FILES
    For $i = 1 To UBound($aItems) - 1
        Local $sCurrentPath = $sFolder & "\" & $aItems[$i]

        ; PROCESS FOLDERS RECURSIVELY
        If StringInStr(FileGetAttrib($sCurrentPath), "D") Then
            SortByAlphabet($sCurrentPath)
        EndIf
    Next

    ; HANDLE FILES IN CURRENT FOLDER
    Local $aFiles = _FileListToArray($sFolder, "*", 1)

    ; DEFINE FILE LIMIT
    Global $FileLimit

    ; CHECK IF FOLDER CONTAINS MORE THAN N FILES
    If IsArray($aFiles) And UBound($aFiles) - 1 > $FileLimit And $FileLimit <> 0 Then

        ; PROCESS FILES
        For $j = 1 To UBound($aFiles) - 1
            Local $sFile = $sFolder & "\" & $aFiles[$j]
            Local $sFileName = StringTrimLeft($sFile, StringInStr($sFile, "\", 0, -1))
            Local $sFirstChar = StringUpper(StringLeft($sFileName, 1))
            Local $sDestFolder

            ; SET DESTINATION FOLDER BASED ON STARTING CHARACTER
            If StringRegExp($sFirstChar, "[A-Z]") Then
                $sDestFolder = $sFolder & "\" & $sFirstChar
            Else
                $sDestFolder = $sFolder & "\#"
            EndIf

            ; CREATE DESTINATION FOLDER
            If Not FileExists($sDestFolder) Then
                DirCreate($sDestFolder)
            EndIf

            ; MOVE FILES
            FileMove($sFile, $sDestFolder & "\" & $sFileName)
        Next
    EndIf
EndFunc
