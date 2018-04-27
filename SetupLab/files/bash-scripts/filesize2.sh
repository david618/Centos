#!/bin/bash

SEARCH_FOLDER=/usr

for f in ${SEARCH_FOLDER}/*; do
	if [ -d "${f}" ]; then
		echo "Processing Folder ${f}"
		if [ -z "$(ls -A ${f})" ]; then 
			echo "  Empty Directory"
		else
			for ff in ${f}/*; do
				echo "  File ${ff} is $(stat --print='%s' ${ff}) bytes"
				#echo "  ${ff}"
			done
		fi
	else
		echo "File ${f} is $(stat --print='%s' ${f}) bytes"
		#echo "${f}"
	fi

done
