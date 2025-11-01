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

; STREAMLINE FOLDERS
Func StreamlineFolders($sPath)
    Local $sParent = StringLeft($sPath, StringInStr($sPath, "\", 0, -1) - 1)
    Local $iCount = 0

    Local $hSearch = FileFindFirstFile($sParent & "\*")
    If $hSearch = -1 Then Return 0

    While 1
        Local $sFile = FileFindNextFile($hSearch)
        If @error Then ExitLoop
        If StringLeft($sFile, 1) <> "." Then $iCount += 1
    WEnd
    FileClose($hSearch)

    If $iCount <= 1 Then
        Local $hMoveSearch = FileFindFirstFile($sPath & "\*")
        If $hMoveSearch = -1 Then Return 0

        While 1
            Local $sMoveFolder = FileFindNextFile($hMoveSearch)
            If @error Then ExitLoop
            If StringLeft($sMoveFolder, 1) <> "." Then
                DirMove($sPath & "\" & $sMoveFolder, $sParent & "\" & $sMoveFolder)
            EndIf
        WEnd
        FileClose($hMoveSearch)
    EndIf

    Return 1
EndFunc

; LONG PATH
Func LongPath($path)
    Return $path
EndFunc
