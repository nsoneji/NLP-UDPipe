library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

options(shiny.maxRequestSize = 30*1024^2)
shinyServer(function(input,output){
  
  Dataset <- reactive({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      text <- readLines(input$file1$datapath)
      text = str_replace_all(text,"<.*?>","")
      
      text = text[text != ""]
      
      return(text)
    }
  })
  
  english_model <- reactive({
    if(is.null(input$file2)){ return (NULL)}
    else {
    english_model = udpipe_load_model(input$file2$datapath)
    return(english_model)
    }
  })
  
  annotation = reactive({
    x <- udpipe_annotate(english_model(),x = Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  
  output$dout1 = renderDataTable({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      out = annotation()[,-4]
      return(out)
    }
  })
  output$plot1 = renderPlot({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      text_cooc <- cooccurrence(
        x = subset(annotation(),upos %in% input$xpos),
        term = "lemma",
        group = c("doc_id","paragraph_id","sentence_id"))
      
      wordnetwork <- head(text_cooc,50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
      
      ggraph(wordnetwork, layout = "fr") +
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +
        theme(legend.position = "none") +
        
        labs(title = "Cooccurence plot", subtitle = input$xpos[2])
      
    }
  }) 
 
})