#!/bin/sh
# $Id$
# -----------------------------------------------------------------------|
#									 |
# Nome do programa: DBIInstall.sh					 |
#									 |
# Descricao abreviada de funcionalidade: JOB de carga para instalacoes   |
#					 de pacotes			 |
# Autor(es): Thiago Lorena e Heitor Lima				 |
# 									 |
# Data de criacao do programa: 17/06/2016				 |
# 									 |
# -----------------------------------------------------------------------|
# 									 |
# Descricao detalhada de funcionalidade: Este JOB tem a responsabilidade |  
# de efetuar a carga dos arquivos "rows.ipt" gerado pelo PMS.            |
# 									 |
# Exemplo(s) de execucao:						 |
#   $ ./DBIInstall.sh							 |
#									 |
# -----------------------------------------------------------------------|
# -----------------------------------------------------------------------|
# Arquivos de Configuracao:						 |
#						                         |
# Os arquivos de configuracao estao dentro da pasta "cfg", desta forma	 |
# qualquer alteracao na parametrizacao da aplicacao deve ser realizada   |
# neste diretorio.				                         |
#						                         |
# Principal arquivo de configuracao: DBIInstall.cfg                      |
#									 |
# -----------------------------------------------------------------------|
# -----------------------------------------------------------------------|
# -----------------------------------------------------------------------|
# Diretorios								 |
#  									 |
# Os diretorios da aplicacao serao detalhados abaixo:			 |
#									 |
# /input = Diretorio onde e depositado os arquivos rows.ipt para carga.  |
# /error = Diretorio onde e movido os arquivos rows e alterado o         |
#          timestamp para processamentos futuros.			 |
# /processed = Diretorio onde os arquivos rows pos processamento sao     |
#              armazenados.						 |
# /bin = Diretorio onde fica o binario da aplicacao.			 |
# /cfg = Diretorio onde fica os arquivos de configuracao (Ver acima). 	 |
# /log = Diretorio onde fica armazenado os logs tanto dos binarios       |
#        quanto do sqlloader.						 |
# -----------------------------------------------------------------------|
# -----------------------------------------------------------------------|
# -----------------------------------------------------------------------|
# Versoes e Modificacoes:						 |
#									 |
# Versão 1.0 - 17/06/2016 - Thiago Lorena e Heitor Lima			 |
#       - JOB inicial, utilizando as funcionalidades abaixo:		 |
#		 							 |
#	- SQLLDR com TNS (BUG ORACLE, nao remover a variavel ${vTNS})    |
# 	- Logs em modo DEBUG						 |
#									 |
# Versão 1.1 - 16/11/2016 - Thiago Lorena				 |
#       								 |
#	Funcionalidades:						 |
#	- Atualização de código para processar arquivos sqlldr em lista  |
#									 |
#	Correções de BUGS:						 |
#	- Corrigido variável vDIR_ERROR no arquivo de configuração       |
#	  principal, pois após erro de carga, arquivos não eram		 |
#	  transferidos para o diretório de error. 			 |
#									 |
# Versao 1.2 - 05/06/2017 - Thiago Lorena			 	 |	
#									 |
#	Funcionalidades:						 |
#	- Atualizacao de configuracao para inputar dados nos campos:	 |
#       {VERSION,SUCCESS}						 |
#									 |
# 									 |
# Licenca: GPL								 |
#									 |
# -----------------------------------------------------------------------|


source ../cfg/DBIInstall.cfg
source ../cfg/logger.fnc

#Begin
cd ${vDIR_INPUT}
vQtdFiles=`ls -ltr ${vDIR_INPUT} | grep -vi total | wc -l`

Log_init "Inicio do job de carga do DBI-Install"


Log_info "Inicando varredura dos diretorios de INPUT"

if [[ ${vQtdFiles} -gt 0 ]]; then	#Valida se existem arquivos a serem processados

	Log_info "Arquivos de carga encontrado, QTD: ${vQtdFiles}"
	Log_info "Executando SQLLDR no Banco de dados, favor aguardar"

	#cat ${vDIR_INPUT}/* > ${vDIR_INPUT}/dbi_install.ipt    #Correcao de BUG com lista de arquivos a serem processados
		
	sqlldr ${vUserBD}/${vPasswdBD}@${vTNS} control=${vControlFile} -silent=ALL log=${vDIR_LOG}/DBIInstall_`date +%d.%m.%Y_%H.%M.%S`.log	#Executa o sqlldr no banco de dados com TNS

	if [[ $? -eq 0 ]]; then 	#Valida se a sqlldr foi executado com sucesso e move o arquivo para a pasta processed com o timestamp.
		
	Log_info "Carga efetuada com sucesso"

	cd ${vDIR_INPUT}
	mv dbi_install.ipt ${vDIR_PROCESSED}/rows_`date +%d.%m.%Y_%H.%M.%S`.prc 
	#rm dbi_install_*.ipt  #Correcao de BUG com lista de arquivos a serem processados

	else 		#Caso apresente erro na carga ele copia o arquivo para a pasta error.

	cd ${vDIR_INPUT}
	mv dbi_install.ipt ${vDIR_ERROR}/rows_`date +%d.%m.%Y_%H.%M.%S`.err
	Log_error "Carga com erro no Banco de Dados"
		
	fi

else

	Log_info "Nao existem arquivos para serem carregados na base de dados"
	exit 0;
fi
