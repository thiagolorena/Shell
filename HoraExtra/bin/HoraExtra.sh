#!/bin/ksh
# ------------------------------------------------------------------------------
# SVN ID: $Id$
# Nome do programa: HoraExtra.sh
#
# Descricao abreviada de funcionalidade: Cria arquivo de Hora Extra 
# 
# Autor(es): Thiago Lorena
# 
# Data de criacao do programa: 27/11/2014
# 
# ------------------------------------------------------------------------------
# 
# Descricao detalhada de funcionalidade: Este Shell Script tem a funcionalidade
# de gravacao em arquivo ".csv" das Horas Extras contabilidades no mes corrente
# inputadas automaticamente ou por demanda do utilizador
#
# Exemplo(s) de execucao:
#   $ ./HoraExtra.sh
#
# Funcoes:
#
# ------------------------------------------------------------------------
# help();				              	 								 |								 
# - Funcao responsavel pelas informacoes de ajuda e preencimento de dados|
#   					                                                 |
#									 									 |
#   *Para suas variaveis consultar o arquivo cfg de variaveis            |
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# ConsolidaHoras                                                         |                             
# - Funcao responsavel por consolidar as horas geradas no mes corrente.  |
#   Utilizar a mesma com o parametro: $APP -c                            |
#                                                                        |
#   *Para suas variaveis consultar o arquivo cfg de variaveis            |
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# func.log();				              	 							 |								 
# - Funcao responsavel pela geracao de log da aplicacao					 |
#   					                                                 |
#									 									 |
#   *Para suas variaveis consultar o arquivo cfg de variaveis            |
# ------------------------------------------------------------------------
# Arquivos de Configuracao:												 |
#									 									 |
# Os arquivos de configuracao estao dentro da pasta "cfg", desta forma	 |
# qualquer alteracao na parametrizacao da aplicacao deve ser realizada   |
# neste diretorio.														 |
#																		 |
# Principal arquivo de configuracao: .variaveis (Arquivo oculto)         |
#																		 |
# -----------------------------------------------------------------------|
# Versoes e Modificacoes:
#
# Versão 1.0 - 27/11/2014 - Thiago Lorena
#        - Script gerando arquivo .csv apenas com dados multiplos, automaticos
#		   ou inseridos manualmente pelo usuario. 
#
# 
# Versão 1.1 - 26/05/2015 - Thiago Lorena
#        - Inserido a funcao ConsolidaHoras.
#
#		
# Licenca: GPL
#
# ------------------------------------------------------------------------------


source ../cfg/func.log
source ../cfg/.variaveis
source ../func/ConsolidaHoras

help(){

	echo "Hora Extra V1.0 - Help:

			Parametros:
			-i = Inserir dados de outras datas que nao sejam o dia atual
			vazio = Inserir dados do dia atual

			Variaveis:
			-i)
			 
			 $1 = -i
			 $2 = Dia Mes
			 $3 = Hora Inicio
			 $4 = Hora Fim
			 $5 = Qtd Horas
			 $6 = Comentarios/Obs


			 vazio)

			 $1 = Hora Inicio
			 $2 = Hora Fim
			 $3 = Qtd Horas
			 $4 = Comentarios/Obs


			 -c = Consolida Horas do Mês corrente.

			 Ex: $APP -c

			 Para mais informacoes sobre as variaveis consultar o cabeçalho do script.

"

}

if [[ ${1} = "-h" ]]; then

	help
	exit 0

fi

if [[ ${1} = "-c" || ${1} = "-C" ]]; then

	ConsolidaHoras
	exit 0;

fi

if [[ -z ${1} || -z ${2} || -z ${3} ]]; then

	Log_info "Inicio do Script"		
	Log_warn "Existem dados a serem preenchidos"
	Log_info "Digite -h para ajuda"		
	Log_finish "Fim do Script"

else

	if [[ ${1} = "-i" ]]; then
	
	Log_info "Inicio do Script"
        echo "${v_Func}|${v_Ano}|${v_Mes}|${2}|${3}|${4}|${5}|${6}" >> ${a_HoraExtra}

        if [[ $? -eq 0 ]]; then

                Log_info "Registro inserido com sucesso"
                Log_finish "Fim do Script"

        else

                Log_error "Registro com erro"
                Log_finish "Fim do Script"

        fi



else

	Log_info "Inicio do Script"
	echo "${v_Func}|${v_Ano}|${v_Mes}|${v_Dia}|${v_HoraInicio}|${v_HoraFim}|${v_QtdHoras}|${v_Obs}" >> ${a_HoraExtra}

	if [[ $? -eq 0 ]]; then
	
		Log_info "Registro inserido com sucesso"
		Log_finish "Fim do Script"

	else

		Log_error "Registro com erro"
		Log_finish "Fim do Script"

	fi

fi
fi
