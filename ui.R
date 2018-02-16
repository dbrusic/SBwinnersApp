library(shiny)
library(ggplot2)
library(plotly)
library(reshape2)
library(gridExtra)

shinyUI(fluidPage(
        titlePanel("Analyzing Winning Super Bowl Teams"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("yearRange", "Year Range:", 1966,2017,value=c(1966, 2017), sep = ""),
                        selectInput("stat", "Stat to Highlight:", choices = names(diff_df)[4:21], 
                                    selectize = FALSE),
                        radioButtons("radio", "Histogram or Boxplot:",
                                     choices = list("Histogram" = 1, "Boxplot" = 2), 
                                     selected = 1),
                        submitButton("Submit")
                ),
                mainPanel(
                        tabsetPanel(type = "tabs",
                                tabPanel("Plots",
                                         plotOutput("plotBoth"),
                                         plotlyOutput("plot2")
                                ),
                                tabPanel("App Description",
                                         h3("Description"),
                                         p("This app's purpose is to analyze statistical data on super bowl winning teams
                                           in the NFL. It provides a platform for the user to explore the statistical 
                                           differences between teams that have played against each other in the super bowl."),
                                         p("There have now been a total of 52 super bowls played, allowing for a data set
                                           of 52 winning teams. Certain statistics were collected from", 
                                           a("Pro Football Reference", href="https://www.pro-football-reference.com/"),
                                           "(and from the NFL's", a("website", href = "https://www.nfl.com/"),
                                           ") for each of these teams (winners) and their super bowl opponents (losers)."),
                                         p("This app uses three plots to explore the differences between winning and losing 
                                           super bowl teams. The first plot (either a histogram or boxplot) shows the distribution of
                                           the differences between winning and losing super bowl teams for the selected year range and 
                                           statistic. An orange line is drawn at 0 as a reference (representing no difference)."),
                                         p("The second plot is a horizontal barplot that is dependent on the year range selected.
                                           It shows the percentage of winning teams in that year range that were better in the selected 
                                           statistic. Whether a team is better is determined by the sign of the difference
                                           (which side of zero it falls on). To be considered better, offensive statistics 
                                           (denoted with an O) should be positive and defensives statistics (denoted with a D) 
                                           should be negative. Statistics that do not have an offensive or defensive designation
                                           should be positive. It is important to note that a team being better in statistics
                                           involving touchdowns per game and attempts per game simply means that they had
                                           more (or less for defense) than the losing team. For these particular stats, more (or less)
                                           does not necessarily mean better."),
                                         p("The third plot is an interactive line graph of each winning team for the selected year range
                                           and statistic. Hovering over the points will display the winning team's name, the season year, and
                                           the difference in the selected statistic from the winning team's perspective. These are the same
                                           points used to create the histogram and boxplot."),
                                         h4("Further Notes"),
                                         p("The years used in this app represent the regular season years as opposed to the year
                                           the super bowls were actually played. Because the NFL season runs through the fall, the super 
                                           bowl has always been played after the new year. For example the most recent super bowl
                                           between the Patriots and Eagles was played on February 4, 2018, but it was the championship
                                           for the 2017 season. Therefore, the year range is from 1966 to 2017 as opposed to 
                                           1967 to 2018."),
                                         p("For teams from 1966 to 1969, yards per play and point differential represent 
                                           only the regular season. For teams from 1970 to 2017, these two stats represent the regular
                                           and post season combined. All other stats only represent the regular season for that 
                                           particular year.")
                                         )
                                )
                )
        )
))
