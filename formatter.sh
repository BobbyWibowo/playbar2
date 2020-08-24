#!/bin/bash

astyle --options='.astylerc' `find engine/ -name '*.cpp' -o -name '*.h'`
find . \( -name '*.orig' -o -name '.directory' -o -name '*~' -o -name '*.user' -o -name '*.autosave' \) -exec rm -v {} +
plasmapkg2 --remove audoban.applet.playbar
