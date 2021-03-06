#/!bin/sh

theApts() {
    printf "Beginning package updating with apt"
    # Basic stuff to get our machine to the latest packages available
    echo $passwd | sudo -S apt --fix-broken install -y # When installing new packages it is possible for something to go wrong 
                                                        #so we will keep a constant eye during this setup on apt just in case
    echo $passwd | sudo -S apt update
    echo $passwd | sudo -S apt-get upgrade -y
    echo $passwd | sudo -S apt-get dist-upgrade -y
    echo $passwd | sudo -S apt-get full-upgrade -y
    echo $passwd | sudo -S apt-get autoremove -y # Delete any unecessary packages to free up some space
    echo $passwd | sudo -S apt --fix-broken install -y
    echo $passwd | sudo -S dpkg --configure -a #In case dpkg encounters any errors
    printf "\nFinished package updating.."
}

main() {
    printf "\nSome Packages require sudo privillages to be installed\nPlease enter your user's Password: "
    read -s passwd
    clear

    whoAreyou=$(whoami) # Save the username to later locate paths

    # Make log folders
    cd ~/Desktop/
    mkdir purpleKeepLogs 
    cd purpleKeepLogs/
	
	printf "Please wait while the latest packages are being installed with apt...\n\n\n"
	theApts
	printf "\n\n\nUpdate Complete.."
	printf "\nAll things are set let's begin.."

        # Install from functions
            ## And save all the logs the functions make inside the Logs folder
        general | tee ~/Desktop/purpleKeepLogs/generalFunctions.log
        forensicTools | tee ~/Desktop/purpleKeepLogs/forensicsFunctions.log
        stego | tee ~/Desktop/purpleKeepLogs/stegoFunctions.log
        rev | tee ~/Desktop/purpleKeepLogs/revFunctions.log
        pentest | tee ~/Desktop/purpleKeepLogs/penTestFunctions.log

        printf "[+] Installation has completed...\nPress any key to close this windows :)"
        read endOfScript
        source ~/.zshrc # Final step to add volatility and ghidra to path
        source ~/.bashrc
        exit
}

