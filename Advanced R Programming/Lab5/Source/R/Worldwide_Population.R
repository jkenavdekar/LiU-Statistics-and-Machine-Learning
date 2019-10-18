#' Title Worldwide_Pollution
#'
#' @field responses list. The list of responses comming from API 
#' @field root_url character. The base url of the API
#' @field countries list. A list of the user's input
#' @description This class creates one object which can give access in an API.The user can choose between four countries(Greece,Italy,Sweden,Turkey),
#' and manipulate data for air pollution such as value pm5.
#' @import methods
#' @export Worldwide_Pollution
#' @exportClass Worldwide_Pollution 
Worldwide_Pollution =   
  setRefClass(
    "Worldwide_Pollution",
    fields = list(
     responses = "list",
     root_url = "character",
     countries = "list"
    ),
    methods = list(
      initialize = function(country_list=list("Sweden")){
        if(!is.list(country_list) | any(!unlist(lapply(country_list, is.character))))
          stop("The input is not a list!")
        supported_countries = list(
          "Turkey",
          "Italy",
          "Greece",
          "Sweden"
        )
        if(any(!(country_list %in% supported_countries)))
          stop("No correct input")
        if(length(country_list)==0)
          stop("country_list parameter cannot be empty!")
       
        
        countries <<- country_list
        root_url <<- "https://public.opendatasoft.com/api/records/1.0/search/?dataset=worldwide-pollution"
        responses <<- get_all_country_responses()
      },
      
      # takes parameter:
      # country: string
      # facets: list that contains facets that you want
      get_country_data = function(country, facets=c()){
        response = jsonlite::fromJSON(get_req_url(get_req_part(facets,"facet"), get_req_query("refine.country", country), get_req_query("rows", "10000")))
        return(response)
      },
      
      # returns observations of countries:
      # Turkey,Greece,Italy,Sweden
      # as a dataframe
      get_all_country_responses = function(){
        ress = list()
        for (country in countries) {
          cat(country, "request sent..." , sep = " ", "\n")
          res = jsonlite::fromJSON(get_req_url(get_req_query("refine.country", country), get_req_query("rows", "10000")))
          ress[[country]]=res
          cat(country, "responded!" , sep = " ", "\n")
        }
        return(ress)
      },
      
      
      # returns &key=value
      get_req_query = function(key,val){
        return(paste(list("&",key,"=",gsub(" ", "%20", val)), collapse = ""))
      },
      
      # if you have a list for request parameters.
      # This function will return repeatly get_req_query
      # for facet_list and key=facet
      # it returns &facet=facet_list[1]&facet=facet_list[2]
      get_req_part = function(facet_list, key){
        return(paste(lapply(facet_list, FUN=get_req_query, key=key), collapse=""))
      },
      
      # takes elements as parameter
      # returns the whole url for request
      get_req_url = function(...){
        elements = list(...)
        return(paste(c(root_url, elements), collapse=""))
      },
      
      # gets only one response from API and specific facets to get data that we want
      # returns dataframe only for response
      get_only_faced_data = function(response,facet_vector){
        if(length(facet_vector)==0)
          stop("facet_vector cannot be empty!!!")
        return(response$records$fields[,facet_vector])
      },
      
      # gets a response_list contains responses from API and specific facets to get data that we want
      # returns only one dataframe that merged all responses by row wise
      get_facets_all_responses = function(facet_vector){
        if(length(facet_vector)==0)
          stop("facet_vector cannot be empty!!!")
        if(!(is.vector(facet_vector) && is.character(facet_vector)))
          stop("facet_vector should be character vector!!!")
        d=NA
        counter=1
        for (res in responses) {
          if(counter==1)
            d=get_only_faced_data(res, facet_vector) 
          else
            d=rbind(d, get_only_faced_data(res, facet_vector))
          counter=counter+1
        }
        return(d)
      }
      
    )                        
)
