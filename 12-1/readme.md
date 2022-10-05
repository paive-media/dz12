# Домашнее задание к занятию 12.1 "Базы данных."

---
### Легенда

Заказчик передал Вам [файл в формате Excel](https://github.com/netology-code/sdb-homeworks/blob/main/resources/hw-12-1.xlsx), в котором сформирован отчет. 

На основе этого отчета, нужно выполнить следующие задания: 

### Задание 1.

Опишите таблицы (не менее 7), из которых состоит База данных:

- какие данные хранятся в этих таблицах,
- какой тип данных у столбцов в этих таблицах, если данные хранятся в PostgreSQL.

Приведите решение к следующему виду:

Сотрудники (

- идентификатор, первичный ключ, serial,
- фамилия varchar(50),
- ...
- идентификатор структурного подразделения, внешний ключ, integer).

---

Тип `int` выбирал с учётом удаления/добавления записей при автоинкременте, чтобы размерности хватило.

Разбил ПРОЕКТЫ по Компаниям-клиентам.

**Сотрудники (employees)**
 - `id` 					int NOT NULL *PK autoincrement*
 - `full_name` 			varchar(255)


**Должности (positions)**
 - `id` 					smallint NOT NULL *PK autoincrement*
 - `title` 				varchar(255)


**Подразделения (divisions)**
 - `id` 					smallint NOT NULL *PK autoincrement*
 - `title` 				varchar(255)
 - `div_type` 			enum('Группа','Отдел','Департамент')


**Проекты (projects)**
 - `id`					int NOT NULL *PK autoincrement*
 - `customer_id` 			int NOT NULL *FK customers.id*
 - `title` 				varchar(255)


**Клиенты (customers)**
 - `id` 					int NOT NULL *PK autoincrement*
 - `legal_title` 			varchar(255)


**Филиалы (offices)**
 - `id` 					smallint NOT NULL *PK autoincrement*
 - `region` 				varchar(255)
 - `city` 				varchar(255)
 - `address` 				varchar(255)


**Распределение по проектам (teams)**
 - `id` 					int NOT NULL *PK autoincrement*
 - `project_id` 			int NOT NULL *FK projects.id*
 - `emp_id`				int NOT NULL *FK employees.id*


**Информация о найме (hr_links)**
 - `id` 					int NOT NULL *PK autoincrement*
 - `emp_id`				int NOT NULL *FK employees.id*
 - `hire_date` 			date
 - `salary_value` 		decimal
 - `office_id` 			smallint NOT NULL *FK offices.id*
 - `div_id` 				smallint NOT NULL *FK divisions.id*
 - `pos_id` 				smallint NOT NULL *FK positions.id*
 
