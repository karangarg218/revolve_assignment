-- QUS1. Which manufacturer's planes had most no of flights? And how many flights?
FROM flights
GROUP BY tailnum
ORDER BY 2 DESC
