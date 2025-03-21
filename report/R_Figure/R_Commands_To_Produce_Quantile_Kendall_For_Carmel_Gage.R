# From Bob Hirsch's blog post:  https://owi.usgs.gov/blog/Quantile-Kendall/

library(rkt)
library(zyp)
library(lubridate)

#########################################################################################
########## this is the function you will use to make a single trend graph  ##############
#########################################################################################

plotFlowTrend <- function (eList, istat, startDate = NA, endDate = NA, 
                           paStart = 4, paLong = 12, window = 30, qMax = NA, 
                           printTitle = TRUE, tinyPlot = FALSE, 
                           customPar = FALSE, runoff = FALSE,
                           qUnit = 2, printStaName = TRUE, printPA = TRUE,
                           printIstat = TRUE, cex = 0.8, cex.axis = 1.1,
                           cex.main = 1.1, lwd = 2, col = "black", ...){
  localDaily <- getDaily(eList)
  localINFO <- getInfo(eList)
  localINFO$paStart <- paStart
  localINFO$paLong <- paLong
  localINFO$window <- window
  start <- as.Date(startDate)
  end <- as.Date(endDate)
  
  if(is.na(startDate)){
    start <- as.Date(localDaily$Date[1]) 
  } 
  
  if(is.na(endDate)){
    end <- as.Date(localDaily$Date[length(localDaily$Date)])
  }
  
  localDaily <- subset(localDaily, Date >= start & Date <= end)
  eList <- as.egret(localINFO,localDaily)
  localAnnualSeries <- makeAnnualSeries(eList)
  qActual <- localAnnualSeries[2, istat, ]
  qSmooth <- localAnnualSeries[3, istat, ]
  years <- localAnnualSeries[1, istat, ]
  Q <- qActual
  time <- years
  LogQ <- log(Q)
  mktFrame <- data.frame(time,LogQ)
  mktFrame <- na.omit(mktFrame)
  mktOut <- rkt::rkt(mktFrame$time,mktFrame$LogQ)
  zypOut <- zyp::zyp.zhang(mktFrame$LogQ,mktFrame$time)
  slope <- mktOut$B
  slopePct <- 100 * (exp(slope)) - 100
  slopePct <- format(slopePct,digits=2)
  pValue <- zypOut[6]
  pValue <- format(pValue,digits = 3)
  
  if (is.numeric(qUnit)) {
    qUnit <- qConst[shortCode = qUnit][[1]]
  } else if (is.character(qUnit)) {
    qUnit <- qConst[qUnit][[1]]
  }
  
  qFactor <- qUnit@qUnitFactor
  yLab <- qUnit@qUnitTiny
  
  if (runoff) {
    qActual <- qActual * 86.4/localINFO$drainSqKm
    qSmooth <- qSmooth * 86.4/localINFO$drainSqKm
    yLab <- "Runoff in mm/day"
  } else {
    qActual <- qActual * qFactor
    qSmooth <- qSmooth * qFactor
  }
  
  localSeries <- data.frame(years, qActual, qSmooth)
  
  
  yInfo <- generalAxis(x = qActual, maxVal = qMax, minVal = 0, 
                       tinyPlot = tinyPlot)
  xInfo <- generalAxis(x = localSeries$years, maxVal = decimal_date(end), 
                       minVal = decimal_date(start), padPercent = 0, tinyPlot = tinyPlot)
  
  line1 <- localINFO$shortName
  nameIstat <- c("minimum day", "7-day minimum", "30-day minimum", 
                 "median daily", "mean daily", "30-day maximum", "7-day maximum", 
                 "maximum day")
  
  line2 <-  paste0("\n", setSeasonLabelByUser(paStartInput = paStart, 
                                              paLongInput = paLong), "  ", nameIstat[istat])
  
  line3 <- paste0("\nSlope estimate is ",slopePct,"% per year, Mann-Kendall p-value is ",pValue)
  
  if(tinyPlot){
    title <- paste(nameIstat[istat])
  } else {
    title <- paste(line1, line2, line3)
  }
  
  if (!printTitle){
    title <- ""
  }
  
  genericEGRETDotPlot(x = localSeries$years, y = localSeries$qActual, 
                      xlim = c(xInfo$bottom, xInfo$top), ylim = c(yInfo$bottom, 
                                                                  yInfo$top), xlab = "", ylab = yLab, customPar = customPar, 
                      xTicks = xInfo$ticks, yTicks = yInfo$ticks, cex = cex, 
                      plotTitle = title, cex.axis = cex.axis, cex.main = cex.main, 
                      tinyPlot = tinyPlot, lwd = lwd, col = col, ...)
  lines(localSeries$years, localSeries$qSmooth, lwd = lwd, 
        col = col)
}

