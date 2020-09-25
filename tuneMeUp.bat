@echo off
cls
set TAB=    
echo [*] Running System File Checker (SFC)... && echo;
sfc /scannow > nul 2>&1

echo [*] Running Deployment Image Servicing and Management (DISM)... && echo;
echo %TAB%[*] Scanning health... && echo;
dism /Online /Cleanup-Image /Scanhealth > nul 2>&1
echo %TAB%[*] Checking health... && echo;
dism /Online /Cleanup-Image /Checkhealth > nul 2>&1
echo %TAB%[*] Restoring health... && echo;
dism /Online /Cleanup-Image /Restorehealth > nul 2>&1
echo %TAB%[*] Performing clean up... && echo;
dism /Online /Cleanup-Image /startcomponentcleanup > nul 2>&1

echo [*] Defragmenting C: and D: drives... && echo;
defrag C: D: /H /U /V > nul 2>&1

echo [*] Cleaning C: drive... && echo;
cleanmgr /d c: /sageset:1 > nul 2>&1
cleanmgr /d c: /sagerun:1 > nul 2>&1

echo [*] Cleaning D: drive... && echo;
cleanmgr /d d: /sageset:2 > nul 2>&1
cleanmgr /d d: /sagerun:2 > nul 2>&1

set drive=
set /p drive="[*] Enter backup drive [Press enter to abort]: " && echo;
if "%drive%" EQU "" (
	echo;
	echo %TAB%[!] Aborting backup... && echo;
) ELSE (
	if "%drive%" EQU "C" (
		echo %TAB%[!] C is not a backup drive && echo;
	) ELSE (
		if "%drive%" EQU "D" (
			echo %TAB%[!] D is not a backup drive && echo;
		) ELSE (
			echo [*] Performing backup of C: and D: drives on %drive%: drive && echo;
			wbadmin START BACKUP -backuptarget:"%drive%": -include:C:,D: -allCritical -quiet > nul 2>&1
		)
	)
)
set drive=
	
echo [*] Checking C: drive for logical and physical errors... && echo;
chkdsk C: /R /X > nul 2>&1

echo [*] Checking D: drive for logical and physical errors... && echo;
chkdsk D: /R /X > nul 2>&1

echo [*] Rebooting...
shutdown /r /t 0
