#!/usr/bin/ksh
# (c) 2012 s@ctrlc.hu

#  This is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.

# creates a skeleton for daemontools/runit
# copies the ./run from stdin or uses the files in $1 for bootstrapping the service

basedir=/etc/sv/"${1##*/}"

mkdir -p "$basedir"
[[ -d "$1" ]] && cp -r "$1"/* "$basedir"

[[ ! -r "$basedir"/run ]] && {
    cat >"$basedir"/run <<EOF
#!/bin/sh
exec >/dev/null
exec 2>&1
EOF
    echo -n "exec " >>"$basedir"/run
    cat >>"$basedir"/run
}
chmod +x "$basedir"/run
mkdir -p /var/lib/supervise/"$1" || exit 1
ln -s /var/lib/supervise/"$1" "$basedir"/supervise

# logger
mkdir -p "$basedir"/log
[[ ! -r "$basedir"/log/run ]] && cat >"$basedir"/log/run <<EOF
#!/bin/sh
exec >/dev/null
exec 2>&1
exec chpst -unobody logger -d -p daemon.err -t $1
EOF
chmod +x "$basedir"/log/run
mkdir -p /var/lib/supervise/"$1".log || exit 1
ln -s /var/lib/supervise/"$1".log "$basedir"/log/supervise
