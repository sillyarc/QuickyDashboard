@echo off
setlocal

REM Caminho do Flutter (ajuste se estiver em outro lugar)
set "FLUTTER=C:\flutter\bin\flutter.bat"

REM Caminho do Firebase CLI
set "FIREBASE=%APPDATA%\npm\firebase.cmd"

echo.
echo === Build Flutter web (release) ===
call "%FLUTTER%" build web --release
if errorlevel 1 goto :error

echo.
echo === Copiando build\web para firebase\public ===
if exist "firebase\public" (
  rmdir /S /Q "firebase\public"
)
mkdir "firebase\public"
xcopy /E /Y /I "build\web\*" "firebase\public\" >nul

echo.
echo === Deploy para Hosting (site: quicky-dashboard) ===
pushd "firebase"
call "%FIREBASE%" deploy --only hosting:quicky-dashboard --project quick-b108e --config firebase.json
set "ERR=%ERRORLEVEL%"
popd
if not "%ERR%"=="0" goto :error

echo.
echo Deploy concluido com sucesso para https://quicky-dashboard.web.app
goto :eof

:error
echo.
echo *** O deploy falhou. Veja as mensagens de erro acima. ***
exit /b 1
