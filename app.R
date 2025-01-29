library(shiny)
library(ggplot2)
library(plotly)
library(readxl)
library(dplyr)

# Load data
data <- read_excel("Data.xlsx")  # Pastikan file ini ada di direktori yang sama

# UI
ui <- fluidPage(
  titlePanel("Visualisasi Interaktif"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("tahun", "Pilih Tahun:", 
                  min = min(data$Tahun), 
                  max = max(data$Tahun), 
                  value = min(data$Tahun),
                  step = 1,
                  animate = animationOptions(interval = 250, loop = TRUE))
    ),
    mainPanel(
      plotlyOutput("scatterPlot")
    )
  )
)

# Server
server <- function(input, output) {
  output$scatterPlot <- renderPlotly({
    data_filtered <- data %>% filter(Tahun == input$tahun)
    
    p <- ggplot(data_filtered, aes(x = Pendapatan_per_kapita, y = Angka_Harapan_Hidup, color = Benua, text = Negara)) +
      geom_point(alpha = 0.7, size = 3) +
      labs(title = paste("Hubungan Pendapatan per Kapita dan Angka Harapan Hidup di Tahun", input$tahun),
           x = "Pendapatan per Kapita",
           y = "Angka Harapan Hidup") +
      theme_minimal()
    
    ggplotly(p, tooltip = "text")
  })
}

# Jalankan aplikasi
shinyApp(ui = ui, server = server)