general(){
    printf "[!] Initiating installation of general applications.."
    echo $passwd | sudo -S apt-get install -y aptitude exiftool snapd git curl ruby gem gnupg default-jre apt-transport-https npm gzip htop

    # Setup zsh
    	clear
    	printf "[!] Apt updates complete!\n"
        printf "Do you wish to install ZSH as your new and fresh Terminal?[y/n]\n"
        printf "Visit https://ohmyz.sh/ for more information :)"
        read wantZSH

        if [ "$wantZSH" = "y" ]; then
            sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            printf "[!] If you wish to change the zsh theme please visit..\nhttps://github.com/ohmyzsh/ohmyzsh/wiki/Themes"
            echo "y" # ZSH prompt to install it
            echo "exit" # Exit ZSH shell and continue with the script
        else
            printf "[!] You have selected not to install ZSH\n[+] Moving on with the installation.."
        fi
    
    # Python3 Pip if not installed and python3 libs 
        echo $passwd | sudo -S apt install -y python3-pip libpython3-dev libpython3.8-dev python-pip-whl python3-dev python3-wheel python3.8-dev python3-venv
        echo $passwd | sudo -S cp /home/$whoAreyou/.local/bin/pip3 /usr/bin # In case pip3 doesn't get in PATH


    ## Kali Repo
        # Some files may not be found from your default repositories or even be outdates
        # So we will setup the official Kali Repository to get packages from there as well

        # If the user executed the script in any other Linux OS apart from Kali 
        if ! grep -q Kali "/etc/os-release" ;then
            clear
            printf "[!] You are not on a Kali Linux Distro\nSetting up the official Kali Linux Repository..\n"
            echo $passwd | sudo -S sh -c "echo 'deb https://http.kali.org/kali kali-rolling main non-free contrib' > /etc/apt/sources.list.d/kali.list"
            wget 'https://archive.kali.org/archive-key.asc'
            echo $passwd | sudo -S apt-key add archive-key.asc
            echo $passwd | sudo -S sh -c "echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref"
            theApts
            rm archive-key.asc
            printf "\n[+] Kali Linux Repository has been installed on your system!\n"
        fi

    ## Tools
    	cd ~/Documents/
    	mkdir Tools && cd Tools/

        ### Visual Studio Code
            wget https://az764295.vo.msecnd.net/stable/e5a624b788d92b8d34d1392e4c4d9789406efe8f/code_1.51.1-1605051630_amd64.deb
            echo $passwd | sudo -S dpkg -i code_1.51.1-1605051630_amd64.deb
            rm code_1.51.1-1605051630_amd64.deb*

        ### Discord
            wget https://discord.com/api/download?platform=linux&format=deb
            echo $passwd | sudo -S dpkg -i discord-0.0.12.deb
            rm discord-0.0.12.deb*
        
        ### Sage
        printf "[!] Would you like to install Sage Math ?\nhttps://www.sagemath.org/\nInput: "
            read wantSage
            if [ "$wantSage" = "y" ]; then
                printf "[+] OK!\n[!] This might take a while :')\nPlease wait..."
                # Installed under ~/Documents/Tools/
                wget http://mirrors.mit.edu/sage/linux/64bit/sage-9.2-Ubuntu_20.04-x86_64.tar.bz2
                tar -xjf *.tar.bz2
                cd Sage*
                chmod +x sage
                ./sage
                clear
                printf "[+] Sage has been installed !!\n"
            fi


    ## Github Tools
		#Create a folder in the users Documents to be later used to store the tools we install from github
    	cd ~/Documents/
    	mkdir githubTools && cd githubTools/
        
        ### Cheat
            # Cheat is an amazing tool that a friend of mine found and I am completely addicted to it
            # You basically call it when you can't recall a command you want to execute and it will prompt you with some suggestions
            # For more information about Cheat and how to configure please visit its github page https://github.com/cheat/cheat
            wget https://github.com/cheat/cheat/releases/download/4.2.0/cheat-linux-amd64.gz
            gzip -d cheat-linux-amd64.gz
            mv cheat-linux-amd64 ~/Documents/githubTools/
            chmod +x cheat-linux-amd64
            ./cheat-linux-amd64
            mv cheat-linux-amd64 cheat
            echo $passwd | sudo -S cp cheat /usr/bin/
            echo $passwd | sudo -S rm ~/Documents/githubTools/cheat

		
    theApts # Check if the new installed packages need upgrading
    printf "\n[+] general function has completed its installation\n[!] Starting forensics installation..\n" 
}

