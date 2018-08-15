@echo off
setlocal ENABLEDELAYEDEXPANSION

SET OUTPUT_TYPE=%~1

IF "%OUTPUT_TYPE%" == "" (
	ECHO Specify OUTPUT_TYPE
	EXIT /B 1
)

IF "%OUTPUT_TYPE%" NEQ "EXE" IF "%OUTPUT_TYPE%" NEQ "DLL" (
	ECHO OUTPUT_TYPE must be either EXE or DLL
	goto error
)


for %%V in (15,14,12,11) do if exist "!VS%%V0COMNTOOLS!" call "!VS%%V0COMNTOOLS!..\..\VC\vcvarsall.bat" x86 && goto compile

SET VCVARSALL_2017_BAT="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
if exist %VCVARSALL_2017_BAT% call %VCVARSALL_2017_BAT% x86 && goto compile

goto error


:compile
IF "%OUTPUT_TYPE%" == "DLL" goto compile_dll
goto compile_exe


:compile_exe
nvcc -arch compute_30 src\ebsynth.cu -m32 -O6 -w -I "include" -o "bin\ebsynth.exe" -Xcompiler "/DNDEBUG /Ox /Oy /Gy /Oi /fp:fast" -Xlinker "/IMPLIB:\"lib\ebsynth.lib\"" || goto error
goto :EOF

:compile_dll
nvcc -arch compute_30 src\ebsynth.cu -m32 -O6 -w -I "include" -o "bin\ebsynth.dll" --shared -Xcompiler "/DEBSYNTH_API=\"__declspec(dllexport)\" /DNDEBUG /Ox /Oy /Gy /Oi /fp:fast" -Xlinker "/IMPLIB:\"lib\ebsynth.lib\"" || goto error
goto :EOF 

:error
echo FAILED
@%COMSPEC% /C exit 1 >nul