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

; PROCESS FILES
Func ProcessFiles($Roms, $IniFile, $AllFolderRules, $Other)
    ; GET ALL FILES
    Local $Files = _FileListToArrayRec($Roms, "*", 1, $FLTAR_RECUR, 1, 2)
    If @error Or $Files[0] = 0 Then
        Return SetError(1, 0, 0)
    EndIf

    ; PROCESS FILES
    For $f = 1 To $Files[0]
        Local $file = $Files[$f]
        Local $moved = False

        ; PROCESS CUSTOM RULES
        If CustomRules($IniFile, $Roms, $file, "Rules") = 1 Then ContinueLoop

        ; PROCESS MAIN RULES
        For $k = 0 To UBound($AllFolderRules) - 1
            Local $rulesArray = $AllFolderRules[$k]

            For $i = 0 To UBound($rulesArray) - 1
                Local $patterns = $rulesArray[$i][0]
                Local $targetFolder = $rulesArray[$i][1]

                For $j = 0 To UBound($patterns) - 1
                    Local $filename = StringRegExpReplace($file, '^.*\\', '')
                    If StringInStr($filename, $patterns[$j]) Then
                        Local $filename = StringTrimLeft($file, StringInStr($file, "\", 0, -1))
                        FileMove($file, $targetFolder & "\" & $filename, 9)
                        $moved = True
                        ExitLoop 3
                    EndIf
                Next
            Next
        Next

        ; REMAINING FILES
        If Not $moved Then
            Local $filename = StringTrimLeft($file, StringInStr($file, "\", 0, -1))
            FileMove($file, $Other & "\" & $filename, 9)
        EndIf
    Next
EndFunc

; CUSTOM RULES
Func CustomRules($sIniFile, $sRootFolder, $sFilePath, $sSection)
    ; READ ALL KEY/VALUE PAIRS FROM SECTION
    Local $aRules = IniReadSection($sIniFile, $sSection)
    If @error Or Not IsArray($aRules) Then
        Return SetError(1, 0, False)
    EndIf

    ; EXTRACT FILE NAMES
    Local $iPos = StringInStr($sFilePath, "\", 0, -1)
    Local $sFileName = StringTrimLeft($sFilePath, $iPos)

    ; ENSURE ROOT FOLDER ENDS WITH BACKSLASH
    If StringRight($sRootFolder, 1) <> "\" Then $sRootFolder &= "\"

    ; LOOP THROUGH EACH RULE
    For $i = 1 To $aRules[0][0]
        Local $sSubFolder = StringStripWS($aRules[$i][0], 3)
        Local $sPattern = StringStripWS($aRules[$i][1], 3)

        Local $aMatches = StringRegExp($sFileName, $sPattern, 1)
        Local $bMatch = IsArray($aMatches) And UBound($aMatches) > 0

        ; MATCH PATTERN IN FILE NAME
        If $bMatch Then

            ; SET PATH FOR TARGET FOLDER
            Local $sTargetFolder = $sRootFolder & $sSubFolder

            ; CREATE TARGET FOLDER
            If Not FileExists($sTargetFolder) Then
                DirCreate($sTargetFolder)
            EndIf

            ; MOVE FILES
            Local $sDest = $sTargetFolder & "\" & $sFileName
            FileMove($sFilePath, $sDest, 1)

            Return 1
        EndIf
    Next

    Return 0
EndFunc
