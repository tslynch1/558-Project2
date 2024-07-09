library(shiny)
library(shinydashboard)
library(DT)

header_dash <- dashboardHeader(title = "ST 558 - Project 2 Shiny App")

sidebar_dash <- dashboardSidebar(
  sidebarMenu(
    menuItem(" About", tabName = "about_first", icon = icon("info")),
    menuItem(" Data Download", tabName = "download", icon = icon("download")),
    menuItem(" Data Exploration", tabName = "chart-bar", icon = icon("table"))
  )
)

body_dash <- dashboardBody(
  tabItems(
    ####################### CODE FOR THE ABOUT TAB #################################
    tabItem(tabName = "about_first",
            h2("About Tab"),
            br(),
            h4("The purpose of this app is to query a database of makeup products and produce numerical and graphical summaries regarding the price and rating of different brands or types of products."),
            br(),
            h4("This data set comes from the ", a(href = "http://makeup-api.herokuapp.com/", "Makeup API"), "which can be used to determine descriptive information about Brand, Product Type, Release Data, Price, and Rating of different makeup products"),
            br(),
            h4("The Data Download tab allows the user to specify changes to the API querying functions and return data, display and/or subset the data, and allow for the data to be downloaded."),
            br(),
            h4("The Data Exploration tab allows the user to choose variables, or combinations of variables, to be summarized with numerical, tabular, or graphical summaries. The user can also choose the specific type of plot or summary report they want to see."), 
            br(),
            tags$img(src="makeup_pic.png", height = "200px", width = "350px", alt = "This is supposed to be a picture of makeup products", deletefile = FALSE)
            ),
    
    ####################### CODE FOR THE DATA DOWNLOAD TAB #################################
    tabItem(tabName = "download",
            h2("Data Download Tab"), 
            h4("The data being queried comes from the Makeup API."),
            br(),
            fluidRow(
              sidebarPanel(
                radioButtons("brand_choice", "Brands", choices = list("Clinique" = "clinique", "Covergirl" = "covergirl", "e.l.f." = "e.l.f.", "Maybelline" = "maybelline", "Revlon" = "revlon")),
                br(),
                sliderInput("max_price", label = "Products Cost Less Than",
                            min = 10, max = 40, value = 40, step = 5, ticks = TRUE),
                br(),
                conditionalPanel(
                  condition = "input.brand_choice == 'e.l.f.'",
                  checkboxInput("vegan", "Vegan e.l.f. Products Only?")
                ),
                br(),
                downloadButton("downloadData", "Download Data")
              ),
              mainPanel(
                tableOutput("selected_data")
              )
            )
            
    ),
    
    ####################### CODE FOR THE DATA EXPLORATION TAB #################################
    tabItem(tabName = "exploration",
            h2("Data Exploration Tab")
    )
  )
  
)

dashboardPage(header_dash, sidebar_dash, body_dash)