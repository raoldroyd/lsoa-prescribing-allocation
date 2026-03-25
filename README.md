# LSOA Prescribing Allocation

Estimate LSOA-level prescribing rates by allocating GP practice data using patient distributions.

## Overview

This project redistributes GP practice-level prescribing data to neighbourhood level (LSOA) using NHS England patient registration data.

## Data

  ### Extracting prescribing data

    Prescribing data (practice-level prescribing, item counts) were obtained using the OpenPrescribing search tool:
    
    https://openprescribing.net/analyse/
    
    - Data extracted at GP practice level  
    - Measure: item counts  
    - Time period: 2021–2025  
    - Geography: Sub-ICB (Leeds)  
    
    Data were downloaded as a CSV file and processed in R.

  ### Downloading patients registered at a GP practice

  * GP practice – LSOA patient registration data (patient counts by LSOA):
    https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice
  
    Dataset used:
    *gp-reg-pat-prac-lsoa-male-female-Jan-26.zip*
  
    Direct download:
    https://files.digital.nhs.uk/5E/95A783/gp-reg-pat-prac-lsoa-male-female-Jan-26.zip

Data were accessed in January 2026.

## Method

1. Calculate mean yearly prescribing per GP practice (2021–2025) using item counts
2. Calculate proportion of patients in each LSOA
3. Allocate prescribing to LSOAs using these proportions
4. Aggregate to LSOA level
5. Calculate prescribing rates per patient

## Output

* LSOA-level prescribing volume (items)
* Population (registered GP patients)
* Items per patient
* Items per 1000 patients

## How to run
This project uses R to process and analyse prescribing data. 

```r
library(dplyr)
source("scripts/lsoa_prescribing_allocation.R")
```

## Notes

* Uses GP-registered population
* Prescribing is measured using item counts from OpenPrescribing
* Assumes prescribing is proportional to patient distribution within practices

## License

MIT
