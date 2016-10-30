#
# ORIGINAL GIST: https://gist.github.com/thecompyoda/88ccf2fbd48a33f2fcd7ce7e6993b824 + https://gist.github.com/natelandau/10654137
# MODIFIED: 30/10/16 - LR
#

#   ---------------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   ---------------------------------------

#{{{
#   Prompt
#   ------------------------------------------------------------
    export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

#   Set Paths
#   ------------------------------------------------------------

#   --------------------------------------------------------------------
#   Set the path using an array, and a loop that checks to see if array alements already exist in current PATH
#   Added by: thecompyoda <Donnie Bartley>
#   On: August 20, 2016
#   --------------------------------------------------------------------

    ### DO NOT EDIT THIS PATH! ###
    export PATH=$PATH            #
    ##############################
   
    # ADD NEW PATH VARS TO THIS ARRAY
    pathsarray=(
        '/usr/local/bin'
        '/usr/local'
        '/opt/local/bin'
        '/usr/bin'
        '/bin',
        '$HOME/.jenv/bin'
    )

    for i in "${pathsarray[@]}"
    do
        if [[ $PATH != *$i:* ]]; then
            export PATH=$PATH:$i
        fi
    done

#   Set Default Editor (change 'Vim' to the editor of your choice)
#   ------------------------------------------------------------
    export EDITOR=/usr/bin/vim

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------

    export BLOCKSIZE=1k

## COLORS
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

#   Control History
#   ----------------------------------------------
    export HISTCONTROL=ignoreboth:erasedups
    export HISTSIZE=5000
    export HISTFILESIZE=5000
#}}}

#   ---------------------------------------
#   2.  MAKE TERMINAL BETTER
#   ---------------------------------------

#{{{
#   Misc Aliases
#   -------------------------------------------------------------------------
    alias editvim='vi ~/.vimrc'			        # editvim: opens .vimrc for editing
    alias cp='cp -iv'                           # Preferred 'cp' implementation
    alias mv='mv -iv'                           # Preferred 'mv' implementation
    alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
    alias ls='ls -aFGlAhp'                      # Preferred 'ls' implementation
    alias ll='ls'				                # Simply points back to the preferred 'ls'
    alias dir='ls -aFGlAhp'			            # Crazy old DOS habbit that has follwed me for life
    alias less='less -FSRXc'                    # Preferred 'less' implementation
    alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
    alias ..='cd ../'                           # Go back 1 directory level
    alias .2='cd ../../'                        # Go back 2 directory levels
    alias .3='cd ../../../'                     # Go back 3 directory levels
    alias .4='cd ../../../../'                  # Go back 4 directory levels
    alias .5='cd ../../../../../'               # Go back 5 directory levels
    alias .6='cd ../../../../../../'            # Go back 6 directory levels
    alias edit='subl'                           # edit:         Opens any file in sublime editor
    alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
    alias ~="cd ~"                              # ~:            Go Home
    alias c='clear'                             # c:            Clear terminal display
    alias which='type -all'                     # which:        Find executables
    alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
    alias show_options='shopt'                  # Show_options: display bash options settings
    alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
    alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
    #alias rm='trash'				            # rm:		forcing rm to use trash function
    alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

#   Git Aliases
#   ----------------------------------------------
    alias gs='git status'
    alias gc='git commit'
    alias gca='git commit .'
    alias gcam='git commit -am'
    alias gco='git checkout'
    alias gcod='git checkout origin development'
    alias gpod='git pull origin development'
    alias daje='gcod && gpod'
    alias gp='git pull'
    alias gpom="git pull origin master"
    alias gp='git push'
    alias gd='git diff | mate'
    alias gb='git branch'
    alias gba='git branch -a'
    alias del='git branch -d'    

#   Functions
#   ----------------------------------------------
    mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
    ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
    cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
