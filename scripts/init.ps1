# init.ps1

$ProjectRoot = Split-Path $PSScriptRoot -Parent
$EnvFile = Join-Path $ProjectRoot ".env"

Write-Host "🔄 Reiniciando entorno Docker..." -ForegroundColor Cyan

Push-Location $ProjectRoot
Write-Host "Deteniendo contenedores anteriores (docker compose down)..." -ForegroundColor Cyan
docker compose down
Pop-Location

Write-Host "🔍 Buscando archivo .env..." -ForegroundColor Cyan

if (Test-Path $EnvFile) {
    Write-Host "Archivo .env ya existe. No se sobrescribirá." -ForegroundColor Yellow
} else {
    Write-Host "No se encontró .env en el directorio raíz." -ForegroundColor Red
    Write-Host "Creando .env..." -ForegroundColor Cyan
    @'
POSTGRES_USER=admin
POSTGRES_PASSWORD=secretKey123
POSTGRES_DB=evolutiondb

AUTHENTICATION_API_KEY=mySecretApiKey123

SERVER_URL=http://localhost:5600
DATABASE_CONNECTION_URI=postgresql://admin:secretKey123@postgres:5432/evolutiondb

N8N_USER=developer
N8N_PASSWORD=72[%F>]V@8h+
'@ | Out-File -FilePath $EnvFile -Encoding utf8
    Write-Host '.env creado. Puedes editarlo en: ' $EnvFile -ForegroundColor Green
}

Push-Location $ProjectRoot
docker compose up -d
Pop-Location

Write-Host "`nEsperando que los servicios se levanten..." -ForegroundColor Cyan
Start-Sleep -Seconds 15

Write-Host "`nVerificando estado de servicios..." -ForegroundColor Cyan

function Test-HttpEndpoint {
    param([string]$Url)
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
        return $response.StatusCode -eq 200
    } catch {
        return $false
    }
}

# Verificar PostgreSQL
Write-Host "`nVerificando PostgreSQL..." -ForegroundColor Cyan
$pgReady = docker exec postgres pg_isready -U admin
if ($pgReady -like "*accepting connections*") {
    Write-Host "✅ PostgreSQL está listo." -ForegroundColor Green
} else {
    Write-Host "❌ PostgreSQL no responde correctamente." -ForegroundColor Red
}

# Verificar evolution-api
Write-Host "`nVerificando evolution-api en http://localhost:5600 ..." -ForegroundColor Cyan
if (Test-HttpEndpoint -Url "http://localhost:5600") {
    Write-Host "✅ evolution-api responde correctamente." -ForegroundColor Green
} else {
    Write-Host "❌ evolution-api NO responde." -ForegroundColor Red
}

# Verificar n8n
$n8nUrl = "http://localhost:5678/healthz"
Write-Host "`nVerificando n8n en $n8nUrl ..." -ForegroundColor Cyan
if (Test-HttpEndpoint -Url $n8nUrl) {
    Write-Host "✅ n8n responde correctamente." -ForegroundColor Green
} else {
    Write-Host "❌ n8n NO responde" -ForegroundColor Red
}

Write-Host "`nEntorno Docker inicializado correctamente." -ForegroundColor Green
Write-Host "Puedes acceder a los servicios en:"
Write-Host "  - PostgreSQL: docker exec -it postgres psql -U admin -d evolutiondb" -ForegroundColor Cyan
Write-Host "  - evolution-api: http://localhost:5600" -ForegroundColor Cyan
Write-Host "  - n8n: http://localhost:5678" -ForegroundColor Cyan
Write-Host "`nPara detener los servicios, ejecuta: docker compose down" -ForegroundColor Cyan
