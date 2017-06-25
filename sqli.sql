Create database faculty;
use faculty;

create user 'admin'@'%' IDENTIFIED BY 'admin123';
create user 'system'@'%' IDENTIFIED BY 'system123';
create user 'john'@'%' IDENTIFIED BY 'passw0rd';
GRANT ALL PRIVILEGES ON faculty. * TO 'admin'@'%';
GRANT ALL PRIVILEGES ON faculty. * TO 'system'@'%';
GRANT ALL PRIVILEGES ON faculty. * TO 'john'@'%';

grant all on faculty.* to faculty@'%' IDENTIFIED BY 'ifaculty';

create table `faculty`.`users` (
`id` int(11) not NULL AUTO_INCREMENT ,
`username` varchar(30) NOT NULL ,
`password` varchar(128) NOT NULL ,
PRIMARY KEY ( `id` ) ,
UNIQUE KEY `username` ( `username` ) )
ENGINE = MYISAM DEFAULT CHARSET = utf8;

insert into `users`(`username`,`password`) values ('admin','sysadmin');
insert into `users`(`username`,`password`) values ('saffro','tsunami2007');
insert into `users`(`username`,`password`) values ('guildi','qwert12345');
insert into `users`(`username`,`password`) values ('milli_2192','kissmelove');
insert into `users`(`username`,`password`) values ('adamjo','jafrriejones');
insert into `users`(`username`,`password`) values ('sibble','notAhacker');

INSTALL PLUGIN server_audit SONAME 'server_audit.so';

SET PASSWORD FOR 'root'@'%' = PASSWORD('root');
flush privileges;
