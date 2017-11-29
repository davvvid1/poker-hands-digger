#include <GuiConstantsEx.au3>
#include <ColorConstants.au3>
#include "lib\digger.au3"
#include "lib\file.au3"

HotKeySet ("{F2}", getPos)
HotKeySet ("{F4}", doExit)

Global $panelConfigX = 10
Global $panelConfigY = 10

Global $idLabel_topLeft
Global $idButton_setTopLeft
Global $idButton_goTopLeft

Global $idLabel_bottomRight
Global $idButton_setBottomRight
Global $idButton_goBottomRight

Global $idLabel_bottomRight
Global $idButton_setBottomRight
Global $idButton_goBottomRight

Global $idLabel_tablesScanPos
Global $idLabel_tablesScanCol
Global $idButton_setTablesScanPos
Global $idButton_goTablesScanPos

Global $idLabel_tablesHeight
Global $idButton_setTablesHeight

Global $idLabel_tableFullHandsPos
Global $idLabel_tableFullHandsCol
Global $idButton_setTableFullHandsPos
Global $idButton_goTableFullHandsPos

Global $idLabel_tableRecommendsPos
Global $idLabel_tableRecommendsCol
Global $idButton_setTableRecommendsPos
Global $idButton_goTableRecommendsPos

Global $idLabel_handsScanPos
Global $idLabel_handsScanCol
Global $idButton_setHandsScanPos
Global $idButton_goHandsScanPos

Global $idLabel_handsHeight
Global $idButton_setHandsHeight

Global $idLabel_handOptionsPos
Global $idLabel_handOptionsCol
Global $idButton_setHandOptionsPos
Global $idButton_goHandOptionsPos

Global $idLabel_handSharePos
Global $idLabel_handShareCol
Global $idButton_setHandSharePos
Global $idButton_goHandSharePos

Global $idLabel_handCopyPos
Global $idLabel_handCopyCol
Global $idButton_setHandCopyPos
Global $idButton_goHandCopyPos

Global $idLabel_handBackPos
Global $idButton_setHandBackPos
Global $idButton_goHandBackPos

Global $idLabel_message
Global $idButton_saveConfig
Global $idButton_loadConfig
Global $idButton_start

Global $f2Mode
Global $topLeftPos[2]
Global $bottomRightPos[2]
Global $tablesScanOffset[2]
Global $tablesScanCol
Global $tablesHeight
Global $tableFullHandsOffset[2]
Global $tableFullHandsCol
Global $tableRecommendsOffset[2]
Global $tableRecommendsCol
Global $handsScanOffset[2]
Global $handsScanCol
Global $handsHeight
Global $handOptionsOffset[2]
Global $handOptionsCol
Global $handShareOffset[2]
Global $handShareCol
Global $handCopyOffset[2]
Global $handCopyCol
Global $handBackOffset[2]

_Main()

Func createSectionUI($y, $label, $isColor)
   Local $ids[4]
   $buttonsY = 120
   GUICtrlCreateLabel($label, $panelConfigX + 15, $panelConfigY + $y)
   $ids[0] = GUICtrlCreateLabel("", $panelConfigX + 15, $panelConfigY + $y + 20, 90, 20)
   If $isColor Then
	  $ids[1] = GUICtrlCreateLabel("", $panelConfigX + 94, $panelConfigY + $y + 18, 20, 20, 0x1000)
   EndIf
   $ids[1 + $isColor] = GUICtrlCreateButton("S", $panelConfigX + $buttonsY, $panelConfigY + $y, 20, 20)
   $ids[2 + $isColor] = GUICtrlCreateButton("G", $panelConfigX + $buttonsY, $panelConfigY + $y + 20, 20, 20)
   GUICtrlSetTip($ids[1], "Set point")
   GUICtrlSetTip($ids[2], "Go to point")
   Return $ids
EndFunc

