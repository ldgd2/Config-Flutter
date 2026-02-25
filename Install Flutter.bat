@echo off
setlocal enabledelayedexpansion
title Instalador de Entorno de Desarrollo - Flutter ^& Android SDK

:: Inicializando codigos de color ANSI para Windows
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_GREEN=%ESC%[92m"
set "C_RED=%ESC%[91m"
set "C_CYAN=%ESC%[96m"
set "C_YELLOW=%ESC%[93m"
set "C_RESET=%ESC%[0m"

:: Definiendo el directorio de instalacion principal
set "DEV_DIR=C:\dev"
set "ANDROID_ROOT=%DEV_DIR%\Android"
set "CMDLINE_DIR=%ANDROID_ROOT%\cmdline-tools\latest"
set "SDKMANAGER=%CMDLINE_DIR%\bin\sdkmanager.bat"

:: URLs de descarga directa
set "FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.41.2-stable.zip"
set "JAVA_URL=https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.zip"
set "GRADLE_URL=https://services.gradle.org/distributions/gradle-8.6-bin.zip"
set "CMD_TOOLS_URL=https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"

if not exist "%DEV_DIR%" mkdir "%DEV_DIR%"

:MENU
cls
echo %C_CYAN%=================================================================%C_RESET%
echo %C_CYAN%       CONFIGURACION DE ENTORNO DE DESARROLLO (C:\dev)%C_RESET%
echo %C_CYAN%=================================================================%C_RESET%
echo.
echo Estado de los componentes:

:: Verificando Java
if exist "%DEV_DIR%\Java\bin\java.exe" (
    echo   [%C_GREEN% OK %C_RESET%] Java JDK 21
    set "JAVA_INSTALLED=1"
) else (
    echo   [%C_RED% -- %C_RESET%] Java JDK 21
    set "JAVA_INSTALLED=0"
)

:: Verificando Gradle
if exist "%DEV_DIR%\Gradle\bin\gradle.bat" (
    echo   [%C_GREEN% OK %C_RESET%] Gradle 8.6
    set "GRADLE_INSTALLED=1"
) else (
    echo   [%C_RED% -- %C_RESET%] Gradle 8.6
    set "GRADLE_INSTALLED=0"
)

:: Verificando Flutter
if exist "%DEV_DIR%\flutter\bin\flutter.bat" (
    echo   [%C_GREEN% OK %C_RESET%] Flutter SDK ^(3.41.2^)
    set "FLUTTER_INSTALLED=1"
) else (
    echo   [%C_RED% -- %C_RESET%] Flutter SDK ^(3.41.2^)
    set "FLUTTER_INSTALLED=0"
)

:: Verificando Android SDK
if exist "%SDKMANAGER%" (
    echo   [%C_GREEN% OK %C_RESET%] Android Command Line Tools
    set "SDK_INSTALLED=1"
) else (
    echo   [%C_RED% -- %C_RESET%] Android Command Line Tools
    set "SDK_INSTALLED=0"
)

echo.
echo %C_CYAN%Opciones de Instalacion:%C_RESET%
echo %C_YELLOW%1.%C_RESET% Instalar todos los componentes faltantes
echo %C_YELLOW%2.%C_RESET% Instalar solo Java JDK 21
echo %C_YELLOW%3.%C_RESET% Instalar solo Gradle 8.6
echo %C_YELLOW%4.%C_RESET% Instalar solo Flutter SDK
echo %C_YELLOW%5.%C_RESET% Instalar Android SDK ^(API 35^) y aceptar licencias
echo %C_YELLOW%6.%C_RESET% Configurar variables de entorno ^(PATH^) automaticamente
echo %C_YELLOW%0.%C_RESET% Salir
echo.
set /p opcion="Seleccione una opcion (0-6): "

if "%opcion%"=="1" goto ALL
if "%opcion%"=="2" goto JAVA
if "%opcion%"=="3" goto GRADLE
if "%opcion%"=="4" goto FLUTTER
if "%opcion%"=="5" goto SDK
if "%opcion%"=="6" goto PATH_CONFIG
if "%opcion%"=="0" exit

goto MENU

:ALL
echo.
call :INSTALL_JAVA
call :INSTALL_GRADLE
call :INSTALL_FLUTTER
call :INSTALL_SDK
echo.
echo %C_GREEN%[+] Instalacion masiva completada exitosamente.%C_RESET%
pause
goto MENU

:JAVA
echo.
call :INSTALL_JAVA
pause
goto MENU

:GRADLE
echo.
call :INSTALL_GRADLE
pause
goto MENU

:FLUTTER
echo.
call :INSTALL_FLUTTER
pause
goto MENU

:SDK
echo.
call :INSTALL_SDK
pause
goto MENU

:PATH_CONFIG
echo.
echo %C_CYAN%[*] Actualizando variables de entorno del sistema...%C_RESET%
setx ANDROID_HOME "%ANDROID_ROOT%" /M
setx PATH "%PATH%;%DEV_DIR%\Java\bin;%DEV_DIR%\Gradle\bin;%DEV_DIR%\flutter\bin;%ANDROID_ROOT%\cmdline-tools\latest\bin;%ANDROID_ROOT%\platform-tools" /M
echo %C_GREEN%[+] Variables configuradas correctamente.%C_RESET%
echo %C_YELLOW%Aviso: Es necesario reiniciar el equipo para aplicar los cambios en el PATH.%C_RESET%
pause
exit

:: =================================================================
:: FUNCIONES DE DESCARGA E INSTALACION
:: =================================================================

:INSTALL_JAVA
if "%JAVA_INSTALLED%"=="1" (
    echo %C_GREEN%[i] Java ya se encuentra instalado.%C_RESET%
    goto :eof
)
echo %C_CYAN%[*] Descargando Java JDK 21...%C_RESET%
curl -L -# -o "%TEMP%\java.zip" "%JAVA_URL%"
echo %C_CYAN%[*] Extrayendo archivos en %DEV_DIR%...%C_RESET%
tar -xf "%TEMP%\java.zip" -C "%DEV_DIR%"
for /d %%I in ("%DEV_DIR%\jdk-*") do ren "%%I" Java
del "%TEMP%\java.zip"
echo %C_GREEN%[+] Java instalado.%C_RESET%
goto :eof

:INSTALL_GRADLE
if "%GRADLE_INSTALLED%"=="1" (
    echo %C_GREEN%[i] Gradle ya se encuentra instalado.%C_RESET%
    goto :eof
)
echo %C_CYAN%[*] Descargando Gradle 8.6...%C_RESET%
curl -L -# -o "%TEMP%\gradle.zip" "%GRADLE_URL%"
echo %C_CYAN%[*] Extrayendo archivos en %DEV_DIR%...%C_RESET%
tar -xf "%TEMP%\gradle.zip" -C "%DEV_DIR%"
for /d %%I in ("%DEV_DIR%\gradle-*") do ren "%%I" Gradle
del "%TEMP%\gradle.zip"
echo %C_GREEN%[+] Gradle instalado.%C_RESET%
goto :eof

:INSTALL_FLUTTER
if "%FLUTTER_INSTALLED%"=="1" (
    echo %C_GREEN%[i] Flutter ya se encuentra instalado.%C_RESET%
    goto :eof
)
echo %C_CYAN%[*] Descargando Flutter SDK (v3.41.2)...%C_RESET%
curl -L -# -o "%TEMP%\flutter.zip" "%FLUTTER_URL%"
echo %C_CYAN%[*] Extrayendo archivos en %DEV_DIR%...%C_RESET%
tar -xf "%TEMP%\flutter.zip" -C "%DEV_DIR%"
del "%TEMP%\flutter.zip"
echo %C_GREEN%[+] Flutter instalado.%C_RESET%
goto :eof

:INSTALL_SDK
if "%SDK_INSTALLED%"=="1" (
    echo %C_GREEN%[i] Android Command Line Tools ya estan presentes.%C_RESET%
) else (
    echo %C_CYAN%[*] Descargando Android Command Line Tools...%C_RESET%
    if not exist "%CMDLINE_DIR%" mkdir "%CMDLINE_DIR%"
    curl -L -# -o "%TEMP%\cmdline.zip" "%CMD_TOOLS_URL%"
    echo %C_CYAN%[*] Extrayendo herramientas base...%C_RESET%
    tar -xf "%TEMP%\cmdline.zip" -C "%TEMP%"
    xcopy /E /Y /Q "%TEMP%\cmdline-tools\*" "%CMDLINE_DIR%\" >nul
    rmdir /S /Q "%TEMP%\cmdline-tools"
    del "%TEMP%\cmdline.zip"
)

echo %C_CYAN%[*] Aceptando licencias del SDK de Android de forma automatica...%C_RESET%
(
echo y
echo y
echo y
echo y
echo y
echo y
echo y
echo y
echo y
echo y
) > "%TEMP%\yes.txt"
call "%SDKMANAGER%" --licenses --sdk_root="%ANDROID_ROOT%" < "%TEMP%\yes.txt" >nul
del "%TEMP%\yes.txt"

echo %C_CYAN%[*] Instalando Plataforma Android (API 35), Build-Tools y ADB...%C_RESET%
call "%SDKMANAGER%" "platform-tools" "platforms;android-35" "build-tools;35.0.0" --sdk_root="%ANDROID_ROOT%"
echo %C_GREEN%[+] Android SDK configurado.%C_RESET%
goto :eof
