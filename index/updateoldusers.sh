#!/bin/bash
getent passwd |
  while IFS=: read username x uid guid gecos home shell
  do
    [[ "$username" == root || ! -d $home ]] && continue
    tar -cf - -C /etc/skel . | sudo -Hu "$username" tar --skip-old-files -xf -
  done

# overwrite old files past in args
for user in "$@"
do
  [[ ! -d $home ]] && continue
  tar -cf - -C /etc/skel . | sudo -Hu "$user" tar --overwrite -xf -
done
