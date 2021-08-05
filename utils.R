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

read_prep_votes_2021_July <- function(link_to_file, party_df){
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

read_prep_votes_2021_April<- function(link_to_file, party_df){
  votes <- read.delim(link_to_file, 
                      sep=";", 
                      encoding = "UTF-8",
                      header = FALSE
  )
  names(votes)[1] <- 'section_code'
  names(votes)[2] <- 'identificator_administrative_entity'
  
  party_name_col_numbers <- seq(3,126,4)
  party_total_votes_col_numbers <- seq(4,126,4)
  party_votes_paper_col_numbers <- seq(5,126,4)
  party_votes_machines_col_numbers <- seq(6,126,4)
  
  
  names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %in% party_name_col_numbers] <- party_df$party_name
  names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %in% party_total_votes_col_numbers] <- paste(party_df$party_name, "_votes", sep='')
  names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %in% party_votes_paper_col_numbers] <- paste(party_df$party_name, "_paper_votes", sep='')
  names(votes)[grepl("V", names(votes)) & parse_number(names(votes)) %in% party_votes_machines_col_numbers] <- paste(party_df$party_name, "_machine_votes", sep='')
  
  votes
}

read_prep_votes_table <- function(link_to_file, party_df, elections){
  
  if ('april' %in% elections){
    votes <- read_prep_votes_2021_April(link_to_file, party_df)
  } else {
    votes <- read_prep_votes_2021_July(link_to_file, party_df)
  }
  votes
}

extract_votes_per_party <- function(votes_df, party_name){
  
  votes_df %>% 
    select(starts_with(c('form_number', 'section_code', 'identificator_administrative_entity'))|starts_with(party_name)) %>% 
    rename(party_index := !!party_name) %>% 
    rename(votes_count := !!paste(party_name, "_votes", sep='')) 
}

finalize_votes_df <- function(votes_link, parties_df, elections){
  
  raw_df <- read_prep_votes_table(votes_link, parties_df, elections)
  
  datalist <- list()
  
  for (party_ix in seq_along(parties_df$party_name)) {
    temp_df <- extract_votes_per_party(raw_df, parties_df$party_name[party_ix])
    datalist[[party_ix]] <- temp_df
  }
  
  full_votes_df <- bind_rows(datalist)
  full_votes_df
}
