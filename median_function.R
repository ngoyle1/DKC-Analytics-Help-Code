define_median <- function(input_vector){
  x <- sort(c(input_vector), decreasing = FALSE)
  modulo <- length(x) %%2
  if(modulo == 0){
    median <- (x[length(x)/2] + x[length(x)/2 + 1])/2
  }else{
    median <- x[length(x)/2 + 1]
  }
  return(median)
}

is_prime <- function(n){
  if(n == 2){
    TRUE
  }else if(any(n%%2:(n-1) == 0)){
    FALSE
  }else{
    TRUE
  }
}

return_all_primes <- function(list_of_numbers){
  x <- list_of_numbers
  y <- unlist(lapply(x, is_prime))
  f <- x[which(y == TRUE)]
  return(f)
}

fibonacci_sequence <- function(enter_number){
  sequence <- c(0,1)
  for(i in 1:enter_number){
    if(enter_number == 1){
      return(0)
    }else if(enter_number == 2){
      return(c(0,1))
    }else{
    sequence <- append(x = sequence, values = sequence[i-1] + sequence[i-2])
    }
  }
  return(sequence)
}

options(scipen = 999)
fibonacci_sequence(125)

plot(1:3,fibonacci_sequence(3))