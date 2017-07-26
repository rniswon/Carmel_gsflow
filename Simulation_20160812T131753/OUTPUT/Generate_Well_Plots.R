setwd('D:/EDM_LT/GitHub/Carmel/Simulation_20160812T131753/OUTPUT/')

dat <- read.table('hobsout.dat', header=FALSE, skip=1, col.names=c('sim','obs','name'))
dat$name <- as.character(dat$name)
dat$id   <- sapply(strsplit(dat[,'name'], "\\_"), `[[`, 1)
dat$date <- sapply(strsplit(dat[,'name'], "\\_"), `[[`, 2)
dat$date <- as.Date(dat$date, "%m%d%Y")
uni_names <- unique(dat$id)


for(i in (1:length(uni_names))){
    wel <- subset(dat, dat$id==uni_names[i])
    wel <- subset(wel, wel$sim != 0)
    
    if(nrow(wel)!=0){
        png(paste('./well_fits/well_fit_',as.character(i),'.png',sep=''), height=600, width=700, res=130)
            par(mar=c(4,4,0.25,0.25))
            plot(as.Date(wel$date), wel$sim, col="blue", typ='l', xlab='Year', ylab='Head (m)', ylim=c(0.92*min(wel$sim, wel$obs), 1.08*max(wel$sim, wel$obs)), las=1)
            points(as.Date(wel$date), wel$obs, pch=8, col='red')
            legend("topright", c('Simulated', 'Observed'), pch=c(NA, 8), col=c('blue','red'), lwd=c(1,NA), bty='n')
            mtext(side=3, paste("Well ", as.character(i),sep=''), line=-1.5, adj=0.05)
        dev.off()
    }
}
