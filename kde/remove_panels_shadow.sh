for win in $(xdotool search --class "plasmashell"); do
	xprop -id $win -remove _KDE_NET_WM_SHADOW
done