forensicTools() {
	printf "\n[+] Initiating Installation process for Forensics Tools\n"
    
    # Volatility
        # reference link https://covert.sh/2020/08/24/volatility-ubuntu-setup/
        # official repo https://github.com/volatilityfoundation/volatility
    
    cd ~/Documents/githubTools/

    printf "[!] Which version of volatility would you like to install ?\n1. vol2\n2. vol3\nor just press enter to skip..\nInput: "
    read whichVol # Read either vol2/vol3 for volatility with python2 or volatility with python3
    if [ $whichVol = "vol2" ]; then
        # if the user selects to install volatility2, 

        #Setup python2 libraries
        echo $passwd | sudo -S apt install -y python2 python-dev dwarfdump build-essential yara zip
        wget https://bootstrap.pypa.io/pip/2.7/get-pip.py #Download pip2
        echo $passwd | sudo -S python2 get-pip.py # Setup pip2
        sudo cp /home/$whoAreyou/.local/bin/pip2 /usr/bin/ #Make sure pip2 is in PATH
        pip2 install --upgrade setuptools #Make sure pip2 is ok to install packages
        
        # Install libraries for vol2
        pip2 install pycrypto yara-python distorm3==3.4.4
        
        # Setup Volatility2
        git clone https://github.com/volatilityfoundation/volatility.git
        cd volatility/
        mv ../get-pip.py .
        echo $passwd | sudo -S python2 setup.py install
        clear
        echo "[+] Volatility2 has succesfully been installed"

    elif [ $whichVol = "vol3" ]; then
        # if the user selects to install volatility2,

        ### Basic installation
        pip3 install capstone yara-python pefile 
        git clone https://github.com/volatilityfoundation/volatility3.git

        ### Symbol Tables
            cd volatility3/volatility3/symbols/
            wget https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip
            wget https://downloads.volatilityfoundation.org/volatility3/symbols/mac.zip
            wget https://downloads.volatilityfoundation.org/volatility3/symbols/linux.zip
        
        clear
        echo "[+] Volatility3 has succesfully been installed"
    
    else 
        printf "[!] Are you sure you don't want to install volatility?\ny | skip volatility\nn | No I want it!\nInput:"
        read whichVol 
        if [ $whichVol = "n" ]; then
            # Call the function Again but when it finishes we use break so it doesn't execute twice
            forensicTools
            break
        else
            printf "[!] Skipping volatility...\n"
        fi
    fi 

    ## Backup volatility standalone edition
        cd ~/Documents/Tools/
        wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip
        unzip volatility_2.6_lin64_standalone.zip
        rm volatility_2.6_lin64_standalone.zip*

        ## Add Volatility to PATH
        echo $passwd | sudo -S echo "export PATH=$PATH:/home/$whoAreyou/Documents/githubTools/volatility3" >> ~/.bashrc
        echo $passwd | sudo -S echo "export PATH=$PATH:/home/$whoAreyou/Documents/githubTools/volatility3" >> ~/.zshrc

    # avml
        # Official Repo https://github.com/microsoft/avml
        cd ~/Documents/githubTools/
        mkdir avml && cd avml/
        wget https://github.com/microsoft/avml/releases/download/v0.2.0/avml-minimal
        chmod +x avml-minimal

    # Autopsy
        # Official WebPage https://www.sleuthkit.org/autopsy/
        echo $passwd | sudo -S apt install -y autopsy sleuthkit
    
    # Wireshark
        # Official WebPage https://www.wireshark.org
        echo $passwd | sudo -S apt install -y wireshark tshark

    # BinWalk
        echo $passwd | sudo -S apt install -y binwalk
    
    # Macro analysis
        ## OleTools
            # Official Repo https://github.com/decalage2/oletools
            echo $passwd | sudo -S pip3 install -U oletools
    
        ## ViperMonkey
            # Official Repo https://github.com/decalage2/ViperMonkey
            pip2 install --requirement https://raw.githubusercontent.com/decalage2/ViperMonkey/master/requirements.txt # install vmonkey requirments 
            pip2 install -U https://github.com/decalage2/ViperMonkey/archive/master.zip
            echo $passwd | sudo -S cp ~/.local/bin/vmonkey /usr/bin
            printf "\n[+]Viper Monkey succesfully installed!!\n"
	
    
    theApts # Check if the new installed packages need upgrading
    printf "\n[+] Forensics function has completed its installation\nStarting steganography installation..\n" 
}


stego(){

    printf "[!] Initiating Installation for Steganography Tools"
    echo $passwd | sudo -S apt install -y foremost steghide kali-tools-crypto-stego stegcracker elpa-ps-ccrypt
    theApts # Check if the new installed packages need upgrading
    printf "\n[+] Steganography function has completed its installation\n[!] Starting Reverse engineering installation..\n" 

}


rev(){
    printf "[!] Initiating Installation for Reverse Engineering Tools"
    
    #Install some common tools that you might need
    echo $passwd | sudo -S apt install -y ghex radare2 radare2-cutter
    pip3 install pwntools

    # Ghidra
        # Website https://ghidra-sre.org/
        cd ~/Documents/Tools/
        wget https://ghidra-sre.org/ghidra_9.2_PUBLIC_20201113.zip
        unzip ghidra_9.2_PUBLIC_20201113.zip
        rm ghidra_9.2_PUBLIC_20201113.zip
        mv ghidra_9.2_PUBLIC ghidra_9
        
        ## Add GHidra to PATH
        echo $passwd | sudo -S echo "export PATH=$PATH:/home/$whoAreyou/Documents/Tools/ghidra_9" >> ~/.bashrc
        echo $passwd | sudo -S echo "export PATH=$PATH:/home/$whoAreyou/Documents/Tools/ghidra_9" >> ~/.zshrc
    
    theApts # Check if the new installed packages need upgrading 
    printf "\n[+] Reverse Engineering function has completed its installation\n[!] Starting Pen Test installation..\n"
}



