setwd('D:\DATA\Niswonger\Carmel.git\Simulation_20160812T131753\OUTPUT\gages')

# 7 gages
H1 <- read.table('H1.gg1', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
NC <- read.table('NC.gg3', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
GA <- read.table('GA.gg7', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
DJ <- read.table('DJ.gg8', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
RR <- read.table('RR.gg10', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
SH <- read.table('SH.gg12', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
CL <- read.table('CL.gg13', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
# 

# Because the simulated values don't have a time stamp, need to give them one.  According to the transient control file, dates range from 10-1-1990 to 10-31-1995
H1_dates <- seq(as.Date('1990-10-01'), as.Date('2012-12-31'), by='day')
NC_dates <- seq(as.Date('1990-10-01'), as.Date('2012-12-31'), by='day')
GA_dates <- seq(as.Date('1990-10-01'), as.Date('2012-12-31'), by='day')
DJ_dates <- seq(as.Date('1990-10-01'), as.Date('2012-12-31'), by='day')
RR_dates <- seq(as.Date('1990-10-01'), as.Date('2012-12-31'), by='day')
SH_dates <- seq(as.Date('1990-10-01'), as.Date('2012-12-31'), by='day')
CL_dates <- seq(as.Date('1990-10-01'), as.Date('2012-12-31'), by='day')

# Check to make sure their lengths are equivelent before merging:
length(H1_dates)
length(NC_dates)
length(GA_dates)
length(DJ_dates)
length(RR_dates)
length(SH_dates)
length(CL_dates)
# 1857
nrow(H1)
nrow(NC)
nrow(GA)
nrow(DJ)
nrow(RR)
nrow(SH)
nrow(CL)
# 1857

# Add the time stamp to the simulated values
H1$Date <- H1_dates         
NC$Date <- NC_dates
GA$Date <- GA_dates
DJ$Date <- DJ_dates   
RR$Date <- RR_dates 
SH$Date <- SH_dates
CL$Date <- CL_dates

# Retrieve the observations
H1_obs <- read.table('../../tsproc/H1_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))
NC_obs <- read.table('../../tsproc/NC_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))
GA_obs <- read.table('../../tsproc/GA_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))
DJ_obs <- read.table('../../tsproc/DJ_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))
RR_obs <- read.table('../../tsproc/RR_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))
SH_obs <- read.table('../../tsproc/SH_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))
CL_obs <- read.table('../../tsproc/CL_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))

H1_obs$Date <- as.Date(H1_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date Column of values from type 'factor' to type 'date'
NC_obs$Date <- as.Date(NC_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date Column of values from type 'factor' to type 'date'
GA_obs$Date <- as.Date(GA_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date Column of values from type 'factor' to type 'date'
DJ_obs$Date <- as.Date(DJ_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date Column of values from type 'factor' to type 'date'
RR_obs$Date <- as.Date(RR_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date Column of values from type 'factor' to type 'date'
SH_obs$Date <- as.Date(SH_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date Column of values from type 'factor' to type 'date'
CL_obs$Date <- as.Date(CL_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date Column of values from type 'factor' to type 'date'


png('H1_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(H1$Date), H1$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(H1_obs$Date), H1_obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()

png('NC_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(NC$Date), NC$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(NC_obs$Date), _obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()

png('GA_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(GA$Date), GA$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(GA_obs$Date), GA_obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()

png('DJ_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(DJ$Date), DJ$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(DJ_obs$Date), DJ_obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()

png('RR_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(RR$Date), RR$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(RR_obs$Date), RR_obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()

png('SH_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(SH$Date), SH$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(SH_obs$Date), SH_obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()

png('CL_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(CL$Date), CL$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(CL_obs$Date), CL_obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()





