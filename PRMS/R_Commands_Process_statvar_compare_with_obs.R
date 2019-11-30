#library(EGRET)
library(hydroGOF)
library(gdata)

#setwd('D:/EDM_LT/github/Carmel/PRMS')
setwd('C:\Users\rniswon\Documents\Data\Git\Carmel_gsflow.git\PRMS')

# Add capability for appending plot version # to end of plot file names
# Increment this value with each run of the script to preserve old output for comparing with new output
args = commandArgs(trailingOnly=TRUE)

if(length(args)==0) {
  ver <- 1
  print('Using a default version number of: 1')
} else if(length(args) == 1){
  ver <- args[1]
  print(paste0('Using a user supplied version number of: ',args[1]))
}

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
  dfn <- ifelse(txt_lines$code==1 & (as.character(txt_lines$var_name) != 'sub_cfs'), as.character(txt_lines$var_name), paste0(txt_lines$var_name,'_',txt_lines$code))
  
  # Read the meat
  dat <- read.table(fname, skip=nstats + 1, col.names=c('rownum','yr','mon','day','H','M','S',dfn))
  
  # Construct usable date column
  dat$Date <- with(dat, as.Date(paste0(yr,'-',mon,'-',day), '%Y-%m-%d'))
  
  # Drop and reorder columns
  dat2 <- dat[,c(ncol(dat),seq(8, ncol(dat)-1, by=1))]
  
  dat2
}

readPRMSdata2df <- function(fname){
  # Set variable for later use
  colnms <- NULL
  colkeep <- rep(FALSE, times=6)   # First six column of data section are year, mon, day, 
                                   # hour, min, sec and don't need to be kept after 
                                   # processed (see below).
  
  # Customized function for reading Carmel .data file, may need tweaking 
  # when applied to other data files if they don't all look like Carmels
  print(paste0('Reading ',as.character(fname),' ...'))
  
  # get header information
  fname_con <- file(paste0(getwd(),'/',fname)) 
  con <- fname_con
  open(con)
  alines <- readLines(con, n = -1, warn = FALSE) # n=-1 indicated read to eof
  close(con)
  
  # process lines until "#####..." encountered
  i <- 1
  first <- TRUE
  while (!grepl('####', alines[i])){
    substr1 <- '//'
    substr2 <- 'runoff'
    if(grepl(substr1, alines[i]) & grepl(substr2, alines[i])){
      m_row <- alines[i]
      m_arr <- strsplit(m_row, " +")                        # split line based on whitespaces
      if(first) {
        key <- data.frame(ID=m_arr[[1]][2], name=trimws(substr(alines[i], 6, 30)))
        first <- !first
      } else {
        d_row <- data.frame(ID=m_arr[[1]][2], name=trimws(substr(m_row, 6, 30)))  # 6 & 30 read fixed positioning 
                                                                                  # m_row, will only work for current 
                                                                                  # data file and may need to be modified 
                                                                                  # for other .data files
        key <- rbind(key, d_row)
      }
    }
  
    if(length(strsplit(alines[i], " +")[[1]])==2)  {    # This is keying off of whether only 2 values on the line
                                               # May need to check for other lines with only 2 vals when
                                               # applied to other models
      # create a vector of column names based on how many entries are encountered for each parameter
      m_arr <- strsplit(alines[i], " +")
      colnms <- c(colnms, paste0(m_arr[[1]][1], '_', seq(1:as.integer(m_arr[[1]][2]))))
      
      # create another vector of true/false on whether column is runoff column
      if(m_arr[[1]][1]=='runoff'){
        colkeep <- c(colkeep, rep(TRUE, times = as.integer(m_arr[[1]][2])))
      } else {
        colkeep <- c(colkeep, rep(FALSE, times = as.integer(m_arr[[1]][2])))
      }
    }
    
    i <- i + 1
  }
  
  # When code exits while loop, ready to start reading data
  dat <- read.table(fname, skip=i, col.names=c('yr', 'mon', 'day', 'H', 'M', 'S', colnms))
  
  # Construct usable date column
  dat$Date <- with(dat, as.Date(paste0(yr,'-',mon,'-',day), '%Y-%m-%d'))
  
  # Because 'Date' appended to the end, need to append colkeep by one
  colkeep <- c(colkeep, TRUE)
  
  # Drop and reorder columns
  dat2 <- dat[,colkeep]
  
  lst_dat <- list(dat2, key)
}

