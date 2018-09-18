@echo off
setlocal ENABLEDELAYEDEXPANSION

for %%V in (15,14,12,11) do if exist "!VS%%V0COMNTOOLS!" call "!VS%%V0COMNTOOLS!..\..\VC\vcvarsall.bat" amd64 && goto compile

SET VCVARSALL_2017_ENTERPRISE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
if exist %VCVARSALL_2017_ENTERPRISE% call %VCVARSALL_2017_ENTERPRISE% amd64 && goto compile

SET VCVARSALL_2017_COMMUNITY="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
if exist %VCVARSALL_2017_COMMUNITY% call %VCVARSALL_2017_COMMUNITY% amd64 && goto compile

echo vcvarsall.bat could not be found
goto error

:compile
nvcc -arch compute_30 src\ebsynth.cpp src\ebsynth_cpu.cpp src\ebsynth_cuda.cu -DNDEBUG -O6 -I "include" -o "bin\ebsynth.exe" -Xcompiler "/openmp /fp:fast" -Xlinker "/IMPLIB:dummy.lib" -w || goto error
nvcc -arch compute_30 src\ebsynth.cpp src\ebsynth_cpu.cpp src\ebsynth_cuda.cu -DNDEBUG -O6 -I "include" -o "bin\ebsynth.dll" -Xcompiler "/openmp /fp:fast" -Xlinker "/IMPLIB:lib\ebsynth.lib" -shared -DEBSYNTH_API=__declspec(dllexport) -w || goto error
del dummy.lib;dummy.exp 2> NUL
goto :EOF

:error
echo FAILED
@%COMSPEC% /C exit 1 >nul
