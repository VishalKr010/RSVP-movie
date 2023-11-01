USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*) AS TOTAL_ROWS_IN_MOVIES FROM movie;
SELECT COUNT(*) AS TOTAL_ROWS_IN_DIRECTOR_MAPPING FROM director_mapping;
SELECT COUNT(*) AS TOTAL_ROWS_IN_GENRE FROM GENRE;
SELECT COUNT(*) AS TOTAL_ROWS_IN_RATINGS FROM RATINGS;
SELECT COUNT(*) AS TOTAL_ROWS_IN_NAMES FROM NAMES;
SELECT COUNT(*) AS TOTAL_ROWS_IN_ROLE_MAPPING FROM ROLE_MAPPING;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
SUM(CASE WHEN TITLE IS NULL THEN 1 ELSE 0 END) AS TITLE_NULL,
SUM(CASE WHEN YEAR IS NULL THEN 1 ELSE 0 END) AS YEAR_NULL,
SUM(CASE WHEN DATE_PUBLISHED IS NULL THEN 1 ELSE 0 END) AS DATEPUBLISHED_NULL,
SUM(CASE WHEN DURATION IS NULL THEN 1 ELSE 0 END) AS DURATION_NULL,
SUM(CASE WHEN COUNTRY IS NULL THEN 1 ELSE 0 END) AS COUNTRY_NULL,
SUM(CASE WHEN WORLDWIDE_GROSS_INCOME IS NULL THEN 1 ELSE 0 END) AS WORLDWIDE_NULL,
SUM(CASE WHEN LANGUAGES IS NULL THEN 1 ELSE 0 END) AS LANGUAGE_NULL,
SUM(CASE WHEN PRODUCTION_COMPANY IS NULL THEN 1 ELSE 0 END) AS PRODUCTION_COMPANY_NULL
FROM MOVIE;
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- answer to first part
SELECT YEAR, COUNT(TITLE) AS NUMBER_OF_MOVIES FROM MOVIE GROUP BY YEAR;

-- ANSWER TO 2ND PART
SELECT MONTH(DATE_PUBLISHED) AS MONTH_NUMBER,COUNT(*) AS NUMBER_OF_MOVIES FROM MOVIE GROUP BY MONTH_NUMBER ORDER BY MONTH_NUMBER; 


