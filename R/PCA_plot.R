#'PCA_plot
#'@description PCA_plot
#'
#'@usage
#'@param e should be the e, where rows are samples and columns are compounds.

#'@details
#'
#'@return
#'@author Sili Fan \email{fansili2013@gmail.com}
#'@seealso
#'@examples
#'@export

PCA_plot = function(e, f, p, color, sample_information_selection){
  if(length(color)==0){
    color = "fdafdafdasfdasfdasfdasfsd"
  }
  if(length(sample_information_selection)==0){
      sample_information_selection = colnames(p) # it means we need all the information of samples.
  }else{
    sample_information_selection = colnames(p)[sample_information_selection]
    }
  if(!color%in%colnames(p)){
    p$temp = "samples"
color = "temp"
cols = gg_color_hue(length(unique(p[[color]])))
  }else{
    cols = gg_color_hue(length(unique(p[[color]])))
  }

    p$Sample_name = rownames(p)
    # e[is.na(e)] = 500
    pca = prcomp(e, center = T, scale. = T)
    score = pca$x
    score = data.frame(score, p[sample_information_selection]);rownames(score) = rownames(e)
variance = pca$sdev^2/sum(pca$sdev^2)
    temp = by(score,p[[color]],FUN=function(x){
      # x = score[p[[color]]==p[[color]][1],]
      text.temp = x[sample_information_selection]
      text.temp = apply(x[sample_information_selection],1,function(o){
        paste(paste(sample_information_selection,o, sep=": "),collapse = "</br>")
      })
      ell.info <- cov.wt(cbind(x[,1], x[,2]))
      eigen.info <- eigen(ell.info$cov)
      lengths <- sqrt(eigen.info$values * 2 * qf(.95, 2, length(x[,1])-1))
      d = rbind(ell.info$center + lengths[1] * eigen.info$vectors[,1],
                ell.info$center - lengths[1] * eigen.info$vectors[,1],
                ell.info$center + lengths[2] * eigen.info$vectors[,2],
                ell.info$center - lengths[2] * eigen.info$vectors[,2])
      r <- cluster::ellipsoidhull(d)
      pred = predict(r)
      list(list(x = x[,1], y = x[,2]
           ,mode = 'markers',type='scatter'
           ,name = x[[color]][1]
           ,text = text.temp,marker=NULL
           ),
           list(x = pred[,1], y = pred[,2]
                ,mode = 'lines',type='scatter'
                ,name = x[[color]][1]
                ,marker=NULL,showlegend=FALSE
           ))
    },simplify =F)
    temp0 = range(score[,1]);range_x = temp0 + c(-0.1 * diff(temp0), 0.1 * diff(temp0))
    temp0 = range(score[,2]);range_y = temp0 + c(-0.1 * diff(temp0), 0.1 * diff(temp0))

    result2 = list(paper_bgcolor = "rgba(0,0,0,0)",
                   plot_bgcolor = "rgba(0,0,0,0)",
                   # title="PCA Score Plot",
                   xaxis = list(
                     title = paste0("PC 1 (",round(variance[1],4) * 100,"%)"),
                     titlefont = list(
                       family="Courier New, monospace",
                       size = 18, color = "#7f7f7f"
                     )
                     # ,range = range_x
                     ),
                   yaxis=list(
                     title = paste0("PC 2 (",round(variance[2],4) * 100,"%)"),
                     titlefont = list(
                       family="Courier New, monospace",
                       size = 18, color = "#7f7f7f"
                     )
                     # ,range = range_y
                   ),
                   legend=list(
                     xanchor="auto"
                   )
                   )
    result = list()
    for(i in 1:length(temp)){
      result[[i]] = temp[[i]][[1]]
      result[[i]]$marker =  list(color = cols[i])
      result[[i+length(temp)]] = temp[[i]][[2]]
      result[[i+length(temp)]]$marker =  list(color = cols[i])
    }

data = jsonlite::toJSON(result,auto_unbox=T)
layout = jsonlite::toJSON(result2,auto_unbox=T)
return(list(data = data, layout=layout
            ,variance_explained = variance, range = list(range_x=range_x, range_y=range_x)
            ))
}
