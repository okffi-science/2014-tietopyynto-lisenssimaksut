library(dplyr)
library(tidyr)
library(reshape2)
library(ggplot2)
theme_set(theme_bw(20))

# License fee data URL
f <- "~/data/Tietopyynto/20160607\ Kustantajahintatiedot_koottu_v0.99.csv"

# Read the data
df <- read.csv(f, fileEncoding = "latin1")

# Rename
df$Kustantaja <- df$Kustantaja.Välittäjä
df$Kustantaja.Välittäjä <- NULL

p <- ggplot(df, aes(x=reorder(Organisaation.tyyppi, table(Organisaation.tyyppi)[Organisaation.tyyppi]))) + geom_bar() + ggtitle("Organisaation tyyppi") + coord_flip() + xlab("") + ylab("Tietoja (N)")
print(p)

p <- ggplot(df, aes(x=reorder(Organisaation.nimi, table(Organisaation.nimi)[Organisaation.nimi]))) + geom_bar() + ggtitle("Organisaatio") + coord_flip() + xlab("") + ylab("Tietoja (N)")
print(p)

p <- ggplot(df, aes(x=reorder(Kustantaja, table(Kustantaja)[Kustantaja]))) + geom_bar() + ggtitle("Kustantaja") + coord_flip() + xlab("") + ylab("Tietoja (N)")
print(p)

p <- ggplot(df, aes(x=reorder(Aineistotyyppi, table(Aineistotyyppi)[Aineistotyyppi]))) + geom_bar() + ggtitle("Aineistotyyppi") + coord_flip() + xlab("") + ylab("Tietoja (N)")
print(p)

p <- ggplot(df, aes(x=reorder(Hankintatapa, table(Hankintatapa)[Hankintatapa]))) + geom_bar() + ggtitle("Hankintatapa") + coord_flip() + xlab("") + ylab("Tietoja (N)")
print(p)

p <- ggplot(df, aes(x=reorder(Vuosi, table(Vuosi)[Vuosi]))) + geom_bar() + ggtitle("Vuosi") + coord_flip() + xlab("") + ylab("Tietoja (N)")
print(p)


# Hinta, Vuosi : all publishers
# Growth percentage compared to previous year is shown
dfs <- df %>% group_by(Vuosi) %>% summarise(Hinta = sum(Hinta)) %>% arrange(Vuosi)
p <- ggplot(dfs, aes(x = Vuosi, y = Hinta)) +
       geom_bar(stat = "identity") + ggtitle("Hintojen kehitys") +
       geom_text(data = dfs[-1,], aes(x = Vuosi, y = 1.042 * Hinta,
     label = round(100 * diff(dfs$Hinta)/dfs$Hinta[-length(dfs$Hinta)], 1)), size = 8) + 
       ylab("Hinta (EUR)")
print(p)

# Kokonaishinta : all publishers
dfs <- df %>% group_by(Kustantaja) %>% summarise(Hinta = sum(Hinta)) %>% arrange(desc(Hinta))
p <- ggplot(dfs, aes(x = Kustantaja, y = Hinta)) +
       geom_bar(stat = "identity") + ggtitle("Maksut yhteensä") +
       ylab("Hinta (EUR)")
print(p)

# Top-10 publishers (out of nrow(dfs)) correspond to 77% overall costs
sum(dfs$Hinta[1:10])/sum(dfs$Hinta)
top.publishers <- as.character(dfs$Kustantaja[1:10])

# Hinta, Vuosi : individual publishers compared
# Growth percentage compared to previous year is shown
dfs <- dplyr::filter(df, Kustantaja %in% top.publishers) %>% group_by(Vuosi, Kustantaja) %>% summarise(Hinta = sum(Hinta)) %>% arrange(Vuosi)
dfs$Kustantaja <- factor(dfs$Kustantaja, levels = top.publishers)
p <- ggplot(dfs, aes(x = Vuosi, y = Hinta, color = Kustantaja)) +
       geom_point() +
       geom_line() +       
       ggtitle("Kokonaishintojen kehitys kustantajittain") +
       ylab("Hinta (EUR)") 
print(p)



# Check relative increase in costs 2015 vs 2010
dfs <- df %>% group_by(Vuosi, Kustantaja) %>% summarise(Hinta = sum(Hinta)) %>% arrange(Vuosi)
dfss <- spread(dfs, Vuosi, Hinta)
kasvu <- unlist(dfss[, "2015"]/dfss[, "2010"]);
names(kasvu) <- as.character(dfss$Kustantaja)
sort(kasvu)


# Relative prices with 2010 baseline
# Top relative increase
kustantajat <- dfss[,1]
hinnat = as.matrix(dfss[, -1])
hinnat <- hinnat/hinnat[,1]
dfs2 <- as.data.frame(hinnat)
dfs2$Kustantaja <- as.character(unlist(kustantajat, use.names = F))
dfs2 <- dfs2[!is.na(dfs2[, "2015"]),]
dfs2 <- dfs2[rev(order(dfs2[, "2015"])),]
top <- as.character(unlist(dfs2$Kustantaja, use.names = F)[1:10])
dfs3 <- dfs[unlist(dfs$Kustantaja) %in% top,]
dfs3$Kustantaja <- as.character(unlist(dfs3$Kustantaja, use.names = F))
dfs3 <- melt(dfs3)
names(dfs3) <- c("Kustantaja", "Vuosi", "Hinta")
dfs3$Kustantaja <- factor(dfs3$Kustantaja, levels = top)
dfs3$Vuosi <- as.numeric(as.character(dfs3$Vuosi))
dfs3$Hinta <- as.numeric(as.character(dfs3$Hinta))
p <- ggplot(dfs3,
       aes(x = Vuosi, y = Hinta, color = Kustantaja)) +
       geom_point() +
       geom_line() +       
       ggtitle("Kokonaishintojen suhteellinen kehitys kustantajittain") +
       ylab("Hinta (EUR)") 
print(p)

