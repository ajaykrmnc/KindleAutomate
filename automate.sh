#!/bin/bash

# === Configurations ===
REPO_PATH="$HOME/Desktop/KindleAutomate/economist-epub"     # Local path to clone the repo
GIT_REPO_URL="https://gitlab.com/Monkfishare/2025.git"
KINDLE_EMAIL="pramodshah6797_37OKiT@kindle.com"
SENDER_EMAIL="ajaykg6917@gmail.com"  # Must be on Amazon whitelist

# === Step 1: Clone or pull latest changes ===
if [ ! -d "$REPO_PATH" ]; then
    git clone "$GIT_REPO_URL" "$REPO_PATH"
else
    cd "$REPO_PATH" || exit
    git pull
fi

# === Step 2: Find the latest EPUB file ===
YYY=$(date +%Y)

cd "$REPO_PATH/TE/$YYY" || exit
latest_folder=$(ls -d [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] | sort -r | head -n 1)
cd "$latest_folder" || exit
latest_epub=$(ls -t *.epub | head -n 1)

if [ -z "$latest_epub" ]; then
    echo "No EPUB file found."
    exit 1
fi

# === Step 3: Send using Calibre ===
# Ensure calibre is installed. On macOS, you can install it via Homebrew:
#   brew install --cask calibre
# calibre-smtp is included with Calibre. After installation, it should be available in your PATH.
# If calibre-smtp is not in your PATH, specify the full path below:
# 

/Applications/calibre.app/Contents/MacOS/calibre-smtp \
    --attachment "$latest_epub" \
    --relay smtp.gmail.com \
    --port 587 \
    --username "ajaykg6917@gmail.com" \
    --password "uhdh ijrj jweq ziqb" \
    "$SENDER_EMAIL" "$KINDLE_EMAIL" \
    "Your Daily Economist" "Attached is the latest Economist EPUB."

# === Step 4: (Optional) Instructions to automate with cron ===
# To run this script daily at 7 AM, add the following line to your crontab:
# 0 7 * * * /bin/bash /Users/ajaymac/Desktop/raw\ project/KindleAutomate/automate.sh >> /Users/ajaymac/Desktop/raw\ project/KindleAutomate/automate.log 2>&1
#
# To edit your crontab, run:
# crontab -e
#
# Make sure the script is executable:
# chmod +x /Users/ajaymac/Desktop/raw\ project/KindleAutomate/automate.sh