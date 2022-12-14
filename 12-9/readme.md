# Домашнее задание к занятию 12.09 "Базы данных в облаке"

---

Домашнее задание подразумевает, что вы уже делали предыдущие работы в Яндекс.Облаке, и у вас есть аккаунт и каталог.

Используйте следующие рекомендации во избежание лишних трат в Яндекс.Облаке:
1) Сразу после выполнения задания удалите кластер;
2) Если вы решили взять паузу на выполнение задания, то остановите кластер.

### Задание 1


#### Создание кластера
1. Перейдите на главную страницу сервиса Managed Service for PostgreSQL.
1. Создайте кластер PostgreSQL со следующими параметрами:
- Класс хоста: s2.micro, диск network-ssd любого размера;
- Хосты: нужно создать два хоста в двух  разных зонах доступности  и указать необходимость публичного доступа (публичного IP адреса) для них;
- Установите учетную запись для пользователя и базы.

Остальные параметры оставьте по умолчанию либо измените по своему усмотрению.

* Нажмите кнопку "Создать кластер" и дождитесь окончания процесса создания (Статус кластера = RUNNING). Кластер создается от 5 до 10 минут.

#### Подключение к мастеру и реплике 

* Используйте инструкцию по подключению к кластеру, доступную на вкладке "Обзор": cкачайте SSL сертификат и подключитесь к кластеру с помощью утилиты psql, указав hostname всех узлов и атрибут ```target_session_attrs=read-write```.

* Проверьте, что подключение прошло к master-узлу.
```
select case when pg_is_in_recovery() then 'REPLICA' else 'MASTER' end;
```
* Посмотрите количество подключенных реплик:
```
select count(*) from pg_stat_replication;
```

### Проверьте работоспособность репликации в кластере

* Создайте таблицу и вставьте одну-две строки.
```
CREATE TABLE test_table(text varchar);
```
```
insert into test_table values('Строка 1');
```

* Выйдите из psql командой ```\q```.

* Теперь подключитесь к узлу-реплике. Для этого из команды подключения удалите атрибут ```target_session_attrs``` , и в параметре атрибут ```host``` передайте только имя хоста-реплики. Роли хостов можно посмотреть на соответствующей вкладке UI консоли.

* Проверьте, что подключение прошло к узлу-реплике.
```
select case when pg_is_in_recovery() then 'REPLICA' else 'MASTER' end;
```
* Проверьте состояние репликации
```
select status from pg_stat_wal_receiver;
```

* Для проверки, что механизм репликации данных работает между зонами доступности облака, выполните запрос к таблице, созданной на предыдущем шаге:
```
select * from test_table;
```

По итогу пришлите скриншоты:

1) Созданной базы данных;
2) Результата вывода команды на реплике ```select * from test_table;```.

![task1 screen1](https://github.com/paive-media/dz12/blob/main/12-9/dz12-9_screen1.png "master")

![task1 screen2](https://github.com/paive-media/dz12/blob/main/12-9/dz12-9_screen2.png "replica")

![task1 screen3](https://github.com/paive-media/dz12/blob/main/12-9/dz12-9_screen3.png "ya.cl db")

```sql
-- на MASTER-е
CREATE TABLE test_table( id int NOT NULL, fld varchar) ;

ALTER TABLE test_table ADD PRIMARY KEY (id);

INSERT INTO test_table (id, fld) 
VALUES (1,'Строка 1'), (2,'Строка 2'), (3,'Строка 3');


-- test query @ MASTER 
SELECT * FROM test_table;

-- test query @ REPLICA
SELECT * FROM test_table;

```

### Задание 2*

Создайте кластер, как в задании 1 с помощью terraform.

[main_err.tf](https://github.com/paive-media/dz12/blob/main/12-9/main_err.tf)

Разбираюсь с ошибкой доступа при создании: ожидаю комментария от Поддержки Я.Облака…
![task2 screen1](https://github.com/paive-media/dz12/blob/main/12-9/dz12-9_screen4.png "ya.cl tf err")

`UPDATED` Разобрался &mdash; была ошибка в указании ID сетей.

По итогу пришлите скришоты:

1) Скриншот созданной базы данных;
2) Код terraform, создающий базу данных.



Кластер, созданного с помощью Terraform:
[main.tf правильный](https://github.com/paive-media/dz12/blob/main/12-9/main.tf)

![task2 screen2](https://github.com/paive-media/dz12/blob/main/12-9/dz12-9_screen5.png "ya.cl tf-cluster")
![task2 screen3](https://github.com/paive-media/dz12/blob/main/12-9/dz12-9_screen6.png "ya.cl tf-cluster db")
![task2 screen4](https://github.com/paive-media/dz12/blob/main/12-9/dz12-9_screen7.png "ya.cl tf-cluster operations")
