chi <- read.csv("Chile/memo2015_Page17_Table4.csv", sep = "\t")
chi <- melt(chi)
names(chi) <- c("Publisher", "Year", "Cost")
chi$Currecy <- rep("USD", nrow(chi))
chi$Year <- as.numeric(gsub("^X", "", chi$Year))
chi$Country <- "Chile"