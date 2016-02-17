<?php

/* Servers configuration */
$i = 0;

/* Server: SQL [1] */
$i++;
$cfg['Servers'][$i]['verbose'] = 'Local';
$cfg['Servers'][$i]['host'] = 'db';
$cfg['Servers'][$i]['port'] = 3306;
$cfg['Servers'][$i]['socket'] = '';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['extension'] = 'mysqli';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['user'] = '';
$cfg['Servers'][$i]['password'] = '';
$cfg['Servers'][$i]['CountTables'] = true;

/* End of servers configuration */

$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['PmaNoRelation_DisableWarning'] = true;
$cfg['blowfish_secret'] = '50643b5a2b2e99.85133932';
$cfg['EditInWindow'] = false;
$cfg['Export']['compression'] = 'gzip';
$cfg['Export']['charset'] = 'utf-8';
$cfg['DefaultLang'] = 'en';
$cfg['ShowPhpInfo'] = true;
$cfg['ServerDefault'] = 1;

$cfg['MaxNavigationItems'] = 250;
$cfg['LoginCookieValidity'] = 72000;
$cfg['Servers'][$i]['only_db'] = 'docker%';
$cfg['ShowAll'] = true;
