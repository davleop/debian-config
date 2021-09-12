#!/bin/bash

if [ "$1" = "overwrite" ]; then
	tar -cf - -C /etc/skel . | sudo -Hu root tar --overwrite -xf -
else
	tar -cf - -C /etc/skel . | sudo -Hu root tar --skip-old-files -xf -
fi
