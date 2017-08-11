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

# Harmonize synonymes
# To be combined between datasets 2010-2014 vs. 2015-2016
uk$Organization.name <- gsub("St Mary's University, Twickenham", "St Mary's University College", uk$Organization.name)

uk$Organization.name <- gsub("London School of Economics and Political Science", "London School of Economics", uk$Organization.name)

uk$Organization.name <- gsub("Universiity", "University", uk$Organization.name)

uk$Organization.name <- gsub("University of Wales, Trinity St David", "University of Wales Trinity St David", uk$Organization.name)

uk$Publisher <- gsub("IOP", "Institute of Physics Publishing", uk$Publisher)
uk$Publisher <- gsub("RSC", "Royal Society of Chemistry", uk$Publisher)
