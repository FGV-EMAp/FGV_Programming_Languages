# In order to create aliases, we usually place them in ~/.bashrc file, 
# However, a good practice is to keep system files separate from personal use case. 
# For that reason, we will create a new file called ~/.custom_aliases and place all aliases in there. 
# Keep in mind that whenever you add a new alias, run source ~/.custom_aliases otherwise the aliases will not work.

# Step 1 — Create a custom_aliases file
touch ~/.custom_aliases

# Step 2 — Open custom_aliases file
gedit ~/.custom_aliases

#Step 3— Create shortcuts (aliases)
# Let’s create a simple alias that will print “Welcome John Doe.” when we type welcome in bash terminal.
alias welcome='echo "Welcome $USER."'

#Step 4— Update changes
# Before you can run the newly created bash command, you must update custom_aliases file.
source ~/.custom_aliases

#Step 5— Execute new bash command
# command line 
welcome
#> Welcome John Doe.

#Common alias

# Version Control
alias gs="git status"
alias gd="git add ."
alias gp="git push -u origin master"

# Directory
alias diskusage="df -h"
alias folderusage="du -ch"
alias totalfolderusage="du -sh"

# Various
alias opencustomaliases="code  ~/.custom_aliases"
alias updatecustomaliases="source ~/.custom_aliases"
alias updatethenupgrade="sudo apt-get update && sudo apt-get upgrade"

# Keep in mind that some OS (operating system) may differ, 
# make sure you run these commands in terminal and check if it works before placing them in the custom_aliases file.


#Running multiple commands

#Example 1 — Create function

function lazyman() {
    git add .
    git commit -a -m "$1"
    git push -u origin master
}

# Example 2 — Create alias

# alias lazyman="git add . && git commit -a -m '$i' && git push -u origin master"

# Remember to update the custom_aliases file by running source ~/.custom_aliases, and then type lazyman "First commit".