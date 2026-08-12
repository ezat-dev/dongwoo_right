@echo off
setlocal

set "PROJECT_DIR=%~dp0"
set "TOMCAT_HOME=D:\apache-tomcat-9.0.115"
set "CATALINA_HOME=%TOMCAT_HOME%"
set "CATALINA_BASE=%TOMCAT_HOME%"
set "JAVA_HOME="
if exist "C:\Program Files\Eclipse Adoptium\jdk-11.0.30.7-hotspot\bin\java.exe" (
  set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.30.7-hotspot"
) else if exist "C:\Program Files\Java\jdk-11\bin\java.exe" (
  set "JAVA_HOME=C:\Program Files\Java\jdk-11"
)
set "JRE_HOME=%JAVA_HOME%"
set "WAR_NAME=sample_pro.war"
set "APP_DIR=sample_pro"
set "BUILD_LOG=%PROJECT_DIR%redeploy-build.log"
set "PATH=%JAVA_HOME%\bin;%PATH%"

if not defined JAVA_HOME (
  echo [ERROR] JAVA_HOME not found.
  pause & exit /b 1
)

echo [1/3] Building WAR...
pushd "%PROJECT_DIR%"
call "D:\apache-maven-3.9.15\bin\mvn.cmd" -DskipTests clean package > "%BUILD_LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] Build failed. See %BUILD_LOG%
  powershell -NoProfile -Command "Get-Content -Tail 30 -Path '%BUILD_LOG%'"
  popd & pause & exit /b 1
)

echo [2/3] Stopping Tomcat...
call "%TOMCAT_HOME%\bin\shutdown.bat" >nul 2>&1
timeout /t 6 /nobreak >nul
for /f "tokens=5" %%P in ('netstat -ano ^| findstr :8080 ^| findstr LISTENING') do taskkill /PID %%P /F >nul 2>&1
timeout /t 2 /nobreak >nul

echo [3/3] Deploying and Starting Tomcat...
if exist "%TOMCAT_HOME%\webapps\%WAR_NAME%" del "%TOMCAT_HOME%\webapps\%WAR_NAME%"
if exist "%TOMCAT_HOME%\webapps\%APP_DIR%" rmdir /s /q "%TOMCAT_HOME%\webapps\%APP_DIR%"
copy /y "target\%WAR_NAME%" "%TOMCAT_HOME%\webapps\%WAR_NAME%" >nul
call "%TOMCAT_HOME%\bin\startup.bat"

echo [OK] Done.
echo [URL] http://localhost:8080/sample_pro
popd
pause
