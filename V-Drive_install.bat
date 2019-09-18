@echo off
echo                                                                                                    by: Andreas Anderson
echo               ---====++++ VICE Lab V: Drive Installer 1.3.1 ++++====----                                      8/06/2019    
echo.
echo.
echo This will install a V: drive that maps to the VICE Lab folder on box Drive.
echo.
echo Benefits:
echo   - Use Windows search on Box
echo   - Paths/links are consistent from one computer to the next 
echo   - V-drive can also mirror your V: drive to a profile on Remote Desktop (as long as you are connected):
echo       Just install V-Drive on the Remote Desktop profile as well, 
echo       and make sure you have shared your local V: drive using the Local Devices and Resources option. 
echo.          
echo.
CHOICE /C IUC /M "Press I to install, U to uninstall, C to cancel."
IF %ERRORLEVEL% equ 2 (
  IF NOT EXIST "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\V-Drive.bat" (
    echo.
    echo V-Drive was not found on your system, aborting...
    pause
    goto end
  )
  del "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\V-Drive.bat"
  subst v: /d
  echo.
  echo V-Drive has been un-installed.
  pause
  goto end
)

IF %ERRORLEVEL% equ 3 goto end



if exist v:\ (
  subst V: /d
)
if exist v:\ (
  echo !!!Failure!!! 
  echo You already have a V: drive that seems to have nothing to do with this program. 
  echo Please unmap this Drive before installing V-Drive.
  echo.
  pause
  goto end
)

REM ===========This block of code creates the batch file line by line ===============
cd %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
echo @echo off>V-Drive.bat
echo REM This will minimize the command window>>V-Drive.bat
echo if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 ^&^& start "Mapping V: Drive" /min "%%~dpnx0" %%* ^&^& exit>>V-Drive.bat
echo.>>V-Drive.bat
echo echo This will connect the V: drive..  Waiting a bit for box to load, checking every 10 seconds...>>V-Drive.bat
echo :waitloop>>V-Drive.bat
echo if '%%1'=='' (timeout 10) else (timeout %%1)>>V-Drive.bat
echo IF EXIST "%%USERPROFILE%%\Box\VICE Lab" GOTO mapboxdrive>>V-Drive.bat
echo IF EXIST "\\tsclient\V" GOTO mapremote>>V-Drive.bat
echo GOTO waitloop>>V-Drive.bat
echo.>>V-Drive.bat
echo :mapboxdrive>>V-Drive.bat
echo cd "%%USERPROFILE%%\Box\VICE Lab">>V-Drive.bat
echo subst V: "%%USERPROFILE%%\Box\VICE Lab">>V-Drive.bat
echo GOTO end>>V-Drive.bat
echo.>>V-Drive.bat
echo :mapremote>>V-Drive.bat
echo subst V: "\\tsclient\V">>V-Drive.bat
echo GOTO end>>V-Drive.bat
echo.>>V-Drive.bat
echo.>>V-Drive.bat
echo. >>V-Drive.bat
echo :end>>V-Drive.bat
echo exit>>V-Drive.bat



echo.
echo Installation Complete!


echo Connecting V: Drive.... 
start "Mapping V: Drive" "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\V-Drive.bat" 2
timeout 4
echo.
if exist v:\ (
  echo Drive connected! 
  echo Despite its name, 'Disconnected Network Drive ^(V:^)', it should be working as advertised.
  echo From now on the V: drive will connect to the VICE Lab folder on box every time you log in.
  echo.
  echo - To temporarily disable, go to Task Manager -^> Startup tab -^> right-click "V-Drive.bat" -^> choose 'disable'
  echo - To uninstall, just run this installer again, and choose the 'uninstall' option
) else (
  echo !!!WARNING!!! 
  echo The drive is not mapped, perhaps box is not yet connected... 
  echo V-Drive ^(minimized command window^) will continue to retry until you stop it 
)  
echo.
pause
:end