pentest(){

    # Evil-WinRM
        # Official Repo https://github.com/Hackplayers/evil-winrm
        echo $passwd | sudo -S apt install ruby ruby-dev # In case you don't have ruby Installed
        echo $passwd | sudo -S gem install evil-winrm

    # CrackMapExec
        # Official Repo https://github.com/byt3bl33d3r/CrackMapExec
        pip3 install pipx
        pipx ensurepath
        pipx install crackmapexec
        echo $passwd | sudo -S cp ~/.local/bin/pipx /usr/bin

    # Impacket
        # Official Repo https://github.com/SecureAuthCorp/impacket
        cd ~/Documents/githubTools/
        git clone https://github.com/SecureAuthCorp/impacket.git
        cd impacket/
        pip3 install .
    
    # PayloadsAllTheThings
        # Official repo https://github.com/swisskyrepo/PayloadsAllTheThings
        cd ~/Documents/githubTools/
        git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
    
    # Web Brute Forcers
        echo $passwd | sudo -S apt install -y dirbuster wfuzz gobuster masscan
    
    # Must have 
        echo $passwd | sudo -S apt install -y nmap metasploit-framework netcat openjdk-11-jdk burpsuite
            ## Suggested libs from nmap installation
            echo $passwd | sudo -S apt install -y liblinear-tools liblinear-dev clamav clamav-daemon ndiff libjson-perl isag
    
    # BloodHound
        ## Neo4j
            printf "deb http://httpredir.debian.org/debian stretch-backports main" | sudo tee -a /etc/apt/sources.list.d/stretch-backports.list
            echo $passwd | sudo -S apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010 04EE7237B7D453EC
            echo $passwd | sudo -S apt update
            echo $passwd | sudo -S apt install -y neo4j
            wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
            echo $passwd | sudo -S echo 'deb https://debian.neo4j.com stable 4.0' > /etc/apt/sources.list.d/neo4j.list
            echo $passwd | sudo -S apt-get update
        
        ## Bloodhound
            ### Also includes sharphound
            cd ~/Documents/Tools/
            wget https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.1/BloodHound-linux-arm64.zip
            unzip BloodHound-linux-arm64.zip
            rm BloodHound-linux-arm64.zip
            mv BloodHound-linux-arm64 bloodhound

    # Password Cracking
        ## Hashcat and John
            echo $passwd | sudo -S apt install -y hashcat john
    
    # Priv Escallation
        # winPEAS/linPEAS
            cd ~/Documents/githubTools/
            mkdir thePEAS && cd thePEAS/
            wget https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/binaries/Obfuscated%20Releases/winPEASx64.exe
            wget https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/blob/master/linPEAS/linpeas.sh

    printf "\n[+] Pen Test function has completed its installation\n"
}


clear
printf "Thank you for installing PurpleKeep for setting up your Cybersecurity linux machine!\n"
printf "In case you experience any problems or want to help me improve my work don't hesitate contacting me through github :)\n"
printf "No need to run the script as a sudoer because the tools will only be available for the root user, so if you runned the script with sudo and want to use the tools as a normal user please exit (Ctrl+C)\nRun the program again by..\n>PurpleKeep.sh\n"


printf "\nPlease note that the script dispite displaying what is happening will also save all the logs in a new directory on your Desktop..\n"
printf "Press any key to begin the installation\n"
read waitForLaunch # Allow the user some time to read the prompt messages until he presses any button to proceed

clear
echo "                                               "
echo "   ___                __      __ __            "
echo "  / _ \__ _________  / /__   / //_/__ ___ ___  "
echo " / ___/ // / __/ _ \/ / -_) / ,< / -_) -_) _ \ "
echo "/_/   \_,_/_/ / .__/_/\__/ /_/|_|\__/\__/ .__/ "
echo "             /_/                       /_/     "
echo "                                               "

main # Call main function when user presses any button to begin the installation