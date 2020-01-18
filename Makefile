SHELL:=/bin/bash
PATH:=./bin:$(PATH)

SUB_DIR:=sub
RES_DIR:=res
ARCH_FILE:=subs.zip

JPLAG_SAVE_SIM:=20
JPLAG_LOG_OUT:=${RES_DIR}/log.out

LANGUAGE:=c/c++
MOSS_ID:=123456789
MOSS_FILES_POSTFIX:=asm

all: jplag

jplag: resDir extract fixFiles
	java -jar jplag.jar -l ${LANGUAGE} -m ${JPLAG_SAVE_SIM}% -r ${RES_DIR} -s ${SUB_DIR} -o ${JPLAG_LOG_OUT}

moss: prepare
	moss_run ${MOSS_ID} "${SUB_DIR}" ${LANGUAGE} ${MOSS_FILES_POSTFIX} "${RES_DIR}"

resDir:
	mkdir -p ${RES_DIR}

extract:
	find ${SUB_DIR} -type f -iname '*.zip' -o -iname '*.rar' | while read e; do \
		7z x -y "$${e}" -o"$$(dirname "$${e}")"; \
	done

prepare: ${ARCH_FILE}
	prepare -s ${SUB_DIR} -r ${RES_DIR} ${ARCH_FILE}

fixFiles:
	find ${SUB_DIR} -type f -iname '*.cpp' -o -iname '*.hpp' | while read d; do \
		dos2unix "$${d}"; \
		LC_ALL=C sed -i 's/[^[:blank:][:print:]]//g' "$${d}"; \
	done

