setwd('D:/EDM_LT/GitHub/Carmel/Simulation_20160812T131753/OUTPUT/gages')


H1 <- read.table('H1.gg1', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))
# RR <- read.table('RR.gg10', skip=2, header=FALSE, col.names=c('Time','Stage','Depth','GWHead','MidptFlow','StreamLoss','GWRech','ChngeUZStor','VolUZStor'))

# Because the simulated values don't have a time stamp, need to give them one.  According to the transient control file, dates range from 10-1-1990 to 10-31-1995
H1_dates <- seq(as.Date('1990-10-01'), as.Date('1995-10-31'), by='day')

# Check to make sure their lengths are equivelent before merging:
length(H1_dates)
# 1857
nrow(H1)
# 1857

# Add the time stamp to the simulated values
H1$Date <- H1_dates

# Retrieve the observations
H1_obs <- read.table('../../tsproc/H1_StrmQ_obs.txt', header=FALSE, col.names=c('dummy','Date','Time','Q','dummy2'))
H1_obs$Date <- as.Date(H1_obs$Date, '%m/%d/%Y')  # This changes the internal storage of the Date solumn of values from type 'factor' to type 'date'

png('H1_hydroGraph.png',width=6.5, height=4.5, units='in',res=140)
  par(mar=c(4,5,1,1))
  # Don't forget to apply unit conversion to simulated values for lining up with observations.
  plot(as.Date(H1$Date), H1$MidptFlow * 35.315 / 86400, typ='l', xlab='Time Step', xaxs='i', yaxs='i', ylab=expression(paste('Streamflow, ',ft^3~ s^-1,sep='')), las=1)
  points(as.Date(H1_obs$Date), H1_obs$Q, typ='l',lty=2, col='red')
  legend('topleft', c('Simulated','Observed'), col=c('black','red'), lty=c(1,2), bty='n', bg='white') 
dev.off()




