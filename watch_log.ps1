# Function to send a Discord embed
function Send-DiscordEmbed($title, $desc, $color) {
    $embed = @{
        title = $title
        description = $desc
        color = $color
        timestamp = (Get-Date).ToString("o")
    }

    $payload = @{
        username = "YourBotName"
        embeds = @($embed)
    } | ConvertTo-Json -Depth 3

    try {
        Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType 'application/json' -Body $payload
        Write-Host "Sent embed: $desc"
    } catch {
        Write-Host "Error sending to Discord: $_"
    }
}

# Configuration
$logFile = "logs\latest.log" # Path to your Minecraft server log file
$webhookUrl = "Your Discord Webhook URL Here"   # Replace with your Discord webhook URL

# Regex patterns
$playerPattern = 'joined the game|has made|left the game|was slain by|fell from|drowned|burned to death|hit the ground too hard'
$startedPattern = 'Done \(\d+\.\d+s\)! For help, type "help"'
$stoppedPattern = 'ThreadedAnvilChunkStorage: All dimensions are saved'

# Start watching the log file
Get-Content -Path $logFile -Wait -Tail 0 | ForEach-Object {
    $line = $_

    if ($line -match $playerPattern) {
        $clean = $line -replace '^\[\d{2}:\d{2}:\d{2}\] \[Server thread\/INFO\]: ', ''
        Send-DiscordEmbed "Player Event" $clean 65280
    }
    elseif ($line -match $startedPattern) {
        Send-DiscordEmbed "Server Started" "Minecraft server is now online." 3066993
    }
    elseif ($line -match $stoppedPattern) {
        Send-DiscordEmbed "Server Stopped" "Minecraft server has been shut down." 15158332
    }
}
