#!/bin/bash
#Author:Natalie Niemeir
#Simple script to encrypt passwords with SHA1/SHA256, then attempt to crack the hashes
#Not recommended for a persistent install
echo "Extracting RockYou Sample Wordlist"
sudo gunzip /usr/share/wordlists/rockyou.txt.gz &>/dev/null
echo "Enter the password you would like to test"
echo "_________________________________________"
read -r -s unhashed
echo "Encrypting..."
echo "_________________________________________"
PS3='Which encryption algorithm would you like to use?'
algorithms=("SHA1" "SHA256")
select enchoice in "${algorithms[@]}"; do
    case $enchoice in
        "SHA1")
            echo -n $unhashed | sha1sum > temp.txt
            head -c 40 temp.txt > password.txt
            echo "Attempting to crack hash with John The Ripper"
            john --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-SHA1 password.txt &>/dev/null
            john --show --format=Raw-SHA1 password.txt 
	    ;;
        "SHA256")
            
            echo -n $unhashed | sha256sum > temp.txt
            head -c 64 temp.txt > password.txt
            john --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-SHA256 password.txt &>/dev/null
            john --show --format=Raw-SHA256 password.txt 
	    break
            ;;
        *) echo "Invalid choice"
        ;;
    esac
done
echo "Cleaning Up"
shred password.txt temp.txt
rm -rf password.txt temp.txt
echo "FINISHED!"
