#include <Date.au3>
#include <WinAPIFiles.au3>

Func moveToScanPoint($topLeftPos, $bottomRightPos, $scanOffset, $scanCol, $height)
   $i = 0;
   $col = 0
   $x = $topLeftPos[0] + $scanOffset[0]
   $y = $topLeftPos[1] + $bottomRightPos[1] - 120
   $yScan = $topLeftPos[1] + $scanOffset[1]

  $col = PixelGetColor ($x, $yScan)
   If $col = $scanCol Then
	  Return true
   EndIf

   MouseMove($x, $y)
   Sleep(200)
   MouseDown("left")
   Sleep(200)
   While $i < 3 * $height
	  $i = $i + 1
	  $y = $y - 1
	  $col = PixelGetColor ($x, $yScan)
	  If $col = $scanCol Then
		 MouseUp("left")
		 Sleep(200)
		 Return true
	  EndIf
	  MouseMove($x, $y)
	  Sleep(1)
   WEnd
   MouseUp("left")
   Sleep(200)
   Return false
EndFunc

Func waitForColor($hFileLogs, $topLeftPos, $offset, $color, $waitTime)
   $i = 0;
   $x = $topLeftPos[0] + $offset[0]
   $y = $topLeftPos[1] + $offset[1]

   While $i < $waitTime / 100
	  $i = $i + 1
	  $col = PixelGetColor ($x, $y)
	  If $col = $color Then
	  	 logToFile($hFileLogs, "click")
		 MouseClick("left", $topLeftPos[0] + $offset[0], $topLeftPos[1] + $offset[1])
		 Sleep(200)
		 Return true
	  EndIf
	  Sleep(100)
   WEnd
   Return false
EndFunc

Func waitForColorInNeighborhood($hFileLogs, $topLeftPos, $offset, $color, $waitTime)
   $k = 0;
   Local $modifiedOffset[2]
   $neighborhoodPixels = 4

   While $k * (2 * $neighborhoodPixels + 1) * (2 * $neighborhoodPixels + 1) < $waitTime / 100 * 0.7
	  $k = $k + 1

	  For $j = -$neighborhoodPixels To $neighborhoodPixels Step 1
		 For $i = -$neighborhoodPixels To $neighborhoodPixels Step 1
			$modifiedOffset[0] = $offset[0] + $i
			$modifiedOffset[1] = $offset[1] + $j
			If waitForColor($hFileLogs, $topLeftPos, $modifiedOffset, $color, 100) Then
			   Return true
			EndIf
		 Next
	  Next
   WEnd
   Return false
EndFunc

Func swipeToNext($topLeftPos, $scanOffset, $height, $count)
   $x = $topLeftPos[0] + $scanOffset[0]
   $y = $topLeftPos[1] + $scanOffset[1] + (1 + $count) * $height

   MouseMove($x, $y)
   Sleep(200)
   MouseDown("left")
   Sleep(200)
   MouseMove($x, $y - ($count - 0.15) * $handsHeight)
   Sleep(500)
   MouseUp("left")
   Sleep(200)
EndFunc

Func handleHand($filePath, $hFileData, $hFileLogs, $topLeftPos, $bottomRightPos, $handsScanOffset, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset, $handsHeight, $isTablePlayed, $waitForColorTimeout, $handNumber, $y)
   logToFile($hFileLogs, "handle hand: " & $handNumber)
   If $y Then
	  logToFile($hFileLogs, "one of the last hand $y: " & $y)
	  logToFile($hFileLogs, "click hand")
     MouseClick("left", $topLeftPos[0] + $handsScanOffset[0], $y)
	  Sleep(200)
   Else
     logToFile($hFileLogs, "click hand")
	  MouseClick("left", $topLeftPos[0] + $handsScanOffset[0], $topLeftPos[1] + $handsScanOffset[1])
	  Sleep(200)
   EndIf
   ClipPut ( "" )
   logToFile($hFileLogs, "wait for $handOptionsCol")
   waitForColorInNeighborhood($hFileLogs, $topLeftPos, $handOptionsOffset, $handOptionsCol, $waitForColorTimeout)
   logToFile($hFileLogs, "wait for $handShareCol")
   waitForColor($hFileLogs, $topLeftPos, $handShareOffset, $handShareCol, $waitForColorTimeout)
   logToFile($hFileLogs, "wait for $handCopyCol")
   waitForColor($hFileLogs, $topLeftPos, $handCopyOffset, $handCopyCol, $waitForColorTimeout)
   Sleep(1000)

   $isUniqueHand = saveResults($hFileData, $hFileLogs, ClipGet(), $isTablePlayed, 30, $handNumber)
   logToFile($hFileLogs, "$isUniqueHand: " & $isUniqueHand)
	logToFile($hFileLogs, "click back")
   MouseClick("left", $topLeftPos[0] + $handBackOffset[0], $topLeftPos[1] + $handBackOffset[1])
   Sleep(1000)

   If $isUniqueHand Then
	  If Not $y Then
		 swipeToNext($topLeftPos, $handsScanOffset, $handsHeight, 1)
       logToFile($hFileLogs, "start scrolling to $handsScanCol")
       $isHandFocused = moveToScanPoint($topLeftPos, $bottomRightPos, $handsScanOffset, $handsScanCol, $handsHeight)
       logToFile($hFileLogs, "$isHandFocused: " & $isHandFocused)
		 Return $isHandFocused
	  EndIf
   Else
	  ConsoleWrite("delete file " & $filePath & @CRLF);
	  logToFile($hFileLogs, "delete file: " & $filePath)
	  FileClose ($hFileData)
	  FileDelete ($filePath)
	  Return False
   EndIf
