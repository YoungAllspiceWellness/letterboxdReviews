# letterboxdReviews
Database of Letterboxd reviews

The attached script scrapes the text and corresponding metadata for every review on Letterboxd's most popular page, creating two relational tables: one holds the metadata and the other holds the text. Each review's fulltext URL functions as the primary key in both tables, allowing for a simple join of desired fields. With the reiews and their metadata in this form factor, one can easily perform any desired analaysis, including natural language processing. Currently, a googlesheets document stores the data, but one can easily modify the script to write to a prefered database. You can also automate the script with the cron package and I have done this on an AWS micro EC2 instance in the past. 
