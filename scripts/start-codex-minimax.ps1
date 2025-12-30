param(
  [string]$ApiKey
)

Remove-Item Env:OPENAI_API_KEY, Env:OPENAI_BASE_URL -ErrorAction SilentlyContinue

$defaultApiKey = "sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
$storedKey = $env:MINIMAX_API_KEY
if (-not $storedKey) {
  $storedKey = [Environment]::GetEnvironmentVariable('MINIMAX_API_KEY', 'User')
}
if ($ApiKey) {
  $storedKey = $ApiKey
}
if (-not $storedKey) {
  $storedKey = $defaultApiKey
  [Environment]::SetEnvironmentVariable('MINIMAX_API_KEY', $storedKey, 'User')
}

$env:MINIMAX_API_KEY = $storedKey

$codexPath = "C:\Users\Sam\.vscode\extensions\openai.chatgpt-0.5.56-win32-x64\bin\windows-x86_64\codex.exe"
if (-not (Test-Path $codexPath)) {
  $codexPath = "codex"
}

# Force the env var into the launched process to avoid sandbox/env gaps.
$cmd = "set MINIMAX_API_KEY=$env:MINIMAX_API_KEY && `"$codexPath`" --profile m21"
cmd /c $cmd
