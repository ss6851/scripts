arg="1920 1080 60"

modename=$(echo $arg | sed 's/\s/_/g')
display=$(xrandr | grep -Po '.+(?=\sconnected)')
if [[ "$(xrandr|grep $modename)" = "" ]];
	then
		xrandr --newmode $modename $(gtf $(echo $arg) | grep -oP '(?<="\s\s).+') &&
		xrandr --addmode $display $modename     
fi
