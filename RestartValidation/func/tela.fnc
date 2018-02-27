#!/bin/sh

source ../cfg/RestartValidation.cfg
source ../func/consulta.fnc

Tela() {
segmento=$(whiptail --title "SCP|DSCP Restart Validation 1.0" --menu "      Escolha uma opção na lista abaixo" --fb 15 50 4 \
"1" "SCP" \
"2" "DSCP" \
"3" "Consulta Hosts SCP" \
"4" "Consulta Hosts DSCP" 3>&1 1>&2 2>&3)
status=$?
if [ $status = 0 ]
then
if [ $segmento = 3 ]; then

        whiptail --title "Hosts SCPs Configurados" --textbox /home/a5129279/IMP/RestartValidation/cfg/hosts-scps 20 65 --scrolltext
fi
if [ $segmento = 4 ]; then

        whiptail --title "Hosts DSCPs Configurados" --textbox /home/a5129279/IMP/RestartValidation/cfg/hosts-dscps 20 65 --scrolltext

fi
if [ $segmento = 2 ]
then
    process_dscp=$(whiptail --title "SCP|DSCP Restart Validation" --radiolist \
    "       Deseja consultar qual grupo de processo?" 15 60 2 \
    "dscfs" "DSCF" ON \
    "dsgws" "DSGW" OFF 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then

                 ConsultaDSCP
    else
        exit 1;
    fi
fi

if [ $segmento = 1 ]
then
    process=$(whiptail --title "SCP|DSCP Restart Validation" --radiolist \
    "       Deseja consultar qual grupo de processo?" 15 60 2 \
    "gsmppsscfs" "PRE" ON \
    "gsmcorpscfs" "CORP" OFF 3>&1 1>&2 2>&3)
     
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        
                 ConsultaSCP
    else
        exit 1;
    fi
    fi
fi
}
