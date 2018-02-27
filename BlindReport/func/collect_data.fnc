#!/bin/sh

source ../cfg/BlindReport.cfg
source ../func/logger.fnc

Collect(){

	Log_init "Inicio da funcao de coleta dos dados"
	Log_info "Carregando os arquivos de hosts, gentileza aguarde"

	if [[ -e ${vHostFile} ]]; then  #Valida se o arquivo de configuracao existe

		Log_info "Arquivo de configuracao carregado com sucesso, exibindo hosts"
		
		for x in `cat ${vHostFile}`; do  #Executa loop com os hosts encontrados no arquivo de configuracao
		Log_info "Base de dados a ser coletado: ${x}"
		done

			#Loop para query abaixo, fazendo a coleta dos dados na base de dados
			for y in `cat ${vHostFile}`; do

			#Validacao do Host inputado e executado.
			if [[ $y =~ "NGIN0[1-4]_BDA" || $y =~ "NGIN0[1-4]_BDB" || $y =~ "NGIN0[1-4]_BDRT" || $y =~ "NGIN0[1-4]_BDFIN" ]]; then		
	
			Log_info "Iniciando coleta nos hosts carregados"

			QUERY=`sqlplus -s system/manager@${y} << EOF

			SPOOL ${vDirOut}/${y}_Report.csv

			SET PAGES 500 
			SET LINES 500
			SET FEEDBACK OFF
			SELECT to_char(LOGIN_TIME,'DD/MM/YYYY HH24:MI:SS') as LOGIN_TIME,
			    USERNAME,
			    OSUSER,
			    MACHINE,
			    PROGRAM
			  FROM
			    (SELECT *
			    FROM adminprov2_10.ngin_user_login_audit
			    WHERE program NOT LIKE '%oracle@%'
			    AND program NOT LIKE '%sqlplus%'
			    AND program not like '%@sobral%'
			    AND program not like 'JDBC Thin Client%'
			    AND program not like '%sendin%'
			    AND program not like '%inbscp%'
			    AND program not like '%SDF%'
                AND program not like '%sqlldr%'
			    AND login_time BETWEEN sysdate-7 AND sysdate
			    ORDER BY osuser, login_time DESC
			    );

			EXIT;
			SPOOL OFF;
			EOF`
	
			fi		

		        #Validacao do Host inputado e executado.
			if [[ $y =~ "NGIN0[1-4]_SDP" || $y =~ "NGIN0[1-4]_SMP" ]]; then
			
			Log_info "Iniciando coleta nos hosts carregados"

			QUERY=`sqlplus -s system/manager@${y} << EOF

			SPOOL ${vDirOut}/${y}_Report.csv

			SET PAGES 500 
			SET LINES 500
			SET FEEDBACK OFF
			SELECT to_char(LOGIN_TIME,'DD/MM/YYYY HH24:MI:SS') as LOGIN_TIME,
			    USERNAME,
			    OSUSER,
			    MACHINE,
			    PROGRAM
			  FROM
			    (SELECT *
			    FROM core.ngin_user_login_audit
			    WHERE program NOT LIKE '%oracle@%'
			    AND program NOT LIKE '%sqlplus%'
			    AND program not like '%@sobral%'
			    AND program not like 'JDBC Thin Client%'
			    AND program not like '%sendin%'
			    AND program not like '%inbscp%'
                AND program not like '%sqlldr%'
			    AND login_time BETWEEN sysdate-7 AND sysdate
			    ORDER BY osuser, login_time DESC
			    );

			EXIT;
			SPOOL OFF;
			EOF`
	
			fi		

				if [[ -e ${vDirOut}/${y}_Report.csv ]]; then	#Valida se o arquivo coletado foi gerado com sucesso.
				
					Log_info "Arquivo do host $y criado com sucesso"

				else

					Log_info "Arquivo do host $y nao foi criado, gentileza verificar"

				fi

			done


	else

		Log_finish "Arquivo de configuracao nao foi encontrado, gentileza verificar"
		exit 1;

	fi


}

