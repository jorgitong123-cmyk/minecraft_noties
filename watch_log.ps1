# Function to send a Discord embed
function Send-DiscordEmbed($title, $desc, $color) {
    $embed = @{
        title = $title
        description = $desc
        color = $color
        timestamp = (Get-Date).ToString("o")
    }

    $payload = @{
        username = "YourBotName"    # Change to your bot's name *Have fun with it*
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
$logFile = "logs\latest.log" # Path to your Minecraft server log file **DONT CHANGE THIS**
$webhookUrl = "Your Discord Webhook URL Here"   # Replace with your Discord webhook URL *Change this*

# Regex patterns
$playerPattern = 'was slain by|was shot by|was blown up by|blew up|was killed by magic|
was killed while trying to hurt|was struck by lightning|drowned|burned to death|
went up in flames|tried to swim in lava|was pricked to death|walked into a cactus|
hit the ground too hard|fell from a high place|fell out of the world|
was squished by a falling anvil|was squashed by a falling block|
froze to death|starved to death|suffocated in a wall|was poked to death|
was impaled by|was fireballed by|was stung to death|withered away|
was killed by|died'
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
