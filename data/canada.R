can <- read_xlsx("Canada/UAL_Serials_Expenditures_2014_2015_2016.xlsx")
can <- as.data.frame(can[, -3])
can <- as.data.frame(can[, -6])
names(can) <- c("Material", "Resource.type", as.character(2014:2016))
can <- melt(can, id = c("Material", "Resource.type"))
names(can) <- c("Material", "Resource.type", "Year", "Cost")
can$Country <- "Canada"
can$Currency <- "CAD"
