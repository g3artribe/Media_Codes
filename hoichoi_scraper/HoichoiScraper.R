


require(httr)

typs=c('latest-movies','free-movies',paste0('genre/',c('drama','action','sex','romance','classic','detective','comedy','family','thriller')))

out=NULL
for(typ in typs)
{
  print(typ)
  h=GET(paste0('https://prod-api-cached-2.viewlift.com/content/pages?path=%2F',typ,'&site=hoichoitv&includeContent=true&moduleOffset=0&moduleLimit=500&languageCode=default&countryCode=IN'))
  require(jsonlite)
  tmp=content(h,'text')
  
  tmp=fromJSON(tmp)
  
  s=sapply(tmp$modules$contentData,function(x) {
    
    k=sapply(x$contentDetails$closedCaptions,function(y) ifelse(nrow(y)==0,NA,unlist(y$url[y$format=="SRT"])) )
    if(length(x$gist$permalink)==0) return( NULL)
    data.frame(Title=x$gist$title,
               Link=x$gist$permalink,
               Desc=x$gist$description,
               Year=ifelse(length(x$gist$year)==0,NA,x$gist$year),
               Runtime=x$gist$runtime)
               #Srt=ifelse(length(k)==0,NA,k))
    })
  
  s=do.call(rbind,s)
  if(is.null(s)) next
  s=s[order(s$Title),]
  
  out=rbind(out,s)
}
out=out[!duplicated(out$Link),]

out$Link=paste0('https://hoichoi.tv',out$Link)
dat=read.csv('/Volumes/Data/Movies/hoichoi_scraper/movielist.csv',stringsAsFactors = F)

cat(' New:',sum(!out$Links%in%dat$Links))

out=rbind(out,dat)
out=out[!duplicated(out$Link),]
out=out[order(out$Title),]


write.csv(out,'movielist.csv',row.names = F)
