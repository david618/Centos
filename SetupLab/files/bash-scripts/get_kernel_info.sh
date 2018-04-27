#!/bin/bash

PKG_TYPE=kernel
PKGS=$(rpm -qa | grep $PKG_TYPE)

for PKG in ${PKGS}; do
	#echo ${PKG}
	INSTALLED_EPOCH=$(rpm -q --qf "%{INSTALLTIME}\n" ${PKG})
        INSTALLED_DT=$(date -d @${INSTALLED_EPOCH})
	echo "${PKG} was installed on ${INSTALLED_DT}"
done

echo "or"

for PKG in ${PKGS}; do
	echo "${PKG} was installed on $(rpm -q --qf "%{INSTALLTIME:date}\n" ${PKG})" 
done

