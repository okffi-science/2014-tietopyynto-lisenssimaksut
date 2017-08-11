library(readxl)
library(readODS)
library(reshape)
library(dplyr)
library(bibliographica)

datasets <- list()

print("Finland EUR")
source("finland.R")
datasets[["Finland"]] <- fin

print("Argentina USD")
source("argentina.R")
datasets[["Argentina"]] <- arg

print("Canada CAD")
source("canada.R")
datasets[["Canada"]] <- can

print("France EUR")
source("france.R")
datasets[["France"]] <- fra

print("Netherlands EUR")
source("netherlands.R")
datasets[["Netherlands"]] <- nld

print("UK / GBP")
source("uk.R")
datasets[["UK"]] <- uk

#print("USA")
#source("us.R")
#datasets[["US"]] <- us

# -------------------------------------------------

print("Harmonize")

datasets <- lapply(datasets, as_data_frame)
for (i in 1:length(datasets)) {
  print(i)
  datasets[[i]]$Year <- as.numeric(as.character(datasets[[i]]$Year))
  datasets[[i]]$Cost <- as.numeric(as.character(datasets[[i]]$Cost))
}

# ------------------------------------------------------

source("exchange_rates.R")

# -------------------------------------------------

print("Combine the datasets")
d <- bind_rows(datasets)
d <- d %>% rename(Organization = Organization.name)
d <- d[, c("Country", "Year", "Organization", "Publisher", "Material", "Resource.type", "CostUSD")]
d$Country <- as.factor(d$Country)
d$Organization <- as.factor(d$Organization)
d$Publisher <- as.factor(d$Publisher)
d$Material <- tolower(d$Material)
d$Resource.type <- tolower(d$Resource.type)

# Let us leave Canada out as there was no Publisher information
d <- filter(d, !Country == "Canada")
d$Country <- droplevels(d$Country)


# Add costs in EUR
for (t in unique(d$Year)) {

  # Exchange rate from USD to EUR
  rate <- 1/subset(exr, Country == "FIN" & Year == t)$Rate

  # Convert from USD to EUR
  d$CostEUR <- d$CostUSD / rate

}

# All costs are now in EUR
d$Cost <- d$CostEUR
d$CostEUR <- NULL

# --------------------------

# Combine duplicate publishers
write.csv(sort(names(table(d$Publisher))), file = "pubs.csv", row.names = F, quote = F)
write.csv(sort(names(table(d$Material))), quote = F, row.names = F, file = "material.csv")
write.csv(sort(names(table(d$Resource.type))), quote = F, row.names = F, file = "Resourcetype.csv")
write.csv(sort(names(table(d$Organization))), quote = F, row.names = F, file = "Organization.csv")

# ---------------------------

# Read the manually constructed file of publisher synonymes
pubs <- read_mapping("publisher_synonymes.csv", from = "orig", to = "name", sep = "\t")
names(pubs) <- c("synonyme", "name")
library(bibliographica)
d$Publisher <- map(d$Publisher, pubs)
d$Publisher <- as.factor(d$Publisher)

# Arrange
d <- d %>% arrange(Country, Year, Publisher)

# Full table
d.full <- d
write.table(d.full, file = "table_full.csv", sep = "\t", quote = FALSE, row.names = FALSE)

# Filtered table
d.filt <- d.full %>%
  select(Country, Year, Publisher, Cost) %>%
  group_by(Country, Year, Publisher) %>%
  summarise(Totalcost = sum(Cost, na.rm = TRUE))

write.table(d.filt, file = "table_summarized.csv", sep = "\t", quote = FALSE, row.names = FALSE)

