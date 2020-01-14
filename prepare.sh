#!/bin/bash

if [ $# -lt 3 ]; then
	echo -e "USAGE:\n"
	echo -e "\tprepare.sh [SUBMISSIONS_FOLDER]"
	exit 1
fi

SUBMISSIONS_FOLDER=$1
REPORSTS_FOLDER=$2
ARCHIVE_FILE=$3

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
		fi
	done
	# Move file from subdir to dir
	for fm in "${SRC_DIR}"/*; do
		if [ -d "${fm}" ]; then
			move "${fm}" "${DST_DIR}"
			rm -r "${fm}"
		elif [ "${SRC_DIR}" != "${DST_DIR}" ]; then
			mv "${fm}" "${DST_DIR}"
		fi
	done
}

# Main ---------------------------------------------------------------------------

rep_dir="${REPORSTS_FOLDER}/"$(basename ${ARCHIVE_FILE})
mkdir -p "${rep_dir}"

sub_dir="${SUBMISSIONS_FOLDER}/"$(basename ${ARCHIVE_FILE})
mkdir -p "${sub_dir}"
cp "${ARCHIVE_FILE}" "${sub_dir}"
7z x -y "${ARCHIVE_FILE}" -o"${sub_dir}"
rm "${ARCHIVE_FILE}"

for f in "${sub_dir}"/*; do
	if [ -d "${f}" ]; then
		move "${f}" "${f}"
		for ff in "${f}"/*; do
			if [ -f "${ff}" ]; then
				mv "${ff}" "${sub_dir}/${f##*/}_${ff##*/}"
			fi
		done
		rm -r "${f}"
	fi
done

exit 0
