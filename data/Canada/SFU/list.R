
url <- "http://api.lib.sfu.ca/serialcosts/list?year=2012"
library(RJSONIO)
df <- data.frame(
         t(sapply(
            RJSONIO::fromJSON(
               paste(readLines(url, warn = F), collapse = ""),
               encoding = "utf8"
            ),
            c
         )),
         stringsAsFactors = FALSE
      )
   

