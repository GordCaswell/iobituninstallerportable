${SegmentFile}

Var CUSTOM_Exists_IobitUninstaller_Scheduled_Task
Var CUSTOM_Exists_IobitUninstaller_Scheduled_Task_User
Var CUSTOM_LoggedInUser

${SegmentPrePrimary}
	System::Call "advapi32::GetUserName(t .r0, *i ${NSIS_MAX_STRLEN} r1) i.r2"
	StrCpy $CUSTOM_LoggedInUser $0

	${If} ${FileExists} "$SYSDIR\Tasks\Uninstaller_SkipUac_$CUSTOM_LoggedInUser"
		StrCpy $CUSTOM_Exists_IobitUninstaller_Scheduled_Task_User true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\Uninstaller_SkipUac_Administrator"
		StrCpy $CUSTOM_Exists_IobitUninstaller_Scheduled_Task true
	${EndIf}
!macroend


${SegmentPostPrimary}
	Delete $DataDirectory\uninstaller\SoftwareCache.ini
	
	System::Call "advapi32::GetUserName(t .r0, *i ${NSIS_MAX_STRLEN} r1) i.r2"
	
	${If} $CUSTOM_Exists_SmartDefrag_Scheduled_Task_User != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn Uninstaller_SkipUac_$CUSTOM_LoggedInUser /f`
		Pop $0
	${EndIf}
	
	${If} $CUSTOM_Exists_SmartDefrag_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn Uninstaller_SkipUac_Administrator /f`
		Pop $0
	${EndIf}
	
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller3/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller4/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller5/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller6/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://update.iobit.com/dl/uninstaller/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://update.iobit.com/dl/uninstaller/uninstall_qdb.dbd')i .r2"
!macroend