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

; DELETE EMPTY FOLDERS
Func DeleteEmptyFolders($sFolder, $bIsRoot = True)
    If Not FileExists($sFolder) Then Return

    ; CHECK ALL SUBFOLDERS
    Local $aSubDirs = _FileListToArray($sFolder, "*", 2)
    If @error = 0 And IsArray($aSubDirs) Then
        For $i = 1 To $aSubDirs[0]
            DeleteEmptyFolders($sFolder & "\" & $aSubDirs[$i], False)
        Next
    EndIf

    ; CHECK IF FOLDER IS EMPTY
    Local $aFiles = _FileListToArray($sFolder, "*", 0)
    Local $aDirs = _FileListToArray($sFolder, "*", 2)

    Local $isEmpty = True
    If Not @error And IsArray($aFiles) And $aFiles[0] > 0 Then $isEmpty = False
    If Not @error And IsArray($aDirs) And $aDirs[0] > 0 Then $isEmpty = False

    ; DELETE FOLDER
    If $isEmpty And Not $bIsRoot Then
        DirRemove($sFolder)
    EndIf
EndFunc
