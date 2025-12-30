# Start Claude Code with MiniMax M2.1 model
# Run this script when you want to use MiniMax instead of Claude

$env:ANTHROPIC_BASE_URL = "https://api.minimax.io/anthropic"
$env:ANTHROPIC_AUTH_TOKEN = "sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c"
$env:API_TIMEOUT_MS = "3000000"
$env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"
$env:ANTHROPIC_MODEL = "MiniMax-M2.1"
$env:ANTHROPIC_SMALL_FAST_MODEL = "MiniMax-M2.1"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL = "MiniMax-M2.1"
$env:ANTHROPIC_DEFAULT_OPUS_MODEL = "MiniMax-M2.1"
$env:ANTHROPIC_DEFAULT_HAIKU_MODEL = "MiniMax-M2.1"

Write-Host "Starting Claude Code with MiniMax M2.1..." -ForegroundColor Cyan
claude
