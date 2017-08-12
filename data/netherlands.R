# (Jounals - detailed book pricing info not available - only summaries)
nld <- read_xlsx("Netherlands/Overzicht uitgaven per universiteit publiek EN_20170110.xlsx", sheet = "Total as dataset")
# Remove summary expenses
nld <- nld[, -c(2,7)]
names(nld) <- c("Year", "Publisher", "Organization.abbrv", "Organization.name", "Cost")
nld$Organization.abbrv <- NULL
nld$Country <- "Netherlands"
nld$Currency <- "EUR"
