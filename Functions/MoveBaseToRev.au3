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
        FileMove($sourcePath, $destPath, 1)

        ; EXCEPTIONS - MODIFY STRINGS AND MOVE TO REVISION FOLDER
		Global $Revision
        ;FDS
        TransformAndMove($sFolderBase, $Revision, $baseName, " (Disk Writer)", "")
        ; GBA
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA, Australia)", "(USA)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(USA)", "(USA, Europe)")
        ; GB
        TransformAndMove($sFolderBase, $Revision, $baseName, "(World)", "(Japan, USA) (En)")
        TransformAndMove($sFolderBase, $Revision, $baseName, " (SGB Enhanced)", "", "(USA, Europe)", "(USA)")
        ; PSX
        TransformAndMove($sFolderBase, $Revision, $baseName, "(De,Es,It)", "(En,Fr,De,Nl)")
        TransformAndMove($sFolderBase, $Revision, $baseName, "(En,Fr,Nl)", "(En,Fr,Es,It)")
        ; NES
        TransformAndMove($sFolderBase, $Revision, $baseName, "(NES-BK)", "(NES-N7)")

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
    FileMove($sourcePath, $destPath, 1)
EndFunc
