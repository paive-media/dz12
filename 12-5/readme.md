# Домашнее задание к занятию 12.5 "Реляционные базы данных: Индексы"

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1.

Напишите запрос к учебной базе данных, который вернет процентное отношение общего размера всех индексов к общему размеру всех таблиц.

```sql
-- ~ 40%
SELECT 100 * SUM(index_length) / SUM(data_length) 
FROM INFORMATION_SCHEMA.TABLES
```

### Задание 2.

Выполните explain analyze следующего запроса:
```sql
select 
  distinct concat(c.last_name, ' ', c.first_name), 
  sum(p.amount) over (partition by c.customer_id, f.title)
from 
  payment p, 
  rental r, 
  customer c, 
  inventory i, 
  film f
where 
  date(p.payment_date) = '2005-07-30' and 
  p.payment_date = r.rental_date and 
  r.customer_id = c.customer_id and 
  i.inventory_id = r.inventory_id
```
- Перечислите узкие места:
  - *указана лишняя неиспользуемая таблица `film`;*
  - *использована избыточная группировка `OVER`;*
  - *`distinct` логически неверен, так как должна выполнится аггрегатная функция `SUM`;*
- Оптимизируйте запрос (внесите корректировки по использованию операторов, при необходимости добавьте индексы):
  - *ниже оптимизированный запрос;*
  - с добавленным индексом `sakila.payment (payment_date)` медленнее в 4 раза, из-за его избыточности - так как уже есть индекс по `r.rental_date`

```sql

-- добавил индекс по дате (выборка 391 строк = 38 ms)
CREATE INDEX payment_payment_date_IDX USING BTREE ON sakila.payment (payment_date);

-- удалил индекс по дате
ALTER TABLE sakila.payment DROP INDEX payment_payment_date_IDX;

-- итоговый запрос: выборка 391 строк = 10ms
SELECT 
  CONCAT(c.last_name, ' ', c.first_name) as fio,
  SUM(p.amount) AS amount
FROM customer AS c
JOIN rental AS r ON r.customer_id = c.customer_id
JOIN payment AS p ON p.payment_date = r.rental_date
JOIN inventory AS i ON i.inventory_id = r.inventory_id
WHERE 
  DATE(p.payment_date) = '2005-07-30'
GROUP BY c.customer_id

```

### Задание 3*.

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL нет.


PgSQL:

MySQL:




