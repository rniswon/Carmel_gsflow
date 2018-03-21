library(EGRET)
library(hydroGOF)

setwd('D:/EDM_LT/github/Carmel/PRMS')

# ***** Important *****
# Set this variable for each individual model, comes from .out file, should be in acres
basin_area <- 41576.39   


# Define function for reading statvar file
readstatvar2df <- function(fname){
  # Translated from Shey's 'read_statvar.py' script
  print(paste0('Reading ',as.character(fname),' ...'))
  
  # get header information
  fname_con <- file(paste0(getwd(),'/',fname)) 
  con <- fname_con
  open(con)
  nstats <- as.integer(readLines(con, n = 1, warn = FALSE))
  close(con)
  
  # Read the variable names
  txt_lines <- read.table(fname, skip=1, nrows=nstats, col.names=c('var_name','code'))
  
  # Strip trailing '1's on basin variables; attach any segment numbers to names
  dfn <- ifelse(txt_lines$code==1, as.character(txt_lines$var_name), paste0(txt_lines$var_name,'_',txt_lines$code))
  
  # Read the meat
  dat <- read.table(fname, skip=nstats + 1, col.names=c('rownum','yr','mon','day','H','M','S',dfn))
  
  # Construct usable date column
  dat$Date <- with(dat, as.Date(paste0(yr,'-',mon,'-',day), '%Y-%m-%d'))
  
  # Drop and reorder columns
  dat2 <- dat[,c(ncol(dat),seq(8, ncol(dat)-1, by=1))]
  
  dat2
}

# read statvar
model_out <- readstatvar2df('statvar.dat')

# Now get 'obs' data from NWIS web for the USGS gage site
StartDate <- "1980-10-01"  # Set dates according to model start day
EndDate   <- "2011-10-31"  # Set dates according to model stop day
siteNumber <- "11143250"   # NWIS Gage ID
QParameterCd <- "00060"    # NWIS parameter code for flow

Daily_Q <- readNWISDaily(siteNumber, QParameterCd, StartDate, EndDate, convert = FALSE)

# Ensure that the time series pulled from NWIS spans the full model period
if(length(seq(as.Date(StartDate), as.Date(EndDate), by='day')) == nrow(Daily_Q)){
    print('OK to proceed')
} else {
    print('# of Days disperity')
}

# At this point Daily_Q is equivalent to Subbasin ID #6 
# according to ...\Carmel.git\PRMS\subbasin_gauge_key.csv
# -------------------------------------------------------
gof(model_out$sub_cfs_6, Daily_Q$Q)  # NWIS values pulled in as m3/s
write.table(gof(model_out$sub_cfs_6, Daily_Q$Q), 'Goodness_of_fit_daily.txt', quote=FALSE, row.names=TRUE, col.names=FALSE)

# Example output (see key below)
#  ME          54.75
#  MAE         98.48
#  MSE      61040.90
#  RMSE       247.06
#  NRMSE %     72.40
#  PBIAS %     51.10
#  RSR          0.72
#  rSD          1.14
#  NSE          0.48
#  mNSE         0.33
#  rNSE    -35455.98
#  d            0.87
#  md           0.63
#  rd       -8497.39
#  cp          -0.56
#  r            0.79
#  R2           0.63
#  bR2          0.60
#  KGE          0.43
#  VE           0.08


#  ME:    Mean Error 
#  MAE:   Mean Absolute Error 
#  RMSE:  Root Mean Square Error 
#  NRMSE: Normalized Root Mean Square Error 
#  r:     Pearson product-moment correlation coefficient
#  RSR:   Spearman Correlation coefficient 
#  R2:    Coefficient of Determination 
#  rSD:   Ratio of Standard Deviations 
#  NSE:   Nash-Sutcliffe efficiency 
#  mNSE:  Modified Nash-Sutcliffe efficiency 
#  rNSE:  Relative Nash-Sutcliffe efficiency
#  d:     Index of Agreement 
#  md:    Modified Index of Agreement 
#  rd:    Relative Index of Agreement 
#  cp:    Coefficient of Persistence 
#  PBIAS: Percent Bias
#  KGE:   Kling-Gupta efficiency 
#  bR2:   the coef. of determination multiplied by the slope of the linear regression between 'sim' and 'obs' 
#  VE:    volumetric efficiency 

# plot daily time series
# ----------------------
png('Site_6_Daily_time_series.png', height=700,width=1200, res=130)
    par(mar=c(4,5,1,1))
    plot(Daily_Q$Date, Daily_Q$Q, typ='l', col='blue', lwd=2, xlab='Date', ylab='Q, cfs', xaxs='i', yaxs='i', las=1, ylim=c(0,12000))
    points(model_out$Date, model_out$sub_cfs_6, col='red', typ='l', lty=2)
    legend('topright',c('Simulated','Observed'), col=c('red','blue'), lty=c(1,2), lwd=c(2,1), bty='n', bg='white')