#########################################################################################
###### this the the function you will use to make the Quantile Kendall Plot #############
#########################################################################################

plotQuantileKendall <- function(eList, startDate = NA, endDate = NA, 
                      paStart = 4, paLong = 12,     
                      legendLocation = "topleft", legendSize = 1.0,
                      yMax = NA, yMin = NA) {
  localDaily <- eList$Daily
  localINFO <- eList$INFO
  localINFO$paStart <- paStart
  localINFO$paLong <- paLong
  start <- as.Date(startDate)
  end <- as.Date(endDate)
  
  if(is.na(startDate)){
    start <- as.Date(localDaily$Date[1]) 
  } 
  
  if(is.na(endDate)){
    end <- as.Date(localDaily$Date[length(localDaily$Date)])
  }
  
  localDaily <- subset(localDaily, Date >= start & Date <= end)
  eList <- as.egret(localINFO,localDaily)
  eList <- setPA(eList, paStart=paStart, paLong=paLong)
  
  v <- makeSortQ(eList)
  sortQ <- v[[1]]
  time <- v[[2]]
  results <- trendSortQ(sortQ, time)
  pvals <- c(0.001,0.01,0.05,0.1,0.25,0.5,0.75,0.9,0.95,0.99,0.999)
  zvals <- qnorm(pvals)
  name <- eList$INFO$shortName
#  ymax <- trunc(max(results$slopePct)*10)
#  ymax <- max(ymax + 2, 5)
#  ymin <- floor(min(results$slopePct)*10)
#  ymin <- min(ymin - 2, -5)
#  yrange <- c(ymin/10, ymax/10)
#  yticks <- axisTicks(yrange, log = FALSE)
  ymax <- max(results$slopePct + 0.5, yMax, na.rm = TRUE)
  ymin <- min(results$slopePct - 0.5, yMin, na.rm = TRUE)
  yrange <- c(ymin, ymax)
  yticks <- axisTicks(yrange, log = FALSE, nint =7)
  p <- results$pValueAdj
  color <- ifelse(p <= 0.1,"black","snow3")
  color <- ifelse(p < 0.05, "red", color)
  pvals <- c(0.001,0.01,0.05,0.1,0.25,0.5,0.75,0.9,0.95,0.99,0.999)
  zvals <- qnorm(pvals)
  name <- paste0("\n", eList$INFO$shortName,"\n",
                 start," through ", end, "\n", 
                 setSeasonLabelByUser(paStartInput = paStart, paLongInput = paLong))
  plot(results$z,results$slopePct,col = color, pch = 20, cex = 1.0, 
       xlab = "Daily non-exceedance probability", 
       ylab = "Trend slope in percent per year", 
       xlim = c(-3.2, 3.2), ylim = yrange, yaxs = "i", 
       las = 1, tck = 0.02, cex.lab = 1.2, cex.axis = 1.2, 
       axes = FALSE, frame.plot=TRUE)
  mtext(name, side =3, line = 0.2, cex = 1.2)
  axis(1,at=zvals,labels=pvals, las = 1, tck = 0.02)
  axis(2,at=yticks,labels = TRUE, las = 1, tck = 0.02)
  axis(3,at=zvals,labels=FALSE, las = 1, tck=0.02)
  axis(4,at=yticks,labels = FALSE, tick = TRUE, tck = 0.02)
  abline(h=0,col="blue")
  legend(legendLocation,c("> 0.1","0.05 - 0.1","< 0.05"),col = c("snow3",                                            "black","red"),pch = 20, title = "p-value",
         pt.cex=1.0, cex = legendSize * 1.5)
}    

#########################################################################################
############  This next function combines four individual trend graphs (for mimimum day,
########### median day, mean day, and maximum day) along with the quantile kendall graph
#########################################################################################

