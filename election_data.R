library(tidyverse)
library(ggbiplot)
library(plotly)
#library(devtools)
#install_github("vqv/ggbiplot")

#Making sure the output in console is readable
#Sys.setlocale("LC_CTYPE", "bulgarian")

#Links to files
parties_link <-'https://raw.githubusercontent.com/krumeto/Elections_data/main/elections/elections_2021_july/cik_parties_11.07.2021.txt'
sections_link <- 'https://raw.githubusercontent.com/krumeto/Elections_data/main/elections/elections_2021_july/sections_11.07.2021.txt'
votes_link <- "https://raw.githubusercontent.com/krumeto/Elections_data/main/elections/elections_2021_july/votes_11.07.2021.txt"

#functions
read_parties_table <- function(link_to_file){
  read.delim(link_to_file, 
             sep=";", 
             encoding = "UTF-8",
             header = FALSE,
             col.names = c('party_index', 'party_name')
             )
}

read_sections_table <- function(link_to_file){
  read.delim(link_to_file, 
             sep=";", 
             encoding = "UTF-8",
             header = FALSE,
             col.names = c('section_code', 'administrative_entity_code', 'administrative_entity_name', 'ekatte_code', 'location', 'mobile_section?', 'ship_section?', 'machine_number')
  )
}

read_prep_votes_table <- function(link_to_file, party_df){
  votes <- read.delim(link_to_file, 
             sep=";", 
             encoding = "UTF-8",
             header = FALSE
  )
  names(votes)[1] <- 'form_number'
  names(votes)[2] <- 'section_code'
  names(votes)[3] <- 'identificator_administrative_entity'
  
  
  names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 0] <- party_df$party_name
  names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 1] <- paste(party_df$party_name, "_votes", sep='')
  
  votes
}

extract_votes_per_party <- function(votes_df, party_name){
  
  votes_df %>% 
    select(starts_with(c('form_number', 'section_code', 'identificator_administrative_entity'))|starts_with(party_name)) %>% 
    rename(party_index := !!party_name) %>% 
    rename(votes_count := !!paste(party_name, "_votes", sep='')) 
  
}

finalize_votes_df <- function(votes_link, parties_df){
  
  raw_df <- read_prep_votes_table(votes_link, parties_df)
  
  datalist <- list()
  
  for (party_ix in seq_along(parties_df$party_name)) {
    temp_df <- extract_votes_per_party(raw_df, parties_df$party_name[party_ix])
    datalist[[party_ix]] <- temp_df
  }
  
  full_votes_df <- bind_rows(datalist)
  full_votes_df
}

finalize_votes_df(votes_link, parties)


sections <- read_sections_table(sections_link)

parties <- read_parties_table(parties_link)

votes <- finalize_votes_df(votes_link, parties)


votes %>% 
  group_by(party_index) %>% 
  summarize(sum_votes = sum(votes_count, na.rm = TRUE)) %>% 
  mutate(percent_votes = sum_votes/sum(sum_votes, na.rm = TRUE)) %>% 
  ggplot(.,aes(x=party_index, y = percent_votes)) + 
  geom_bar(stat="identity") + 
  scale_x_continuous()+
  coord_flip()

 votes_by_section <- votes %>% 
                       group_by(section_code , party_index) %>% 
                       summarize(sum_votes = sum(votes_count, na.rm = TRUE)) %>% 
                     #  mutate(percent_votes = sum_votes/sum(sum_votes, na.rm = TRUE)) %>% 
                       pivot_wider(names_from = party_index, values_from = sum_votes) %>% 
                       tail(-4) %>% 
                       select(-one_of(c('NA')))

 votes_by_section %>% 
   mutate(sum = rowSums(across(where(is.numeric))))

 perc_votes_by_section <-  votes %>% 
                       group_by(section_code , party_index) %>% 
                       summarize(sum_votes = sum(votes_count, na.rm = TRUE)) %>% 
                       mutate(perc_votes = sum_votes / sum(sum_votes))  %>% 
                       select(-one_of(c('sum_votes'))) %>%
                       pivot_wider(names_from = party_index, values_from = perc_votes) %>% 
                       tail(-4) %>% 
                       select(-one_of(c('NA')))


 
 perc_votes_by_section %>% 
   ungroup() %>% 
   select(-section_code) %>% 
   prcomp(center = TRUE,scale. = TRUE) %>% 
   ggbiplot(ellipse=TRUE, alpha = 0.05, labels = c(perc_votes_by_section$section_code)) %>% 
   ggplotly()
 

 
 
 

 
 
 
 
 
 

votes <- read.delim(votes_link, 
           sep=";", 
           encoding = "UTF-8",
           header = FALSE
)

names(votes)[1] <- 'form_number'
names(votes)[2] <- 'section_code'
names(votes)[3] <- 'identificator_administrative_entity'


names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 0] <- parties$party_name
names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 1] <- paste(parties$party_name, "_votes", sep='')


for (parti in parties$party_name) {
  print(parti)
  standard_cols <- c(names(votes)[1:3])
  party_cols <- names(votes)[grepl(parti, names(votes))]
  votes %>% select(append(standard_cols, party_cols)) %>% head(5) %>% print()
}


votes %>% 
  head(100) %>% 
  group_by(section_code) %>% 
  rowwise() %>% 
  summarize(
    party = mean(names(votes)[grepl('_votes', names(votes))])
  )


names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 0] <- 'party'
names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 1] <- 'votes'

votes %>% 
  pivot_longer(c(names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 0], names_to = 'party_name')
               
  
party_cols <- select(votes, names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 0])
votes_cols <- select(votes, names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %% 2 == 1])
               
bind_cols(party_cols, votes_cols) %>% tail(5)
  
paste(parties$party_name, "_votes")

for (parti in parties$party_name) {
  print(parti)
  
}




test <- read_prep_votes_table(votes_link, parties)

datalist <- list()

for (party_ix in seq_along(parties$party_name)) {
  temp_df <- extract_votes_per_party(test, parties$party_name[party_ix])
  datalist[[party_ix]] <- temp_df
}

full_votes_df <- bind_rows(datalist)

full_votes_df %>% 
  group_by(party_index) %>% 
  summarize(sum_votes = sum(votes_count, na.rm = TRUE)) %>% 
  mutate(percent_votes = sum_votes/sum(sum_votes, na.rm = TRUE)) %>% 
  View()

extract_votes_per_party(test, test_party)