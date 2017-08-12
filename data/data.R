library(readxl)
library(readODS)
library(reshape)
library(dplyr)
library(bibliographica)

datasets <- list()

# Not included as the source could not be verified
#print("Argentina USD")
#source("argentina.R")
#datasets[["Argentina"]] <- arg

print("Canada CAD")
source("canada.R")
datasets[["Canada"]] <- can

# TODO Chile:
# Can be manually copied from Spanish PDFs
# http://www.cincel.cl/content/view/90/50/
print("Chile USD")
source("chile.R")
datasets[["Chile"]] <- chi

print("Finland EUR")
source("finland.R")
datasets[["Finland"]] <- fin

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
d <- d[, c("Country", "Year", "Organization", "Publisher", "Material", "Resource.type", "CostUSD", "CostEUR", "CostNAT", "Cost")]
d$Country <- as.factor(d$Country)
d$Organization <- as.factor(d$Organization)
d$Publisher <- as.factor(d$Publisher)
d$Material <- tolower(d$Material)
d$Resource.type <- tolower(d$Resource.type)

# Let us leave Canada out as there was no Publisher information
d <- filter(d, !Country == "Canada")
d$Country <- droplevels(d$Country)

# --------------------------

write.csv(sort(names(table(d$Publisher))), file = "pubs.csv", row.names = F, quote = F)
write.csv(sort(names(table(d$Material))), quote = F, row.names = F, file = "material.csv")
write.csv(sort(names(table(d$Resource.type))), quote = F, row.names = F, file = "Resourcetype.csv")
write.csv(sort(names(table(d$Organization))), quote = F, row.names = F, file = "Organization.csv")

# ---------------------------

# Read the manually constructed file of publisher synonymes
pubs <- read_mapping("publisher_synonymes.csv", from = "orig", to = "name", sep = "\t", self.match = TRUE)
names(pubs) <- c("name", "synonyme")
library(bibliographica)
dbu <- d
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

# -------------

# GDP data
gdp <- read_excel("Supporting/GDP/Download-GDPcurrent-NCU-countries.xls")
colnames(gdp) <- as.character(gdp[2,])
gdp <- gdp[3:nrow(gdp),]
gdp <- subset(gdp, IndicatorName == "Gross Domestic Product (GDP)")

# University Ranking
# Our France Clemont University is not in the list (manually checked)
unirank <- read.csv("Supporting/UniRank/timesData.csv")
# Harmonize names with the other data sets
names(unirank) <- gsub("year", "Year", names(unirank))
names(unirank) <- gsub("university_name", "Organization", names(unirank))
names(unirank) <- gsub("country", "Country", names(unirank))
unirank$Country <- gsub("United Kingdom","UK",unirank$Country)
#unirank$world_rank <- gsub("^=", "", unirank$world_rank)
# For interpretability, remove rankings that are not unique numerics
unirank$world_rank <- gsub("-[0-9]+", "", gsub("^=*", "", unirank$world_rank))
unirank$world_rank[unirank$world_rank == ""] <- NA
unirank$world_rank <- as.numeric(unirank$world_rank)

