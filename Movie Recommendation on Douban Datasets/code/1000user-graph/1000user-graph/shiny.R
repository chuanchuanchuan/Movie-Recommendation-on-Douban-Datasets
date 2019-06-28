
library(shiny)
library(networkD3)

ui <- fluidPage(

  sidebarPanel(
    fileInput("file1", "ѡ���ļ�",
              multiple = TRUE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    sliderInput("link_width", "��ϵ�ߴ�ǳ:",
                min = 0.5, max = 1.5,
                value=0.5, step = 0.1),
    selectInput("link_color", "��ϵ����ɫ", 
                choices = c("black", "grey", "red")),
    sliderInput("charge", "�ڵ��ų��:",
                min = -20, max = 5,
                value=-5, step = 1),
    sliderInput("fontsize", "�ڵ����������С:",
                min = 15, max = 25,
                value=20, step = 1),
    selectInput("fontfamily", "�ڵ��ǩ����", 
                choices = c("����", "�����п�", "����"))
    ),
  mainPanel(
    
    forceNetworkOutput("network")
    
  )
)

server <- function(input, output) {
   
  
  
  output$network <- renderForceNetwork({
    
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    hr=read.csv(inFile$datapath)
    hr_edge <- hr[,c('source','target','value')]
    hr_type <- hr[,c('name','group','size')]
    hr_edge <- na.omit(hr_edge)
    hr_type <- na.omit(hr_type)
    forceNetwork(Links = hr_edge,#���������ݿ�
                 Nodes = hr_type,#�ڵ��������ݿ�
                 
                 Source = "target",#���ߵ�Դ����
                 Target = "source",#���ߵ�Ŀ�����
                 Value = "value",#���ߵĴ�ϸֵ
                 NodeID = "name",#�ڵ�����
                 Group = "group",#�ڵ�ķ���
                 Nodesize = "size" ,#�ڵ��С���ڵ����ݿ���
                 ###��������
                 height=1000,
                 linkDistance = JS("function(d){return d.value/10}"),
                 linkWidth = input$link_width,
                 radiusCalculation = JS("d.nodesize"),
                 fontFamily="����",#����������"�����п�" ��
                 fontSize = input$fontsize, #�ڵ��ı���ǩ�����������С��������Ϊ��λ����
                 linkColour=input$link_color,#������ɫ,black,red,blue,  
                 #colourScale ,linkWidth,#�ڵ���ɫ,red����ɫblue,cyan,yellow��
                 charge = input$charge,#��ֵ��ʾ�ڵ��ų�ǿ�ȣ���ֵ��������������ֵ��  
                 opacity = 10,
                 #opacityNoHover = 0.5,
                 legend=T,#��ʾ�ڵ�������ɫ��ǩ
                 arrows=F,#�Ƿ������
                 bounded=F,#�Ƿ���������ͼ��ı߿�
                 #opacityNoHover=1.0,#�������ͣ������ʱ���ڵ��ǩ�ı��Ĳ�͸���ȱ�������ֵ
                 zoom = T)
  })
  
}

shinyApp(ui = ui, server = server)

