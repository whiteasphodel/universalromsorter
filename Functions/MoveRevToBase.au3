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

; MOVE REV TO BASE
Func MoveRevToBase($sFolderRev, $sFolderBase)
    If Not FileExists($sFolderBase) Then DirCreate($sFolderBase)

    ; GET ALL FILES
    Local $aFiles = _FileListToArray($sFolderRev, "*", 1)
    If @error Then Return

    Local $aGroups[0][2]

    ; FIND MAX REVISION PER BASE GAME
    For $i = 1 To $aFiles[0]
        Local $sFile = $aFiles[$i]
        Local $sBase = _BaseBeforeRev($sFile)
        Local $sRev = _ExtractRev($sFile)

        Local $found = False
        For $j = 0 To UBound($aGroups) - 1
            If $aGroups[$j][0] = $sBase Then
                If _CompareRev($sRev, $aGroups[$j][1]) > 0 Then
                    $aGroups[$j][1] = $sRev
                EndIf
                $found = True
                ExitLoop
            EndIf
        Next

        If Not $found Then
            ReDim $aGroups[UBound($aGroups) + 1][2]
            $aGroups[UBound($aGroups) - 1][0] = $sBase
            $aGroups[UBound($aGroups) - 1][1] = $sRev
        EndIf
    Next

    ; MOVE ALL MATCHING FILES WITH THE HIGHEST REVISION
    For $i = 0 To UBound($aGroups) - 1
        Local $sBase = $aGroups[$i][0]
        Local $sRev = $aGroups[$i][1]
        Local $pattern = $sBase & " (Rev " & $sRev & "*"

        Local $aMatches = _FileListToArray($sFolderRev, $pattern, 1)
        If @error Then ContinueLoop

        For $j = 1 To $aMatches[0]
            FileMove($sFolderRev & "\" & $aMatches[$j], $sFolderBase & "\" & $aMatches[$j], 1)
        Next
    Next
EndFunc

; BASE BEFORE REF
Func _BaseBeforeRev($sFile)
    Local $aMatch = StringRegExp($sFile, "^(.*?)(?=\s*\(Rev)", 1)
    If IsArray($aMatch) Then
        Return StringStripWS($aMatch[0], 3)
    EndIf
    Return $sFile
EndFunc

; EXTRACT REV
Func _ExtractRev($sFile)
    Local $aMatch = StringRegExp($sFile, "\(Rev ([A-Z0-9]+)\)", 1)
    If IsArray($aMatch) Then
        Return $aMatch[0]
    EndIf
    Return "0"
EndFunc

; COMPARE REV
Func _CompareRev($a, $b)
    Local $n1 = StringIsDigit($a) ? Number($a) : Asc(StringUpper($a))
    Local $n2 = StringIsDigit($b) ? Number($b) : Asc(StringUpper($b))
    Return $n1 - $n2
EndFunc
