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

; MOVE BASE TO REV
Func MoveBaseToRev($sFolderBase, $sFolderRev)
    If Not FileExists($sFolderRev) Then DirCreate($sFolderRev)

    Local $aFiles = _FileListToArray($sFolderBase, "*(Rev*", 1)
    If @error Then Return SetError(1, 0, 0)

    ; GUESS BASE NAME AND MOVE TO REV
    For $i = 1 To $aFiles[0]
        Local $filename = $aFiles[$i]
        Local $baseName = StringStripWS(StringRegExpReplace($filename, " ?\(Rev[^\)]*\)", ""), 3)
        Local $sourcePath = $sFolderBase & "\" & $baseName
        Local $destPath = $sFolderRev & "\" & $baseName
        FileMove(LongPath($sourcePath), LongPath($destPath), 1)

        ; TWEAKS - MODIFY STRINGS AND MOVE TO REVISION FOLDER
		Global $Revision
        ;FDS
        TransformAndMove($sFolderBase, $Revision, $baseName, " (Disk Writer)", "")
        ; GBA
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA, Australia)", "(USA)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA)", "(USA, Europe)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(En,Fr,De,Es,It,Sv,No,Da,Fi)", "(En,Fr,De,It,Sv,No,Da,Fi) (Rev 1)")
        ; GB
        TransformAndMove($sFolderBase, $Revision, $baseName, "(World)", "(Japan, USA) (En)")
        TransformAndMove($sFolderBase, $Revision, $baseName, " (SGB Enhanced)", "", "(USA, Europe)", "(USA)")
		; GBC
		TransformAndMove($sFolderBase, $Revision, $baseName, "(Europe)", "(Europe) (En,Es,Nl)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(Europe)", "(Europe) (En,Fr,It)")
        ; PSX
        TransformAndMove($sFolderBase, $Revision, $baseName, "(De,Es,It)", "(En,Fr,De,Nl)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(En,Fr,Nl)", "(En,Fr,Es,It)")
		TransformAndMove($sFolderBase, $Revision, $baseName, "(USA)", "(USA, Canada)")
		TransformAndMove($sFolderBase, $Revision, $baseName, "(USA, Canada)", "(USA)")
		TransformAndMove($sFolderBase, $Revision, $baseName, "(Europe, Australia)", "(Europe)")
        ; NES
        TransformAndMove($sFolderBase, $Revision, $baseName, "(NES-BK)", "(NES-N7)")
        ; SMD
        TransformAndMove($sFolderBase, $Revision, $baseName, "(World)", "(World) (En,Ja)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA, Europe, Korea)", "(Japan, USA)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(Japan, USA, Korea)", "(Japan, USA)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(MDST17FF)", "(MDST6636)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA)", "(USA, Europe) (F-202)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA, Europe)", "(Japan, USA) (En)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA, Europe)", "(Japan, USA) (En) (Rev 1)")
        ; SMS
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA, Europe, Brazil) (En)", "(USA, Europe)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(Europe, Brazil)", "(Japan, Europe)")

        ; SORT REVISIONS FOLDER BY REGION
        RegionSort($Revision)

    Next
    Return 1 ; Success
EndFunc

; TRANSFORM STRING AND MOVE
Func TransformAndMove( _
    $sourceFolder, _
    $destFolder, _
    $fileName, _
    $search1, $replace1, _
    $search2 = "", $replace2 = "", _
    $search3 = "", $replace3 = "")

    Local $newName = $fileName
    $newName = StringReplace($newName, $search1, $replace1)
    If $search2 <> "" Then $newName = StringReplace($newName, $search2, $replace2)
    If $search3 <> "" Then $newName = StringReplace($newName, $search3, $replace3)

    Local $sourcePath = $sourceFolder & "\" & $newName
    Local $destPath = $destFolder & "\" & $newName
    FileMove(LongPath($sourcePath), LongPath($destPath), 1)
EndFunc
