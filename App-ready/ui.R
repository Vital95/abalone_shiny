library(shiny)
library(ggplot2)
library(caret)
library(C50)

abalone <- read.csv("./Data/abalone.csv")
abalone <- abalone[,c(2:10)]
listOfNames <- names(abalone)
rest <- listOfNames[c(1,9)]
listOfNames <- listOfNames[2:8]
abaloneGood <- abalone

ui <- fluidPage(
       titlePanel("Abalone dataset analysis"),

       sidebarLayout(
              sidebarPanel(
                     selectInput(inputId = "sex", label = "Choose a sex:",
                                 choices = c("Male", "Female", "Infant","All")),
                     
                     checkboxGroupInput("Columns", "Choose columns:", choiceNames = listOfNames,
                                        choiceValues = listOfNames),
                     
                     selectInput(inputId = "axis", label = "Choose a second axis:",
                                 choices = listOfNames),
                     
                     selectInput(inputId = "method", label = "Choose a method:",
                                 choices = c("gbm","c50","rf")),
                     
                     verbatimTextOutput("info")
              ),
              mainPanel(
                     tabsetPanel(
                            
                            tabPanel("How to use (documentation) ", fluid = TRUE,
                                     fluidRow(
                                            
                                            
                                            h1(textOutput('doc1')),
                                            p(textOutput('doc2')),
                                            p(textOutput('doc3')),
                                            p(textOutput('doc4')),
                                            p(textOutput('doc5')),
                                            p(textOutput('doc6'))
                                     )
                            ),
                            tabPanel("Dataset", fluid = TRUE,
                                     fluidRow(dataTableOutput('table'))
                            ),
                            
                            tabPanel("Plot", fluid = TRUE,
                                     fluidRow(  plotOutput('plot'))
                                     
                            ),
                            
                            tabPanel("ML Predictions", fluid = TRUE,
                                     fluidRow(
                                     verbatimTextOutput('summary'),
                                     textOutput('summary1')
                                     )
                                     
                            )
                     )
              )
       )
)