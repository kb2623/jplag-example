SHELL=/bin/bash

SUB_DIR:=sub
RES_DIR:=res
SAVE_SIM:=20
LOG_OUT:=${RES_DIR}/log.out
LANGUAGE:=c/c++
ARCH_FILE:=subs.zip

all: resDir extract fixFiles
	java -jar jplag.jar -l ${LANGUAGE} -m ${SAVE_SIM}% -r ${RES_DIR} -s ${SUB_DIR} -o ${LOG_OUT}

resDir:
	mkdir -p ${RES_DIR}

extract:
	find ${SUB_DIR} -type f -iname '*.zip' -o -iname '*.rar' | while read e; do \
		7z x -y "$${e}" -o"$$(dirname "$${e}")"; \
	done

prepare:
	./prepare.sh ${SUB_DIR} ${RES_DIR} ${ARCH_FILE}

fixFiles:
	find ${SUB_DIR} -type f -iname '*.cpp' -o -iname '*.hpp' | while read d; do \
		dos2unix "$${d}"; \
		LC_ALL=C sed -i 's/[^[:blank:][:print:]]//g' "$${d}"; \
	done

