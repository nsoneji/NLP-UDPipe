# shinyUI() and define the appearance of our app
shinyUI(
  fluidPage(# theme = shinytheme("darkly"),      #fluidPage() defines a dynamic application layout enabling the app to automatically fit a screen size
    
  
    titlePanel(h1("NLP using UDPipe R Package",                # titlePanel() creates a panel containing an application title.
                   style = "font-family: 'Calibri', cursive;
                   font-style:italic;
                   color: #d76336;")),
    sidebarLayout(                                             # creates a layout with a sidebar and main area
      sidebarPanel(                                            # sidebarPanel() creates a sidebar panel containing input controls
        fileInput("file1",label = h3("Upload Data (Any text file)")),
        fileInput("file2",label = h3("Upload UDPipe Language Model")),
        
        checkboxGroupInput("xpos",
                           label = h3("Select Part of Speech (POS)"),
                           choices = list("Adjective" = 'JJ', 
                                          "Noun" = "NN",
                                          "Proper Noun" = "NNP",
                                          "Adverb" = "RB",
                                          "Verb" = "VB"
                                           ),
                           selected = c("JJ","NN","NNP"))
      ),
      mainPanel(                       # mainPanel() creates a main panel containing output elements, typically structured in tabs
        tabsetPanel(type = "tabs",     # tabsetPanel() creates a set of tabs with tabPanel elements  
                    
                    tabPanel(h4("Overview"),    #tabPanel() creates a tab panel that can be included within a tabsetPanel.
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
                            
                    tabPanel(h4("Annotated Document"),
                             dataTableOutput('annotatedOutput')),
                            # h4('Please click below button to download the annotated data'),
                            #downloadButton("downloadData","Download Annotated Data")),
                   tabPanel(h4("Co-occurences"),
                            plotOutput('cooccurence'))
                    
        )
      )
    )
  )
)

