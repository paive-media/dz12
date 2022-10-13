# Домашнее задание к занятию 12.4 "Реляционные базы данных: SQL. Часть 2"

Домашнее задание нужно выполнить на датасете из презентации.

*Решение нужно прислать одним SQL файлом, содержащим запросы по всем заданиям.*

[dz12-4_queries.sql](dz12-4_queries.sql)

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1.

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина,
- город нахождения магазина,
- количество пользователей, закрепленных в этом магазине.

```sql
SELECT 
  CONCAT_WS(' ', stf.last_name, stf.first_name) as manager,
  cty.city,
  COUNT(1) as customers_count	
FROM store str  
JOIN customer cst ON str.store_id = cst.store_id
JOIN address adr ON str.address_id = adr.address_id
JOIN city cty ON cty.city_id = adr.address_id 
JOIN staff stf ON str.manager_staff_id = stf.staff_id 
WHERE 1
GROUP BY str.store_id;

-- проверочный запрос магазинов
SELECT s.store_id , COUNT(1) as cst_count
FROM store s, customer c 
WHERE 
  c.store_id = s.store_id 
GROUP BY s.store_id;
```

### Задание 2.

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

```sql

-- подготовительный запрос = 115.272
SELECT AVG(f.`length`), SUM(f.`length`)/COUNT(1) 
FROM film f 
WHERE 1;

-- проверка = 489
SELECT COUNT(1) as long_film_count 
FROM film f
WHERE f.`length` > 115.272;

-- итоговый запрос
SELECT COUNT(1) as long_film_count
FROM film f 
WHERE 
 f.`length` > ( SELECT AVG(f0.`length`) FROM film f0 WHERE 1 );
```

### Задание 3.

Получите информацию, за какой месяц была получена наибольшая сумма платежей и добавьте информацию по количеству аренд за этот месяц.

```sql
SELECT MONTH(p.payment_date) as most_value_month, SUM(amount) as month_summ, COUNT(1) as rental_count
FROM payment p 
WHERE 1
GROUP BY most_value_month
ORDER BY month_summ DESC
LIMIT 1;
```

### Задание 4*.

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», 
иначе должно быть значение «Нет».

```sql
SELECT 
  vp.staff_id,
  CONCAT_WS(' ', s.first_name, s.last_name) AS manager,
  CASE 
    WHEN vp.payment_count > 8000 THEN 'Yes'
    ELSE 'No'
  END AS bonus
FROM 
  staff s,
  (
    SELECT 
      p.staff_id, 
      COUNT(1) AS payment_count
    FROM payment p 
    WHERE 1
    GROUP BY p.staff_id 
  ) AS vp
WHERE 
  vp.staff_id = s.staff_id;
```

### Задание 5*.

Найдите фильмы, которые ни разу не брали в аренду.

```sql
-- медленный, но ВЕРНЫЙ запрос = 42 фильма
SELECT f.*
FROM film f
WHERE 
  f.film_id NOT IN (
    SELECT DISTINCT i.film_id
    FROM inventory i
    LEFT JOIN rental r ON r.inventory_id = i.inventory_id
  )


-- ошибочный запрос = всегда возвращает только первый фильм
SELECT f.*
FROM film f, inventory i
LEFT JOIN rental r ON r.inventory_id = i.inventory_id 
WHERE 
  r.rental_id IS NULL AND 
  f.film_id = i.film_id 
```
