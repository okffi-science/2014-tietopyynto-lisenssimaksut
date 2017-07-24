library(readxl)
library(readODS)
library(reshape)

# Finland EUR
fin <- read.csv("Finland/Publisher_Costs_FI_Full_Data.csv")
names(fin) <- gsub("Publisher.Supplier", "Publisher", names(fin))

# Argentina USD
# Starts always from July. Mark by the start year.
# Separate the total sum (almost exact match with colSums)
arg <- read_xls("Argentina/Cotizaciones 2008-2016 distribuidos por editor.xls")[2:19,]
colnames(arg) <- c("Publisher", as.character(2008:2016))
arg <- melt(as.data.frame(arg))
colnames(arg) <- c("Publisher", "Year", "Cost")

# Canada CAD
can <- read_xlsx("Canada/UAL_Serials_Expenditures_2014_2015_2016.xlsx")
can <- as.data.frame(can[, -3])
can <- as.data.frame(can[, -6])
names(can) <- c("Material", "Resource.type", as.character(2014:2016))
can <- melt(can, id = c("Material", "Resource.type"))
names(can) <- c("Material", "Resource.type", "Year", "Cost")

# France EUR
fra <- read.ods(file="France/Couts-Clermont-2009-2015.ods")[[1]]
colnames(fra) <- fra[4,]
fra <- fra[5:nrow(fra),]
fra[, 4:ncol(fra)] <- apply(fra[, 4:ncol(fra)], 2, function (x) {as.numeric(gsub(" ", "", gsub("\\,", ".", gsub(" €", "", x))))})

# Netherlands EUR
# (Jounals - detailed book pricing info not available - only summaries)
nld <- read_xlsx("Netherlands/Overview of costs incurred by universities for books and journals by publisher_2011_2015.xlsx", sheet = "Total as dataset")
# Remove summary expenses
nld <- nld[, -c(2,7)]
names(nld) <- c("Year", "Publisher", "Organization.abbrv", "Organization.name", "Cost")

# UK
uk1 <- read_xlsx("UK/Journal_publishing_cost_FOIs_UK_universities_2010_2014.xlsx", sheet = "Responses")
uk2015 <- read_xlsx("UK/Journalsubscost20152016v3_2015_2016.xlsx", sheet = "2015")
uk2016 <- read_xlsx("UK/Journalsubscost20152016v3_2015_2016.xlsx", sheet = "2016")



