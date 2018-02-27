--$Id$
load data
 infile '/opt/ngin/PMS/dbi/install/input/dbi_install.ipt'
 into table PACKAGE_INSTALL
 APPEND 
 fields terminated by ","
 (PACKAGE, DATE_INSTALL TIMESTAMP "DD.MM.YYYY_hh24.mi.ss" ,INSTALLER, ENVIRONMENT,VERSION,SUCCESS,RELEASE, VALID)