plotFiveTrendGraphs <- function(eList, startDate = NA, endDate = NA, 
                                paStart = 4, paLong = 12, qUnit = 2, window = 30, 
                                legendLocation = "topleft", legendSize = 1.0) {
  localDaily <- eList$Daily
  localINFO <- eList$INFO
  localINFO$paStart <- paStart
  localINFO$paLong <- paLong
  localINFO$window <- window
  
  start <- as.Date(startDate)
  end <- as.Date(endDate)
  
  if(is.na(startDate)){
    start <- as.Date(localDaily$Date[1]) 
  } 
  
  if(is.na(endDate)){
    end <- as.Date(localDaily$Date[length(localDaily$Date)])
  }
  
  localDaily <- subset(localDaily, Date >= start & Date <= end)
  
  eList <- as.egret(localINFO,localDaily)
  eList <- setPA(eList, paStart=paStart, paLong=paLong, window=window)
  # this next line of code is inserted so that when paLong = 12, we always use the
  # climate year when looking at the trends in the annual minimum flow
  paStart1 <- if(paLong == 12)  4 else paStart
  plotFlowTrend(eList, istat = 1, qUnit = qUnit, paStart = paStart1, paLong = paLong, window = window)
  plotFlowTrend(eList, istat = 4, qUnit = qUnit, paStart = paStart, paLong = paLong, window = window)
  plotFlowTrend(eList, istat = 8, qUnit = qUnit, paStart = paStart, paLong = paLong, window = window)
  plotFlowTrend(eList, istat = 5, qUnit = qUnit, paStart = paStart, paLong = paLong, window = window)
  # now the quantile kendall
  plotQuantileKendall(eList, startDate = startDate, endDate = endDate, paStart = paStart,
                      paLong = paLong, legendLocation = legendLocation, legendSize = legendSize)
  
} 

#########################################################################################
########### makeSortQ creates a matrix called Qsort. 
############It sorted from smallest to largest over dimDays 
############(if working with full year dimDays=365), 
#############and also creates other vectors that contain information about this array.
#########################################################################################

makeSortQ <- function(eList){
  localINFO <- getInfo(eList)
  localDaily <- getDaily(eList)
  paStart <- localINFO$paStart
  paLong <- localINFO$paLong
  # determine the maximum number of days to put in the array
  numDays <- length(localDaily$DecYear)
  monthSeqFirst <- localDaily$MonthSeq[1]
  monthSeqLast <- localDaily$MonthSeq[numDays]
  # creating a data frame (called startEndSeq) of the MonthSeq values that go into each year
  Starts <- seq(paStart, monthSeqLast, 12)
  Ends <- Starts + paLong - 1
  startEndSeq <- data.frame(Starts, Ends)
  # trim this list of Starts and Ends to fit the period of record
  startEndSeq <- subset(startEndSeq, Ends >= monthSeqFirst & Starts <= monthSeqLast)
  numYearsRaw <- length(startEndSeq$Ends)
  # set up some vectors to keep track of years
  good <- rep(0, numYearsRaw)
  numDays <- rep(0, numYearsRaw)
  midDecYear <- rep(0, numYearsRaw)
  Qraw <- matrix(nrow = 366, ncol = numYearsRaw)
  for(i in 1: numYearsRaw) {
    startSeq <- startEndSeq$Starts[i]
    endSeq <- startEndSeq$Ends[i]
    startJulian <- getFirstJulian(startSeq)
    # startJulian is the first julian day of the first month in the year being processed
    # endJulian is the first julian day of the month right after the last month in the year being processed
    endJulian <- getFirstJulian(endSeq + 1)
    fullDuration <- endJulian - startJulian
    yearDaily <- localDaily[localDaily$MonthSeq >= startSeq & (localDaily$MonthSeq <= endSeq), ]
    nDays <- length(yearDaily$Q)
    if(nDays == fullDuration) {
      good[i] <- 1
      numDays[i] <- nDays
      midDecYear[i] <- (yearDaily$DecYear[1] + yearDaily$DecYear[nDays]) / 2
      Qraw[1:nDays,i] <- yearDaily$Q
    }   else {
      numDays[i] <- NA
      midDecYear[i] <- NA
    }
  }
  # now we compress the matrix down to equal number of values in each column
  j <- 0
  numGoodYears <- sum(good)
  dayCounts <- ifelse(good==1, numDays, NA)
  lowDays <- min(dayCounts, na.rm = TRUE)
  highDays <- max(dayCounts, na.rm = TRUE)
  dimYears <- numGoodYears
  dimDays <- lowDays
  sortQ <- matrix(nrow = dimDays, ncol = dimYears)
  time <- rep(0,dimYears)
  for (i in 1:numYearsRaw){
    if(good[i]==1) {
      j <- j + 1
      numD <- numDays[i]
      x <- sort(Qraw[1:numD, i])
      # separate odd numbers from even numbers of days
      if(numD == lowDays) {
        sortQ[1:dimDays,j] <- x
      } else {
        sortQ[1:dimDays,j] <- if(odd(numD)) leapOdd(x) else leapEven(x)
      }
      time[j] <- midDecYear[i]
    } 
  }
  
  sortQList = list(sortQ,time)
  
  return(sortQList)         
}
#########################################################################################
########## Another function trendSortQ needed for Quantile Kendall
#########################################################################################

