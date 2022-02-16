anovatab <-
function(mod){
  tab=as.matrix(anova(mod))
  rows=dim(tab)[1]
  moddf=sum(tab[,1])-tab[rows,1]
  ssmodel=sum(tab[,2])-tab[rows,2]
  msmodel=ssmodel/moddf
  f=msmodel/tab[rows,3]
  p=1-pf(f,moddf,tab[rows,1])
  tab2=tab[(rows-1):rows,]
  tab2[1,1:5]=c(moddf,ssmodel,msmodel,f,p)
  tab2=rbind(tab2,c(moddf+tab2[2,1],ssmodel+tab2[2,2],rep(NA,3)))
  rownames(tab2)=c('Model','Error','Total')
  colnames(tab2)[1]='df'
  return(print(tab2,na.print = "" , quote = FALSE,digits=3))
}