/*The highest number of movies is produced in the month of March WHICH IS 824 AND FOLLOWING BY SEPTEMBER WHICH IS 809 AND THE LEAST IN DECEMBER WHICH IS 438.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(DISTINCT id) AS NO_OF_MOVIES, YEAR FROM MOVIE WHERE( COUNTRY LIKE '%INDIA%' OR COUNTRY LIKE '%USA%') AND YEAR = 2019; 
-- THE NNUMBER OF MOVIES PRODUCED IN USA OR INDIA IS 1059 IN THE YEAR 2019 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT GENRE FROM GENRE;

-- THE DISTINCT ROWS ARE GENRE AS FOLLOWS -> 'Drama','Fantasy','Thriller','Comedy','Horror','Family','Romance'
-- 'Adventure','Action','Sci-Fi','Crime','Mystery','Others'

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT     GENRE,COUNT(M.ID) AS NO_OF_MOVIES
FROM       MOVIE       AS M
INNER JOIN GENRE       AS G
where      G.MOVIE_ID = M.ID
GROUP BY   GENRE
ORDER BY   NO_OF_MOVIES DESC LIMIT 1 ;
-- THE DRAMA MOVIES WERE 4285 WHICH WERE HIGHEST AMONG ALL THE GENRES.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH MOVIE_WITH_1_GENRE AS (SELECT MOVIE_ID FROM GENRE GROUP  BY MOVIE_ID HAVING COUNT(DISTINCT GENRE) = 1)
SELECT COUNT(*) AS MOVIE_WITH_1_GENRE FROM MOVIE_WITH_1_GENRE; 
-- THERE ARE 3289 MOVIES BELONG TO ONLY ONE GENRE.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT GENRE, ROUND(AVG(DURATION),2) AS AVG_DURATION FROM MOVIE AS M INNER JOIN GENRE AS G ON G.MOVIE_ID=M.ID GROUP BY GENRE ORDER BY AVG_DURATION DESC;

-- ACTION GENRE HAS HIGHEST AVG DURATION OF 112.88 SEC NEXT ROMANCE BY 109.53 SEC LOWEST AVG DURATION IS HORROR WHICH IS 92.72

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:



WITH GENRE_SUM AS
(SELECT GENRE, COUNT(MOVIE_ID) AS MOVIE_COUNT, Rank() OVER(ORDER BY COUNT(MOVIE_ID) DESC) AS GENRE_RANK
FROM GENRE GROUP BY GENRE )
SELECT * FROM GENRE_SUM WHERE  GENRE = "THRILLER" ;
-- THE GENRE THRILLER HAS RANK 3 WITH THE MOVIE COUNT 1484

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(AVG_RATING) AS MIN_AVG_RATING, MAX(AVG_RATING) AS MAX_AVG_RATING, MIN(TOTAL_VOTES) AS MIN_TOTAL_VOTES, MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING, MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING FROM RATINGS;
-- # MIN_AVG_RATING, MAX_AVG_RATING, MIN_TOTAL_VOTES, MAX_TOTAL_VOTES, MIN_MEDIAN_RATING, MAX_MEDIAN_RATING
--     '1.0',              '10.0',           '100',        '725138',       '1',              '10'


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT TITLE, AVG_RATING, DENSE_RANK() OVER(ORDER BY AVG_RATING DESC) AS MOVIE_RANK
FROM RATINGS AS R
INNER JOIN MOVIE AS M
ON M.ID = R.MOVIE_ID limit 10;
-- KIRLKET TOPPED WITH 10.O AVG RATING ALONG WITH LOVE IN KILNERRY WITH THE SAME RATING.

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT MEDIAN_RATING, COUNT(MOVIE_ID) AS MOVIE_COUNT FROM RATINGS GROUP BY MEDIAN_RATING ORDER BY MOVIE_COUNT DESC;
-- MEDIAN RATING OF 7 IS HIGHEST AND MOVIE COUNT IS 2257 WHICH IS 7 AS MEDIAN COUNT.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT PRODUCTION_COMPANY, COUNT(ID) AS MOVIE_COUNT, DENSE_RANK() OVER(ORDER BY COUNT(ID) DESC) PROD_COMPANY_RANK
FROM MOVIE M INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID WHERE R.AVG_RATING > 8 AND M.PRODUCTION_COMPANY IS NOT NULL GROUP BY M.PRODUCTION_COMPANY;
-- 'Dream Warrior Pictures', '3', '1'
-- 'National Theatre Live', '3', '1'
-- THESE TWO COMPANIES HAVE PRODUCED MOST HIT MOVIES WHICH IS 3 WITH A AVG RATING OF > 8


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT GENRE, COUNT(ID) AS MOVIE_COUNT FROM MOVIE AS M INNER JOIN GENRE AS G ON G.MOVIE_ID = M.ID INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID  
WHERE YEAR = 2017 AND MONTH(DATE_PUBLISHED) = 3 AND COUNTRY LIKE '%USA%' AND TOTAL_VOTES > 1000
GROUP BY GENRE ORDER BY MOVIE_COUNT DESC;
-- DRAMA IS WITH THE HIGHEST MOVIE COUNT THAT IS 24 FOLLOWED BY COMEDY BY 9, LOWEST IS FAMILY BY 1
-- TOP 3 ARE DRAMA, COMEDY, ACTION

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT TITLE, AVG_RATING, GENRE FROM MOVIE AS M INNER JOIN GENRE AS G ON G.MOVIE_ID = M.ID
INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID
WHERE AVG_RATING > 8 AND TITLE LIKE 'THE%' GROUP BY TITLE ORDER BY AVG_RATING DESC;

-- THERE ARE TOTAL 8 MOVIES WHICH BEGIN WITH THE TITLE "THE' AND 'The Brighton Miracle' HAD THE HIGHEST AVG RATING OF 9.5 GENRE DRAMA
-- FOLLOWED BY The Colour of Darkness WITH AVG RATING 9.1 GENRE DRAMA AND LOWEST OF ALL IS 'The King and I' WITH AVD RATING 8.2 GENRE DRAMA

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT MEDIAN_RATING, COUNT(ID) AS MOVIE_COUNT FROM MOVIE AS M INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID
WHERE MEDIAN_RATING = 8 AND DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01' GROUP BY MEDIAN_RATING;

-- MEDIAN RATING IS 8 WITH A MOVIE_COUNT 361

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT LANGUAGES, Sum(total_votes) AS VOTES FROM MOVIE AS M INNER JOIN ratings AS R ON R.movie_id = M.id
WHERE  LANGUAGES LIKE '%Italian%'
UNION
SELECT LANGUAGES, Sum(total_votes) AS VOTES FROM MOVIE AS M INNER JOIN ratings AS R ON R.movie_id = M.id
WHERE  LANGUAGES LIKE '%GERMAN%'
ORDER  BY VOTES DESC; 
-- YES GERMAN MOVIES (4421525) GET MORE VOTES THAN ITIALIN MOVIES (2559540) WHICH LEAD BY 1861985


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) AS NULL_NAME,
SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) AS NULL_HEIGHT,
SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) AS NULL_DATE_OF_BIRTH,
SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) AS NULL_KNOWN_FOR_MOVIES
FROM names;
-- THERE ARE NO NULL NAMES
-- THERE ARE 17335 NULL_HEIGHT
-- THERE ARE 13431 NULL_DATE_OF_BIRTH
-- THERE ARE 15226 NULL_KNOWN_FOR_MOVIES


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH TOP_THREE_GENRES AS
(
SELECT GENRE, COUNT(m.id) AS MOVIE_COUNT , Rank() OVER(ORDER BY Count(m.id) DESC) AS GENRE_RANK
FROM MOVIE AS m INNER JOIN genre AS g ON g.movie_id = m.id INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE AVG_RATING > 8 GROUP BY GENRE limit 3)
SELECT n.NAME AS DIRECTOR_NAME ,COUNT(d.MOVIE_ID) AS MOVIE_COUNT
FROM DIRECTOR_MAPPING  AS d INNER JOIN GENRE G
using (MOVIE_ID) INNER JOIN names AS n ON n.ID = d.NAME_ID INNER JOIN TOP_THREE_GENRES using (GENRE)
INNER JOIN RATINGS using (MOVIE_ID) WHERE AVG_RATING > 8 GROUP BY NAME ORDER BY MOVIE_COUNT DESC limit 3 ;
-- # DIRECTOR_NAME, MOVIE_COUNT
--  'James Mangold', '4'
--  'Anthony Russo', '3'
--  'Soubin Shahir', '3'
-- THESE ARE 3 DIRECTOR NAMES WHO HAVE THE RATING ABOVE 8


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT N.NAME AS ACTOR_NAME, COUNT(MOVIE_ID) AS MOVIE_COUNT FROM ROLE_MAPPING AS RM
INNER JOIN MOVIE AS M ON M.ID = RM.MOVIE_ID INNER JOIN RATINGS AS R USING(MOVIE_ID) INNER JOIN NAMES AS N ON N.ID = RM.NAME_ID
WHERE  R.MEDIAN_RATING >= 8 AND CATEGORY = 'ACTOR' GROUP  BY ACTOR_NAME ORDER  BY MOVIE_COUNT DESC LIMIT  2; 
-- Mammootty(8), Mohanlal (5) ARE THE TOP 2 ACTORS WHOSE MOVIES HAVE A MEDIAN RATING OF >=8.



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     PRODUCTION_COMPANY,
           SUM(TOTAL_VOTES) AS VOTE_COUNT,
           RANK() OVER(ORDER BY SUM(TOTAL_VOTES) DESC) AS PROD_COMP_RANK 
FROM MOVIE AS M INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID GROUP BY PRODUCTION_COMPANY limit 3;



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.NAME AS actor_name,
       Sum(r.total_votes) AS total_votes,
       Count(m.id) AS movie_count,
       Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actor_avg_rating,
       DENSE_RANK()
         OVER (ORDER BY Sum(r.avg_rating*r.total_votes)/Sum(r.total_votes) DESC) AS actor_rank
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON n.id = rm.name_id
       INNER JOIN movie AS m
               ON m.id = rm.movie_id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  rm.category = 'actor' AND country like '%India%'
GROUP  BY n.NAME
HAVING Count(m.id) >= 5; 


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name,
       Sum(r.total_votes) AS total_votes,
       Count(m.id) AS movie_count,
       Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating,
       DENSE_RANK()
         OVER (ORDER BY Sum(r.avg_rating*r.total_votes)/Sum(r.total_votes) DESC) AS actress_rank
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON n.id = rm.name_id
       INNER JOIN movie AS m
               ON m.id = rm.movie_id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  rm.category = 'actress' and m.languages like '%Hindi%' and country like '%India%'
GROUP  BY n.NAME
HAVING Count(m.id) >= 3
)
select * from top_actress where actress_rank<=5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating < 5 THEN 'Flop Movie'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch Movie'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit Movie'
        ELSE 'Superhit Movie'
    END AS movie_rating
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    g.genre = 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT GENRE,
		ROUND(AVG(duration),2) AS AVG_DURATION,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY GENRE ROWS UNBOUNDED PRECEDING) AS RUNNING_TOTAL_DURATION,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY GENRE ROWS 10 PRECEDING) AS MOVING_AVG_DURATION
FROM MOVIE AS M INNER JOIN GENRE AS G ON M.ID= G.MOVIE_ID GROUP BY GENRE ORDER BY GENRE;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 ), movie_summary AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
           FROM       movie                                                                     AS m
           INNER JOIN genre                                                                     AS g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_genres)
            GROUP BY   movie_name
           )
SELECT * FROM movie_summary WHERE movie_rank<=5 ORDER BY YEAR;
-- Top 3 Genres based on most number of movies



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
       Count(m.id) AS movie_count,
       Rank() over (ORDER BY Count(m.id) DESC) AS prod_comp_rank
FROM   movie AS m
       inner join ratings AS r
               ON m.id = r.movie_id
WHERE  r.median_rating >= 8
       AND Position("," IN m.languages) > 0
       AND m.production_company IS NOT NULL
GROUP  BY m.production_company
limit 2; 


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.NAME  AS actress_name,
       Sum(r.total_votes) AS total_votes,
       Count(rm.movie_id) AS movie_count,
       Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating,
       Rank() OVER (ORDER BY Count(rm.movie_id) DESC) AS actress_rank
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON rm.name_id = n.id
       INNER JOIN ratings AS r
               ON r.movie_id = rm.movie_id
       INNER JOIN genre AS g
               ON g.movie_id = r.movie_id
WHERE  g.genre = 'Drama'
       AND rm.category = 'actress'
       AND r.avg_rating > 8
GROUP  BY n.NAME
LIMIT 3; 


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH NEXTDATE_PUB_SUMMARY AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping AS d
           INNER JOIN names AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   NEXTDATE_PUB_SUMMARY)
SELECT   name_id AS director_id, NAME AS director_name, Count(movie_id) AS number_of_movies, Round(Avg(date_difference),2) AS avg_inter_movie_days,
Round(Avg(avg_rating),2) AS avg_rating,Sum(total_votes) AS total_votes,Min(avg_rating) AS min_rating,Max(avg_rating) AS max_rating,Sum(duration) AS total_duration
FROM top_director_summary GROUP BY director_id ORDER BY Count(movie_id) DESC limit 9;






