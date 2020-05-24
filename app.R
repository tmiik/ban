
# library(shiny)
# library(shinyjs)
# 
# shinyApp(
# 
#   ui = fluidPage(
# 
#     useShinyjs(),
#     # Set up shinyjs
# 
#     "Count:", textOutput("number", inline = TRUE), br(),
#     actionButton("start", "Start"), br(),
#     "The button will be pressed automatically every 3 seconds",br(),
#     checkboxInput("stop", "Stop"), br(),
#     "The counter is stopped when the checkbox is pressed"
#   ),
#   server = function(input, output, session) {
#     output$number <- renderText({
#       input$start
#     })
# 
#     # unselect stop when start is pressed
#     observeEvent(input$start, {
#       print(7)
#       if(input$stop){
#         updateCheckboxInput(session, "stop", value = FALSE)
#       }
#     })
# 
#     # every 3000 ms, press start (if stop is unselected, else do nothing)
#     observe({
#       invalidateLater(1000)
# 
#       if(!isolate(input$stop)){
#         click("start")
#         updateCheckboxInput(session, "stop", value = FALSE)
#       }
#     })
# 
#     # after clicking start, uncheck stop checkbox
#     observeEvent(input$start, {
#       updateCheckboxInput(session, "stop", value = FALSE)
#     })
#   }
# )





library(shiny)
library(magrittr)

ui <- shinyServer(fluidPage(
  plotOutput("first_column")
))

server <- shinyServer(function(input, output, session){
  # Function to get new observations
  get_new_data <- function(){
    data <- rnorm(5) %>% rbind %>% data.frame
    return(data)
  }

  # Initialize my_data
  my_data <<- get_new_data()

  # Function to update my_data
  update_data <- function(){
    my_data <<- rbind(get_new_data(), my_data)
  }

  # Plot the 30 most recent values
  output$first_column <- renderPlot({
    #print("Render")
    invalidateLater(100, session)
    update_data()
    #print(my_data)
    plot(X1 ~ 1, data=my_data[1:60,], ylim=c(-3, 3), las=1, type="l")
  })
})

shinyApp(ui=ui,server=server)






## Only run examples in interactive R sessions
# if (interactive()) {
# 
#   ui <- fluidPage(
#     sliderInput("n", "Number of observations", 2, 1000, 500),
#     plotOutput("plot")
#   )
# 
#   server <- function(input, output, session) {
# 
#     observe({
#       # Re-execute this reactive expression after 1000 milliseconds
#       invalidateLater(1000, session)
# 
#       # Do something each time this is invalidated.
#       # The isolate() makes this observer _not_ get invalidated and re-executed
#       # when input$n changes.
#       print(paste("The value of input$n is", isolate(input$n)))
#     })
# 
#     # Generate a new histogram at timed intervals, but not when
#     # input$n changes.
#     output$plot <- renderPlot({
#       # Re-execute this reactive expression after 2000 milliseconds
#       invalidateLater(2000)
#       hist(rnorm(isolate(input$n)))
#      # hist(rnorm(input$n))
#       
#     })
#   }
# 
#   shinyApp(ui, server)
# }
