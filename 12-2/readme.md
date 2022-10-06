# Домашнее задание к занятию 12.2 "Работа с данными (DDL/DML)"

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1.
1.1 Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.

1.2 Создайте учетную запись sys_temp. 

1.3 Выполните запрос на получение списка пользователей в Базе Данных. (скриншот)

1.4 Дайте все права для пользователя sys_temp. 

1.5 Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)

1.6 Переподключитесь к базе данных от имени sys_temp.

Для смены типа аутентификации с sha2 используйте запрос: 
```sql
ALTER USER 'sys_test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```
1.6 По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.

1.7 Восстановите дамп в базу данных.

1.8 При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)

*Результатом работы должны быть скриншоты обозначенных заданий, а так же "простыня" со всеми запросами.*


### Решение

```sql

-- Создание пользователя
CREATE USER 'sys_temp'@'localhost' IDENTIFIED BY 'sys_pass';

SELECT User,Host FROM mysql.user;

-- Установка и отбор прав доступа
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost';
GRANT ALL PRIVILEGES ON sakila.* TO 'sys_temp'@'localhost';

SHOW GRANTS FOR 'sys_temp'@'localhost';

-- 

-- Сводка по таблицам
SHOW TABLES FROM sakila;

SHOW TABLE STATUS;

```

![task1 screen1](https://github.com/paive-media/dz12/blob/main/12-2/dz_db_12-2_screen1.png "DDL")
![task1 screen2](https://github.com/paive-media/dz12/blob/main/12-2/sakila_erd.png "ERd")


---

### Задание 2.
Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца, в первом должны быть названия таблиц восстановленной базы, 
во втором названия первичных ключей этих таблиц. Пример: (скриншот / текст)
```
Название таблицы | Название первичного ключа
customer         | customer_id
```

### Решение

```sql

SELECT TABLE_NAME  FROM information_schema.table_constraints 
WHERE 
	TABLE_SCHEMA = 'sakila';

-- Имя таблицы в бд sakila | Первичный ключ
SELECT table_name, COLUMN_NAME  FROM information_schema.key_column_usage 
WHERE 
	TABLE_SCHEMA = 'sakila' AND 
	CONSTRAINT_NAME = 'PRIMARY';

```

![task2 screen](https://github.com/paive-media/dz12/blob/main/12-2/dz_db_12-2_screen3.png "Tables+PKs")


### Задание 3.*
3.1 Уберите у пользователя sys_temp права на внесение, изменение и удаление данных из базы sakila.
3.2 Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)


### Решение

```sql
-- Установка и отбор прав доступа
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost';
GRANT ALL PRIVILEGES ON sakila.* TO 'sys_temp'@'localhost';

SHOW GRANTS FOR 'sys_temp'@'localhost';

-- Отбор прав доступа для таблицы
REVOKE INSERT,UPDATE,DELETE,DROP ON sakila.* FROM 'sys_temp'@'localhost';

-- Отбор прав доступа ото всех таблиц (уже после скрина)
REVOKE ALL PRIVILEGES ON *.* FROM 'sys_temp'@'localhost';
```

![task3 screen](https://github.com/paive-media/dz12/blob/main/12-2/dz_db_12-2_screen4.png "revoked")

