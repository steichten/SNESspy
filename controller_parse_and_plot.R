options(echo=T)
args=commandArgs(trailingOnly=T)
print(args)

##############
filename=args[1]
library(ggplot2)
library(reshape2)
options("digits.secs"=6)
##############

#read in data and ID the time data accordingly
#split values into individual columns
file=read.delim(filename,head=T)
time=strptime(file$timestamp,format="%Y-%m-%dT%H:%M:%OS")
p=as.character(file$controllerRecord)
inputs=strsplit(p,split='')
inputs=unlist(inputs)
inputs=matrix(inputs,ncol=16,byrow=T)
formatted.data=data.frame(time,inputs[,5:16])
colnames(formatted.data)=c('timestamp','R','L','X','A','Right','Left','Down','Up','Start','Select','Y','B')

#define the time difference between each cycle
formatted.data[,14]=c(NA,diff(formatted.data$timestamp))
#remove odd doubles
formatted.data=subset(formatted.data,formatted.data$V14>0.003)
#go through and identify all sections that cycle too fast (>60Hz) as these are 
#(thought to be) resets of the console. From that, give a section identifier 
#in between each of these as we will look at them separately

attempt=c(1,rep(NA,nrow(formatted.data)-1))
start=1
for(i in 2:length(attempt)){
	if(formatted.data[i,2]==1 & formatted.data[i-1,2]==0){
		start=start+1
		attempt[i]=start} else {attempt[i]=start}

}
attempt=matrix(attempt,ncol=1)
#stick it all to our formatted data
formatted.data=cbind(formatted.data,attempt)



####################################

#
#make a quick plot of the values
for(i in 1:start){
plot.attempt=subset(formatted.data,formatted.data$attempt==i)
if(nrow(plot.attempt)<200){next}
dd=melt(plot.attempt[,1:13],id.var='timestamp')
plotout=ggplot(dd,aes(timestamp,variable)) + geom_tile(aes(fill=value,width=0.016)) + scale_fill_manual(values=c("#999999","#99CCFF")) + labs(title='June 25th Example Run',x='Time(Hour:Min)',y='Buttons')
ggsave(paste(filename,'_','attempt','_',i,".pdf",sep=''),plotout,width=11,height=3,units="in")
}

write.table(formatted.data,paste(filename,'.formatted.txt',sep=''),sep='\t',row.names=F,quote=F)
#