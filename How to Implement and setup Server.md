How to Implement and setup Server

Step 1:

Add all files to a folder...

Step 2: 

Add a .jar file to the same folder. 
example: Spigot-1.21.5.jar or Paper-1.21.4.jar

Step 3: 

Copy the name of the .jarfile onto the start.bat file. 
Alocate the amount of memory you want and run the start.bat.

Step 4:

Open the EULA.txt file that generates and replace "false" with "true"

Step 5: 

Now that the logs file is generated, place the location of the file in the noties_watcher.cmd file. example: E:\2025 Server\watch_log.ps1


~~~~~~~~~~~~~~~~~~CREATING THE BOT~~~~~~~~~~~~~~~~~~

Step 6: Probably the most tedious and annoying part.

Create a New Application

Go to https://discord.com/developers/applications
Click "New Application"
Give your bot a name
Set up the Bot User

Go to the "Bot" section in the left sidebar
Click "Add Bot"
Under the bot's username, you'll see a "Token" section
(Don't share this token with anyone)
Create a Webhook

Go to your Discord server
Edit the channel where you want the notifications
Click "Integrations" → "Create Webhook"
Give it a name
Copy the Webhook URL
Paste this URL in your watch_log.ps1 file where it says:
Required Bot Permissions

The bot needs these permissions:
Send Messages
Embed Links
Read Message History
View Channels

Congrats your done!!! Now load up the server and let everything do its thing!