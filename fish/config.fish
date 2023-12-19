if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr -a todo habitipy todos add 
abbr -a org hx ~/org


function today
    set today (date "+%Y-%m-%d")
    cd /home/john/org/
    if test -e "roam/daily/$today.org"
        hx "roam/daily/$today.org"
    else
        echo "Creating file for today: $today.org"
        touch "roam/daily/$today.org"
        echo -e "#+TITLE: $today\n\n* Journal\n\n* Tasks" > "roam/daily/$today.org"
        hx "roam/daily/$today.org"
    end
end
