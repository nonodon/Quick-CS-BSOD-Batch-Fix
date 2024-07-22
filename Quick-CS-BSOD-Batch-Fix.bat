REM Comment backing up BCD in %WINDIR%\TEMP and CS-BSOD-TMPBCD on ROOT DRIVE/FOLDER...e.g. C:\ or C DRIVE :
cls
cd %WINDIR%\TEMP
bcdedit /export "%WINDIR%\TEMP\CS-BSOD-[prefix].bcd"

cd \
mkdir CS-BSOD-TMPBCD
bcdedit /export "CS-BSOD-TMPBCD\CS-BSOD-[prefix].bcd"

BCDEdit /enum
dir %WINDIR%\TEMP\CS-BSOD-[prefix].bcd
dir CS-BSOD-TMPBCD\CS-BSOD-[prefix].bcd


REM Comment ###go to CrowdStrike directory & list files in directory named such... C-00000291".sys
cd %WINDIR%\System32\drivers\CrowdStrike
dir
dir C-00000291*.sys


REM Comment ###delete matching "C-00000291".sys".
del /s C-00000291*.sys


REM Comment ###search system for residual files on ROOT DRIVE/FOLDER...e.g. C:\ or C DRIVE :
cd \
echo "search system for residual files"
where /r c:\ C-00000291*.sys > more_to_delete.txt
type more_to_delete.txt


REM Comment ###removing residual files
echo "removing residual files and artifacts as referenced by CS via manual review"
timeout /t 30
powershell -command "Get-Content more_to_delete.txt | Remove-Item"


REM Comment ## restore and reboot
bcdedit /set testsigning off
bcdedit /deletevalue {default} safeboot
BCDEdit /enum


timeout /t 30
echo " rebooting in 2 mins"
shutdown /r /f /t 120

echo "run command SHUTDOWN /A if you want to review more/futher"