dev.off()

png('Site_6_Daily_time_series_log_scale.png', height=700,width=1200, res=130)
    par(mar=c(4,5,1,1))
    plot(Daily_Q$Date, Daily_Q$Q, typ='l', col='blue', lwd=2, xlab='Date', ylab='Log10(Q), cfs', xaxs='i', yaxs='i', las=1, ylim=c(0.1,12000), log='y')
    points(model_out$Date, model_out$sub_cfs_6, col='red', typ='l', lty=2)
    legend('topright',c('Simulated','Observed'), col=c('red','blue'), lty=c(1,2), lwd=c(2,1), bty='n', bg='white')
dev.off()


# plot annual total time series
# -----------------------------

# Start by adding water year attribute to simulated data
model_out$wyr <- as.numeric(format(as.Date(model_out$Date), "%Y"))
is.nxt        <- as.numeric(format(as.Date(model_out$Date), "%m")) %in% 1:9
model_out$wyr[!is.nxt] <- model_out$wyr[!is.nxt] + 1

# next aggregate by water years
model_out_ann <- aggregate(sub_cfs_6 ~ wyr, data = model_out, sum)
model_out_ann$sub_cfs_6 <- model_out_ann$sub_cfs_6 * 86400 / 43560

annual_obs   <- aggregate(Q ~ waterYear, data = Daily_Q, sum)
annual_obs$Q <- annual_obs$Q * 86400 / 43560

# bar plot of annual totals
mat <- matrix(c(model_out_ann$sub_cfs_6, annual_obs$Q), 
              byrow=TRUE, nrow = 2, ncol = nrow(model_out_ann), 
              dimnames = list(c("Simulated", "Observed"),
                              as.character(annual_obs$waterYear)))

png('Site_6_Annual_Totals.png', height=700,width=800, res=130)
    par(mar=c(4,5,1,1))
    barplot(mat, beside=TRUE, xlab='Water Year', ylab='', xaxs='i', yaxs='i', yaxt='n', col=c('red', 'blue'), las=1)
    axis(side=2, at=seq(0,350000,by=50000), labels=seq(0,350,by=50), las=2)
    mtext(side=2, expression(paste('Total Annual Flow, ',10^3~ ac%.%ft)), line=3)
    abline(h=0)
    legend('top', c('Simulated','Observed'), pch=22, pt.bg=c('red','blue'), bty='n', bg='white')
dev.off()    


# Run hydroGOF on annual amounts
gof(model_out_ann$sub_cfs_6, annual_obs$Q)
write.table(gof(model_out_ann$sub_cfs_6, annual_obs$Q), 'Goodness_of_fit_annual.txt', quote=FALSE, row.names=TRUE, col.names=FALSE)

# ME           38530.03
# MAE          45545.81
# MSE     2607963675.08
# RMSE         51068.23
# NRMSE %         63.60
# PBIAS %         51.10
# RSR              0.64
# rSD              0.79
# NSE              0.58
# mNSE             0.21
# rNSE        -13433.03
# d                0.88
# md               0.60
# rd           -3859.38
# cp               0.76
# r                0.91
# R2               0.84
# bR2              0.76
# KGE              0.44
# VE               0.40

# Look at daily comparison
model_out_dy         <- model_out
model_out_dy$mon_day <- format(model_out_dy$Date, "%m%d")

Daily_Q_dy         <- Daily_Q
Daily_Q_dy$mon_day <- format(Daily_Q_dy$Date, "%m%d")

sim_dy <- aggregate(sub_cfs_6 ~ mon_day, data = model_out_dy, mean)
obs_dy <- aggregate(Q ~ mon_day, data = Daily_Q_dy, mean)

png('Site_6_Daily_Mean_Flow.png', height=700,width=800, res=130)
    par(mar=c(4,5,1,1))
    plot(sim_dy$sub_cfs_6, pch=16, col='red', ylim=c(0,750), las=1, xlab='Day of Year (ticks @ start of the month)', ylab='Mean Daily Flow, cfs', xaxt='n', yaxs='i')
    points(obs_dy$Q, col='blue')
    axis(side=1, at=cumsum(c(1,30,28,31,30,31,30,31,31,30,31,30)), labels=format(seq(as.Date('1980-01-01'), as.Date('1980-12-01'), by='month'), '%m'))
    legend('top', c('Simulated','Observed'), pch=c(16,1), col=c('red','blue'), bty='n', bg='white')
dev.off()

