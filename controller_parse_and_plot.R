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

#make a quick plot of the values
dd=melt(formatted.data,id.var='timestamp')
tiff(paste(filename,'.tiff',sep=''),width=1500,height=300)
ggplot(dd,aes(timestamp,variable)) + geom_tile(aes(fill=value)) + labs(title = filename)
dev.off()

write.table(formatted.data,paste(filename,'.formatted.txt',sep=''),sep='\t',row.names=F,quote=F)
#