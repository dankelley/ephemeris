# See README.md and Makefile

library(oce)

query <- "https://ssp.imcce.fr/webservices/miriade/api/ephemcc.php?-name=s:Moon&-type=&-ep=(2020-01-01)&-nbd=5&-step=1d&-tscale=UTC&-observer=@500&-theory=INPOP&-teph=1&-tcoor=1&-oscelem=astorb&-mime=text/csv&-from=MiriadeDoc"

eph <- readLines(query)

col.names <- c("time", "RA", "DEC", "Dobs", "VMag", "Phase", "Elong.", "dRAcosDEC", "dDEC", "RV")
data <- read.csv(text=eph, skip=4, header=FALSE, col.names=col.names)
## RA and DEC are in '[sign]deg min sec' format
data$RAdeg <- sapply(data$RA, function(x) {
       s <- strsplit(trimws(x), " ")[[1]]
       as.integer(s[1]) + as.integer(s[2])/60 + as.integer(s[3])/3600
})
data$DECdeg <- sapply(data$DEC, function(x) {
       s <- strsplit(trimws(x), " ")[[1]]
       as.integer(s[1]) + as.integer(s[2])/60 + as.integer(s[3])/3600
})
data$time <- as.POSIXct(data$time, tz="UTC")
print(data)
par(mfrow=c(2, 1))
oce.plot.ts(data$time, data$RAdeg, type="o", ylab="Right Ascension")
oce.plot.ts(data$time, data$DECdeg, type="o", ylab="Declination")
