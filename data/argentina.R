# Starts always from July. Mark by the start year.
# Separate the total sum (almost exact match with colSums)
arg <- read_xls("Argentina/Cotizaciones 2008-2016 distribuidos por editor.xls")[2:19,]
colnames(arg) <- c("Publisher", as.character(2008:2016))
arg <- melt(as.data.frame(arg))
colnames(arg) <- c("Publisher", "Year", "Cost")
arg$Country <- "Argentina"
arg$Currency <- "USD"
