
#SingleInstance Force
SetTitleMatchMode, 2

versionURL	:=	"http://quicklip.honestpromo.com/data/version.txt",			v_file	:=	"version.txt"
1scriptURL	:=	"http://quicklip.honestpromo.com/data/QuicKlipCore.ahk",	File1	:=	"QuicKlipCore.ahk"

FileRead, splashver, %A_WorkingDir%/data/version.txt
IfInString, A_ScriptFullPath, temp.exe
{
	SplashImage, %A_WorkingDir%/data/splash.jpg, B, Updating - Please Wait, QuicKlip, splash2
	sleep 1000
	WinWaitNotActive, splash, QuicKlip, 120
	del_again:
	FileDelete, QuicKlip.exe
	IfExist, QuicKlip.exe
		Goto, del_again
	copy_again:
	FileCopy, %A_ScriptFullPath%, %A_WorkingDir%\QuicKlip.exe, 1
	If Errorlevel
		Goto, copy_again
	sleep 200
	Run QuicKlip.exe
	ExitApp
}
IfExist, temp.exe
{
	deltemp:
	FileDelete, temp.exe
	If ErrorLevel
		Goto, deltemp
}
URLDownloadToFile, %versionURL%, temp.txt
Loop, Read, %A_WorkingDir%/data/%v_file%
{
	IfInString, A_LoopReadLine, Version
	{
		RegExMatch(A_LoopReadLine,"Version: (?<Ver1>\d{1,2})\.(?<Ver2>\d{1,2})",_)
		CurrentVersion := _Ver1 . _Ver2
	}
}
Loop, Read, temp.txt
{
	IfInstring, A_LoopReadLine, Version
	{
		RegExMatch(A_LoopReadLine,"Version: (?<New1>\d{1,2})\.(?<New2>\d{1,2})",_)
		CheckVersion := _New1 . _New2
	}
}
FileDelete, temp.txt
If (CheckVersion = CurrentVersion) {
	SplashImage, %A_WorkingDir%/data/splash.jpg, B, %splashver% - Up to date, QuicKlip, splash
} Else If (CheckVersion > CurrentVersion) {
	SplashImage,%A_WorkingDir%/data/splash.jpg, B, %splashver% is old. Updating to v%_new1%.%_New2%, QuicKlip, splash
	URLDownloadToFile, %versionURL%, %A_WorkingDir%/data/%v_file%
	URLDownloadToFile, %1scriptURL%, %A_WorkingDir%/data/%File1%
	If ( A_IsCompiled = 1 ) {
		SplashImage,%A_WorkingDir%/data/splash.jpg, B, Updating - Please Wait, QuicKlip, splash
		RunWait %A_WorkingDir%\data\Ahk2Exe.exe /in "%A_WorkingDir%/QuicKlip.ahk" /out "%A_WorkingDir%/temp.exe" /icon "%A_workingDir%/data/QuicKlip.ico
		sleep 500
		run temp.exe
		exitapp
	} Else {
		IfExist, QuicKlip.exe
			FileDelete, QuicKlip.exe
		SplashImage,%A_WorkingDir%/data/splash.jpg, B, Updating - Please Wait, QuicKlip, splash
		RunWait %A_WorkingDir%\data\Ahk2Exe.exe /in "%A_WorkingDir%/QuicKlip.ahk" /out "%A_WorkingDir%/QuicKlip.exe" /icon "%A_workingDir%/data/QuicKlip.ico
		sleep 500
	}
	SplashImage,%A_WorkingDir%/data/splash.jpg, B, UPDATE COMPLETE! -- Reloading..., QuicKlip, splash
	sleep 1500
	Reload
} Else If (CheckVersion < CurrentVersion) {
	SplashImage,%A_WorkingDir%/data/splash.jpg, B, %splashver% - You appear to have a newer version than is available, QuicKlip, splash
}
SetTimer, HideSplash, 3000

; Include files below this Line
#Include data\QuicKlipCore.ahk

HideSplash:
	SplashImage, Off
	SetTimer, HideSplash, Off
Return