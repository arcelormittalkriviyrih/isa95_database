@echo on
cd "%WORKSPACE%\service_packs_internal"
if ERRORLEVEL 1 exit 1
XCOPY "*" "..\service_packs" /s /i /y
if ERRORLEVEL 1 exit 1
del ..\service_packs\.git
if ERRORLEVEL 1 exit 1
