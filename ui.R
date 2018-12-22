
library(shiny)
library(shinythemes)

shinyUI(
  fluidPage(# theme = shinytheme("darkly"),
    
  
    titlePanel(h1("NLP using UDPipe R Package", 
                   style = "font-family: 'Calibri', cursive;
                   font-style:italic;
                   color: #d76336;")),
    sidebarLayout(
      sidebarPanel(
        fileInput("file1",label = h3("Upload Data (Any text file)")),
        fileInput("file2",label = h3("Upload UDPipe Language Model")),
        
        checkboxGroupInput("xpos",
                           label = h3("Select Part of Speech (POS)"),
                           choices = list("Adjective" = 'ADJ',
                                          "Noun" = "NOUN",
                                          "Proper Noun" = "PROPN",
                                          "Adverb" = 'ADV',
                                          "Verb" = 'VERB'),
                           selected = c("ADJ","NOUN","PROPN"))
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    
                    tabPanel(h4("Overview"),
                             h2(p("NLP in R")),
                             (p("The purpose of this App is to showcase the NLP capabilties of R using R UDPipe package.
                               UDPipe provides the standard NLP functionalities of tagging, parsing and dependency evaluations - all within R",align = "justify")),
                            h2("Data Input"),
                            ("Currently this app support text files in different language which UDPipe support as input"),
                            
                            ('How to use this app'),
                            h4("Step 1:"),
                            p('To use this app, upload the text file that need to analyzed click on',
                               span(strong("Upload Data (Any text file)")),'and upload the textfile') ,
                            h4("Step 2:"),
                            p('Upload the trained udpipe model for the text language choosen above',
                                span(strong("Upload UDPipe Language Model")),'and upload the trained UDPipe Language Model'),
                               
                            h4("Step3:"),
                            p('Select the POS tag for analysis from check list, default selections are Adjective, Noun and Proper Noun(NNP)', 
                              span(strong("Select Part of Speech (POS)")),'and Select Part of Speech (POS) from the check List')
                                ),
                            
                    tabPanel(h4("Annotation"),
                             dataTableOutput('dout1')),
                            # h4('Please click below button to download the annotated data'),
                            #downloadButton("downloadData","Download Annotated Data")),
                   tabPanel(h4("co-occurences"),
                            plotOutput('plot1'))
                    
        )
      )
    )
  )
)



