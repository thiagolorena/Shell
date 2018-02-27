#!/bin/sh
#
# # # 
# # #
# # #      .....
# # #   ,,$$$$$$$$$,    
# # #  ;$'      '$$$$:  
# # #  $:         $$$$:
# # #   $       o_)$$$: -"Hi linux, what do we gone to do today at night?"
# # #   ;$,    _/\ &&:' -"What we do every night link,
# # #     '     /( &&&    tries to dominate the world!"
# # #         \_&&&&'
# # #        &&&&.      -DEBIAN, THE CHOICE OF NEW GNU LINUX GENERATION!!!!
# # #  &&&&&&&:
# #
#
#
# ------------------------------------------------------------------------------
#
# Nome do programa: CollectInvalid.ksh
#
# Descrição abreviada de funcionalidade: Efetua coleta de objetos invalidos da Base de Dados
# 
# Autor(es): Thiago Lorena
# 
# Data de criação do programa: 11/11/2013
# 
# ------------------------------------------------------------------------------
# 
# Descricao detalhada de funcionalidade: Este shell Script tem a funcionalidade de coleta
# via sqlplus dos objetos invalidos do Banco de Dados dos ambientes. Como packages, procedures
# synonimos.
#
# Query utilizada para a coleta dos dados:
#
# select OWNER, OBJECT_NAME, OBJECT_TYPE,to_char(CREATED, 'DD/MM/YYYY HH24:MI:SS') AS CREATED, 
# to_char(LAST_DDL_TIME, 'DD/MM/YYYY HH24:MI:SS') AS LAST_DDL_TIME,STATUS from dba_objects 
# where status = 'INVALID' and owner not in ('SYS','PUBLIC','OBT_INTF') and owner not like 'ACESSO_NGIN' 
# and owner not like 'MIGRAPTIV2C' and OBJECT_TYPE NOT like 'JAVA%' and  OWNER NOT like 'SUPPORT' 
# order by last_ddl_time desc;
#
# Exemplo(s) de execucao:
#   $ ./CollectInvalid.ksh
#
# Funcoes:
#
# ------------------------------------------------------------------------
# EXECUTE_LAB();				                         						 |
# - Funcao responsavel pela execucao nos ambientes internos LAB EVL e OG |
# Disponibilizando os arquivos de saida no diretorio ${DIR_OUT}          |
# ------------------------------------------------------------------------
#
# Versoes e Modificacoes:
#
# Versão 1.0 - 11/11/2013 - Thiago Lorena
#        - Script efetuando a execucao apenas em LAB coletando o 
#		   objetos inválidos com a query padrao definida na secao detalhada.
#
# Versão 1.1 - 15/06/2014 - Thiago Lorena
#		 - Adicionado arquivo .variables para controle e limpeza de codigo
#          dentro do ${DIR_CFG}.
#
# Versão 1.2 - 17/06/2014 - Thiago Lorena
#		 - Adicionado Funcao EXECUTE_LAB() no script, juntamente com as bibliotecas
# 		   de funcoes, possibilitando maior desenvolvimento no script. 
#
# Licença: GPL
#
# ------------------------------------------------------------------------------



#VARIABLES EXPORT
source ../cfg/.variables    

#FUNCOES DE LOG
Log_init(){
echo "${APP}:`date +%d%m` `date +%H%M%S`:INIT:$*;" | tee -a $LOGFILE 1>&2
}
Log_info(){
echo "${APP}:`date +%d%m` `date +%H%M%S`:INFO:$*;" | tee -a $LOGFILE 1>&2
}
Log_finish(){
echo "${APP}:`date +%d%m` `date +%H%M%S`:FINISH:$*;" | tee -a $LOGFILE 1>&2
}
Log_error(){
echo "${APP}:`date +%d%m` `date +%H%M%S`:ERROR:$*;" | tee -a $LOGFILE 1>&2
}

#FUNCAO DE EXECUCAO DO SCRIPT EM LAB-EVL/OG
EXECUTE_LAB(){

Log_info "Loading Config Files"
sleep 2

if [[ -e ${CONFIG_FILE_LAB} ]]; then    #VALIDACAO DO ARQUIVO DE CONFIGURACAO
	
	Log_info "Config Files Loaded"

	for x in `cat ${CONFIG_FILE_LAB}`; do      #LACO DE REPETICAO PARA EXECUCAO DE TODOS OS TNSNAMES CARREGADOS NOS ARQUIVOS DE CONFIGURACAO

	Log_info "Generating file ${x}"  	#INICIO DA COLETA DOS DADOS VIA SQLPLUS	
			
		RETVAL=`sqlplus -silent system/manager@${x} << EOF

        	SPOOL ${DIR_OUT}/${x}_${DATE}.log

        	SET TRIMSPOOL ON 
        	SET LINESIZE 200
        	SET FEEDBACK OFF
			SET PAGESIZE 50000 

        	COLUMN OWNER FORMAT A25
        	COLUMN OBJECT_NAME FORMAT A45
        	COLUMN OBJECT_TYPE FORMAT A30
        	COLUMN CREATED FORMAT A20
        	COLUMN LAST_DDL_TIME FORMAT A20
        	COLUMN STATUS FORMAT A7
	
            	select OWNER, OBJECT_NAME, OBJECT_TYPE,to_char(CREATED, 'DD/MM/YYYY HH24:MI:SS') AS CREATED, to_char(LAST_DDL_TIME, 'DD/MM/YYYY HH24:MI:SS') AS LAST_DDL_TIME,STATUS from dba_objects where status = 'INVALID' order by last_ddl_time desc;

        	EXIT;
        	SPOOL OFF
        	EOF`
	

			Log_info "File ${x} successfully generated"
			done

			Log_finish "Script Finish"

		else 	#EM CASO DE FALHA NO LOAD DO ARQUIVO DE CONFIG, APRESENTA ERRO E SAI DO SCRIPT

			Log_error "Config files not found"
			exit 0

fi 		#FINAL DO FUNCAO

}

#FUNCAO PRINCIPAL

Log_init "Begin Script"
EXECUTE_LAB       #CHAMADA DA FUNCAO

