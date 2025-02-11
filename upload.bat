@echo off
cd /d "%~dp0"

:: Show current changes
git status
echo.
echo Review the changes above.
pause

:: Ensure we are on the correct branch
git checkout daily

:: Add all changes
git add .

:: Create commit with timestamp (Windows 10 & 11 compatible)
for /f "delims=" %%i in ('powershell -command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set commit_message=Auto commit on %%i

:: Check if there are changes to commit
git diff --cached --exit-code >nul
if %errorlevel% neq 0 (
    git commit -m "%commit_message%"
    echo Commit created: %commit_message%
) else (
    echo No changes to commit.
    pause
    exit /b
)

:: Ask for confirmation before pushing
echo.
echo You are about to push to branch: daily
set /p confirm="Do you want to continue? (y/n): "
if /I not "%confirm%"=="y" exit

git push origin daily

echo.
echo Upload complete!
pause
