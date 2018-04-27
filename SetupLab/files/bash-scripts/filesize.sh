#!/bin/bash

DIR=/tmp
for FILE in $DIR/*; do
	echo "File ${FILE} is $(stat --print='%s' ${FILE}) bytes"
done
