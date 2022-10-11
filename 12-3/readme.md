# Домашнее задание к занятию 12.3 "Реляционные базы данных: SQL. Часть 1"

Домашнее задание нужно выполнить на Dataset из презентации.

*Решение нужно прислать одним SQL файлом, содержащим запросы по всем заданиям.*

[dz12-3_queries.sql](dz12-3_queries.sql)

---

Задание можно выполнить как в любом IDE, так и в командной строке.

### Задание 1.

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a”, и не содержат пробелов.

```sql
SELECT DISTINCT district
FROM address  
WHERE 
  LEFT(district,1)='K' AND 
  RIGHT(district,1)='a' AND 
  POSITION(' ' IN district)=0

```

### Задание 2.

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно**, 
и стоимость которых превышает 10.00.

```sql
SELECT * 
FROM payment 
WHERE 
  amount >10 AND 
  DATE(payment_date) BETWEEN '2005-06-15' AND '2005-06-18'
```

### Задание 3.

Получите последние 5 аренд фильмов.

```sql
SELECT * 
FROM payment 
WHERE 1
ORDER BY payment_date DESC 
LIMIT 5
```

### Задание 4.

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'

```sql
SELECT 
  customer_id, 
  store_id, 
  first_name, 
  REPLACE(LOWER(first_name),'ll','pp') as new_first_name, 
  LOWER(last_name) as last_name, 
  email, 
  active  
FROM customer 
WHERE 
  (first_name = 'Kelly' OR first_name = 'Willie') AND 
  active = 1
```

### Задание 5*.

Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй значение, указанное после @.

```sql
SELECT 
	email, 
	LEFT(email, POSITION('@' IN email)-1) AS mail_user,
	SUBSTR(email, POSITION('@' IN email)+1) AS mail_domain
FROM customer
WHERE 
	POSITION('@' IN email)!=0
```

### Задание 6.*

Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные строчными.

```sql

SELECT 
	email, 
	LEFT(email, POSITION('@' IN email)-1) AS mail_user,
	CONCAT( UPPER(LEFT(email,1)), LOWER(SUBSTR(email, 2, POSITION('@' IN email)-2)) ) AS mail_user_formatted,
	SUBSTR(email, POSITION('@' IN email)+1) AS mail_domain,
	CONCAT( UPPER(SUBSTR(email,POSITION('@' IN email)+1,1)), LOWER( SUBSTR(email, POSITION('@' IN email)+2) )) AS mail_domain_formatted
FROM customer
WHERE 
	POSITION('@' IN email)!=0
```

