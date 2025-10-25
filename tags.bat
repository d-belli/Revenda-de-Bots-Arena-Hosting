@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: =====================================
:: CONFIGURAÇÕES
:: =====================================
set "REPO_OWNER=d-belli"
set "REPO_NAME=Revenda-de-Bots-Arena-Hosting"
set "SCRIPT_PATH=gerenciador.sh"
set "VERSION_PATH=version.txt"
set "TOKEN_GITHUB=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"  :: 🔧 coloque aqui seu token com permissão "repo"

:: =====================================
:: VERIFICAÇÃO DE PRÉ-REQUISITOS
:: =====================================
where git >nul 2>nul || (echo ❌ Git não encontrado! Instale o Git antes de continuar. & pause & exit /b)
where curl >nul 2>nul || (echo ❌ cURL não encontrado! Instale o cURL antes de continuar. & pause & exit /b)

if not exist "%SCRIPT_PATH%" (
    echo ❌ Arquivo %SCRIPT_PATH% não encontrado!
    pause
    exit /b
)

if not exist "%VERSION_PATH%" (
    echo ❌ Arquivo %VERSION_PATH% não encontrado!
    pause
    exit /b
)

:: =====================================
:: LER VERSÃO DO ARQUIVO
:: =====================================
for /f "tokens=*" %%v in ('type "%VERSION_PATH%" ^| findstr /R "[0-9]*\.[0-9]*\.[0-9]*"') do set "VERSION=%%v"

if "%VERSION%"=="" (
    echo ❌ Não foi possível ler a versão do arquivo version.txt
    pause
    exit /b
)

set "TAG=v%VERSION%"

echo ============================================
echo 🚀 Criando release: %TAG%
echo ============================================

:: =====================================
:: CRIAR TAG LOCAL E ENVIAR PARA O GITHUB
:: =====================================
git add .
git commit -m "Release %TAG%"
git tag -a %TAG% -m "Release %TAG%"
git push origin main
git push origin %TAG%

:: =====================================
:: CRIAR RELEASE VIA API DO GITHUB
:: =====================================
echo Criando release no GitHub...
curl -s -X POST "https://api.github.com/repos/%REPO_OWNER%/%REPO_NAME%/releases" ^
    -H "Authorization: token %TOKEN_GITHUB%" ^
    -H "Content-Type: application/json" ^
    -d "{\"tag_name\":\"%TAG%\",\"name\":\"%TAG%\",\"body\":\"Versão %VERSION% publicada automaticamente.\",\"draft\":false,\"prerelease\":false}" > release.json

for /f "tokens=2 delims=:," %%i in ('findstr "upload_url" release.json') do set "UPLOAD_URL=%%~i"
set "UPLOAD_URL=%UPLOAD_URL:~2,-1%"
set "UPLOAD_URL=%UPLOAD_URL:{?name,label}=%%"

if "%UPLOAD_URL%"=="" (
    echo ❌ Falha ao criar release no GitHub.
    type release.json
    pause
    exit /b
)

:: =====================================
:: ENVIAR ASSETS PARA A RELEASE
:: =====================================
echo Enviando arquivos para a release...

curl -s -X POST -H "Authorization: token %TOKEN_GITHUB%" -H "Content-Type: application/octet-stream" ^
    --data-binary "@%SCRIPT_PATH%" "%UPLOAD_URL%?name=%SCRIPT_PATH%"

curl -s -X POST -H "Authorization: token %TOKEN_GITHUB%" -H "Content-Type: application/octet-stream" ^
    --data-binary "@%VERSION_PATH%" "%UPLOAD_URL%?name=%VERSION_PATH%"

echo ============================================
echo ✅ Release %TAG% publicada com sucesso!
echo ============================================
del release.json >nul 2>nul
pause
