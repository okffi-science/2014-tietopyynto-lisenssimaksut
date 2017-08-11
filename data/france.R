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
