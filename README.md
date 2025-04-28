# SSH Script

This shell script is designed to automate the process of generating and configuring SSH keys for either Bitbucket, GitHub, or GitLab.

## Installation

Install my-project with npm

```bash
  sh ssh.sh
```
Run the above command in the git bash terminal inside the folder where you have downloaded the script.

## Running the script locally without cloning the repo

To run the script locally on your system without cloning the repository, follow these steps:

1. Open your terminal.
2. Create a new file named `ssh.sh` using a text editor of your choice (e.g., `nano ssh.sh`).
3. Copy the content of the script from the repository and paste it into the `ssh.sh` file.
4. Save the file and exit the text editor.
5. Make the script executable by running the following command:
```bash
  chmod +x ssh.sh
```
6. Run the script by executing the following command:
```bash
  ./ssh.sh
```

## Running the script using curl

To run the script locally on your system using curl, follow these steps:

1. Open your terminal.
2. Download the script using curl by running the following command:
```bash
  curl -O https://raw.githubusercontent.com/vancityAyush/ssh_script/main/ssh.sh
```
3. Make the script executable by running the following command:
```bash
  chmod +x ssh.sh
```
4. Run the script by executing the following command:
```bash
  ./ssh.sh
```
