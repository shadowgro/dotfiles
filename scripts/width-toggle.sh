#!/usr/bin/env bash

LOCKFILE="/tmp/noctalia-mango-toggle.lock"

exec 9>"$LOCKFILE"
flock -n 9 || exit 0

NOCTALIA="$HOME/.dotfiles/noctalia/settings.toml"
MANGO="$HOME/.dotfiles/mango/config.conf"

if grep -qE '^ *border_width *= *0(\.0)?$' "$NOCTALIA"; then

    # обычный режим

    sed -i \
        -e 's/^    border_width = 0$/    border_width = 2.0/' \
        -e 's/^    margin_ends = 0$/    margin_ends = 20/' \
        -e 's/^    radius_bottom_left = 0$/    radius_bottom_left = 12/' \
        -e 's/^    radius_bottom_right = 0$/    radius_bottom_right = 12/' \
        -e 's/^    background_radius = 0.0$/        background_radius = 12.0/' \
        -e 's/^    concave_edge_corners = true$/    concave_edge_corners = false/' \
        "$NOCTALIA"

    sed -i \
        -e 's/^no_border_when_single=1$/no_border_when_single=0/' \
        -e 's/^scroller_structs=0$/scroller_structs=20/' \
        -e 's/^smartgaps=1$/smartgaps=0/' \
        "$MANGO"

else

    # компактный режим

    sed -i \
        -e 's/^    border_width = 2.0$/    border_width = 0/' \
        -e 's/^    margin_ends = 20$/    margin_ends = 0/' \
        -e 's/^    radius_bottom_left = 12$/    radius_bottom_left = 0/' \
        -e 's/^    radius_bottom_right = 12$/    radius_bottom_right = 0/' \
        -e 's/^    background_radius = 12.0$/        background_radius = 0.0/' \
        -e 's/^    concave_edge_corners = false$/    concave_edge_corners = true/' \
        "$NOCTALIA"

    sed -i \
        -e 's/^no_border_when_single=0$/no_border_when_single=1/' \
        -e 's/^scroller_structs=20$/scroller_structs=0/' \
        -e 's/^smartgaps=0$/smartgaps=1/' \
        "$MANGO"

fi

        # -e 's/^    radius = 0$/    radius = 12/' \ #
        # -e 's/^    radius = 12$/    radius = 0/' \ #
# mmsg dispatch togglemaximizescreen
# mmsg dispatch togglefakefullscreen
# mmsg dispatch togglegaps
mmsg dispatch reload_config
noctalia msg config-reload