Func _Main()
   GUICreate("MyGUI", 270, 645, 200)
   GUICtrlCreateGroup("Initial config", $panelConfigX, $panelConfigY, 155, 575)
   $buttonsY = 120

   $ids = createSectionUI(25, "Top left corner", 0)
   $idLabel_topLeft = $ids[0]
   $idButton_setTopLeft = $ids[1]
   $idButton_goTopLeft = $ids[2]

   $ids = createSectionUI(70, "Bottom right corner", 0)
   $idLabel_bottomRight = $ids[0]
   $idButton_setBottomRight = $ids[1]
   $idButton_goBottomRight = $ids[2]

   $ids = createSectionUI(115, "Tables scan", 1)
   $idLabel_tablesScanPos = $ids[0]
   $idLabel_tablesScanCol = $ids[1]
   $idButton_setTablesScanPos = $ids[2]
   $idButton_goTablesScanPos = $ids[3]

   $y = 160
   GUICtrlCreateLabel("Tables height", $panelConfigX + 15, $panelConfigY + $y)
   $idLabel_tablesHeight = GUICtrlCreateLabel("", $panelConfigX + 15, $panelConfigY + $y + 20, 90, 20)
   $idButton_setTablesHeight = GUICtrlCreateButton("S", $panelConfigX + $buttonsY, $panelConfigY + $y, 20, 20)
   GUICtrlSetTip($idButton_setTablesHeight, "Set tables height")

   $ids = createSectionUI(205, "Table full hands", 1)
   $idLabel_tableFullHandsPos = $ids[0]
   $idLabel_tableFullHandsCol = $ids[1]
   $idButton_setTableFullHandsPos = $ids[2]
   $idButton_goTableFullHandsPos = $ids[3]

   $ids = createSectionUI(250, "Table recommends", 1)
   $idLabel_tableRecommendsPos = $ids[0]
   $idLabel_tableRecommendsCol = $ids[1]
   $idButton_setTableRecommendsPos = $ids[2]
   $idButton_goTableRecommendsPos = $ids[3]

   $ids = createSectionUI(295, "Hands scan", 1)
   $idLabel_handsScanPos = $ids[0]
   $idLabel_handsScanCol = $ids[1]
   $idButton_setHandsScanPos = $ids[2]
   $idButton_goHandsScanPos = $ids[3]

   $y = 340
   GUICtrlCreateLabel("Hands height", $panelConfigX + 15, $panelConfigY + $y)
   $idLabel_handsHeight = GUICtrlCreateLabel("", $panelConfigX + 15, $panelConfigY + $y + 20, 90, 20)
   $idButton_setHandsHeight = GUICtrlCreateButton("S", $panelConfigX + $buttonsY, $panelConfigY + $y, 20, 20)
   GUICtrlSetTip($idButton_setHandsHeight, "Set hands height")

   $ids = createSectionUI(385, "Hand options", 1)
   $idLabel_handOptionsPos = $ids[0]
   $idLabel_handOptionsCol = $ids[1]
   $idButton_setHandOptionsPos = $ids[2]
   $idButton_goHandOptionsPos = $ids[3]

   $ids = createSectionUI(430, "Hand share", 1)
   $idLabel_handSharePos = $ids[0]
   $idLabel_handShareCol = $ids[1]
   $idButton_setHandSharePos = $ids[2]
   $idButton_goHandSharePos = $ids[3]

   $ids = createSectionUI(475, "Hand copy", 1)
   $idLabel_handCopyPos = $ids[0]
   $idLabel_handCopyCol = $ids[1]
   $idButton_setHandCopyPos = $ids[2]
   $idButton_goHandCopyPos = $ids[3]

   $ids = createSectionUI(520, "Hand back", 0)
   $idLabel_handBackPos = $ids[0]
   $idButton_setHandBackPos = $ids[1]
   $idButton_goHandBackPos = $ids[2]

   $idLabel_message = GUICtrlCreateLabel("", 10, 600, 250, 800)
   GUICtrlSetFont (-1, 11)
   GUICtrlSetColor (-1, 7895160)

   $x = 180
   $y = 15
   $idButton_saveConfig = GUICtrlCreateButton("Save Config", $x, $y + 30, 80)
   $idButton_loadConfig = GUICtrlCreateButton("Load Config", $x, $y + 60, 80)
   $idButton_start = GUICtrlCreateButton("Start", $x, $y, 80)

   If FileExists("config.ini") Then
	  $loadConfigOnce = True
   Else
	  $loadConfigOnce = False
   EndIf

   GUISetState()
   While 1
	  $iMsg = GUIGetMsg()
	  Select
		 Case $iMsg = $GUI_EVENT_CLOSE
			ExitLoop
		 Case $iMsg = $idButton_setTopLeft
			$f2Mode = "setTopLeftCorder"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goTopLeft
			MouseMove($topLeftPos[0], $topLeftPos[1])
		 Case $iMsg = $idButton_setBottomRight
			$f2Mode = "setBottomRightCorder"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goBottomRight
			MouseMove($topLeftPos[0] + $bottomRightPos[0], $topLeftPos[1] + $bottomRightPos[1])

		 Case $iMsg = $idButton_setTablesScanPos
			$f2Mode = "setTablesScan"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goTablesScanPos
			MouseMove($topLeftPos[0] + $tablesScanOffset[0], $topLeftPos[1] + $tablesScanOffset[1])
		 Case $iMsg = $idButton_setTablesHeight
			$f2Mode = "setTablesHeight1"
			GUICtrlSetData($idLabel_message, "Move mouse to the upper bar of any table and press F2")

		 Case $iMsg = $idButton_setTableFullHandsPos
			$f2Mode = "setTableFullHands"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goTableFullHandsPos
			MouseMove($topLeftPos[0] + $tableFullHandsOffset[0], $topLeftPos[1] + $tableFullHandsOffset[1])

		 Case $iMsg = $idButton_setTableRecommendsPos
			$f2Mode = "setTableRecommends"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goTableRecommendsPos
			MouseMove($topLeftPos[0] + $tableRecommendsOffset[0], $topLeftPos[1] + $tableRecommendsOffset[1])

		 Case $iMsg = $idButton_setHandsScanPos
			$f2Mode = "setHandsScan"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goHandsScanPos
			MouseMove($topLeftPos[0] + $handsScanOffset[0], $topLeftPos[1] + $handsScanOffset[1])
		 Case $iMsg = $idButton_setHandsHeight
			$f2Mode = "setHandsHeight1"
			GUICtrlSetData($idLabel_message, "Move mouse to the upper bar of any hand and press F2")

		 Case $iMsg = $idButton_setHandOptionsPos
			$f2Mode = "setHandOptions"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goHandOptionsPos
			MouseMove($topLeftPos[0] + $handOptionsOffset[0], $topLeftPos[1] + $handOptionsOffset[1])

		 Case $iMsg = $idButton_setHandSharePos
			$f2Mode = "setHandShare"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goHandSharePos
			MouseMove($topLeftPos[0] + $handShareOffset[0], $topLeftPos[1] + $handShareOffset[1])

		 Case $iMsg = $idButton_setHandCopyPos
			$f2Mode = "setHandCopy"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goHandCopyPos
			MouseMove($topLeftPos[0] + $handCopyOffset[0], $topLeftPos[1] + $handCopyOffset[1])

		 Case $iMsg = $idButton_setHandBackPos
			$f2Mode = "setHandBack"
			GUICtrlSetData($idLabel_message, "Move mouse to requested position and press F2")
         Case $iMsg = $idButton_goHandBackPos
			MouseMove($topLeftPos[0] + $handBackOffset[0], $topLeftPos[1] + $handBackOffset[1])

		 Case $iMsg = $idButton_saveConfig
		    saveConfig($topLeftPos, $bottomRightPos, $tablesScanOffset, $tablesScanCol, $tablesHeight, $tableFullHandsOffset, $tableFullHandsCol, $tableRecommendsOffset, $tableRecommendsCol, $handsScanOffset, $handsScanCol, $handsHeight, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset)
		 Case $iMsg = $idButton_loadConfig Or $loadConfigOnce
			$loadConfigOnce = False
		    $config = loadConfig()
			If $config[0] Then
			   $topLeftPos[0] = $config[0]
			   $topLeftPos[1] = $config[1]
			   $bottomRightPos[0] = $config[2]
			   $bottomRightPos[1] = $config[3]
			   $tablesScanOffset[0] = $config[4]
			   $tablesScanOffset[1] = $config[5]
			   $tablesScanCol = $config[6]
			   $tablesHeight = $config[7]
			   $tableFullHandsOffset[0] = $config[8]
			   $tableFullHandsOffset[1] = $config[9]
			   $tableFullHandsCol = $config[10]
			   $tableRecommendsOffset[0] = $config[11]
			   $tableRecommendsOffset[1] = $config[12]
			   $tableRecommendsCol = $config[13]
			   $handsScanOffset[0] = $config[14]
			   $handsScanOffset[1] = $config[15]
			   $handsScanCol = $config[16]
			   $handsHeight = $config[17]
			   $handOptionsOffset[0] = $config[18]
			   $handOptionsOffset[1] = $config[19]
			   $handOptionsCol = $config[20]
			   $handShareOffset[0] = $config[21]
			   $handShareOffset[1] = $config[22]
			   $handShareCol = $config[23]
			   $handCopyOffset[0] = $config[24]
			   $handCopyOffset[1] = $config[25]
			   $handCopyCol = $config[26]
			   $handBackOffset[0] = $config[27]
			   $handBackOffset[1] = $config[28]
			   GUICtrlSetData($idLabel_topLeft, "(" & $topLeftPos[0] & ", " & $topLeftPos[1] & ")")
			   GUICtrlSetData($idLabel_bottomRight, "(+" & $bottomRightPos[0] & ", +" & $bottomRightPos[1] & ")")
			   GUICtrlSetData($idLabel_tablesScanPos, "(+" & $tablesScanOffset[0] & ", +" & $tablesScanOffset[1] & ")")
			   GUICtrlSetBkColor($idLabel_tablesScanCol, $tablesScanCol)
			   GUICtrlSetData($idLabel_tablesHeight, $tablesHeight)
			   GUICtrlSetData($idLabel_tableFullHandsPos, "(+" & $tableFullHandsOffset[0] & ", +" & $tableFullHandsOffset[1] & ")")
			   GUICtrlSetBkColor($idLabel_tableFullHandsCol, $tableFullHandsCol)
			   GUICtrlSetData($idLabel_tableRecommendsPos, "(+" & $tableRecommendsOffset[0] & ", +" & $tableRecommendsOffset[1] & ")")
			   GUICtrlSetBkColor($idLabel_tableRecommendsCol, $tableRecommendsCol)
			   GUICtrlSetData($idLabel_handsScanPos, "(+" & $handsScanOffset[0] & ", +" & $handsScanOffset[1] & ")")
			   GUICtrlSetBkColor($idLabel_handsScanCol, $handsScanCol)
			   GUICtrlSetData($idLabel_handsHeight, $handsHeight)
			   GUICtrlSetData($idLabel_handOptionsPos, "(+" & $handOptionsOffset[0] & ", +" & $handOptionsOffset[1] & ")")
			   GUICtrlSetBkColor($idLabel_handOptionsCol, $handOptionsCol)
			   GUICtrlSetData($idLabel_handSharePos, "(+" & $handShareOffset[0] & ", +" & $handShareOffset[1] & ")")
			   GUICtrlSetBkColor($idLabel_handShareCol, $handShareCol)
			   GUICtrlSetData($idLabel_handCopyPos, "(+" & $handCopyOffset[0] & ", +" & $handCopyOffset[1] & ")")
			   GUICtrlSetBkColor($idLabel_handCopyCol, $handCopyCol)
			   GUICtrlSetData($idLabel_handBackPos, "(+" & $handBackOffset[0] & ", +" & $handBackOffset[1] & ")")
			EndIf
		 Case $iMsg = $idButton_start
		    dig($topLeftPos, $bottomRightPos, $tablesScanOffset, $tablesScanCol, $tablesHeight, $tableFullHandsOffset, $tableFullHandsCol, $tableRecommendsOffset, $tableRecommendsCol, $handsScanOffset, $handsScanCol, $handsHeight, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset)
	  EndSelect
   WEnd
   Exit
