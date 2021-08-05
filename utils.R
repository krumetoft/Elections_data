library(tidyverse)

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
