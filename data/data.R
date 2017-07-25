library(readxl)
library(readODS)
library(reshape)
library(dplyr)
library(bibliographica)

datasets <- list()

print("Finland EUR")
fin <- read.csv("Finland/Publisher_Costs_FI_Full_Data.csv")
names(fin) <- gsub("Publisher.Supplier", "Publisher", names(fin))
fin$Country <- "Finland"
fin$Currency <- "EUR"
# These fields not available for the other countries
fin$Way.of.acquisition <- NULL
fin$Organization.type <- NULL
datasets[["Finland"]] <- fin

print("Argentina USD")
# Starts always from July. Mark by the start year.
# Separate the total sum (almost exact match with colSums)
arg <- read_xls("Argentina/Cotizaciones 2008-2016 distribuidos por editor.xls")[2:19,]
colnames(arg) <- c("Publisher", as.character(2008:2016))
arg <- melt(as.data.frame(arg))
colnames(arg) <- c("Publisher", "Year", "Cost")
arg$Country <- "Argentina"
arg$Currency <- "USD"
datasets[["Argentina"]] <- arg

print("Canada CAD")
can <- read_xlsx("Canada/UAL_Serials_Expenditures_2014_2015_2016.xlsx")
can <- as.data.frame(can[, -3])
can <- as.data.frame(can[, -6])
names(can) <- c("Material", "Resource.type", as.character(2014:2016))
can <- melt(can, id = c("Material", "Resource.type"))
names(can) <- c("Material", "Resource.type", "Year", "Cost")
can$Country <- "Canada"
can$Currency <- "CAD"
datasets[["Canada"]] <- can

print("France EUR")
fra <- read.ods(file="France/Couts-Clermont-2009-2015.ods")[[1]]
colnames(fra) <- fra[4,]
fra <- fra[5:nrow(fra),]
fra[, 4:ncol(fra)] <- apply(fra[, 4:ncol(fra)], 2, function (x) {as.numeric(gsub(" ", "", gsub("\\,", ".", gsub(" €", "", x))))})
names(fra) <- c("Publisher", "Resource", "Resource.type", 2009:2015)
fra <- melt(fra, id = c("Publisher", "Resource", "Resource.type")) %>% rename(Year = variable, Cost = value)
fra$Country <- "France"
fra$Currency <- "EUR"
fra <- fra %>% rename(Material = Resource)
fra <- fra[1:412,] # Drop the total sum row
datasets[["France"]] <- fra

print("Netherlands EUR")
# (Jounals - detailed book pricing info not available - only summaries)
nld <- read_xlsx("Netherlands/Overview of costs incurred by universities for books and journals by publisher_2011_2015.xlsx", sheet = "Total as dataset")
# Remove summary expenses
nld <- nld[, -c(2,7)]
names(nld) <- c("Year", "Publisher", "Organization.abbrv", "Organization.name", "Cost")
nld$Organization.abbrv <- NULL
nld$Country <- "Netherlands"
nld$Currency <- "EUR"
datasets[["Netherlands"]] <- nld

print("UK / GBP")
uk1.init <- read_xlsx("UK/Journal_publishing_cost_FOIs_UK_universities_2010_2014.xlsx", sheet = "Responses")
uk1 <- uk1.init[, -2]
# Format header
h <- cbind(colnames(uk1)[-1], unlist(as.data.frame(uk1)[1,-1]))
rownames(h) <- NULL
h[,1] <- gsub("^X_+[0-9]+$", "", h[,1])
for (i in 1:nrow(h)) {
  x <- h[i,1]
  if (!x == "") {
    publisher <- x
  } else if (x == "") {
    h[i,1] <- publisher
  }
}
colnames(h) <- c("Publisher", "Year")
library(tidyr)
# Combine the publisher (header) and year (first row)
h <- tidyr::unite(data.frame(h), "pub_year", c("Publisher", "Year"), sep = "-")
# Remove the year row
uk1 <- uk1[-1,]
uk1 <- as.data.frame(uk1)
colnames(uk1) <- c("Organization.name", h[,1])
# Drop the last two summary rows
uk1 <- uk1[1:153,]
uk_2010_2014 <- melt(uk1) %>% separate(variable, c("Publisher", "Year"), sep = "-") %>% rename(Cost = value)
uk_2010_2014$Year <- as.numeric(uk_2010_2014$Year)

uk2015 <- read_xlsx("UK/Journalsubscost20152016v3_2015_2016.xlsx", sheet = "2015")
uk2015 <- melt(as.data.frame(uk2015)[1:153, 1:9])
names(uk2015) <- c("Organization.name", "Publisher", "Cost")
uk2015$Year <- 2015

uk2016 <- read_xlsx("UK/Journalsubscost20152016v3_2015_2016.xlsx", sheet = "2016")
uk2016 <- melt(as.data.frame(uk2016)[1:153, 1:9])
names(uk2016) <- c("Organization.name", "Publisher", "Cost")
uk2016$Year <- 2016

# Combine UK 2010-2016
uk <- bind_rows(uk_2010_2014, uk2015, uk2016)
uk$Country <- "UK"
uk$Currency <- "GBP"

datasets[["UK"]] <- uk

# ---------------------------

print("Harmonize")

datasets <- lapply(datasets, as_data_frame)
for (i in 1:length(datasets)) {
  print(i)
  datasets[[i]]$Year <- as.numeric(as.character(datasets[[i]]$Year))
  datasets[[i]]$Cost <- as.numeric(as.character(datasets[[i]]$Cost))
}

print("Combine the datasets")
d <- bind_rows(datasets)
d <- d %>% rename(Organization = Organization.name)
d <- d[, c("Country", "Year", "Organization", "Publisher", "Material", "Resource.type", "Cost", "Currency")]
d$Country <- as.factor(d$Country)
d$Organization <- as.factor(d$Organization)
d$Publisher <- as.factor(d$Publisher)
d$Material <- tolower(d$Material)
d$Resource.type <- tolower(d$Resource.type)

# Let us leave Canada out as there was no Publisher information
d <- filter(d, !Country == "Canada")
d$Country <- droplevels(d$Country)

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
  select(Country, Year, Publisher, Cost, Currency) %>%
  group_by(Country, Year, Publisher) %>%
  summarise(Totalcost = sum(Cost, na.rm = TRUE))

write.table(d.filt, file = "table_summarized.csv", sep = "\t", quote = FALSE, row.names = FALSE)