EndFunc

Func setOffset($idLabel, $idLabel_message)
   $pos = MouseGetPos()
   $pos[0] = $pos[0] - $topLeftPos[0]
   $pos[1] = $pos[1] - $topLeftPos[1]
   GUICtrlSetData($idLabel, "(+" & $pos[0] & ", +" & $pos[1] & ")")
   GUICtrlSetData($idLabel_message, "")
   Return $pos
EndFunc

Func setCol($idLabel, $idLabel_message)
   $pos = MouseGetPos()
   $col = PixelGetColor ($pos[0], $pos[1])
   GUICtrlSetBkColor($idLabel, $col)
   GUICtrlSetData($idLabel_message, "")
   Return $col
EndFunc

Func getPos()
   Global $previousPos

   Select
	  Case "setTopLeftCorder" = $f2Mode
		 $topLeftPos = MouseGetPos()
		 GUICtrlSetData($idLabel_topLeft, "(" & $topLeftPos[0] & ", " & $topLeftPos[1] & ")")
		 GUICtrlSetData($idLabel_message, "")

	  Case "setBottomRightCorder" = $f2Mode
		 $bottomRightPos = MouseGetPos()
		 $bottomRightPos = setOffset($idLabel_bottomRight, $idLabel_message)

	  Case "setTablesScan" = $f2Mode
		 $tablesScanOffset = setOffset($idLabel_tablesScanPos, $idLabel_message)
		 $tablesScanCol = setCol($idLabel_tablesScanCol, $idLabel_message)

	  Case "setTablesHeight1" = $f2Mode
		 $f2Mode = "setTablesHeight2"
		 $previousPos = MouseGetPos()
		 GUICtrlSetData($idLabel_message, "Move mouse to the lower bar of same hand and press F2")
	  Case "setTablesHeight2" = $f2Mode
		 $pos = MouseGetPos()
		 $tablesHeight = $pos[1] - $previousPos[1]
	     GUICtrlSetData($idLabel_tablesHeight, $tablesHeight)
		 GUICtrlSetData($idLabel_message, "")

	  Case "setTableFullHands" = $f2Mode
		 $tableFullHandsOffset = setOffset($idLabel_tableFullHandsPos, $idLabel_message)
		 $tableFullHandsCol = setCol($idLabel_tableFullHandsCol, $idLabel_message)

	  Case "setTableRecommends" = $f2Mode
		 $tableRecommendsOffset = setOffset($idLabel_tableRecommendsPos, $idLabel_message)
		 $tableRecommendsCol = setCol($idLabel_tableRecommendsCol, $idLabel_message)

	  Case "setHandsScan" = $f2Mode
		 $handsScanOffset = setOffset($idLabel_handsScanPos, $idLabel_message)
		 $handsScanCol = setCol($idLabel_handsScanCol, $idLabel_message)

	  Case "setHandsHeight1" = $f2Mode
		 $f2Mode = "setHandsHeight2"
		 $previousPos = MouseGetPos()
		 GUICtrlSetData($idLabel_message, "Move mouse to the lower bar of same hand and press F2")
	  Case "setHandsHeight2" = $f2Mode
		 $pos = MouseGetPos()
		 $handsHeight = $pos[1] - $previousPos[1]
	     GUICtrlSetData($idLabel_handsHeight, $handsHeight)
		 GUICtrlSetData($idLabel_message, "")

	  Case "setHandOptions" = $f2Mode
		 $handOptionsOffset = setOffset($idLabel_handOptionsPos, $idLabel_message)
		 $handOptionsCol = setCol($idLabel_handOptionsCol, $idLabel_message)

	  Case "setHandShare" = $f2Mode
		 $handShareOffset = setOffset($idLabel_handSharePos, $idLabel_message)
	     $handShareCol = setCol($idLabel_handShareCol, $idLabel_message)

	  Case "setHandCopy" = $f2Mode
		 $handCopyOffset = setOffset($idLabel_handCopyPos, $idLabel_message)
	     $handCopyCol = setCol($idLabel_handCopyCol, $idLabel_message)

	  Case "setHandBack" = $f2Mode
		 $handBackOffset = setOffset($idLabel_handBackPos, $idLabel_message)
	  EndSelect


EndFunc

Func doExit()
   Exit
EndFunc

ConsoleWrite("while" & @CRLF)