EndFunc

Func handleLastHands($filePath, $hFileData, $hFileLogs, $topLeftPos, $bottomRightPos, $handsScanOffset, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset, $handsHeight, $waitForColorTimeout)
   Sleep(1000)

   If Not FileExists($filePath) Then
	  Return
   EndIf

   $x = $topLeftPos[0] + $handsScanOffset[0]
   $y = $topLeftPos[1] + $bottomRightPos[1] - 70

   While $y > $topLeftPos[1] + $handsScanOffset[1] + $handsHeight
      $y = $y - $handsHeight
   WEnd
   While $y <= $topLeftPos[1] + $bottomRightPos[1] - 70
      handleHand($filePath, $hFileData, $hFileLogs, $topLeftPos, $bottomRightPos, $handsScanOffset, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset, $handsHeight, False, $waitForColorTimeout, 99, $y)
      $y = $y + $handsHeight
      Sleep(1000)
   WEnd
EndFunc

Func saveResults($hFileData, $hFileLogs, $url, $isTablePlayed, $retry, $handNumber)
   If Not $retry Or 10 > StringLen($url) Then
	  Return True
   EndIf
   $serverAddress = IniRead("config.ini", "general", "serverAddress", "https://poker-hands-digger.herokuapp.com")
   $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
   $oHTTP.Open("POST", $serverAddress & "/parse", False)
   $oHTTP.SetRequestHeader("Content-Type", "text/plain")
   logToFile($hFileLogs, "request to server $url: " & $url)
   $oHTTP.Send($url)
   $oReceived = $oHTTP.ResponseText
   $oStatusCode = $oHTTP.Status

   logToFile($hFileLogs, "status: " & $oStatusCode)
   logToFile($hFileLogs, "data: " & $oReceived)

   If 10 < StringLen($oReceived) Then
	  If 1 = $handNumber and Not $isTablePlayed Then
		 If Not isUniqueHand($oReceived) Then
		   logToFile($hFileLogs, "not unique first hand")
			Return False
		 EndIf
	  EndIf

	  FileWrite($hFileData, $oReceived & @CRLF & @CRLF)
	  Return True
   Else
     logToFile($hFileLogs, "$retry: " & $retry)
	  If $retry Then
		 Sleep(30000)
		 Return saveResults($hFileData, $hFileLogs, $url, $isTablePlayed, $retry - 1, $handNumber)
	  EndIf
	  Return True
   EndIf
EndFunc

Func logToFile($hFileLogs, $message)
   FileWrite($hFileLogs, @YEAR & "-" & @MON & "-" & @MDAY & "___" & @HOUR  & "-" & @MIN& "-" & @SEC & "   " & $message & @CRLF)
EndFunc

