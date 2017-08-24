
url <- "tmp2.json"
library(RJSONIO)
df2 <- data.frame(
         t(sapply(
            RJSONIO::fromJSON(
               paste(readLines(url, warn = F), collapse = ""),
               encoding = "utf8"
            ),
            c
         )),
         stringsAsFactors = FALSE
      )
   

