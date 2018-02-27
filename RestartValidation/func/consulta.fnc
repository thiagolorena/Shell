#!/bin/sh

source ../cfg/RestartValidation.cfg

ConsultaSCP() {
	
	clear

        for x in `cat ${HostsScp}`; do

        printf ${grnb}'%10s\n' "SITE: $x"${end}
        printf ${red}'%10s %20s\n' 'DATA' 'PROCESSO'${end}
        ssh core@$x "source /home/core/.bash_profile ; SCP status $process | grep LOOP | cut -d' ' -f11,10 " >> ${ArqAux}
	printf ${whi}'%10s %16s\n'${end} $(cut -f1- --output-delimiter=' '  ${ArqAux})

        rm ${ArqAux}

        printf '\n'

        done

}

ConsultaDSCP(){


        clear

        for x in `cat ${HostsDscp}`; do

        printf ${grnb}'%10s\n' "SITE: $x"${end}
        printf ${red}'%10s %20s\n' 'DATA' 'PROCESSO'${end}
        ssh core@$x "export HOME=/opt/ngin/core ; PATH=\$JAVA_HOME/bin:\$PATH:\$HOME/bin:\$ORACLE_HOME/bin:\$HOME/Commands ; DSCP status $process_dscp | grep LOOP | cut -d' ' -f11,10 " >> ${ArqAuxDscp}
	ssh core@$x "export HOME=/opt/ngin/core ; PATH=\$JAVA_HOME/bin:\$PATH:\$HOME/bin:\$ORACLE_HOME/bin:\$HOME/Commands ; DSCPTNG status $process_dscp | grep LOOP | cut -d' ' -f11,10 " >> ${ArqAuxDscp}
	ssh core@$x "export HOME=/opt/ngin/core ; PATH=\$JAVA_HOME/bin:\$PATH:\$HOME/bin:\$ORACLE_HOME/bin:\$HOME/Commands ; DSCPSY status $process_dscp | grep LOOP | cut -d' ' -f11,10 " >> ${ArqAuxDscp}
	printf ${whi}'%10s %16s\n'${end} $(cut  -f1- --output-delimiter=' '  ${ArqAuxDscp})

        rm ${ArqAuxDscp}

        printf '\n'

        done

}
