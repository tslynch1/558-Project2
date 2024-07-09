library(jsonlite)
library(tidyverse)
library(shiny)

# All of the makeup data, which will be used in the Data Exlporation tab
input_URL <- paste0("https://makeup-api.herokuapp.com/api/v1/products.json")
info_from_URL <- httr::GET(input_URL)
parsed_data <- fromJSON(rawToChar(info_from_URL$content))
# Create a data frame of selected variables
output_tib <- as_tibble(parsed_data) 
makeup_tib <- output_tib |>
  dplyr::select(id, brand, name, product_type, category, tag_list, price, rating)


no_missing_both <- makeup_tib |>
  filter(!is.na(price) & !is.na(rating))

summary_tib <- makeup_tib |>
  filter(brand %in% c("clinique","covergirl","e.l.f.","maybelline","revlon")) |>
  ## Insert input value for different product types below
  filter(product_type == "lipstick") |>
  group_by(brand) |>
  summarise(Count = n(),
            Count_Missing = sum(is.na(as.numeric(price))),
            Mean_Price = round(mean(as.numeric(price), na.rm = TRUE),2),
            Std.Dev_Price = round(sd(as.numeric(price), na.rm = TRUE),2),
            Minimum_Price = round(min(as.numeric(price), na.rm = TRUE),2),
            Median_Price = round(median(as.numeric(price), na.rm = TRUE),2),
            Maximum_Price = round(max(as.numeric(price), na.rm = TRUE),2))

# Define server logic required to produce data or output objects in each tab
function(input, output, session) {
  
  ####################### CODE FOR THE DATA DOWNLOAD TAB #################################
  ## Get data for only the Brand and Maximum Price specified
  get_data <- reactive({
    base_url <- "https://makeup-api.herokuapp.com/api/v1/products.json/"
    #1. Construct parameters based on inputs 
    params <- list(brand = input$brand_choice, price_less_than = input$max_price) 
    if (input$brand_choice == "e.l.f." && input$vegan == T) {
      params <- c(params, list(tag_list = "Vegan")) 
    }
    
    #2. Make sure that the API requests (based on the parameters sent in step 1)
    res <- httr::GET(base_url, query = params)
    if (res$status_code != 200) { 
      showNotification("Error: unsupported type", type = "error")
      return(NULL) 
    } 
    else {
    data <- fromJSON(httr::content(res, "text"))
    }
    
    #3. Convert the data.frame and filter columns
    data_df <- as.data.frame(data) 
    data_df <- data_df %>% dplyr::select(id, brand, name, product_type, category, tag_list, price, rating) 
    return(data_df) 
  })
  
  # Generate a data table based on the selected input values 
    output$selected_data <- renderTable({
      # Get the data based on user input
      makeup_data <- get_data()
      makeup_data
  })
               
    # Give the user the ability to download the selected data as a CSV
    output$downloadData <- downloadHandler(
      filename = paste0("makeup_data.csv"),
      content = function(file) {
        write.csv(get_data(), file, row.names = TRUE)
      }
    )
    
  ####################### CODE FOR THE DATA DOWNLOAD TAB #################################
  # Create output objects based on user input for what analysis summaries they want to see (using full makeup data set)
  
  
}


