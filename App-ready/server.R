abalone <- read.csv("./Data/abalone.csv")
abalone <- abalone[,c(2:10)]
listOfNames <- names(abalone)
rest <- listOfNames[c(1,9)]
listOfNames <- listOfNames[2:8]
abaloneGood <- abalone

server <- function(input, output) {
       
       output$doc1 <- renderText({ 
              
              "With this app you can investigate how lm, rf, gbm and c50 works using abalone dataset"
              })
       output$doc2 <- renderText({ 
              "-please choose any columns to add or remove"
              
       })
       
       output$doc3 <- renderText({ 
              
              "-you should use all genders to enter ML tab (classification task)"
       })
       
       output$doc4 <- renderText({ 
              
              "-plots will dynamically fit to your needs"
       })
       
       output$doc5 <- renderText({ 
              
              "-investigate how outliers affect lm line"
       })
       
       output$doc6 <- renderText({ 
              
              "-research how number of predictors builds an outcome"
       })
       
       datasetInput <- reactive({
              switch(input$sex,
                     "Male" = abalone[abalone$sex == 'M',c(rest, input$Columns)],
                     "Female" = abalone[abalone$sex == 'F',c(rest, input$Columns)],
                     "Infant" = abalone[abalone$sex == 'I',c(rest, input$Columns)],
                     "All" = abalone[,c(rest, input$Columns)]
                     )
       })
       
       output$table <- renderDataTable(datasetInput(),options = list(pageLength = 10))
       
       output$info <- renderText({
              input$axis
       })
       
       output$plot <-
              renderPlot({
                     if( length(  intersect(input$Columns, input$axis) )  >= 1     ){
                            output$info <- renderText({
                                   "processing...."
                            })
                            
                            x_axis <- input$axis
                            if(x_axis == "length"){
                                   gg <- ggplot(datasetInput(), aes(length, rings))
                            }
                            if(x_axis == "diameter"){
                                   gg <- ggplot(datasetInput(), aes(diameter, rings))
                            }
                            if(x_axis == "height"){
                                   gg <- ggplot(datasetInput(), aes(height, rings))
                            }
                            if(x_axis == "whole.wt"){
                                   gg <- ggplot(datasetInput(), aes(whole.wt, rings))
                            }
                            if(x_axis == "shucked.wt"){
                                   gg <- ggplot(datasetInput(), aes(shucked.wt, rings))
                            }
                            if(x_axis == "viscera.wt"){
                                   gg <- ggplot(datasetInput(), aes(viscera.wt, rings))
                            }
                            if(x_axis == "shell.wt"){
                                   gg <- ggplot(datasetInput(), aes(shell.wt, rings))
                            }
                            gg <- gg + geom_jitter(alpha=0.25)
                            gg <- gg + geom_smooth(method=loess, se=FALSE)
                            gg <- gg + facet_grid(. ~ sex)
                            gg
                     }else{
                            output$info <- renderText({
                                   "Please add selected axis column to dataset"
                            })
                     }
              })
       
       #to do - rewrite
       fited <- reactive({
               
              if(length(datasetInput()$sex == 3)){
              
              set.seed(998)
              metric <- "Accuracy"
              inTraining <- createDataPartition(datasetInput()$sex, p = .75, list = FALSE)
              training <- datasetInput()[ inTraining,]
              testing  <- datasetInput()[-inTraining,]
              fitControl <- trainControl(## 10-fold CV
                     method = "repeatedcv",
                     number = 5,
                     repeats = 3)
              
              if(input$method == "gbm"){
                     output$info <- renderText({
                            "Learning gbm...."
                     }) 
                     gbm <- train(sex ~ ., data = training, 
                                    method = "gbm", 
                                    trControl = fitControl,
                                    verbose = FALSE,
                                  metric = metric)
                     output$info <- renderText({
                            "Done"
                     })
                     
                     return(gbm) 
              }
              if(input$method == "c50"){
                     "Learning c50...."
                     c50 <- train(sex ~ ., data = training, 
                                  method="C5.0", 
                                  trControl = fitControl,
                                  verbose = FALSE,
                                  metric = metric)
                     
                     output$info <- renderText({
                            "Done"
                     })
                     
                     return(c50)
              }
              
              if(input$method == "rf"){
                     "Learning rf...."
                     rf <- train(sex ~ ., data = training, 
                                  method="rf", 
                                  trControl = fitControl,
                                  verbose = FALSE,
                                  metric = metric)
                     
                     output$info <- renderText({
                            "Done"
                     })
                     
                     return(rf)
              }
              
              }
              else{
                     output$info <- renderText({
                            "Please Select all genders"
                     })  
              }
       })

       output$summary <- renderPrint({ fited() })
       output$summary1 <- renderText({ "TEXT"})
       
}