# read statvar
model_out <- readstatvar2df('statvar.dat')

# Reduce simulated output to only those values needed the comparison
model_out <- model_out[, grepl('Date|sub_cfs', colnames(model_out))]

# Retrieve observed values from PRMS .data file
obs       <- readPRMSdata2df('carmel.data')
obs_ts    <- obs[[1]]   # get the separate elements returned from the function call
obs_key   <- obs[[2]]   # get the separate elements returned from the function call

# An example for pulling data from NWIS that is going to be set aside for now

# Now get 'obs' data from NWIS web for the USGS gage site
# StartDate <- "1980-10-01"  # Set dates according to model start day
# EndDate   <- "2011-10-31"  # Set dates according to model stop day
# siteNumber <- "11143250"   # NWIS Gage ID
# QParameterCd <- "00060"    # NWIS parameter code for flow
# 
# Daily_Q <- readNWISDaily(siteNumber, QParameterCd, StartDate, EndDate, convert = FALSE)

key_file <- read.csv('./subbasin_gauge_key.csv',header=TRUE)

# Drop first instance of duplicated row
key_file <- key_file[!rev(duplicated(rev(key_file$Stream.Gauge.Name))),]

for(i in (1:nrow(key_file)))
{
    # Set some values for retrieving data for this iteration of for loop
    obs_key_val <- key_file[i,'Data.File.Order']
    sim_key_val <- key_file[i,'Basin.Subbasin.ID']
    
    # Get only the column needed from the observed values
    obs <- obs_ts[, c('Date', colnames(obs_ts)[which(colnames(obs_ts) == paste0('runoff_', obs_key_val))])]
    
    # Get only the column needed from the simulated values
    srch_str <- paste0('sub_cfs_',sim_key_val)
    sim <- model_out[,c('Date', srch_str)]
    
    # Because the .data file contains more data than what was simulated, reduce to same window as simulated
    obs <- obs[seq(which(obs$Date==sim[1,'Date']), which(obs$Date==sim[nrow(sim),'Date']), by=1),]
    
    # Because the window of observed data may be narrower than some of the other observed time series in the .data file, filter further
    obs <- subset(obs, obs$runoff >= 0)
    
    # If no observations, skip to next for loop iteration
    if(nrow(obs)==0) next
    
    # Now, match the simulated time series up with the observed
    sim <- sim[seq(which(sim$Date==obs[1,'Date']), which(sim$Date==obs[nrow(obs),'Date']), by=1), ]
    
    # In case there are any missing dates in the observed values, need to fill in
    dt_complete <- data.frame(Date = seq(obs[1,'Date'], obs[nrow(obs),'Date'], by='day'))
    obs <- merge(dt_complete, obs, by='Date', all.x=TRUE)
    
    # Process daily time series!
    
    # First, write a header that is the key to interpretting the data that follows
    writeLines(c('#  ME:    Mean Error',                                                                                         
                 '#  MAE:   Mean Absolute Error',                                                                                
                 '#  RMSE:  Root Mean Square Error',                                                                             
                 '#  NRMSE: Normalized Root Mean Square Error',                                                                  
                 '#  r:     Pearson product-moment correlation coefficient',                                                     
                 '#  RSR:   Spearman Correlation coefficient',                                                                   
                 '#  R2:    Coefficient of Determination',                                                                       
                 '#  rSD:   Ratio of Standard Deviations',                                                                       
                 '#  NSE:   Nash-Sutcliffe efficiency',                                                                          
                 '#  mNSE:  Modified Nash-Sutcliffe efficiency',                                                                 
                 '#  rNSE:  Relative Nash-Sutcliffe efficiency',                                                                 
                 '#  d:     Index of Agreement',                                                                                 
                 '#  md:    Modified Index of Agreement',                                                                        
                 '#  rd:    Relative Index of Agreement',                                                                        
                 '#  cp:    Coefficient of Persistence',                                                                         
                 '#  PBIAS: Percent Bias',                                                                                       
                 '#  KGE:   Kling-Gupta efficiency',                                                                             
                 '#  bR2:   the coef. of determination multiplied by the slope of the linear regression between "sim" and "obs"',
                 '#  VE:    volumetric efficiency',                                                                              
                 ' ',                                                                                                            
                 paste0('*** Comparison of DAILY flows for ',trimws(key_file[i,'Stream.Gauge.Name']),' ***'),                                                  
                 ' '), con = paste0('./R_post-processed/GOF_',trimws(key_file[i,'Stream.Gauge.Name']),'_ver',ver,'.txt'))
                                                     
    write.fwf(gof(sim[!grepl('Date', colnames(sim))], obs[!grepl('Date', colnames(obs))]), file = paste0('./R_post-processed/GOF_',trimws(key_file[i,'Stream.Gauge.Name']),'_ver',ver,'.txt'), append = TRUE, quote=FALSE, rownames=TRUE, colnames=FALSE, width=c(10, 10))
    
    
    # plot daily time series
    # ----------------------
    ylim <- c(0,1.01 * max(obs[,!grepl('Date|wyr', colnames(obs))], na.rm=TRUE))
    ylim_log <- c(0.01,1.01 * max(obs[,!grepl('Date|wyr', colnames(obs))], na.rm=TRUE))
    
    png(paste0('./R_post-processed/', trimws(key_file[i,'Stream.Gauge.Name']),'_Daily_time_series_ver',ver,'.png'), height=700,width=1200, res=130)
        par(mar=c(4,5,1,1))
        plot(obs$Date, obs[,!grepl('Date|wyr', colnames(obs))], typ='l', col='blue', lwd=2, xlab='Date', ylab='Q, cfs', xaxs='i', yaxs='i', las=1, ylim=ylim)
        points(sim$Date, sim[,!grepl('Date|wyr', colnames(sim))], col='red', typ='l', lty=2)
        legend('topright',c('Observed','Simulated'), col=c('blue','red'), lty=c(1,2), lwd=c(2,1), bty='n', bg='white')
    dev.off()
    
    png(paste0('./R_post-processed/', trimws(key_file[i,'Stream.Gauge.Name']),'_Daily_time_series_log_scale_ver',ver,'.png'), height=700,width=1200, res=130)
        par(mar=c(4,5,1,1))
        plot(obs$Date,obs[,!grepl('Date|wyr', colnames(obs))], typ='l', col='blue', lwd=2, xlab='Date', ylab='Log10(Q), cfs', xaxs='i', yaxs='i', las=1, ylim=ylim_log, log='y')
        points(sim$Date, sim[,!grepl('Date|wyr', colnames(sim))], col='red', typ='l', lty=2)
        legend('topright',c('Observed','Simulated'), col=c('blue','red'), lty=c(1,2), lwd=c(2,1), bty='n', bg='white')
    dev.off()
    
    
    # plot annual total time series
    # -----------------------------
    
    # Start by adding water year attribute to simulated data
    sim$wyr <- as.numeric(format(as.Date(sim$Date), "%Y"))
    is.nxt        <- as.numeric(format(as.Date(sim$Date), "%m")) %in% 1:9
    sim$wyr[!is.nxt] <- sim$wyr[!is.nxt] + 1
    
    # Now add water year attribute to observed data
    obs$wyr <- as.numeric(format(as.Date(obs$Date), "%Y"))
    is.nxt        <- as.numeric(format(as.Date(obs$Date), "%m")) %in% 1:9
    obs$wyr[!is.nxt] <- obs$wyr[!is.nxt] + 1
    
    # next aggregate by water years, simulated then observed data
    sim_ann <- aggregate(sim[[colnames(sim[!grepl('Date|wyr', colnames(sim))])]] ~ wyr, data = sim, sum)
    names(sim_ann) <- c('wyr', 'ann_tot')
    sim_ann$ann_tot <- sim_ann$ann_tot * 86400 / 43560
    
    obs_ann <- aggregate(obs[[colnames(obs[!grepl('Date|wyr', colnames(obs))])]] ~ wyr, data = obs, sum)
    names(obs_ann) <- c('wyr', 'ann_tot')
    obs_ann$ann_tot <- obs_ann$ann_tot * 86400 / 43560
    
    # bar plot of annual totals
    mat <- matrix(c(sim_ann$ann_tot, obs_ann$ann_tot), 
                  byrow=TRUE, nrow = 2, ncol = nrow(sim_ann), 
                  dimnames = list(c("Simulated", "Observed"),
                                  as.character(obs_ann$wyr)))
    
    png(paste0('./R_post-processed/', trimws(key_file[i,'Stream.Gauge.Name']),'_Annual_Totals_ver',ver,'.png'), height=700,width=800, res=130)
        par(mar=c(4,5,2,1))
        barplot(mat, beside=TRUE, xlab='Water Year', ylab='', xaxs='i', yaxs='i', yaxt='n', col=c('red', 'blue'), las=1)
        axis(side=2, at=pretty(c(0:max(mat))), labels=pretty(c(0:max(mat))) / 1000, las=2)
        mtext(side=2, expression(paste('Total Annual Flow,  ',10^3~ ac%.%ft)), line=3)
        abline(h=0)
        legend('topleft', c('Simulated','Observed'), pch=22, pt.bg=c('red','blue'), bty='n', bg='white')
    dev.off()    
    
    
    # Run hydroGOF on annual amounts
    writeLines(c('#  ME:    Mean Error',                                                                                         
                 '#  MAE:   Mean Absolute Error',                                                                                
                 '#  RMSE:  Root Mean Square Error',                                                                             
                 '#  NRMSE: Normalized Root Mean Square Error',                                                                  
                 '#  r:     Pearson product-moment correlation coefficient',                                                     
                 '#  RSR:   Spearman Correlation coefficient',                                                                   
                 '#  R2:    Coefficient of Determination',                                                                       
                 '#  rSD:   Ratio of Standard Deviations',                                                                       
                 '#  NSE:   Nash-Sutcliffe efficiency',                                                                          
                 '#  mNSE:  Modified Nash-Sutcliffe efficiency',                                                                 
                 '#  rNSE:  Relative Nash-Sutcliffe efficiency',                                                                 
                 '#  d:     Index of Agreement',                                                                                 
                 '#  md:    Modified Index of Agreement',                                                                        
                 '#  rd:    Relative Index of Agreement',                                                                        
                 '#  cp:    Coefficient of Persistence',                                                                         
                 '#  PBIAS: Percent Bias',                                                                                       
                 '#  KGE:   Kling-Gupta efficiency',                                                                             
                 '#  bR2:   the coef. of determination multiplied by the slope of the linear regression between "sim" and "obs"',
                 '#  VE:    volumetric efficiency',                                                                              
                 ' ',                                                                                                            
                 paste0('*** Comparison of ANNUAL totals for ',trimws(key_file[i,'Stream.Gauge.Name']),' ***'),                                                  
                 ' '), con = paste0('./R_post-processed/Annual_GOF_',trimws(key_file[i,'Stream.Gauge.Name']),'_ver',ver,'.txt'))
                                                     
    write.fwf(gof(sim_ann[!grepl('Date|wyr', colnames(sim_ann))], obs_ann[!grepl('Date|wyr', colnames(obs_ann))]), file = paste0('./R_post-processed/Annual_GOF_',trimws(key_file[i,'Stream.Gauge.Name']),'_ver',ver,'.txt'), append = TRUE, quote=FALSE, rownames=TRUE, colnames=FALSE, width=c(20, 20))
    
    
    # Look at average daily comparison
    sim_dy         <- sim
    sim_dy$mon_day <- format(sim_dy$Date, "%m%d")
    
    obs_dy         <- obs
    obs_dy$mon_day <- format(obs_dy$Date, "%m%d")
    
    sim_dy <- aggregate(sim_dy[[colnames(sim_dy[!grepl('Date|wyr|mon_day', colnames(sim_dy))])]] ~ mon_day, data = sim_dy, mean)
    names(sim_dy) <- c('JDay','Q')
    obs_dy <- aggregate(obs_dy[[colnames(obs_dy[!grepl('Date|wyr|mon_day', colnames(obs_dy))])]] ~ mon_day, data = obs_dy, mean)
    names(obs_dy) <- c('JDay','Q')
    
    ylim2 <- c(0, 1.01 * max(sim_dy$Q))
    
    png(paste0('./R_post-processed/', trimws(key_file[i,'Stream.Gauge.Name']),'_Daily_Mean_Flow_ver',ver,'.png'), height=700, width=800, res=130)
        par(mar=c(4,5,1,1))
        plot(sim_dy$Q, pch=16, col='red', ylim=ylim2, las=1, xlab='Day of Year (ticks @ start of the month)', ylab = 'Mean Daily Flow, cfs', xaxt='n', yaxs='i')
        points(obs_dy$Q, col='blue')
        axis(side=1, at=cumsum(c(1,30,28,31,30,31,30,31,31,30,31,30)), labels=format(seq(as.Date('1980-01-01'), as.Date('1980-12-01'), by='month'), '%m'))
        legend('top', c('Simulated','Observed'), pch=c(16,1), col=c('red','blue'), bty='n', bg='white')
    dev.off()
    
}
