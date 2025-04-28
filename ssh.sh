#!/bin/bash

cd $HOME
mkdir -p .ssh
cd .ssh

echo "Select an option:"
echo "1. Bitbucket"
echo "2. Github"
echo "3. GitLab"
read -p "Enter your choice: " option

echo "Enter your email: "
read email
echo "Enter your SSH key name: "
read keyName

if [ "$option" = "1" ]; then
  ssh-keygen -t ed25519 -b 4096 -C "$email" -f "$keyName"
elif [ "$option" = "2" ]; then
  ssh-keygen -t ed25519 -C "$email" -f "$keyName"
elif [ "$option" = "3" ]; then
  ssh-keygen -t rsa -b 4096 -C "$email" -f "$keyName"
fi

eval $(ssh-agent)
ssh-add "$keyName"

config_file="config"
touch "$config_file"

if [ ! -w "$config_file" ]; then
  echo "Error: Config file does not exist or is not writable."
  exit 1
fi

getDefaultHostName() {
  if [ "$option" = "1" ]; then
    echo "bitbucket.org"
  elif [ "$option" = "2" ]; then
    echo "github.com"
  elif [ "$option" = "3" ]; then
    echo "gitlab.com"
  fi
}

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

copy_to_clipboard() {
  if command -v xclip &> /dev/null; then
    xclip -selection clipboard < "$1"
  elif command -v clip.exe &> /dev/null; then
    clip.exe < "$1"
  else
    echo "Warning: Neither xclip (Linux) nor clip.exe (Windows) found. Cannot copy to clipboard."
  fi
}

copy_to_clipboard "$keyName.pub"
echo "SSH Public Key copied to clipboard:"
cat "$keyName.pub"

open_settings_page() {
  if [ "$1" = "1" ]; then
    settings_url="https://bitbucket.org/account/settings/ssh-keys/"
  elif [ "$1" = "2" ]; then
    settings_url="https://github.com/settings/keys"
  elif [ "$1" = "3" ]; then
    settings_url="https://gitlab.com/-/profile/keys"
  fi

  if command -v xdg-open &> /dev/null; then
    xdg-open "$settings_url"
  elif command -v open &> /dev/null; then
    open "$settings_url"
  elif command -v start &> /dev/null; then
    start "$settings_url"
  else
    echo "Could not detect a command to open URLs in the browser."
  fi
}

open_settings_page "$option"

while true; do
  read -p "Press T to test SSH key or any other key to exit: " choice
  echo

  if [ "$choice" = "T" ] || [ "$choice" = "t" ]; then
    ssh -T git@"$hostName"
  else
    break
  fi
done

# Add a section to download the script using curl and run it locally
if [ "$1" == "curl" ]; then
  curl -O https://raw.githubusercontent.com/vancityAyush/ssh_script/main/ssh.sh
  chmod +x ssh.sh
  ./ssh.sh
fi
