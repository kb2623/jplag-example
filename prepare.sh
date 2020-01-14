#!/bin/bash

if [ $# -lt 1 ]; then
	echo -e "USAGE:\n"
	echo -e "\tprepare.sh [SUBMISSIONS_FOLDER]"
	exit 1
fi

SUBMISSIONS_FOLDER=$1

# Funcs --------------------------------------------------------------------------

# move - move file from subdirectoriys
# Usage: move [SRC_DIR] [DST_DIR]
move() {
	if [ $# -lt 2 ]; then exit 1; fi
	local SRC_DIR=$1
	local DST_DIR=$2
	local fm
	# First extract archives if some
	for fm in "${SRC_DIR}"/*; do
		if 7z t "${fm}"; then 
			7z x -y "${fm}" -o"${SRC_DIR}"
			rm "${fm}"
		fi
	done
	# Move file from subdir to dir
	for fm in "${SRC_DIR}"/*; do
		if [ -d "${fm}" ]; then
			move "${fm}" "${DST_DIR}"
			rm -r "${fm}"
		elif [ "${SRC_DIR}" != "${DST_DIR}" ]; then
			echo convert ${fm}
			dos2unix ${fm}
			mv "${fm}" "${DST_DIR}"
		fi
	done
}

# Main ---------------------------------------------------------------------------

for f in "${SUBMISSIONS_FOLDER}"/*; do
	if [ -d "${f}" ]; then
		move "${f}" "${f}"
		for ff in "${f}"/*; do
			if [ -f "${ff}" ]; then
				mv "${ff}" "${sub_dir}/${f##*/}_${ff##*/}"
			fi
		done
	fi
done

exit 0
