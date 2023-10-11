abbr -a -- config '/usr/bin/git --git-dir=/Users/joseph/.dotfiles --work-tree=/Users/joseph'
abbr -a flush_dns 'sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
abbr -a c highlight -Otruecolor
abbr -a meteo curl wttr.in/hondelange
abbr -a cpv rsync -ah --info=progress2
if test (which exa)
    abbr -a ls exa
    abbr -a l exa -lgh
    abbr -a la exa -lgha
    abbr -a lt exa -lTgha
else
    abbr -a ls ls -Fh --color
    abbr -a l ls -Fh --color -l
end
