#RequireAdmin
#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>


Global $sAllFiles = FileSelectFolder("Pasirink, iš kur imti", "", 2)
Global $sBooksFolder = FileSelectFolder("Pasirink, kur saugoti", "")

_initialPopup()

Func _initialPopup()
	Opt("GUIOnEventMode", 1)

	; Create a GUI with various controls.
	Local $hShow = GUICreate("Pasirinkti lyti", 300, 150)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Close")

	; Create GUI label
	$idTextarea = GUICtrlCreateLabel ("Pasirinkite lyti" & @CRLF & "Noredami išeiti, spauskite 'X' arba 'ESC'", 0,25,300,25,$SS_CENTER)

	; Create a button control.
	$idButton_male = GUICtrlCreateButton("Berniukas", 65, 120, 85, 25, $SS_CENTER)
	GUICtrlSetOnEvent(-1, "createBookM")

	$idButton_female = GUICtrlCreateButton("Mergaite", 150, 120, 85, 25, $SS_CENTER)
	GUICtrlSetOnEvent(-1, "createBookF")
	; Display the GUI.
	GUISetState(@SW_SHOW, $hShow)
	While 1
		Sleep(10)
	WEnd
EndFunc

Func _Close()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
		Exit
	EndSelect
EndFunc

Func createBookM()
	While 1

		Local $vFolderVariable = _DateTimeFormat(_NowCalc(), 2)
		; Asking to enter a name for a new folder to be created
		Local $sNameFolder = InputBox ("Vardas", "Bus sukurta vardo direktorija")
		; If input is empty or "Cancel" is pressed - display error message and restart loop

		If @error Or $sNameFolder == "" Then
			MsgBox(0, "Neivestas vardas", "Norint testi, privaloma irasyti varda",5)
			Return
		Else
			DirCreate($sBooksFolder&"\"&$vFolderVariable&" "&$sNameFolder)
		EndIf

		; Enter named files to be copied
		Local $sLetters = InputBox ("Iveskite varda", "Rasyk gyvunu pavadinimus, atskiriant kableliu" & @CRLF & @CRLF & _
							 "Pvz. erelis, jautis, antis")

		If @error Or $sLetters == "" Then
			MsgBox(0, "Neivesti gyvunai", "Norint testi, privaloma ivesti bent viena gyvuna",5)
			Return
		EndIf

		; Split string to array
		$aLettersArray = StringSplit($sLetters, ",", 2)


		; Set loop variable
		$i = 0

		; Start looping through files and folders
		While $i < UBound($aLettersArray)
			; Check if a file with lettersArray[i] exists in
			Local $vBook = $sBooksFolder&"\"&$vFolderVariable&" "&$sNameFolder&"\"
			Local $vFile = FileExists($sAllFiles&"\"&$aLettersArray[$i]&"?"&".pdf")

			If $vFile Then
				FileCopy($sAllFiles&"\"&$aLettersArray[$i]&"?"&".pdf", $vBook)
				FileMove($vBook&$aLettersArray[$i]&"?"&".pdf", $vBook&$i+1&"_"&"*"&".pdf", 1)
			EndIf

			$i += 1
		WEnd

		ExitLoop

	WEnd
EndFunc

Func createBookF()
		While 1

		Local $vFolderVariable = _DateTimeFormat(_NowCalc(), 2)
		; Asking to enter a name for a new folder to be created
		Local $sNameFolder = InputBox ("Vardas", "Bus sukurta vardo direktorija")
		; If input is empty or "Cancel" is pressed - display error message and restart loop
		If @error Or $sNameFolder == "" Then
			MsgBox(0, "Neivestas vardas", "Norint testi, privaloma irašyti varda",5)
			Return
		Else
			DirCreate($sBooksFolder&"\"&$vFolderVariable&" "&$sNameFolder)
		EndIf

		; Enter named files to be copied
		Local $sLetters = InputBox ("Iveskite varda", "Rašyk gyvunu pavadinimus, atskiriant kableliu" & @CRLF & @CRLF & _
							 "Pvz. erelis, jautis, antis")

		If @error Or $sLetters == "" Then
			MsgBox(0, "Neivesti gyvunai", "Norint testi, privaloma ivesti bent viena gyvuna",5)
			Return
		EndIf

		; Split string to array
		$aLettersArray = StringSplit($sLetters, ",", 2)

		; Set loop variable
		Local $i = 0

		; Start looping through files and folders
		While $i < UBound($aLettersArray)
			; Check if a file with lettersArray[i] exists in
			Local $vBook = $sBooksFolder&"\"&$vFolderVariable&" "&$sNameFolder&"\"
			Local $vFile = FileExists($sAllFiles&"\"&$aLettersArray[$i]&"?"&".pdf")

			; Select files to move only from an array from input

			If $vFile Then
				FileCopy($sAllFiles&"\"&$aLettersArray[$i]&"?"&".pdf", $vBook)

				FileMove($vBook&$aLettersArray[$i]&"?"&".pdf", $vBook&$i+1&"_"&"*"&".pdf", 1)

			EndIf

			$i += 1

		WEnd

		ExitLoop

	WEnd
EndFunc
