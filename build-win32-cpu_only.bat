@echo off
setlocal ENABLEDELAYEDEXPANSION

for %%V in (15,14,12,11) do if exist "!VS%%V0COMNTOOLS!" call "!VS%%V0COMNTOOLS!..\..\VC\vcvarsall.bat" x86 && goto compile

SET VCVARSALL_2017_ENTERPRISE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
if exist %VCVARSALL_2017_ENTERPRISE% call %VCVARSALL_2017_ENTERPRISE% x86 && goto compile

SET VCVARSALL_2017_COMMUNITY="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
if exist %VCVARSALL_2017_COMMUNITY% call %VCVARSALL_2017_COMMUNITY% x86 && goto compile

echo vcvarsall.bat could not be found
goto error

:compile
cl src\ebsynth.cpp src\ebsynth_cpu.cpp src\ebsynth_nocuda.cpp /DNDEBUG /O2 /openmp /EHsc /nologo /I"include" /Fe"bin\ebsynth.exe" || goto error
cl src\ebsynth.cpp src\ebsynth_cpu.cpp src\ebsynth_nocuda.cpp /DNDEBUG /O2 /openmp /EHsc /nologo /I"include" /Fe"bin\ebsynth.dll" /DEBSYNTH_API="__declspec(dllexport)" /link /IMPLIB:"lib\ebsynth.lib" || goto error
del ebsynth.obj;ebsynth_cpu.obj;ebsynth_nocuda.obj 2> NUL
goto :EOF

:error
echo FAILED
@%COMSPEC% /C exit 1 >nul
