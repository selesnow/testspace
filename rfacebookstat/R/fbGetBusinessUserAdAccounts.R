fbGetBusinessUserAdAccounts <- function(business_users_id = NULL, 
                                        business_id = getOption("rfacebookstat.business_id"), 
                                        api_version = getOption("rfacebookstat.api_version"), 
                                        access_token = getOption("rfacebookstat.access_token")) 
{
  if ( is.null(access_token) || is.null(business_id) ) {
    stop("Arguments access_token and business_id is require.")
  }
  
  factor_change <- FALSE
  if (getOption("stringsAsFactors")) {
    options(stringsAsFactors = F)
    factor_change <- TRUE
  }
  
  # check user id
  if ( is.null(business_users_id) ) {
    
    QueryString <- paste0("https://graph.facebook.com/", 
                          api_version, "/", business_id, "/business_users?fields=id,email,business,first_name,last_name,name,role,title", "&limit=150&access_token=", access_token)
    
    answer <- httr::GET(QueryString)
    raw <- fromJSON(httr::content(answer, "text", "application/json", 
                                  encoding = "UTF-8"))
    
    message("user = ", raw$data$name, "\nid = ", raw$data$id)
    business_users_id <- raw$data$id
   }
    
    # load accounts
    QueryString <- paste0("https://graph.facebook.com/", 
                          api_version, "/", business_users_id, "/assigned_ad_accounts?fields=tasks,permitted_tasks", 
                          "&limit=5000&access_token=", access_token)
   
    # get answer 
    answer <- httr::GET(QueryString)
    
    # pars answer
    raw <- fromJSON(httr::content(answer, "text", "application/json", 
                                  encoding = "UTF-8"))
    
    # check for error
    if (length(raw$error) > 0) {
        packageStartupMessage(paste0(" - ", raw$error$code, 
                                     " - ", raw$error$message), appendLF = T)
    }
    
    # create data frame
    result <- data.frame(id = raw$data$id,
                         task = sapply(raw$data$tasks,  str_c, collapse = ","),
                         permitted_tasks = sapply(raw$data$permitted_tasks,  str_c, collapse = ","))
    
  return(result)
}
