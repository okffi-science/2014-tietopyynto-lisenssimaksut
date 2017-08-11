fin <- read.csv("Finland/Publisher_Costs_FI_Full_Data.csv")
names(fin) <- gsub("Publisher.Supplier", "Publisher", names(fin))
fin$Country <- "Finland"
fin$Currency <- "EUR"
# These fields not available for the other countries
fin$Way.of.acquisition <- NULL
fin$Organization.type <- NULL
