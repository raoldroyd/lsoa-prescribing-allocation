#install packages
install.packages('dplyr')

#load packages
library(dplyr)

#load prescribing data downloaded from OpenPrescribing
prescribing <- read.csv("items for antidepressant drugs per.csv")
#load GP practice data: 
#https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice/january-2026
gp_practice <- read.csv("gp-reg-pat-prac-lsoa-all.csv")

#aggregate the prescribing data by GP - this is the yearly mean over time (2021 to 2025)
presc_mean <- prescribing %>%
  mutate(year = format(as.Date(date, "%d/%m/%Y"), "%Y")) %>%
  group_by(id, name, year) %>%
  summarise(yearly_total = sum(y_items, na.rm = TRUE), .groups = "drop") %>%
  group_by(id, name) %>%
  summarise(
    mean_yearly_items = mean(yearly_total, na.rm = TRUE),
    .groups = "drop"
  )

# remove 'CLOSED' LSOAs
lsoa_final <- gp_practice %>%
  filter(LSOA_CODE != "CLOSED") %>%
  
  # total patients per practice
  group_by(PRACTICE_CODE) %>%
  mutate(total_patients = sum(NUMBER_OF_PATIENTS)) %>%
  ungroup() %>%
  
  # proportion within practice
  mutate(prop = NUMBER_OF_PATIENTS / total_patients) %>%
  
  # attach prescribing
  inner_join(presc_mean, by = c("PRACTICE_CODE" = "id")) %>%
  
  # allocate prescriptions
  mutate(lsoa_items = mean_yearly_items * prop) %>%
  
  # aggregate to LSOA
  group_by(LSOA_CODE) %>%
  summarise(
    total_items = sum(lsoa_items),
    population  = sum(NUMBER_OF_PATIENTS),
    .groups = "drop"
  ) %>%
  
  # calculate rate
  mutate(
    items_per_patient = total_items / population,
    items_per_1000    = items_per_patient * 1000
  )
