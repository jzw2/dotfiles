if status is-interactive
    # Commands to run in interactive sessions can go here
end


function today
    set today (date "+%Y-%m-%d")
    cd /home/john/org/roam/daily
    if test -e "$today.org"
        hx "$today.org"
    else
        echo "Creating file for today: $today.org"
        touch "$today.org"
        hx "$today.org"
    end
end

