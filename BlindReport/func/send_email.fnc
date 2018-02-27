#!/bin/sh
#Function Send Mail

source ../cfg/BlindReport.cfg
source ../func/logger.fnc


SendMail(){

		for x in `ls -1 ${vDirOut}/*.csv`; do
		
			if [[ -s $x ]]; then

			Log_info "Arquivo $x tem conteudo, sera enviado por email"

			else

			Log_info "Arquivo $x nao tem conteudo, sera removido"
			cd ${vDirOut}
			rm $x
			
			fi

		done

		contador=`ls -ltr ${vDirOut}/* | grep -v total | wc -l`

                if [[ ${contador} -ne 0 ]]; then


                        Log_info "Inicio da funcao de envio de Email"
                        Log_info "Coletando dados, gentileza aguardar"
                        sleep 2
	
${vDirFunc}/.sendEmail -f <mail>@<domain>.com.br -xu <mail>@<domain>.com.br -xp $PassEmail -t <mail>@<domain>.com.br  -u "Relatorio de Blindagem" -o message-file=${MailFile} -a ${vDirOut}/* -s <ServiceMail> > ${vDirCfg}/AuxMailFile.out



                ValidMail=`cat ${vDirCfg}/AuxMailFile.out | grep "Email was sent successfully" | tr -d "!" | awk '{ print $9 }'`

		                        if [[ ${ValidMail} = "successfully" ]]; then

        			                	Log_info "Email enviado com sucesso"
                        				Log_info "Fim da funcao de Email"

                        		else	

                        				Log_info "Falha ao enviar Email, gentileza verificar"
					fi
                else

                        Log_info "Arquivos de coleta nao existem, gentileza analisar"
			Log_info "Fim da funcao de Email"
                        exit 0;

                fi

}

