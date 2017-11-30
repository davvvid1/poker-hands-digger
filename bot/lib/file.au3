#include <file.au3>

Func saveConfig($topLeftPos, $bottomRightPos, $tablesScanOffset, $tablesScanCol, $tablesResultOffset, $tablesResultCol, $tablesHeight, $tableFullHandsOffset, $tableFullHandsCol, $tableRecommendsOffset, $tableRecommendsCol, $handsScanOffset, $handsScanCol, $handsHeight, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset)
   If Not $topLeftPos[0] Or Not $bottomRightPos[0] Or Not $handsScanOffset[0] Or Not $handsScanCol Or Not $handsHeight Or Not $handOptionsOffset[0] Or Not $handOptionsCol Or Not $handShareOffset[0] Or Not $handShareCol Or Not $handCopyOffset[0] Or Not $handCopyCol Or Not $handBackOffset[0] Then
	  MsgBox(0, "Warning", "Set all required fields!")
	  Return
   EndIf

   IniWrite("config.ini", "general", "topLeftPosX", $topLeftPos[0])
   IniWrite("config.ini", "general", "topLeftPosY", $topLeftPos[1])
   IniWrite("config.ini", "general", "bottomRightPosX", $bottomRightPos[0])
   IniWrite("config.ini", "general", "bottomRightPosY", $bottomRightPos[1])
   IniWrite("config.ini", "general", "tablesScanOffsetX", $tablesScanOffset[0])
   IniWrite("config.ini", "general", "tablesScanOffsetY", $tablesScanOffset[1])
   IniWrite("config.ini", "general", "tablesScanCol", $tablesScanCol)
   IniWrite("config.ini", "general", "tablesResultOffsetX", $tablesResultOffset[0])
   IniWrite("config.ini", "general", "tablesResultOffsetY", $tablesResultOffset[1])
   IniWrite("config.ini", "general", "tablesResultCol", $tablesResultCol)
   IniWrite("config.ini", "general", "tablesHeight", $tablesHeight)
   IniWrite("config.ini", "general", "tableFullHandsOffsetX", $tableFullHandsOffset[0])
   IniWrite("config.ini", "general", "tableFullHandsOffsetY", $tableFullHandsOffset[1])
   IniWrite("config.ini", "general", "tableFullHandsCol", $tableFullHandsCol)
   IniWrite("config.ini", "general", "tableRecommendsOffsetX", $tableRecommendsOffset[0])
   IniWrite("config.ini", "general", "tableRecommendsOffsetY", $tableRecommendsOffset[1])
   IniWrite("config.ini", "general", "tableRecommendsCol", $tableRecommendsCol)
   IniWrite("config.ini", "general", "handsScanOffsetX", $handsScanOffset[0])
   IniWrite("config.ini", "general", "handsScanOffsetY", $handsScanOffset[1])
   IniWrite("config.ini", "general", "handsScanCol", $handsScanCol)
   IniWrite("config.ini", "general", "handsHeight", $handsHeight)
   IniWrite("config.ini", "general", "handOptionsOffsetX", $handOptionsOffset[0])
   IniWrite("config.ini", "general", "handOptionsOffsetY", $handOptionsOffset[1])
   IniWrite("config.ini", "general", "handOptionsCol", $handOptionsCol)
   IniWrite("config.ini", "general", "handShareOffsetX", $handShareOffset[0])
   IniWrite("config.ini", "general", "handShareOffsetY", $handShareOffset[1])
   IniWrite("config.ini", "general", "handShareCol", $handShareCol)
   IniWrite("config.ini", "general", "handCopyOffsetX", $handCopyOffset[0])
   IniWrite("config.ini", "general", "handCopyOffsetY", $handCopyOffset[1])
   IniWrite("config.ini", "general", "handCopyCol", $handCopyCol)
   IniWrite("config.ini", "general", "handBackOffsetX", $handBackOffset[0])
   IniWrite("config.ini", "general", "handBackOffsetY", $handBackOffset[1])