Func dig($topLeftPos, $bottomRightPos, $tablesScanOffset, $tablesScanCol, $tablesResultOffset, $tablesResultCol, $tablesHeight, $tableFullHandsOffset, $tableFullHandsCol, $tableRecommendsOffset, $tableRecommendsCol, $handsScanOffset, $handsScanCol, $handsHeight, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset)
   If Not $topLeftPos[0] Or Not $bottomRightPos[0] Or Not $handsScanOffset[0] Or Not $handsScanCol Or Not $handsHeight Or Not $handOptionsOffset[0] Or Not $handOptionsCol Or Not $handShareOffset[0] Or Not $handShareCol Or Not $handCopyOffset[0] Or Not $handCopyCol Or Not $handBackOffset[0] Then
	  MsgBox(0, "Warning", "Set all required fields!")
	  Return
   EndIf
   Sleep(3000)

   $waitForColorTimeout = 60 * 1000

   $id = IniRead("C:\Users\Ziolo\Desktop\config.ini", "general", "id", "no-name")
   $filePath = @WorkingDir & "\" & $id & "-" & @YEAR & "-" & @MON & "-" & @MDAY & "___" & @HOUR  & "-" & @MIN& "-" & @SEC & "___logs.txt"
   $hFileLogs = FileOpen($filePath, $FO_APPEND)

   $isTableFocused = moveToScanPoint($topLeftPos, $bottomRightPos, $tablesScanOffset, $tablesScanCol, $tablesHeight)
   logToFile($hFileLogs, "first $isTableFocused: " & $isTableFocused)
   $isTablePlayed = $tablesResultCol <> PixelGetColor($topLeftPos[0] + $tablesResultOffset[0], $topLeftPos[1] + $tablesResultOffset[1])
   logToFile($hFileLogs, "first $isTablePlayed: " & $isTablePlayed)
   While $isTableFocused
	  $j = 0
     logToFile($hFileLogs, @CRLF & @CRLF & "Start new TABLE")
	  logToFile($hFileLogs, "click table")
	  MouseClick("left", $topLeftPos[0] + $tablesScanOffset[0], $topLeftPos[1] + $tablesScanOffset[1])
	  Sleep(200)
	  logToFile($hFileLogs, "wait for $tableFullHandsCol")
	  waitForColorInNeighborhood($hFileLogs, $topLeftPos, $tableFullHandsOffset, $tableFullHandsCol, $waitForColorTimeout)

	  logToFile($hFileLogs, "wait for $tableRecommendsCol")
	  If waitForColorInNeighborhood($hFileLogs, $topLeftPos, $tableRecommendsOffset, $tableRecommendsCol, $waitForColorTimeout) Then
		 $filePath = @WorkingDir & "\" & $id & "-" & @YEAR & "-" & @MON & "-" & @MDAY & "___" & @HOUR  & "-" & @MIN& "-" & @SEC
		 If $isTablePlayed Then
		   $filePath = $filePath & "___played"
		 EndIf
		 $filePath = $filePath & ".txt"
		 $hFileData = FileOpen($filePath, $FO_APPEND)
		 swipeToNext($topLeftPos, $handsScanOffset, $handsHeight, 2)
		 logToFile($hFileLogs, "start scrolling to $handsScanCol")
		 $isHandFocused = moveToScanPoint($topLeftPos, $bottomRightPos, $handsScanOffset, $handsScanCol, $handsHeight)
		 logToFile($hFileLogs, "$isHandFocused: " & $isHandFocused)
		 For $i = 0 To 5 Step 1
			If Not $isHandFocused Then
			   $isHandFocused = moveToScanPoint($topLeftPos, $bottomRightPos, $handsScanOffset, $handsScanCol, $handsHeight)
			   logToFile($hFileLogs, "$isHandFocused: " & $isHandFocused)
			EndIf
		 Next
		 While $isHandFocused
			$j = $j + 1
		   logToFile($hFileLogs, @CRLF & "Start new HAND")
			$isHandFocused = handleHand($filePath, $hFileData, $hFileLogs, $topLeftPos, $bottomRightPos, $handsScanOffset, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset, $handsHeight, $isTablePlayed, $waitForColorTimeout, $j, 0)
		 WEnd
		 logToFile($hFileLogs, "start handling last hands")
		 handleLastHands($filePath, $hFileData, $hFileLogs, $topLeftPos, $bottomRightPos, $handsScanOffset, $handOptionsOffset, $handOptionsCol, $handShareOffset, $handShareCol, $handCopyOffset, $handCopyCol, $handBackOffset, $handsHeight, $waitForColorTimeout)
	  EndIf

	  Sleep(1000)
	  logToFile($hFileLogs, "click back")
	  MouseClick("left", $topLeftPos[0] + $handBackOffset[0], $topLeftPos[1] + $handBackOffset[1])
	  Sleep(1000)
	  logToFile($hFileLogs, "click back")
	  MouseClick("left", $topLeftPos[0] + $handBackOffset[0], $topLeftPos[1] + $handBackOffset[1])
	  Sleep(1000)

	  swipeToNext($topLeftPos, $tablesScanOffset, $tablesHeight, 0.6)
	  $isTableFocused = moveToScanPoint($topLeftPos, $bottomRightPos, $tablesScanOffset, $tablesScanCol, $tablesHeight)
	  logToFile($hFileLogs, "$isTableFocused: " & $isTableFocused)
	  For $i = 0 To 3 Step 1
		 If Not $isTableFocused Then
			Sleep(10000)
			$isTableFocused = moveToScanPoint($topLeftPos, $bottomRightPos, $tablesScanOffset, $tablesScanCol, $tablesHeight)
	      logToFile($hFileLogs, "$isTableFocused: " & $isTableFocused)
		 EndIf
	  Next
   WEnd
EndFunc