trendSortQ <- function(Qsort, time){
  # note requires packages zyp and rkt
  nFreq <- dim(Qsort)[1]
  nYears <- length(time)
  results <- as.data.frame(matrix(ncol=9,nrow=nFreq))
  colnames(results) <- c("slopeLog","slopePct","pValue","pValueAdj","tau","rho1","rho2","freq","z")
  for(iRank in 1:nFreq){
    mkOut <- rkt::rkt(time,log(Qsort[iRank,]))
    results$slopeLog[iRank] <- mkOut$B
    results$slopePct[iRank] <- 100 * (exp(mkOut$B) - 1)
    results$pValue[iRank] <- mkOut$sl
    outZYP <- zyp.zhang(log(Qsort[iRank,]),time)
    results$pValueAdj[iRank] <- outZYP[6]
    results$tau[iRank] <- mkOut$tau
    # I don't actually use this information in the current outputs, but the code is there 
    # if one wanted to look at the serial correlation structure of the flow series      
    serial <- acf(log(Qsort[iRank,]), lag.max = 2, plot = FALSE)
    results$rho1[iRank] <- serial$acf[2]
    results$rho2[iRank] <- serial$acf[3]
    frequency <- iRank / (nFreq + 1)
    results$freq[iRank] <- frequency
    results$z[iRank] <- qnorm(frequency)    
  }
  return(results)
}
#########################################################################################
################################## getFirstJulian finds the julian date of first day
################################## of a given month
#########################################################################################

getFirstJulian <- function(monthSeq){
  year <- 1850 + trunc((monthSeq - 1) / 12)
  month <- monthSeq - 12 * (trunc((monthSeq-1)/12))
  charMonth <- ifelse(month<10, paste0("0",as.character(month)), as.character(month))
  theDate <- paste0(year,"-",charMonth,"-01")
  Julian1 <- as.numeric(julian(as.Date(theDate),origin=as.Date("1850-01-01")))
  return(Julian1)
}

#########################################################################################
########### leapOdd  is a function for deleting one value 
############when the period that contains Februaries has a length that is an odd number
#########################################################################################

leapOdd <- function(x){
  n <- length(x)
  m <- n - 1
  mid <- (n + 1) / 2
  mid1 <- mid + 1
  midMinus <- mid - 1
  y <- rep(NA, m)
  y[1:midMinus] <- x[1:midMinus]
  y[mid:m] <- x[mid1:n]
  return(y)}

#########################################################################################
########### leapEven  is a function for deleting one value 
############when the period that contains Februaries has a length that is an even number
#########################################################################################

leapEven <- function(x){
  n <- length(x)
  m <- n - 1
  mid <- n / 2
  y <- rep(NA, m)
  mid1 <- mid + 1
  mid2 <- mid + 2
  midMinus <- mid - 1
  y[1:midMinus] <- x[1:midMinus]
  y[mid] <- (x[mid] + x[mid1]) / 2
  y[mid1:m] <- x[mid2 : n]
  return(y)
}

#########################################################################################
####### determines if the length of a vector is an odd number ###########################
#########################################################################################

odd <- function(x) {(!(x %% 2) == 0)}

#########################################################################################
########### calcWY calculates the water year and inserts it into a data frame
#########################################################################################


calcWY <- function (df) {
  df$WaterYear <- as.integer(df$DecYear)
  df$WaterYear[df$Month >= 10] <- df$WaterYear[df$Month >= 
                                                 10] + 1
  return(df)
}
#########################################################################################
##### calcCY calculates the climate year and inserts it into a data frame
#########################################################################################

calcCY <- function (df){
  df$ClimateYear <- as.integer(df$DecYear)
  df$ClimateYear[df$Month >= 4] <- df$ClimateYear[df$Month >= 
                                                    4] + 1
  return(df)
}
#########################################################################################
######## smoother is a function does the trend in real discharge units and not logs. 
######## It is placed here so that users wanting to run this alternative have it available
######## but it is not actually called by any function in this document
#########################################################################################