#   trash:  Moves a file to the MacOS trash, then runs "ls" to save me time wasted by my own habbit
    trash () {
        command mv "$@" ~/.Trash
        until ! [test -f "$@"]; do
            pause 1
        done
        ls
    }

#   lr:  Full Recursive Directory Listing
    alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#    mans: e.g. mans mplayer codec
#   --------------------------------------------------------------------
#       Note:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#               displays paginated result with colored search terms and two lines surrounding each hit.
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   showa: to remind yourself of an alias (given some part of it)
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }
#}}}

#   ---------------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   ---------------------------------------

#{{{
    zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
    alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir

#   cdf:  'Cd's to frontmost window of MacOS Finder
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
        EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   extract:  Extract most know archives with one command
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7za x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }
#}}}

#   ---------------------------------------
#   4.  SEARCHING
#   ---------------------------------------

#{{{
    alias qfind="find . -name "                 # qfind:    Quickly search for file
    ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
    ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
    ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }
#}}}

#   ---------------------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------------------

#{{{
#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop Find memory hogs with top
    alias memHogsTop='top -l 1 -o rsize | head -20'

#   memHogsPS: Find memory hogs with ps
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ---------------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ---------------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }
#}}}

#   ---------------------------------------
#   6.  NETWORKING
#   ---------------------------------------

#{{{
#   myip: Public Facing IP Address
    alias myip='dig + short myip.opendns.com @resolver1.opendns.com'

#   flushDNS: Flush the DNS Cache 
    alias flushDNS='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

    alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
    alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
    alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
    alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
    alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
    alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
    alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
    alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ; # myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }
#}}}

#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

#{{{
#   cleanupDS:  Recursively delete .DS_Store files
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
    alias finderShowHidden='defaults write com.apple.finder AppleShowAllFiles YES'

#   finderHideHidden:   Hide hidden files in Finder
    alias finderHideHidden='defaults write com.apple.finder AppleShowAllFiles NO'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#   screensaverDesktop: Run a screensaver on the Desktop
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'
#}}}

#   ---------------------------------------
#   8.  BASH PROFILE EDIT & SOURCE
#   ---------------------------------------

#{{{
#   --------------------------------------------------------------------
#   Bash editing, and automated re-sourcing
#   Added by: thecompyoda <Donnie Bartley>
#   On: August 20, 2016
#   --------------------------------------------------------------------

#   ebash_profile: opens .bash_profile for editing
#   --------------------------------------------------------------------
#       Note: This function requires the 'sourcebashwait' funtion to keep errors from displaying on
#             the terminal while you are editing the file, and to make sure this file is sourced
#             only AFTER the vi editor is closed.  The terminal also clears after vi is closed
#   --------------------------------------------------------------------
    ebash_profile () {
        vi ~/.bash_profile
        sourcebashwait >/dev/null 2>&1
        source ~/.bash_profile
        c
    }

#   ebash_profile requires the sourcebashwait function!
    sourcebashwait () {
        until ! [ test -f ~/.bash_profile.swp ]; do
            sleep 5
        done
    }

#   editbash: calls the ebash_profile function to edit .bash_profile
#   --------------------------------------------------------------------
#       Note:  calling 'ebash_profile' from command line without using this alias
#              may cause 'command not found' errors to diaplay after closing the vi editor
#   --------------------------------------------------------------------
    alias editbash='ebash_profile'
#}}}

#   ---------------------------------------
#   9.  NOTES & TO-DO
#   ---------------------------------------

#{{{
#   Git branch on terminal: https://github.com/jimeh/git-aware-prompt
#   Git autocomplete commands: http://code-worrier.com/blog/autocomplete-git/
#   Add SSH Connection Aliases
#   Set up BFG Repo (https://rtyley.github.io/bfg-repo-cleaner/) for obfuscating text during git commits
#   Create an alias search command that searches a file, and displays matching alias(es) w/notes
#}}}

## init jenv
eval "$(jenv init -)"

# vim:foldenable:foldlevel=0:foldmethod=marker:foldnestmax=10
