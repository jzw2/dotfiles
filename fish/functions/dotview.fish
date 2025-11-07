function dotview
set name $argv[1]
dot images/$name.dot -Tpng -o $name.png && open $name.png
end
