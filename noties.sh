#!/bin/bash
USER_KEY="Your Pushover User Key Here"
APP_TOKEN="amvv1iz7oipdtvsmqtcgfeqm64ew7q"
LOG_FILE="logs/latest.log"

# Start tailing the log
tail -n 0 -F "$LOG_FILE" | while read -r line; do
  if echo "$line" | grep -E "joined the game|has made|left the game|was slain by|fell from|drowned|burned to death|hit the ground too hard"; then
    # Clean up the message (strip timestamp and thread info)
    message=$(echo "$line" | sed -E 's/^\[[^]]+\] \[[^]]+\] \[INFO\]: //')

    curl -s \
      --form-string "token=amvv1iz7oipdtvsmqtcgfeqm64ew7q" \
      --form-string "user=u9ezm9i371ek9kx8ce6hf1yb4zrdrk" \
      --form-string "message=$message" \
      https://api.pushover.net/1/messages.json

    echo "Sent notification: $message"
  fi
done