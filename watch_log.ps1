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
$playerPatterns = @(
    # Join / leave
    '^.+ joined the game$',
    '^.+ left the game$',

    # Advancements
    '^.+ has made the advancement \[.*?\]$',
    '^.+ has reached the goal \[.*?\]$',
    '^.+ has completed the challenge \[.*?\]$',

    # ===== Death messages =====

    # Generic / fallback
    '^.+ died$',
    '^.+ died because of .+$',
    '^.+ was killed$',
    '^.+ was killed while fighting .+$',

    # Cactus
    '^.+ was pricked to death$',
    '^.+ walked into a cactus while trying to escape .+$',

    # Drowning / dehydration
    '^.+ drowned$',
    '^.+ drowned while trying to escape .+$',
    '^.+ died from dehydration$',
    '^.+ died from dehydration while trying to escape .+$',

    # Elytra
    '^.+ experienced kinetic energy$',
    '^.+ experienced kinetic energy while trying to escape .+$',

    # Explosions
    '^.+ blew up$',
    '^.+ was blown up by .+$',
    '^.+ was blown up by .+ using .+$',
    '^.+ was killed by \[Intentional Game Design\]$',

    # Fall variants
    '^.+ hit the ground too hard$',
    '^.+ hit the ground too hard while trying to escape .+$',
    '^.+ fell from a high place$',
    '^.+ fell off a ladder$',
    '^.+ fell off some vines$',
    '^.+ fell off some weeping vines$',
    '^.+ fell off some twisting vines$',
    '^.+ fell off scaffolding$',
    '^.+ fell while climbing$',
    '^.+ was impaled on a stalagmite$',
    '^.+ was impaled on a stalagmite while fighting .+$',

    # Falling block / anvil / stalactite
    '^.+ was squashed by a falling anvil$',
    '^.+ was squashed by a falling anvil while fighting .+$',
    '^.+ was squashed by a falling block$',
    '^.+ was squashed by a falling block while fighting .+$',
    '^.+ was skewered by a falling stalactite$',
    '^.+ was skewered by a falling stalactite while fighting .+$',

    # Fire
    '^.+ went up in flames$',
    '^.+ walked into fire while fighting .+$',
    '^.+ burned to death$',
    '^.+ was burnt to a crisp while fighting .+$',

    # Fireworks
    '^.+ went off with a bang$',
    '^.+ went off with a bang while fighting .+$',
    '^.+ went off with a bang due to a firework fired from .+ by .+$',

    # Lava / magma
    '^.+ tried to swim in lava$',
    '^.+ tried to swim in lava to escape .+$',
    '^.+ discovered the floor was lava$',
    '^.+ walked into danger zone due to .+$',

    # Lightning
    '^.+ was struck by lightning$',
    '^.+ was struck by lightning while fighting .+$',

    # Magic
    '^.+ was killed by magic$',
    '^.+ was killed by magic while trying to escape .+$',
    '^.+ was killed by .+ using magic$',
    '^.+ was killed by .+ using .+$',

    # Powder snow
    '^.+ froze to death$',
    '^.+ was frozen to death by .+$',

    # Players / mobs / melee
    '^.+ was slain by .+$',
    '^.+ was slain by .+ using .+$',
    '^.+ was stung to death$',
    '^.+ was stung to death by .+$',
    '^.+ was stung to death by .+ using .+$',
    '^.+ was fireballed by .+$',
    '^.+ was fireballed by .+ using .+$',
    '^.+ was shot by a skull from .+$',
    '^.+ was shot by a skull from .+ using .+$',
    '^.+ was shot by .+$',
    '^.+ was shot by .+ using .+$',
    '^.+ was pummeled by .+$',
    '^.+ was pummeled by .+ using .+$',
    '^.+ was destroyed by .+$',
    '^.+ was destroyed by .+ using .+$',

    # Starvation
    '^.+ starved to death$',
    '^.+ starved to death while fighting .+$',

    # Suffocation / cramming
    '^.+ suffocated in a wall$',
    '^.+ suffocated in a wall while fighting .+$',
    '^.+ was squished too much$',
    '^.+ was squashed by .+$',

    # Sweet berry bush
    '^.+ was poked to death by a sweet berry bush$',
    '^.+ was poked to death by a sweet berry bush while trying to escape .+$',

    # Thorns
    '^.+ was killed trying to hurt .+$',
    '^.+ was killed by .+ trying to hurt .+$',

    # Trident
    '^.+ was impaled by .+$',
    '^.+ was impaled by .+ with .+$',

    # Void
    '^.+ fell out of the world$',
    "^.+ didn't want to live in the same world as .+$",
    '^.+ left the confines of this world$',
    '^.+ left the confines of this world while fighting .+$',

    # Wither
    '^.+ withered away$',
    '^.+ withered away while fighting .+$',

    # Sonic boom / warden
    '^.+ was obliterated by a sonically-charged shriek$',
    '^.+ was obliterated by a sonically-charged shriek while trying to escape .+$',
    '^.+ was obliterated by a sonically-charged shriek while trying to escape .+ wielding .+$',

    # Mace-related family (post-1.21.2 change; keep broad until exact log text is confirmed on your server)
    '^.+ was smashed by .+$',
    '^.+ was smashed by .+ using .+$'
)

# One big regex
$playerPattern  = '(?:' + ($playerPatterns -join '|') + ')'
$startedPattern = 'Done \(\d+\.\d+s\)! For help, type "help"'
$stoppedPattern = 'ThreadedAnvilChunkStorage: All dimensions are saved'


# Start watching the log file
Get-Content -Path $logFile -Wait -Tail 0 | ForEach-Object {
    $line = $_

    if ($line -notmatch '\[Server thread\/') {
        return
    }

    $clean = $line -replace '^\[\d{2}:\d{2}:\d{2}\] \[Server thread\/INFO\]: ', ''

    if ($clean -match $playerPattern) {
        Send-DiscordEmbed "Player Event" $clean 65280
    }
    elseif ($clean -match $startedPattern) {
        Send-DiscordEmbed "Server Started" "Minecraft server is now online." 3066993
    }
    elseif ($clean -match $stoppedPattern) {
        Send-DiscordEmbed "Server Stopped" "Minecraft server has been shut down." 15158332
    }
}
