SUB_DIR:=sub
RES_DIR:=res
SAVE_SIM:=20
LOG_OUT:=${RES_DIR}/log.out
BASE_DIR:=.
SHELL=/bin/bash

all: 
	-make resDir 
	-make extract 
	-make fixFiles
	java -jar jplag-2.12.1-SNAPSHOT-jar-with-dependencies.jar -l c/c++ -m ${SAVE_SIM}% -r ${RES_DIR} -s ${SUB_DIR} -o ${LOG_OUT}

resDir:
	mkdir -p ${RES_DIR}

extract:
	find ${BASE_DIR} -type f -iname '*.zip' -o -iname '*.rar' | while read e; do \
		7z x -y "${e}" -o"$(dirname "${e}")" && rm "${e}"; \
	done

fixFiles:
	find ${BASE_DIR} -type f -iname '*.cpp' -o -iname '*.hpp' | while read d; do \
		dos2unix "$${d}"; \
		LC_ALL=C sed -i 's/[^[:blank:][:print:]]//g' "$${d}"; \
	done

