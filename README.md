# 558-Project2

This app is used to pull data from the Makeup API, which contains 19 variables of information for 931 different products. The app allows the user to download the data they select and creates various numerical and graphical summaries. 

The packages needed to run this app include "shiny", "shinydashboard", and "tidyverse".

** Run the following line of code to install all the necessary packages before running the Makeup App:
install.packages(c("shiny","shinydashboard","tidyverse"))

Copy and paste this line into RStudio to run the app:

shiny::runGitHub(repo = "558-Project2", subdir = ".../Makeup", ref = "main") 
