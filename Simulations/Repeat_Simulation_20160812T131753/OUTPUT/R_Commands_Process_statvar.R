
setwd('D:/EDM_LT/github/Carmel')

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