smoother <- function(xy, window){
  edgeAdjust <- TRUE
  x <- xy$x
  y <- xy$y
  n <- length(y)
  z <- rep(0,n)
  x1 <- x[1]
  xn <- x[n]
  for (i in 1:n) {
    xi <- x[i]
    distToEdge <- min((xi - x1), (xn - xi))
    close <- (distToEdge < window)
    thisWindow <- if (edgeAdjust & close) 
      (2 * window) - distToEdge
    else window
    w <- triCube(x - xi, thisWindow)
    mod <- lm(xy$y ~ x, weights = w)
    new <- data.frame(x = x[i])
    z[i] <- predict(mod, new)
  }
  return(z)
}

#####################################################################
# Now, applying the functions above to the Carmel gage
#####################################################################

library(EGRET)

sta       <- "11143250"
param     <- "00060" # this is the parameter code for daily discharge
startDate <- "1962-10-01"
endDate   <- "2017-09-30"
INFO      <- readNWISInfo(siteNumber = sta, parameterCd = param, interactive = FALSE)
Daily     <- readNWISDaily(siteNumber = sta, parameterCd = param, startDate = startDate, 
                           endDate = endDate)
eList     <- as.egret(INFO, Daily)

png("D:/EDM_LT/GitHub/Carmel/report/R_Figure/Quantile_Kendall_gageID_11143250_WatYr.png", width=800, height=700, res=130)
  plotQuantileKendall(eList, startDate = startDate, endDate = endDate, 
                      paStart = 10, paLong = 12, legendLocation = "bottomright", legendSize = 0.5, yMax = 4, yMin = -4)
dev.off()

png("D:/EDM_LT/GitHub/Carmel/report/R_Figure/Quantile_Kendall_gageID_11143250_Aug-Oct.png", width=800, height=700, res=130)
  plotQuantileKendall(eList, startDate = startDate, endDate = endDate, 
                      paStart = 8, paLong = 3, legendLocation = "bottomright", legendSize = 0.5, yMax = 4, yMin = -4)
dev.off()

png("D:/EDM_LT/GitHub/Carmel/report/R_Figure/Quantile_Kendall_gageID_11143250_Jan-Jun.png", width=800, height=700, res=130)
  plotQuantileKendall(eList, startDate = startDate, endDate = endDate, 
                      paStart = 1, paLong = 6, legendLocation = "bottomright", legendSize = 0.5, yMax = 4, yMin = -4)
dev.off()

png("D:/EDM_LT/GitHub/Carmel/report/R_Figure/Quantile_Kendall_gageID_11143250_Mar-May.png", width=800, height=700, res=130)
  plotQuantileKendall(eList, startDate = startDate, endDate = endDate, 
                      paStart = 3, paLong = 3, legendLocation = "bottomright", legendSize = 0.5, yMax = 4, yMin = -4)
dev.off()

# Meaning of istat in plot that follows:
#  (1) 1-day minimum
#  (2) 7-day minimum
#  (3) 30-day minimum
#  (4) median 
#  (5) mean
#  (6) 30-day maximum
#  (7) 7-day maximum
#  (8) 1-day maximum

# Can play with istat to produce plots for the variable listed above.  Don't forget to change the file name to avoid overwriting previous plots
png("D:/EDM_LT/GitHub/Carmel/report/R_Figure/Flow_Stat_MeanDaily_gageID_11143250.png", width=800, height=700, res=130)
  plotFlowTrend(eList, istat = 5)
dev.off()


plotFiveTrendGraphs(eList, legendLocation = "bottomleft")

Daily_wyr <- subset(Daily, Daily$Date > '1962-09-30' & Daily$Date < '2017-10-01')
Daily_wyr$zeroQday <- ifelse(Daily_wyr$Q < 0.01, 1, 0)
dat <- aggregate(zeroQday ~ waterYear, Daily_wyr, sum)

png("D:/EDM_LT/GitHub/Carmel/report/R_Figure/Zero_Flow_Day_Counts.png", width=1200, height=700, res=130)
  par(mar=c(5,4,1,0.25))
  x <- barplot(dat$zeroQday, las=1, ylim=c(0,366), ylab='# of Zero Flow Days') 
  box()
  axis(side=1, at=seq(x[3], x[53], by=6), labels=seq(1965, 2015, by=5), las=2, tcl=0)
dev.off()

