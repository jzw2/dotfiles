if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr -a todo habitipy todos add 
abbr -a org hx ~/org


function today
    set today (date "+%Y-%m-%d")
    set baseDir /home/john/org/roam/daily
    cd /home/john/org/
    if test -e "$baseDir/$today.org"
        hx "$baseDir/$today.org"
    else
        echo "Creating file for today: $today.org"
        touch "$baseDir/$today.org"
        echo -e "#+TITLE: $today\n\n* Journal\n\n* Tasks" > "$baseDir/$today.org"
        hx "$baseDir/$today.org"
    end
    # Remove old 'today' link if it exists and create a new soft link to the current 'today' file
    rm -f "$baseDir/today"
    ln -s "$baseDir/$today.org" "$baseDir/today"
end