EndFunc

Func loadConfig()
   Local $config[32]

   $config[0] = IniRead("config.ini", "general", "topLeftPosX", 0)
   $config[1] = IniRead("config.ini", "general", "topLeftPosY", 0)
   $config[2] = IniRead("config.ini", "general", "bottomRightPosX", 0)
   $config[3] = IniRead("config.ini", "general", "bottomRightPosY", 0)
   $config[4] = IniRead("config.ini", "general", "tablesScanOffsetX", 0)
   $config[5] = IniRead("config.ini", "general", "tablesScanOffsetY", 0)
   $config[6] = IniRead("config.ini", "general", "tablesScanCol", 0)
   $config[7] = IniRead("config.ini", "general", "tablesResultOffsetX", 0)
   $config[8] = IniRead("config.ini", "general", "tablesResultOffsetY", 0)
   $config[9] = IniRead("config.ini", "general", "tablesResultCol", 0)
   $config[10] = IniRead("config.ini", "general", "tablesHeight", 0)
   $config[11] = IniRead("config.ini", "general", "tableFullHandsOffsetX", 0)
   $config[12] = IniRead("config.ini", "general", "tableFullHandsOffsetY", 0)
   $config[13] = IniRead("config.ini", "general", "tableFullHandsCol", 0)
   $config[14] = IniRead("config.ini", "general", "tableRecommendsOffsetX", 0)
   $config[15] = IniRead("config.ini", "general", "tableRecommendsOffsetY", 0)
   $config[16] = IniRead("config.ini", "general", "tableRecommendsCol", 0)
   $config[17] = IniRead("config.ini", "general", "handsScanOffsetX", 0)
   $config[18] = IniRead("config.ini", "general", "handsScanOffsetY", 0)
   $config[19] = IniRead("config.ini", "general", "handsScanCol", 0)
   $config[20] = IniRead("config.ini", "general", "handsHeight", 0)
   $config[21] = IniRead("config.ini", "general", "handOptionsOffsetX", 0)
   $config[22] = IniRead("config.ini", "general", "handOptionsOffsetY", 0)
   $config[23] = IniRead("config.ini", "general", "handOptionsCol", 0)
   $config[24] = IniRead("config.ini", "general", "handShareOffsetX", 0)
   $config[25] = IniRead("config.ini", "general", "handShareOffsetY", 0)
   $config[26] = IniRead("config.ini", "general", "handShareCol", 0)
   $config[27] = IniRead("config.ini", "general", "handCopyOffsetX", 0)
   $config[28] = IniRead("config.ini", "general", "handCopyOffsetY", 0)
   $config[29] = IniRead("config.ini", "general", "handCopyCol", 0)
   $config[30] = IniRead("config.ini", "general", "handBackOffsetX", 0)
   $config[31] = IniRead("config.ini", "general", "handBackOffsetY", 0)

   Return $config
EndFunc

Func isUniqueHand($json)
   $isUnique = True
   $files = _FileListToArray(@WorkingDir)
   For $i = 1 To $files[0] Step 1
	  If StringInStr ($files[$i], ".txt") Then
		 ConsoleWrite($files[$i] & @CRLF)
		 ConsoleWrite("json " & $json & @CRLF)
		 ConsoleWrite("file " & FileReadLine(@WorkingDir & "/" & $files[$i], 1) & @CRLF)
		 $content = FileReadLine(@WorkingDir & "/" & $files[$i], 1)
		 $index = StringInStr($content, """CARD"":""")
       $content = StringMid($content, 1, $index + 7) & "-1 -1" & StringMid($content, $index + 13, StringLen($content))
		 If $isUnique And StringInStr($content, $json) Then
			ConsoleWrite("unique FALSE" & @CRLF)
			$isUnique = False
		 Else
			ConsoleWrite("unique TRUE" & @CRLF)
			$isUnique = $isUnique And True
		 EndIf
		 ConsoleWrite(@CRLF)
	  EndIf

   Next
   Return $isUnique
EndFunc