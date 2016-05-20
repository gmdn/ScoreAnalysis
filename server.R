
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

load("results.RData")


shinyServer(function(input, output) {
  
  ## Save Goals into a variable.
  goalsIdx <- dim(results)[1]
  goals <- as.vector(results[goalsIdx, 1:10])
  
  ## Save credits into a variable.
  credits <- as.vector(results[, 11])

  ## Save average results into a variable.
  meanResults <- colMeans(results[-goalsIdx, 1:10])
  
  ## Build matrix of user results (with "goal").
  userResults <- as.matrix(results[, 1:10])
  
  ## Compute ratio over goals.
  ratioGoals <- reactive({
    
    ## Sums of the ratio between result and goal.
    scores <- userResults %*% t(1/goals)
    
    ## return weighted scores
    return(scores * input$alpha)
    
  })

  ## Compute ratio over average.
  ratioMean <- reactive({
    
    ## Sums of the ratio between result and goal.
    scores <- userResults %*% (1/meanResults)
    
    ## return weighted scores
    return(scores * input$beta)
    
  })

  ## Compute ratio over credits
  ratioCredits <- reactive({
    
    ## Sums of the ratio between result and goal.
    scores <- as.matrix(1 - (credits / 1800))
    rownames(scores) <- rownames(userResults)
    
    ## return weighted scores
    return(scores * input$gamma)
    
  })
  
  output$scores <- renderTable({
    
    ## get scores
    scoresGoal <- ratioMean()
    scoresMean <- ratioGoals()
    
    ## total
    totalScores <- scoresGoal + scoresMean
    
    ## order scores
    idxOrdered <- order(totalScores, decreasing = TRUE)
    
    ## compute weighted sum
    return(as.matrix(totalScores[idxOrdered, ]))
    
  })
  
  output$credits <- renderTable({
    
    ## get scores
    weightedScores <- ratioCredits()
    
    ## order scores
    idxOrdered <- order(weightedScores, decreasing = TRUE)
    
    ## compute weighted sum
    return(as.matrix(weightedScores[idxOrdered, ]))
    
  })

  output$total <- renderTable({
    
    ## get scores
    scoresGoal <- ratioMean()
    scoresMean <- ratioGoals()
    scoreCredits <- ratioCredits()
    
    ## total
    totalScores <- scoresGoal + scoresMean + scoreCredits
    
    ## order scores
    idxOrdered <- order(totalScores, decreasing = TRUE)
    
    ## compute weighted sum
    return(as.matrix(totalScores[idxOrdered, ]))
  })
  
  
})
