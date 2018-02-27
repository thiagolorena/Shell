#!/bin/sh
# ------------------------------------------------------------------------
#									 |
# Nome do programa: BlindReport.sh 					 |
#									 |
# Descricao abreviada de funcionalidade: Script de automacao de coleta   |
# da blindagem do ambiente  						 |
# 									 |
# Autor(es): Thiago Lorena						 |
# 									 |
# Data de criacao do programa: 15/12/2016				 |
# 									 |
# ------------------------------------------------------------------------
# 									 |
# Descricao detalhada de funcionalidade: Script que realiza a coleta de  |
# dados e consolida os mesmos na IMPTOOLS e envia por e-mail. Este e 	 |
# apenas uma automacao do processo manual.				 |
# . 									 |
#									 |
# Exemplo(s) de execucao:						 |
#   $ ./BlindReport.sh							 |
#									 |
# Funcoes:								 |
#									 |
# ------------------------------------------------------------------------
# collect_data.fnc();				              	         |
# - Funcao responsavel pela coleta dos dados nos hosts de banco de dados |
#									 |
#   *Para suas variaveis consultar o arquivo cfg de variaveis            |
# ------------------------------------------------------------------------
# logger.fnc();					                         |
# - Funcao responsavel pelos logs da aplicacao, definicoes de arquivos.  |
# 									 |
#   *Para suas variaveis consultar o arquivo cfg de variaveis            |
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# func.send_mail();					                 |
# - Funcao responsavel pelo envio do e-mail para a equipe de implantacao |
#   com os dados da execucao e procedimentos a serem executados          |
#   tem como sua principal variavel a {ListaMail} onde e configurado os  |
#   destinatarios que irao receber o email de report.                    |
#          								 |
#   *Para suas variaveis consultar o arquivo cfg de variaveis            |
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# purge_files.fnc();					                 |
# - Funcao responsavel pela remocao de arquivos do diretorio vDirOut     |
#									 |
#   *Para suas variaveis consultar o arquivo cfg de variaveis            |
# ------------------------------------------------------------------------
# -----------------------------------------------------------------------|
# Arquivos de Configuracao:						 |
#									 |
# Os arquivos de configuracao estao dentro da pasta "cfg", desta forma	 |
# qualquer alteracao na parametrizacao da aplicacao deve ser realizada   |
# neste diretorio.							 |
#									 |
# Principal arquivo de configuracao: BlindReport.cfg                     |
#									 |
# -----------------------------------------------------------------------|
# Versoes e Modificacoes:						 |
#									 |
# Versão 1.0  15/12/2016 - Thiao Lorena			 	  | 
#        - Script versao inicial, executando remote sqlplus nos hosts    |
#	   sinalizados nos arquivos de configuracao.			 |
#									 |
# Versao 1.1 - 26/12/2016 - Thiago Lorena				 |
#	 - Script agora somente envia arquivos que tenham conteudo.	 |
#									 |
#                                                                        |
# Versao 1.2 - 20/06/2017 - Thiago Lorena                                |
#        - Alterado Funcao (Collect), para receber regex no Host.        |
#	 - Alterado Funcao (SendMail), adicionando Marcos A.             |
#	 - Corrigido BUG na Query para BDRT, adicionado program SDF      |
#        - Corrigido BUG no titulo do E-mail UTF-8. Removido acento      |
#                                                                        |
# Licenca: GPL						 		 |
#									 |
# ------------------------------------------------------------------------


#VARIABLES EXPORT
source ../func/collect_data.fnc
source ../func/logger.fnc
source ../func/purge_files.fnc
source ../func/send_email.fnc
source ../cfg/BlindReport.cfg     

#Inicio do Script

Log_init "Iniciando script $0"
Log_info "Iniciando funcoes de coleta"
	
	#INIT FUNCTIONS
	PurgeFiles
	Collect
	SendMail
        	
Log_finish "Finalizando execucao"
