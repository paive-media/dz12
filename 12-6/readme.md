# Домашнее задание к занятию 12.6 "Репликация и масштабирование. Часть 1"

---

### Задание 1.

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

**Master-Slave**

- Есть главный источник новых данных, куда идет запись и изменения в данных
- Реплики только читают с Мастера
- Клиенты читают с Реплик


**Master-Master**

- Обе ноды плноправные источники новых данных, куда идет запись и изменения в данных
- Реплики только читают с ситуативного "Мастера", синхронизируя свои данные
- Клиенты читают с любой ноды
- думаю в этом случае могут быть сложнсти с производительностью, так как во время синхронизации все изменения выполняются последовательно и тратятся ресурсы, который могут быть нужны на обработку записи новых или изменение данных


---

### Задание 2.

Выполните конфигурацию Master-Slave репликации (примером можно пользоваться из лекции).

Команды:

```sh

sudo apt update

wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
sudo apt install ./mysql-apt-config_0.8.22-1_all.deb

sudo apt update
sudo apt install mysql-server

#-- root - Passw00rd!

systemctl status mysql
systemctl enable mysql

mkdir -p /var/log/mysql
chown mysql: /var/log/mysql


nano /etc/mysql/mysql.conf.d/mysqld.cnf
#-- @Master
bind-address    = 0.0.0.0
server_id       = 1
log_bin         = /var/log/mysql/mybin.log
#--

#-- @Slave add
relay-log = /var/lib/mysql/mysql-relay-bin
relay-log-index = /var/lib/mysql/mysql-relay-bin.index
read_only = 1
#--


systemctl restart mysql

#-- @Master
mysql -uroot -p

mysql> CREATE USER 'repl_user'@'%' IDENTIFIED WITH mysql_native_password BY 'passW00rd!';
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl_user'@'%';
mysql> FLUSH PRIVILEGES;
mysql> SHOW MASTER STATUS;


#-- @Slave
mysql -uroot -p

mysql> CHANGE MASTER TO MASTER_HOST='10.244.0.8', MASTER_USER='repl_user', MASTER_PASSWORD='passW00rd!', MASTER_LOG_FILE='mybin.000002', MASTER_LOG_POS=837;

mysql> START SLAVE;
mysql> SHOW SLAVE STATUS\G
```

Скрины: 

![task2 screen1](https://github.com/paive-media/dz12/blob/main/12-6/dz12-6_screen1.png "Master")
![task2 screen2-1](https://github.com/paive-media/dz12/blob/main/12-6/dz12-6_screen2-1.png "Slave 1")
![task2 screen2-2](https://github.com/paive-media/dz12/blob/main/12-6/dz12-6_screen2-2.png "Slave 2")

---

### Задание 3*. 

Выполните конфигурацию Master-Master репликации. Произведите проверку.

Команды:
```sh


#-- @Master2  deb02
mysql -uroot -p

mysql> CREATE USER 'repl_user2'@'%' IDENTIFIED WITH mysql_native_password BY 'passW02rd*';
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl_user2'@'%';
mysql> FLUSH PRIVILEGES;
mysql> SHOW MASTER STATUS;


nano /etc/mysql/mysql.conf.d/mysqld.cnf

#-- Slave2 add
relay-log = /var/lib/mysql/mysql-relay-bin
relay-log-index = /var/lib/mysql/mysql-relay-bin.index
read_only = 1
#-- 

systemctl restart mysql


#-- @Slave2  deb01
mysql -uroot -p

mysql> CHANGE MASTER TO MASTER_HOST='10.244.0.11', MASTER_USER='repl_user2', MASTER_PASSWORD='passW02rd*', MASTER_LOG_FILE='mybin.000003', MASTER_LOG_POS=1034;

mysql> START SLAVE;
mysql> SHOW SLAVE STATUS\G

```

Скрины:

![task3 screen3](https://github.com/paive-media/dz12/blob/main/12-6/dz12-6_screen3.png "Master2")
![task3 screen4-1](https://github.com/paive-media/dz12/blob/main/12-6/dz12-6_screen4-1.png "Slave2 1")
![task3 screen4-2](https://github.com/paive-media/dz12/blob/main/12-6/dz12-6_screen4-2.png "Slave2 2")
