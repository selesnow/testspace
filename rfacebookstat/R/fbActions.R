# action hander 
# https://developers.facebook.com/docs/marketing-api/reference/ads-action-stats/

name <- NULL
val  <- NULL
.    <- NULL
type <- NULL

# create methode
fbAction <- function(x, ...) {
  
  UseMethod("fbAction", x)
  
}

# cteate parser of all methods
# ============
# actions
# ============
# ============
fbAction.default <- function( obj ) {
  
  actions <-
    map_df(obj$data, 
           function(.x) {

             nm <- names(.x)
             nm <- nm[ ! nm %in% c("actions", "action_values") ]
             
             other_col <- .x[nm] %>% bind_rows()
             
             if ( length(.x$actions ) > 0 ) {
               
               df_actions <-
                 .x$actions %>%
                 bind_rows() %>%
                 pivot_longer(cols = -matches("action\\_.*" ), names_to = "action_sufix", values_to = "val") %>%
                 unite(action_type, matches("action\\_.*" ), remove = T) %>%
                 replace_na(list(val = 0)) %>%
                 pivot_wider(names_from = "action_type", values_from = "val", values_fill = list("val" = "0")) %>%
                 bind_cols(other_col, .)
               
               df <- df_actions
             } 
             
             if ( length(.x$action_values ) > 0 ) {
               
               df_action_values <-
                 .x$action_values %>%
                 bind_rows() %>%
                 pivot_longer(cols = -matches("action\\_.*" ), names_to = "action_sufix", values_to = "val") %>%
                 mutate(action_type = paste0("action_values.", action_type)) %>%
                 unite(action_type, matches("action\\_.*" ), remove = T) %>%
                 replace_na(list(val = 0)) %>%
                 pivot_wider(names_from = "action_type", values_from = "val", values_fill = list("val" = "0")) 
               
                 if ( exists("df_actions") ) {
                   
                   df <- bind_cols(df_actions, df_action_values) 
                   
                 } else {
                   
                   df <- bind_cols(other_col, df_action_values) 
                   
                 }
               
             } 
             
             if ( length( .x$actions ) + length( .x$action_values ) == 0 ) {
               
               other_col
               
             } else {
               
               df
               
             }
             
           }
    )
  
  return(actions)
}


# ============
# action_device
# ============
fbAction.action_device <- function( obj ) {
  
  # action breakdown handing
  tempData <- list()
  
  for ( o1 in obj$data ) {
    
    if ( ! is.null(o1$actions) ) {
      
      r <- lapply(o1$actions, function(x) list(name = x$action_device,
                                               val  = x$value)) %>%
        map_df(flatten) %>%
        unique() %>%
        spread(key = name, value = val)
      
      
      f <-  o1[! names(o1) == "actions"] %>%
        do.call("cbind", .) %>%
        cbind(., r) %>%
        lapply( as.character )
      
    } else {
      f <-  o1[ ! names(o1) == "actions" ] %>%
        bind_cols()
    }
    
    tempData <- append(tempData, list(f))
    
  }
  
  #Adding data to result
  tempData <- purrr::map_df(tempData, purrr::flatten)
  return(tempData)
}

# ============
# action_destination
# ============
fbAction.action_destination <- function( obj ) {
  
  # action breakdown handing
  tempData <- list()
  
  for ( o1 in obj$data ) {
    
    if ( ! is.null(o1$actions) ) {
      
      r <- lapply(o1$actions, function(x) list(name = x$action_destination,
                                               val  = x$value)) %>%
            map_df(flatten) %>%
            group_by(name) %>%
            summarise(val = sum( as.integer(val) )) %>%
            unique() %>%
            spread(key = name, value = val) 
      
      f <-  o1[! names(o1) == "actions"] %>%
        do.call("cbind", .) %>%
        cbind(., r) %>%
        lapply( as.character )
      
    } else {
      f <-  o1[ ! names(o1) == "actions" ] %>%
        bind_cols()
    }
    
    tempData <- append(tempData, list(f))
    
  }
  
  #Adding data to result
  tempData <- purrr::map_df(tempData, purrr::flatten)
  return(tempData)
}

# ============
# action_reaction
# ============
fbAction.action_reaction <- function( obj ) {
  
  # action breakdown handing
  tempData <- list()
  
  for ( o1 in obj$data ) {
    
    if ( ! is.null(o1$actions) ) {
      
      r <- lapply(o1$actions, function(x) list(name = ifelse( is.null(x$action_reaction), NA,  x$action_reaction),
                                               type = ifelse( is.null(x$action_type), NA,  x$action_type),
                                               val  = x$value)) %>%
        map_df(flatten) %>%
        mutate(name = str_c(type, name, sep = "."),
               name = ifelse( is.na(name), type, name) ) %>%
        select(name, val) %>%
        group_by(name) %>%
        summarise(val = sum( as.integer(val))) %>%
        unique() %>%
        spread(key = name, value = val)
      
      
      f <-  o1[! names(o1) == "actions"] %>%
        do.call("cbind", .) %>%
        cbind(., r) %>%
        lapply( as.character )
      
    } else {
      f <-  o1[ ! names(o1) == "actions" ] %>%
        bind_cols()
    }
    
    tempData <- append(tempData, list(f))
    
  }
  
  #Adding data to result
  tempData <- purrr::map_df(tempData, purrr::flatten)
  return(tempData)
}

# ============
# action_target_id
# ============
fbAction.action_target_id <- function( obj ) {
  
  # action breakdown handing
  tempData <- list()
  
  for ( o1 in obj$data ) {
    
    if ( ! is.null(o1$actions) ) {
      
      r <- lapply(o1$actions, function(x) list(action_target_id = x$action_target_id,
                                               action_value     = x$value)) %>%
           map_df(flatten)
      
      f <-  o1[! names(o1) == "actions"] %>%
                do.call("cbind", .) %>%
                cbind(., r) %>%
        lapply( as.character )
      
    } else {
      f <-  o1[ ! names(o1) == "actions" ] %>%
            bind_cols()
    }
    
    tempData <- append(tempData, list(f))
    
  }
  
  #Adding data to result
  tempData <- bind_rows(tempData)
  return(tempData)
}

# ============
# action_type
# ============
fbAction.action_type <- function( obj ) {

  actions <-
  map_df(obj$data, 
           function(.x) {
          #.x = obj$data[[1]]
           nm <- names(.x)
           nm <- nm[ ! nm %in% c("actions", "action_values") ]

           other_col <- .x[nm] %>% bind_rows()

           if ( length(.x$actions ) > 0 ) {
             
               df <-
               .x$actions %>%
               bind_rows() %>%
               pivot_longer(cols = -action_type, names_to = "action_sufix", values_to = "val") %>%
               unite(action_type, c("action_type", "action_sufix"), remove = T) %>%
               replace_na(list(val = 0)) %>%
               pivot_wider(names_from = "action_type", values_from = "val", values_fill = list("val" = "0")) %>%
               bind_cols(other_col, .)

            } else {
             other_col
            }
           }
           )
  
  return(actions)

}
