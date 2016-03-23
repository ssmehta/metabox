#internal function to format node and edge
formatPath.TRANSACTION <- function(graph){
  out <- tryCatch(
    {
      ## Set the name for the class
      data.frame(t(sapply(graph$graph$relationships, 
                          function(x) list(source=x$startNode, target=x$endNode, type=x$type, datasource=paste0(x$properties["dataSource"],collapse = "||"), properties=paste0(x$properties["properties"],collapse = "||")))))
      },
    error=function(e) {
      message(e)
      cat("\n..RETURN empty list of relations")
      out = data.frame() # Choose a return value in case of error
    })    
  return(out)
}

formatNode.TRANSACTION <- function(node){
  out <- tryCatch(
    {
      data.frame(t(sapply(node, 
                          function(x) list(id=x$id, gid=x$properties$GID, nodename=x$properties$name, nodelabel=x$labels, nodexref=paste0(x$properties$xref,collapse = "||")))))
      },
    error=function(e) {
      message(e)
      cat("\n..RETURN empty list of relations")
      out = data.frame() # Choose a return value in case of error
    })    
  return(out)
}

formatNode.TRANSACTION.ALL <- function(node){
  out <- tryCatch(
    {
      data.frame(t(sapply(node, 
                          function(x) list(id=x$id, gid=x$properties$GID, nodename=x$properties$name, nodelabel=x$labels, 
                                           datasource=ifelse(!is.null(x$properties$dataSource),x$properties$dataSource,""), 
                                           description=ifelse(!is.null(x$properties$description),x$properties$description,""), 
                                           organism=ifelse(!is.null(x$properties$organism),x$properties$organism,""), 
                                           synonyms=paste0(x$properties$synonyms,collapse = "||"), nodexref=paste0(x$properties$xref,collapse = "||")))))
    },
    error=function(e) {
      message(e)
      cat("\n..RETURN empty list of relations")
      out = data.frame() # Choose a return value in case of error
    })    
  return(out)
}

formatId = function(x, y) {
  ind = which(y$gid == x)
  x = ifelse(length(ind)>0,y$id[ind],x)
}