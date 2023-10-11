# OSx specific functions and variables

if test (uname -s) = Darwin
    function update -d "update brew, fish, fisher and mac app store"
        echo 'start updating ...'

        echo 'updating homebrew'
        brew update
        brew upgrade
        brew cleanup

        echo 'updating fish shell'
        fisher update
        fish_update_completions

        echo 'updating apple store apps'
        echo 'checking Apple Updates'
        /usr/sbin/softwareupdate -ia

        exit 0
    end

    function pman -d "output man page in preview"
        man -t $argv[1] | ps2pdf - - | open -fa Preview
    end

    function vpn -d "open a Fortinet ssl tunnel"
        echo "search ana.lu airportlu.local" | sudo tee /etc/resolver/ana
        echo "domain airportlu.local" | sudo tee -a /etc/resolver/ana
        sudo openfortivpn -c ~/.config/openfortivpn/config
        sudo rm /etc/resolver/ana
    end
end
