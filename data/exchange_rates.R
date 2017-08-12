# Exchange rates w.r.t. USD
exr <- read.csv("OECD/DP_LIVE_11082017090329570.csv", sep = ",")
names(exr) <- gsub("LOCATION", "Country", names(exr))
names(exr) <- gsub("TIME", "Year", names(exr))
names(exr) <- gsub("Value", "Rate", names(exr))
exr <- exr[, c("Country", "Year", "Rate")]

for (t in unique(datasets$Finland$Year)) {

  # Exchange rate to USD
  rate <- subset(exr, Country == "FIN" & Year == t)$Rate

  # Convert to USD
  datasets$Finland$CostUSD <- datasets$Finland$Cost / rate

}

for (t in unique(datasets$France$Year)) {

  # Exchange rate to USD
  rate <- subset(exr, Country == "FRA" & Year == t)$Rate

  # Convert to USD
  datasets$France$CostUSD <- datasets$France$Cost / rate

}

for (t in unique(datasets$Netherlands$Year)) {

  # Exchange rate to USD
  rate <- subset(exr, Country == "NLD" & Year == t)$Rate

  # Convert to USD
  datasets$Netherlands$CostUSD <- datasets$Netherlands$Cost / rate

}

# Already in USD
datasets$Argentina$CostUSD <- datasets$Argentina$Cost
datasets$Chile$CostUSD <- datasets$Chile$Cost

for (t in unique(datasets$Canada$Year)) {

  # Exchange rate to USD
  rate <- subset(exr, Country == "CAN" & Year == t)$Rate

  # Convert to USD
  datasets$Canada$CostUSD <- datasets$Canada$Cost / rate

}

for (t in unique(datasets$UK$Year)) {

  # Exchange rate to USD
  rate <- subset(exr, Country == "GBR" & Year == t)$Rate

  # Convert to USD
  datasets$UK$CostUSD <- datasets$UK$Cost / rate

}



# Add costs in EUR
for (country in names(datasets)) {

  for (t in unique(datasets[[country]]$Year)) {
  
    # Exchange rate from USD to EUR
    rate <- 1/subset(exr, Country == "FIN" & Year == t)$Rate

    # Convert from USD to EUR
    datasets[[country]]$CostEUR <- datasets[[country]]$CostUSD / rate
    datasets[[country]]$CostNAT <- datasets[[country]]$Cost
    # All costs are now in EUR
    datasets[[country]]$Cost <- datasets[[country]]$CostEUR    
    
  }
  
}




