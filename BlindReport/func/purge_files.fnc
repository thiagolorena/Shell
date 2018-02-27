#!/bin/sh

source ../cfg/BlindReport.cfg
source ../func/logger.fnc

PurgeFiles(){

	Log_init "Iniciando a funcao de limpeza dos arquivos temporarios"
	sleep 2

	cd ${vDirOut}
	
		for x in `ls -1 *.csv`; do 

			if [[ -n ${x} ]]; then

			Log_info "Arquivo ${x} identificado, sera removido"
			rm ${x}
			
			if [[ $? -eq 0 ]]; then

				Log_info "Arquivo ${x} removido com sucesso"

			else

				Log_warn "Falha na remocao do arquivo ${x}"
				Log_finish "Devido falha na remocao do arquivo o script sera encerrado, gentileza verificar"
				exit 1;

			fi
			
			Log_info "Nao existem arquivos a serem removidos"

			fi

		done

}
