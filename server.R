library(shiny)
library(ggplot2)
library(plotly)
library(reshape2)
library(gridExtra)

shinyServer(
        function(input, output) {
        
                new_df <- reactive({
                        y1 = input$yearRange[1]
                        y2 = input$yearRange[2]
                        diff_df[(diff_df$Year >= y1 & diff_df$Year <= y2),]
                })
                
                plot1 <- reactive({
                        vari = which(names(new_df()) == input$stat)
                        xstat = new_df()[,vari]
                        breaks <- pretty(range(xstat), n = nclass.FD(xstat), min.n = 1)
                        bwidth <- breaks[2]-breaks[1]
                        if(input$radio == 1) {
                                g1 = ggplot(new_df(), aes(x = xstat)) +
                                        geom_histogram(aes(y = ..density..), binwidth = bwidth) +
                                        geom_density(alpha = 0.2, fill = 'blue') +
                                        geom_vline(aes(xintercept = 0), color = "orange", size = 1.5) +
                                        geom_vline(aes(xintercept = mean(xstat)), color = 'red', size = 1) +
                                        xlab(paste(names(new_df())[vari], "difference")) +
                                        ggtitle(label = paste("Mean Difference (red line):", round(mean(xstat), 2))) +
                                        theme_bw()
                        }
                        m = data.frame(Stat = input$stat, Difference = xstat)
                        if(input$radio == 2) {
                                g1 = ggplot(m, aes(Stat, Difference)) + 
                                        geom_boxplot(fill = 'blue', alpha = 0.2, outlier.size = 4) + 
                                        geom_hline(yintercept = 0, color = 'orange', size = 1.3) +
                                        theme_bw()
                        }
                        g1
                })
                
                plot2 <- reactive({
                        d0 = new_df()[,-c(1:3)]
                        defI = grep("D", names(d0))
                        d0[,-defI] = lapply(d0[,-defI], function(x) {ifelse(x > 0, 1, 0)})
                        d0[,defI] = lapply(d0[,defI], function(x) {ifelse(x < 0, 1, 0)})
                        diff_sums = cbind(new_df()[,c(1:3)], d0)
                        percents = melt(colSums(diff_sums[,-c(1:3)])/nrow(diff_sums))
                        percents$name = row.names(percents)
                        percents$value = percents$value * 100
                        percents = arrange(percents, desc(value))
                
                
                        g2 = ggplot(percents, aes(reorder(name, value), value)) +
                                geom_col(fill = "blue", alpha = 0.2) +
                                geom_hline(aes(yintercept = 50)) +
                                coord_flip() +
                                ylab("% of Winning Teams with Better Stat than Opponent") +
                                xlab("Stat") +
                                geom_text(aes(x = name, y = value, label = round(value, 2)), 
                                        hjust = 1.5, color = "red", size = 3.5) +
                                scale_y_continuous(limit = c(0, 100)) +
                                theme_bw()
                        g2
                })
                
                linePlot <- reactive({
                        ggplot(new_df(), aes(x = Year, text = Team, group = 1)) +
                                geom_hline(aes(yintercept = 0)) +
                                geom_point(aes_string(y = input$stat), 
                                           shape = 21, size = 1.5, fill = 'ivory3') +
                                geom_path(aes_string(y = input$stat), color = "turquoise") +
                                ylab(paste(input$stat, "Difference")) +
                                theme_bw()
                })
                
                output$plot2 <- renderPlotly({
                        ggplotly(linePlot(), tooltip = c("text", "x", "y"))
                })
                
                output$plotBoth <- renderPlot({
                        grid.arrange(plot1(), plot2(), nrow = 1, ncol = 2)
                })
                
})





