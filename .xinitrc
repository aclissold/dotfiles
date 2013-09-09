xset r rate 200 60
xrandr --output LVDS-1 --mode 1440x900 --left-of VGA-1 --output VGA-1 --mode 1280x1024
pkill ssh-agent
eval $(ssh-agent)
ssh-add ~/.ssh/github &> /dev/null
exec awesome
