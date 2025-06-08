select * from netflix;

-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows.

select 
	type,
	count(*)from netflix
group by 1;

-- 2. Find the most common rating for Movies and TV Shows
select 
	type,
	rating
	from
(select
	type,
	rating,
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
from netflix 
group by 1,2)
as t1
where ranking = 1;



-- 3. List all the movies released in a specific year (e.g., 2020)

select * from netflix 
where type = 'Movie'
	 and release_year = 2020;


-- 4. find the top five countries with the most content on Netflix

select unnest(string_to_array(country,',')) as new_country,	
	   count(show_id)
from netflix
group by 1
order by 2 desc
limit 5 ;


-- 5. Identify the longest Movie 

select * from netflix
where type = 'Movie'
and duration = (select max(duration) from netflix)

-- 6. Find content added in the last 5 years

select 	
	* 
from netflix 
	where to_date(date_added,'Month DD,YYYY')>= current_date - Interval '5 years'

-- 7. Find all the Movies/TV Shows directed by 'Rajiv Chilaka'

select * 	
	from netflix
where 	
	director like '%Rajiv Chilaka%'


-- 8. List all TV Shows with more than 5 seasons
select * from netflix
select *
from netflix
where 
	type = 'TV Show' and
	split_part(duration,' ',1)::numeric > 5;

-- 9. Count the numbers of content items in each genre
select unnest(string_to_array(listed_in,',')) as genre,	
	   count(show_id) as total_content
	   from netflix
group by 1;


-- 10. Find the average release year for content released by India on Netflix.
-- return Top 5 year with highest avg content release
select 
	extract(year from to_date(date_added, 'Month DD,YYYY')) as year,
	count(*) as yearly_content,
	round(
	count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric * 100,2) as avg_content_per_year
from netflix
where country = 'India'
group by 1
order by 1;

-- 11. List all movies that are documentaries
select *  
	from netflix
	where 
listed_in ilike '%documentaries%';

-- 12. Find all content without director
select * 
	from 	
	netflix 
where director is null;


-- 13. Find how many movies acor 'Salman Khan' appeared in last 10 years

select * 
	from netflix
	where casts ilike '%salman khan%' 
	and 
	release_year > extract(year from current_date) - 10 



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced 

select 	
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
-- Label content containing these keywords as 'Bad' and all other content as 'Good'.
-- Count how many items fall into each category.
with new_table
as(
select *, 
	case when description ilike '%kill%'
	or
	description ilike '%violence%' then 'Bad content'
	else 'Good content'
	end category
from netflix
)
select category,
		count(*) as total
	from new_table
group by category;