USE pubs;

/*1*/
SELECT title
FROM titles
WHERE price BETWEEN 10 AND 15

/*2*/
SELECT title_id, title
FROM titles
WHERE type = 'business'

/*3*/
SELECT TOP 5 T.title, A.au_fname, A.au_lname, price
FROM titles T, titleauthor TA, authors A
WHERE T.title_id = TA.title_id AND TA.au_id = A.au_id
ORDER BY price DESC 

/*4*/
SELECT DISTINCT T.title_id, T.title
FROM titles T, sales S
WHERE T.title_id = S.title_id AND YEAR(S.ord_date) = 1993

/*5*/ 
SELECT DISTINCT fname, lname
FROM employee
WHERE DATEDIFF(YY, hire_date, GETDATE()) > 30

/*6*/ 
SELECT DISTINCT pub_id, pub_name
FROM publishers
WHERE pub_id IN (SELECT pub_id
					FROM titles
					GROUP BY pub_id
					HAVING COUNT(pub_id) > 5)


/*7*/ 
WITH auther_sales AS (SELECT TA.au_id, COUNT(TA.au_id) AS sold_books
					FROM sales S INNER JOIN titleauthor TA
						ON S.title_id = TA.title_id
					GROUP BY TA.au_id)
SELECT A.au_id, A.au_fname, A.au_lname, S.sold_books
FROM authors A, auther_sales S
WHERE A.au_id = S.au_id
