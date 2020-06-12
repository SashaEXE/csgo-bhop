#NoEnv
SetWorkingDir %A_ScriptDir%

OnExit, ExitSub

RunAsAdmin()

if ((A_Is64bitOS=1) && (A_PtrSize!=4))
	hMod := DllCall("LoadLibrary", Str, "bhop.dll", Ptr)
Else
{
	MsgBox, Only on x64 bit System!
	ExitApp
}

if (hMod)
{
	hHook := DllCall("SetWindowsHookEx", Int, 5, Ptr, DllCall("GetProcAddress", Ptr, hMod, AStr, "CBProc", ptr), Ptr, hMod, Ptr, 0, Ptr)
	if (!hHook)
	{
		MsgBox, SetWindowsHookEx failed!`nScript will now terminate!
		ExitApp
	}
}
else
{
	MsgBox, LoadLibrary failed!`nScript will now terminate!
	ExitApp
}

Return

RunAsAdmin()
{
	Global 0
	IfEqual, A_IsAdmin, 1, Return 0
	
	Loop, %0%
		params .= A_Space . %A_Index%
	
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath : A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	ExitApp
}

ExitSub:
	if (hHook)
	{
		DllCall("UnhookWindowsHookEx", Ptr, hHook)
	}
	if (hMod)
	{
		DllCall("FreeLibrary", Ptr, hMod)
		SoundPlay, *16, wait
	}
ExitApp


!F12::ExitApp
#NoTrayIcon
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#If WinActive("ahk_exe csgo.exe") || WinActive("ahk_exe hl2.exe")


*~$Space::
Sleep 80
Loop
{
GetKeyState, SpaceState, Space, P
If SpaceState = U
break
Sleep 1
Send, {Blind}{Space}
}
Return



y::
u::
Suspend On
SendInput %A_Thishotkey%
Hotkey, Enter, On
Hotkey, Escape, On
Hotkey, %A_ThisHotkey%, Off
return

Enter::
Suspend Permit
Suspend Off
Send {Enter down}
Send {Enter up}
Hotkey, y, On
Hotkey, u, on
Hotkey, Enter, Off
Hotkey, Escape, Off
return

Escape::
Suspend Permit
Suspend Off
Send {Escape down}
Send {Escape up}
Hotkey, y, On
Hotkey, u, On
Hotkey, Enter, Off
Hotkey, Escape, Off
return
