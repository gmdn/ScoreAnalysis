
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Score Analysis"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("alpha",
                  "Goals",
                  min = 0,
                  max = 2,
                  value = 1,
                  step = 0.1),
      
      sliderInput("beta",
                  "Average",
                  min = 0,
                  max = 2,
                  value = 1,
                  step = 0.1), 
      
      sliderInput("gamma",
                  "Credits",
                  min = 0,
                  max = 2,
                  value = 1,
                  step = 0.1)
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      
      fluidRow(column(4, tableOutput("scores")),
               column(4, tableOutput("credits")),
               column(4, tableOutput("total")))
      
    )
  )
))
