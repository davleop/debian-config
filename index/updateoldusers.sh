#!/bin/bash
pushd /etc/skel
if [ "$1" = "overwrite" ]; then
  getent passwd |
    while IFS=: read username x uid guid gecos home shell
    do
      [[ "$username" == root || ! -d $home ]] && continue
      tar -cf - -C /etc/skel . | sudo -Hu "$username" tar --overwrite -xf -
    done
else
  getent passwd |
    while IFS=: read username x uid guid gecos home shell
    do
      [[ "$username" == root || ! -d $home ]] && continue
      tar -cf - -C /etc/skel . | sudo -Hu "$username" tar --skip-old-files -xf -
    done
fi
