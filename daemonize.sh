#!/usr/bin/ksh
# (c) 2012 s@ctrlc.hu, GPLv3+
# creates a skeleton for daemontools/runit
# copies the ./run from stdin

basedir=/etc/sv/"$1"

mkdir -p "$basedir"
mkdir -p /var/lib/supervise/"$1" && ln -s /var/lib/supervise/"$1" "$basedir"/supervise
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

mkdir -p "$basedir"/log
mkdir -p /var/lib/supervise/"$1".log && ln -s /var/lib/supervise/"$1" "$basedir"/log/supervise
[[ ! -r "$basedir"/log/run ]] && cat >"$basedir"/log/run <<EOF
#!/bin/sh
exec >/dev/null
exec 2>&1
exec chpst -unobody logger -d -p daemon.err -t $1
EOF
chmod +x "$basedir"/log/run
