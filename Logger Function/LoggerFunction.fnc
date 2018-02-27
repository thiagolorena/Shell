#!/bin/sh
Log_init(){
echo "[${vThread}] `date +%d%m` `date +%H%M%S` INIT $*" | tee -a $LOGFILE 1>&2
}
Log_info(){
echo "[${vThread}] `date +%d%m` `date +%H%M%S` INFO $*" | tee -a $LOGFILE 1>&2
}
Log_finish(){
echo "[${vThread}] `date +%d%m` `date +%H%M%S` FINISH $*" | tee -a $LOGFILE 1>&2
}
Log_error(){
echo "[${vThread}] `date +%d%m` `date +%H%M%S` ERROR $*" | tee -a $LOGFILE 1>&2
}

