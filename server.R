
options(shiny.maxRequestSize = 30*1024^2)
shinyServer(function(input,output){
  
  Dataset <- reactive({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      text <- readLines(input$file1$datapath)
      text = str_replace_all(text,"<.*?>","")
      text = str_replace_all(text,"[^a-zA-Z\\s]", " ")
      text = str_replace_all(text,"[\\s]+", " ")
      text = str_replace_all(text,"<.*?>","")
      text = text[text != ""]
      
      return(text)
    }
  })
  
  model <- reactive({
    if(is.null(input$file2)){ return (NULL)}
    else {
    udpipe_model = udpipe_load_model(input$file2$datapath)
    return(udpipe_model)
    }
  })
  
  annotated_df = reactive({
    
    x <- udpipe_annotate(model(),x = Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  
  output$annotatedOutput = renderDataTable({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      out = annotated_df()[,-4]
      out = out %>% subset(.,xpos %in% input$xpos)
      return(out)
    }
  })
  
  plotname <- reactive(
    {  
  plotname = NULL
  
  for ( i in 1:length(input$xpos))
  {
    plotname = paste(plotname,input$xpos[i]) 
    
  }
  
  return (plotname)
    }
  )
  output$cooccurence = renderPlot({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      text_cooc <- cooccurrence(
        x = subset(annotated_df(),xpos %in% input$xpos),
        term = "lemma",
        group = c("doc_id","paragraph_id","sentence_id"))
      
      wordnetwork <- head(text_cooc,50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
      
      ggraph(wordnetwork, layout = "fr") +
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "red") +
        geom_node_text(aes(label = name), col = "blue", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +
        theme(legend.position = "none") +
        
        labs(title = "Cooccurence plot", subtitle = plotname() )
    
    }
  }) 
 
})
