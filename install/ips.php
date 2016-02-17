<?php
$ips = array(
    '192.168.99.1',
    '127.0.0.1',
    '::1',
);
if (!(in_array(@$_SERVER['REMOTE_ADDR'],$ips)) && !(in_array(@$_SERVER['HTTP_X_FORWARDED_FOR'],$ips))) {
    header('HTTP/1.0 403 Forbidden');
    die('You are not allowed to access this file. Check '.basename(__FILE__).' for more information.');
}
