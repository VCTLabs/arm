#!/bin/bash
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/cpufrequtils/files/Attic/cpufrequtils-change.sh,v 1.4 2015/02/03 14:51:49 pacho dead $

ret=0 opts= gov_opts= sep=
for o in "${@}" ; do
	[ "${o}" = "--" ] && sep=1 && continue
	if [ -n "${sep}" ]; then
		gov_opts="${gov_opts} ${o}"
	else
		opts="${opts} ${o}"
	fi
done

echo "cpufreq-set options: ${opts}"
echo "Governor options: ${gov_opts}"

for c in $(cpufreq-info -o | awk '$1 == "CPU" { print $2 }') ; do
	cpufreq-set -c ${c} ${opts}
	: $(( ret += $? ))
done

if [ $# -gt 0 ] ; then
	c=1
	if cd /sys/devices/system/cpu/cpufreq ; then
		for o in ${gov_opts}; do
			v=${o#*=}
			o=${o%%=*}
			echo ${v} > ${o} || break
		done
		c=0
	fi
	: $(( ret += c ))
fi

exit ${ret}
