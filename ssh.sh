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
copy_to_clipboard_linux() {
  echo -n "$1" | xclip -selection clipboard
}

copy_to_clipboard_windows() {
  echo -n "$1" | clip.exe
}
OS="$(uname)"
  public_key=$(cat "$keyName.pub")
  if [ "$OS" = "Linux" ]; then
  copy_to_clipboard_linux "$public_key"
  echo "SSH public key copied to clipboard"
elif [ "$OS" = "Windows_NT" ]; then
  copy_to_clipboard_windows "$public_key"
  echo "SSH public key copied to clipboard"
else
  echo "Clipboard copying is not supported on this operating system."
fi


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
