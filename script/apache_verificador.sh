#!/bin/bash

NFS_DIR="/mnt/luiz"

DATA_HORA=$(date +"%Y-%m-%d %H:%M:%S")

systemctl is-active --quiet httpd

CODIGO_SAIDA=$?

ARQUIVO_ONLINE="${NFS_DIR}/${DATA_HORA}_Online_${SERVICO}.txt"

ARQUIVO_OFFLINE="${NFS_DIR}/${DATA_HORA}_Offline_${SERVICO}.txt"

if [ $CODIGO_SAIDA -eq 0 ]; then
    echo "Status do serviço apache em ${DATA_HORA}: ONLINE" > "${ARQUIVO_ONLINE}"
    echo "Apache está rodando. Arquivo ONLINE gerado em: ${ARQUIVO_ONLINE}"
else
    echo "Status do serviço apache em ${DATA_HORA}: OFFLINE" > "${ARQUIVO_OFFLINE}"
    echo "Apache não está rodando. Arquivo OFFLINE gerado em: ${ARQUIVO_OFFLINE}"
fi

