prior <- read.table('D:/EDM_LT/GitHub/Carmel/Simulation_20161129_SteadyState/OUTPUT/hobs.out',header=FALSE,skip=1,col.names=c('sim','obs','name'))
posterior1 <- read.table('D:/EDM_LT/GitHub/Carmel/PEST/Iteration_1_Back_From_Condor/OUTPUT/hobs.out',header=FALSE,skip=1,col.names=c('sim','obs','name'))
posterior2 <- read.table('D:/EDM_LT/GitHub/Carmel/PEST/Iteration_2_Back_From_Condor/OUTPUT/hobs.out',header=FALSE,skip=1,col.names=c('sim','obs','name'))

posterior <- posterior2

prior$resid <- prior$sim - prior$obs
posterior$resid <- posterior$sim - posterior$obs

png('D:/EDM_LT/GitHub/Carmel/PEST/well_resids_2.png', res=120, width=700, height=700)
hist(prior$resid, breaks=seq(-300,300,by=10), las=1, col='grey80', xlab='Residuals (m)', main='', ylim=c(0,100))
hist(posterior$resid, add=TRUE, breaks=seq(-300,300,by=10), ang=45, den=25)
legend("topright", c("Prior", "Posterior"), fill=c('grey80','black'), ang=c(NA,45), den=c(NA,25), bty="n", bg='white')
dev.off()



