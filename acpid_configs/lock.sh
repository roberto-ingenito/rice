#!/bin/bash

# Lancia i3lock-color con configurazioni personalizzate
i3lock \
    --color="00000044" \
    --radius=200 \
    --ring-width=10 \
    \
    --time-color=ffffff \
    --time-pos="w/2:h/2-10" \
    --time-size=64 \
    --time-str="%H:%M" \
    \
    --date-color=ffffff \
    --date-pos="w/2:h/2+50" \
    --date-size=32 \
    --date-str="%d %B %Y" \
    \
    --inside-color="ffffff22" \
    --ring-color="ffffff88" \
    --line-color="00000000" \
    --clock \
    --indicator \
    \
    --verif-text="Verifying..." \
    --verif-color="ffffff" \
    --insidever-color="ffffff22" \
    --verif-pos="w/2:h/2+10" \
    \
    --wrong-text="Wrong password" \
    --wrong-pos="w/2:h/2+10" \
    --wrong-color="ffffff" \
    --insidewrong-color="ffffff22" \
    --ringwrong-color="aa0000" \
    \
    --greeter-text="Type password" \
    --greeter-size=24 \
    --greeter-pos="w/2:h/2+250" \
    --greeter-color="a0a0a0" \
    \
    --noinput="No input" \
    \
    --keyhl-color="0000aa" \
    --bshl-color="aa0000" \
    --separator-color="00000000" \
