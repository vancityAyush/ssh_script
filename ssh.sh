#!/bin/bash
cd $USERPROFILE
mkdir -p .ssh
cd .ssh

# Step 2: Show a menu to ask for option 1. Bitbucket and 2. Github


echo "Select an option:"
echo "1. Bitbucket"
echo "2. Github"
read -p "Enter your choice: " option

# Step 3: Ask for email and ssh key name from the user
read -p "Enter your email: " email
read -p "Enter your SSH key name: " keyName

# Step 5: Generate SSH key based on the selected option
if [ "$option" = "1" ]; then
  ssh-keygen -t ed25519 -b 4096 -C "$email" -f "$keyName"
elif [ "$option" = "2" ]; then
  ssh-keygen -t ed25519 -C "$email" -f "$keyName"
fi

# Step 6: Add the generated SSH key to the ssh agent
eval $(ssh-agent)
ssh-add "$keyName"

# Step 7: Create/update ssh configuration file
config_file="config"
touch "$config_file"

#function to get host name
getDefaultHostName() {
  if [ "$option" = "1" ]; then
    echo "bitbucket.org"
  elif [ "$option" = "2" ]; then
    echo "github.com"
  fi
}

#function to write config
writeConfig(){
  if ! grep -q "Host $1" "$config_file"; then
    echo -e "\nHost $1" >> "$config_file"
    echo "  HostName $(getDefaultHostName)" >> "$config_file"
    echo "  AddKeysToAgent yes" >> "$config_file"
    echo "  IdentityFile ~/.ssh/$2" >> "$config_file"
    else
     echo "Host already exists!!!"
     exit 1
  fi
}


read -p "Do you want to add custom host name? (Y/N): " choiceHost


if [[ "$choiceHost" == [Yy] ]]; then
    read -p "Enter your host name like (work.github.com): " hostName
  else
    hostName=$(getDefaultHostName) 
fi

writeConfig $hostName $keyName

# Step 8: Copy the keyName.pub file to the clipboard and echo it
copy_to_clipboard() {
  if command -v xclip &> /dev/null; then  # Check for xclip (Linux)
    xclip -selection clipboard < "$1"
  elif command -v clip.exe &> /dev/null; then  # Check for clip.exe (Windows)
    clip.exe < "$1"
  else
    echo "Warning: Neither xclip (Linux) nor clip.exe (Windows) found. Cannot copy to clipboard."
  fi
}

copy_to_clipboard "$keyName.pub"
echo "SSH Public Key copied to clipboard:"
cat "$keyName.pub"

# Step 9: Open GitHub SSH Key Settings in the browser
open_settings_page() {
  if [ "$1" = "1" ]; then  # Bitbucket
    settings_url="https://bitbucket.org/account/settings/ssh-keys/"
  elif [ "$1" = "2" ]; then  # GitHub
    settings_url="https://github.com/settings/keys"
  fi

  if command -v xdg-open &> /dev/null; then   # Linux 
    xdg-open "$settings_url"
  elif command -v open &> /dev/null; then     # macOS
    open "$settings_url"
  elif command -v start &> /dev/null; then   # Windows
    start "$settings_url"
  else
    echo "Could not detect a command to open URLs in the browser."
  fi
}

open_settings_page "$option"


while true; do
  # Step 9: Wait for the user to press T for Test
  read -p "Press T to test SSH key or any other key to exit: " choice
  echo


  if [ "$choice" = "T" ] || [ "$choice" = "t" ]; then
    # Test the SSH key based on the selected option
    ssh -T git@"$hostName"
  else
    break
  fi
done
