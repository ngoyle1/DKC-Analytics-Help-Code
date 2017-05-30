fb_audience_simple_overlap <- function(id_1,name_1, id_2, name_2){
    x <- fbad_reachestimate(targeting_spec = list(
        geo_locations = list(countries = 'US'),
        flexible_spec = list(
            list(interests = data.frame(
                id = id_1,
                name = name_1
            )),
            list(interests = data.frame(
                id = id_2,
                name = name_2
            ))
        )
    ))$users
    return(x)
}
##Get Overlap for Lower Overlap Shows
my_matrix <- data.frame()

for(i in 1:nrow(lower)){
    for(j in 1:nrow(lower)){
        my_matrix[i,j] <- fb_audience_simple_overlap(id_1 = lower$id[i],name_1 = lower$show[i],
                                                     id_2 = lower$id[j], name_2 = lower$show[j])
        print(i + j)
        Sys.sleep(3)
    }
}
remove(i,j)

colnames(my_matrix) <- lower$show
row.names(my_matrix) <- lower$show

p <- diag(as.matrix(my_matrix))

mymax2 <- my_matrix

for(i in 1:nrow(mymax2)){
    mymax2[i,] <- mymax2[i,]/p[i]
}
remove(i)