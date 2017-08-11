# (Jounals - detailed book pricing info not available - only summaries)
nld <- read_xlsx("Netherlands/Overview of costs incurred by universities for books and journals by publisher_2011_2015.xlsx", sheet = "Total as dataset")
# Remove summary expenses
nld <- nld[, -c(2,7)]
names(nld) <- c("Year", "Publisher", "Organization.abbrv", "Organization.name", "Cost")
nld$Organization.abbrv <- NULL
nld$Country <- "Netherlands"
nld$Currency <- "EUR"
