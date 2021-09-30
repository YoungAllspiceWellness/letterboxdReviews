library(tidyverse)
library(rvest)
library(httr)
library(googledrive)
library(googlesheets4)
library(lubridate)

letterboxd <- function (x) {
  url <- read_html(paste('https://letterboxd.com/reviews/popular/this/week/page/', x, '/', sep = ''))
  bind_cols(name = url %>%
              html_nodes('.film-detail') %>%
              html_nodes('.name') %>%
              html_text(),
            date = url %>%
              html_nodes('._nobr') %>%
              html_text() %>%
              dmy(),
            title = url %>%
              html_nodes('.film-detail-content') %>%
              html_nodes('.headline-2') %>%
              html_node('a') %>%
              html_text2(),
            url %>%
              html_nodes('.film-detail-content') %>%
              html_nodes(c('.attribution')) %>%
              html_text() %>%
              as_tibble() %>%
              mutate( rating = map_chr(str_split(value, pattern = ' '), 3), .keep = 'none'),
            review = url %>%
              html_nodes('.film-detail-content') %>%
              html_nodes('.body-text') %>%
              html_attr('data-full-text-url')
  )
}

reviewsTable <- map_df(1:256, ~ letterboxd(.x))

#exchange <- bind_cols(character = unique(reviewsTable$rating), number = c(3.5, 5.0, 1.0, 4.5, NA, 2.0, 4.0, 2.5, .5, 1.5, 3.0))

#for (i in 1:length(reviewsTable$rating)) {      
  reviewsTable$numberRating[i] <- exchange$number[exchange$character == reviewsTable$rating[i]]
}

reviewsText <- {map_df(reviewsTable$review, ~ bind_rows(review = .x, 
                                                       text = read_html(paste('https://letterboxd.com', .x, sep = '')) %>%
                                                         html_text()))}

drive_get('Letterboxd Reviews') %>%
  sheet_append(reviewsTable, 'metadata')

drive_get('Letterboxd Reviews') %>%
  sheet_append(reviewsText, 'fullText')  

str_length(unique(reviewsTable$rating))

