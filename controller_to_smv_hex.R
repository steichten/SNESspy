options(echo=T)
args=commandArgs(trailingOnly=T)
print(args)

##############
library(BMS)
filename=args[1]
##############

#read in datafile
controller.log=read.delim(filename,head=T)

#data comes off controller intercept as:
#1 = off
#0 = pressed
# digit placement - B,Y,Select,Start,Up,Down,Left,Right,A,X,L,R,1,1,1,1

#SMV wants hex values. A single controller recording is two bytes:

# 0001 = Right
# 0002 = Left
# 0004 = Down
# 0008 = Up
# 0010 = Start
# 0020 = Select
# 0040 = Y
# 0080 = B
# 1000 = R
# 2000 = L
# 4000 = X
# 8000 = A

# multiple presses are a sum of the above 1-15(F)

#step 1 - do some splits of the records into individual columns
p=as.character(controller.log$controllerRecord)
inputs=strsplit(p,split='')
inputs=unlist(inputs)
inputs=matrix(inputs,ncol=16,byrow=T)
formatted.data=data.frame(controller.log$timestamp,inputs[,5:16])
colnames(formatted.data)=c('timestamp','R','L','X','A','Right','Left','Down','Up','Start','Select','Y','B')


#dump the last four 'fixed' 1 values, order the buttons for the SMV format
r=formatted.data[,c(5,4,3,2,13,12,11,10,9,8,7,6)]

#swap 1 & 0
r=ifelse(r=="1",0,1)

#create the two byte hex values
out=NULL
for(i in 1:nrow(r)){
  temp=as.numeric(paste(r[i,],sep=''))
  temp1=paste(bin2hex(temp[1:4]),0,sep='')
  temp2=paste(bin2hex(temp[5:8]),sep='')
  temp3=paste(bin2hex(temp[9:12]),sep='')
  temp.all=paste(temp1,temp2,temp3,sep='')
  out=c(out,temp.all)
}

#collapse all of the frames together
out2=paste(out,collapse='')

#write it out
write.table(out2,paste(filename,'.smv.txt',sep=''),sep='',row.names=F,quote=F)