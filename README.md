# Purple Keep

### by Antony Kalampogias

Purple Keep is a work in progress open source bash script for setting up a Linux (Debian-Based) machine with some of the most known and valuable tools for red and blue teamers, hence the name purple :) 

I try to keep the code as user friendly as possible and ease for development

## Installation

All you have to do is download the script

`git clone https://github.com/AnthonyKalampogias/PurpleKeep.git`

and run it on any folder you want 

`./purpleKeep.sh`

But make sure the script has the permission to be executed `chmod +x purpleKeep.sh`



## Notes

- It is suggested to **not** run the script as a sudoer `sudo ./purpleKeep.sh` due to the tools that are installed from the web either from GitHub or in general will only be available for root, the script on startup will ask for your password so it will provide it itself when it is needed for an installation.
  - You can check which commands use sudo privileges by running in your terminal `cat purpleKeep.sh | grep sudo `
- The script will create a folder on your users Desktop to keep all the logs outputted in case you want to give them a look
- It is also advised that if you are to run this script on a freshly installed OS to keep an eye on the screen for there may be some pop up messages from packages that might need user interaction
- I also noticed that when some packages have their own "GUI" in the terminal, because the script prints out that GUI you can't respond to the prompted message so if you are aware of such application that does that please execute `sudo apt update && sudo apt upgrade -y` before the script just to be sure



## Functions

### theAtpts

### This will be our GO-TO function that will keep all packages upgraded and up to date

I encountered some technical issues during the testing of the script so I added `apt --fix-broken install` and `dpkg --configure -a` to make sure your installation won't experience any errors

### General

#### ZSH

I have found ZSH to be quite more easy and helpful than bash, not that I don't love the bash.. but I have found myself using ZSH on a daily bases and I encourage people to give it a try

First you will be prompted if you wish to install ZSH with a provided link to check for information about it, available inputs are pretty simple `y/n`

#### Kali Repo

Set up the official repository of kali Linux if you are **not** on a Kali distro set its priority lower than your other repositories so it will only be used if your other main repositories have nothing to respond to you

#### Visual Studio Code

One of the best editors available right now and one of my personal favorite 

#### Discord

Be social :)

Highly useful communication app for communities and teams



### forensicTools

This will install some of the most commonly used forensics tools that you will need in your forensics journey

## Volatility

Once you reach volatility the user will be prompted with which version of volatility he wishes to install `vol2` or `vol3`

You can also skip this installation by pressing any other key but in that case the user will be prompted once more for this decision 

- Volatility Standalone

  In case something doesn't work in the main volatility you will have the standalone version to work with

- AVML
- Sleuthkit
  
  - Autopsy
- WireShark
  
  - tshark
- BinWalk
- OleTools
  
  - ViperMonkey



### stego

This function will install the most known steganography tools

- foremost 
- steghide
- stegcracker



### rev

This is the Reverse engineering function where we will install the most valuable reverse engineering tools out there

- GHidra
- radare2
  - cutter



### pentest

Probably the most valuable function on this script, here we will install one of the most known tools and scripts for all your Pen Testing needs

- Evil-WinRM
- CrackMapExec
- Impacket
- PayloadsAllTheThings
- Dirbuster
- wfuzz
- nmap
- metasploit-framework
- netcat
- Neo4j
- Bloodhound
  - Sharphound
- HashCat
- John
- winPEAS
