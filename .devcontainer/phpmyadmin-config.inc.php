
<?php
$cfg['blowfish_secret'] =
    trim(file_get_contents('/var/lib/phpmyadmin/.secret'));

$cfg['Servers'][1]['auth_type'] = 'cookie';
$cfg['Servers'][1]['host'] = 'db';
$cfg['Servers'][1]['port'] = 3306;
$cfg['Servers'][1]['connect_type'] = 'tcp';

$cfg['TempDir'] = '/tmp';
