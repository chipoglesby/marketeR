#-------------------------------------------------------------------------------
# report.R (marketeR)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#' @title Automatic reports
#' @description The \code{report} function returns a report presenting your
#' website KPIs during the last month, and their evolution over a one year period.
#' @param website The unique Google Analytics table ID of the form 
#' \code{ga:XXXXXXX}, where \code{XXXXXXX} is the Analytics view (profile) ID 
#' for which the query will retrieve the data.
#' @note The output file will be generated in your working directory. Don't know
#'  where is your working directory ? Type `getwd()` in the R console.
#' @examples \dontrun{
#' report(website = "ga:XXXXXXX")}
#' @export
#-------------------------------------------------------------------------------

report <- function(website) {

  #-----------------------------------------------------------------------------
  # Get report data from Google Analytics Core Reporting API
  #-----------------------------------------------------------------------------

  # basicMetrics.data ----------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(12))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions, ga:percentNewsessions,
                                ga:avgSessionDuration, ga:bounceRate",
                     dimensions = "ga:yearMonth",
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  basicMetrics.data <- GetReportData(ga.query, token)

  # channelGrouping.data -------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(12))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:channelGrouping",
                     sort = "-ga:sessions",
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  channelGrouping.data <- GetReportData(ga.query, token)

  # socialNetwork.data ---------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(1))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:socialNetwork",
                     sort = "-ga:sessions",
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  socialNetwork.data <- GetReportData(ga.query, token)

  # keyword.data ---------------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(1))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:keyword",
                     sort = "-ga:sessions",
                     max.results = 10,
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  keyword.data <- GetReportData(ga.query, token)

  # deviceCategory.data --------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(12))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:deviceCategory",
                     sort = "-ga:sessions",
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  deviceCategory.data <- GetReportData(ga.query, token)

  # topContent.data ------------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(1))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:pagePath",
                     sort = "-ga:sessions",
                     max.results = 10,
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  topContent.data <- GetReportData(ga.query, token)

  # country.data ---------------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(1))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:country",
                     sort = "-ga:sessions",
                     max.results = 10,
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  country.data <- GetReportData(ga.query, token)

  # userGender.data ------------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(12))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:userGender",
                     sort = "-ga:sessions",
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  userGender.data <- GetReportData(ga.query, token)

  # userAgeBracket.data --------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(12))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:sessions",
                     dimensions = "ga:yearMonth, ga:userAgeBracket",
                     sort = "-ga:sessions",
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  userAgeBracket.data <- GetReportData(ga.query, token)

  # newUsers.data --------------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(12))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = "ga:newUsers",
                     dimensions = "ga:yearMonth",
                     table.id = website)

  ga.query <- QueryBuilder(query.list)
  newUsers.data <- GetReportData(ga.query, token)

  #-----------------------------------------------------------------------------
  # Clean report data
  #-----------------------------------------------------------------------------

  # Change the report data date format -----------------------------------------

  yearmonFormat <- function (x) {
    x <- as.Date(as.yearmon(x, "%Y%m"))
  }

  basicMetrics.data$yearMonth <- yearmonFormat(basicMetrics.data$yearMonth)
  channelGrouping.data$yearMonth <- yearmonFormat(channelGrouping.data$yearMonth)
  socialNetwork.data$yearMonth <- yearmonFormat(socialNetwork.data$yearMonth)
  keyword.data$yearMonth <- yearmonFormat(keyword.data$yearMonth)
  deviceCategory.data$yearMonth <- yearmonFormat(deviceCategory.data$yearMonth)
  topContent.data$yearMonth <- yearmonFormat(topContent.data$yearMonth)
  country.data$yearMonth <- yearmonFormat(country.data$yearMonth)
  userGender.data$yearMonth <- yearmonFormat(userGender.data$yearMonth)
  userAgeBracket.data$yearMonth <- yearmonFormat(userAgeBracket.data$yearMonth)

  # Add percentages ------------------------------------------------------------

  channelGrouping.data %<>% 
    group_by(yearMonth) %>% 
    mutate(percentages = sessions / sum(sessions))
      
  deviceCategory.data %<>% 
    group_by(yearMonth) %>% 
    mutate(percentages = sessions / sum(sessions))

  userGender.data %<>% 
    group_by(yearMonth) %>% 
    mutate(percentages = sessions / sum(sessions))

  userAgeBracket.data %<>% 
    group_by(yearMonth) %>% 
    mutate(percentages = sessions / sum(sessions))
                              
  
  # Prepare socialNetwork.data data for making a ggplot2 pie chart -------------

  others = data.frame(yearMonth = socialNetwork.data$yearMonth[1],
                      socialNetwork = "Others",
                      sessions = sum(socialNetwork.data$sessions))

  socialNetwork.data <-
    socialNetwork.data %>%
    slice(1:5)

  others$sessions = others$sessions-sum(socialNetwork.data$sessions)
  socialNetwork.data <- bind_rows(socialNetwork.data, others)

  socialNetwork.data <-
    socialNetwork.data %>%
    dplyr::select(socialNetwork, sessions)

  #-----------------------------------------------------------------------------
  # Preparing data for the Executive Summary
  #-----------------------------------------------------------------------------

  ## sessions ------------------------------------------------------------------

  sessions.currentMonth <- as.numeric(basicMetrics.data$sessions[nrow(basicMetrics.data)])
  sessions.lastMonth <- as.numeric(basicMetrics.data$sessions[nrow(basicMetrics.data)-1])
  sessions.relativeChange <- ((sessions.currentMonth/sessions.lastMonth)-1)*100

  ## percentNewsessions --------------------------------------------------------

  percentNewsessions.currentMonth <- as.numeric(basicMetrics.data$percentNewsessions[nrow(basicMetrics.data)])
  percentNewsessions.lastMonth <- as.numeric(basicMetrics.data$percentNewsessions[nrow(basicMetrics.data)-1])
  percentNewsessions.relativeChange <- ((percentNewsessions.currentMonth/percentNewsessions.lastMonth)-1)*100

  ## avgSessionDuration --------------------------------------------------------

  avgSessionDuration.currentMonth <- as.numeric(basicMetrics.data$avgSessionDuration[nrow(basicMetrics.data)])
  avgSessionDuration.lastMonth <- as.numeric(basicMetrics.data$avgSessionDuration[nrow(basicMetrics.data)-1])
  avgSessionDuration.relativeChange <- ((avgSessionDuration.currentMonth/avgSessionDuration.lastMonth)-1)*100

  ## bounceRate ----------------------------------------------------------------

  bounceRate.currentMonth <- as.numeric(basicMetrics.data$bounceRate[nrow(basicMetrics.data)])
  bounceRate.lastMonth <- as.numeric(basicMetrics.data$bounceRate[nrow(basicMetrics.data)-1])
  bounceRate.relativeChange <- ((bounceRate.currentMonth/bounceRate.lastMonth)-1)*100

  ## mobileRate
  deviceCategory.currentMonth <-
    deviceCategory.data %>%
    filter(yearMonth == basicMetrics.data$yearMonth[nrow(basicMetrics.data)]) %>%
    select(deviceCategory, percentages) %>%
    filter(deviceCategory == "mobile")

  deviceCategory.currentMonth$percentages <- as.numeric(substr(deviceCategory.currentMonth$percentages, 0 , nchar(deviceCategory.currentMonth$percentages) - 1))

  deviceCategory.lastMonth <-
    deviceCategory.data %>%
    filter(yearMonth == basicMetrics.data$yearMonth[nrow(basicMetrics.data)-1]) %>%
    select(deviceCategory, percentages) %>%
    filter(deviceCategory == "mobile")

  deviceCategory.lastMonth$percentages <- as.numeric(substr(deviceCategory.lastMonth$percentages, 0 , nchar(deviceCategory.lastMonth$percentages) - 1))

  deviceCategory.relativeChange <- ((deviceCategory.currentMonth$percentages/deviceCategory.lastMonth$percentages)-1)*100

  #-----------------------------------------------------------------------------
  # Create plots of report data
  #-----------------------------------------------------------------------------

  # sessions.plot --------------------------------------------------------------

  sessions.plot <- ggplot(basicMetrics.data, aes(x = yearMonth, y = sessions)) +
    ggtitle("Sessions") +
    geom_line(size = 0.5, color = "red") +
    geom_point(size = 2.5, shape = 21, fill = "white") +
    scale_x_date(labels = date_format("%b %Y"), breaks = date_breaks("month")) +
    scale_y_continuous(labels = comma, limits=c(0, max(basicMetrics.data$sessions))) +
    theme_economist() +
    scale_colour_economist() +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  # percentNewsessions.plot ----------------------------------------------------

  percentNewsessions.plot <-
    ggplot(basicMetrics.data, aes(x = yearMonth, y = percentNewsessions/100)) +
    ggtitle("Percent of New Sessions") +
    geom_line(size = 0.5, color = "red") +
    geom_point(size = 2.5, shape = 21, fill = "white") +
    scale_x_date(labels = date_format("%b %Y"), breaks = date_breaks("month")) +
    scale_y_continuous(labels  = percent_format(), limits=c(0, max(basicMetrics.data$percentNewsessions/100))) +
    theme_economist() +
    scale_colour_economist() +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  # avgSessionDuration.plot ----------------------------------------------------

  avgSessionDuration.plot <-
    ggplot(basicMetrics.data, aes(x = yearMonth, y = avgSessionDuration)) +
    ggtitle("Average Session Duration (in seconds)") +
    geom_line(size = 0.5, color = "red") +
    geom_point(size = 2.5, shape = 21, fill = "white") +
    scale_x_date(labels = date_format("%b %Y"), breaks = date_breaks("month")) +
    scale_y_continuous(labels = comma, limits=c(0, max(basicMetrics.data$avgSessionDuration))) +
    theme_economist() +
    scale_colour_economist() +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  # bounceRate.plot ----------------------------------------------------

  bounceRate.plot <-
    ggplot(basicMetrics.data, aes(x = yearMonth, y = bounceRate/100)) +
    ggtitle(" Bounce Rate (in percent)") +
    geom_line(size = 0.5, color = "red") +
    geom_point(size = 2.5, shape = 21, fill = "white") +
    scale_x_date(labels = date_format("%b %Y"), breaks = date_breaks("month")) +
    scale_y_continuous(labels  = percent_format(), limits=c(0, max(basicMetrics.data$bounceRate/100))) +
    theme_economist() +
    scale_colour_economist() +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  # channelGrouping.plot -------------------------------------------------------

  channelGrouping.plot <-
    ggplot(channelGrouping.data, aes(x = yearMonth, y = percentages)) +
    geom_bar(aes(fill = channelGrouping), stat = "identity") +
    scale_x_date(labels = date_format("%b %Y"), breaks = date_breaks("month")) +
    scale_y_continuous(labels = percent_format()) +
    theme_economist() +
    scale_colour_economist() +
    scale_fill_brewer(palette = "YlGnBu") +
    guides(fill=guide_legend(title = NULL)) +
    theme(legend.text=element_text(size=10),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  # socialNetwork.plot ---------------------------------------------------------

  socialNetwork.plot <-
    ggplot(socialNetwork.data, aes(x = "", y = sessions, fill = socialNetwork)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y") +
    theme_economist() +
    scale_fill_brewer(palette = "Pastel2") +
    guides(fill=guide_legend(title = NULL)) +
    geom_text(
      aes(y = sessions/3 + c(0, cumsum(sessions)[-length(sessions)])),
      label = paste(round(socialNetwork.data$sessions / sum(socialNetwork.data$sessions) * 100, 0), "%", sep=""),
      size=8,
      color = "white") +
    theme(legend.position = "right",
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          panel.border = element_blank(),
          panel.grid = element_blank(),
          axis.ticks = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank())

  # deviceCategory.plot --------------------------------------------------------

  deviceCategory.plot <-
    ggplot(deviceCategory.data, aes(x = yearMonth, y = percentages)) +
    geom_bar(aes(fill = deviceCategory), stat = "identity") +
    scale_x_date(labels = date_format("%b %Y"), breaks = 0:12) +
    scale_y_continuous(labels = percent_format()) +
    theme_economist() +
    scale_colour_economist() +
    scale_fill_brewer(palette = "RdPu") +
    guides(fill=guide_legend(title = NULL)) +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  # userGender.plot ------------------------------------------------------------

  userGender.plot <-
    ggplot(userGender.data, aes(x = yearMonth, y = percentages)) +
    geom_bar(aes(fill = userGender), stat = "identity") +
    scale_x_date(labels = date_format("%b %Y"), breaks = date_breaks("month")) +
    scale_y_continuous(labels = percent_format()) +
    theme_economist() +
    scale_colour_economist() +
    scale_fill_brewer(palette = "Pastel1") +
    guides(fill=guide_legend(title = NULL)) +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  # userAgeBracket.plot --------------------------------------------------------

  userAgeBracket.plot <-
    ggplot(userAgeBracket.data, aes(x = yearMonth, y = percentages)) +
    geom_bar(aes(fill = userAgeBracket), stat = "identity") +
    scale_x_date(labels = date_format("%b %Y"), breaks = date_breaks("month")) +
    scale_y_continuous(labels = percent_format()) +
    theme_economist() +
    scale_colour_economist() +
    scale_fill_brewer(palette = "Pastel1") +
    guides(fill=guide_legend(title = NULL)) +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10))

  #-----------------------------------------------------------------------------
  # Multiple plot function from cookbook-r.com by Winston Chang
  #-----------------------------------------------------------------------------

  multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {

    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)

    numPlots = length(plots)

    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
      # Make the panel
      # ncol: Number of columns of plots
      # nrow: Number of rows needed, calculated from # of cols
      layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                       ncol = cols, nrow = ceiling(numPlots/cols))
    }

    if (numPlots==1) {
      print(plots[[1]])

    } else {
      # Set up the page
      grid.newpage()
      pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

      # Make each plot, in the correct location
      for (i in 1:numPlots) {
        # Get the i,j matrix positions of the regions that contain this subplot
        matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

        print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                        layout.pos.col = matchidx$col))
      }
    }
  }

  #-----------------------------------------------------------------------------
  # Find then render the report.rmd file
  #-----------------------------------------------------------------------------

  rmdDir <- system.file("report", "report.Rmd", package = "marketeR")
  if (rmdDir == "") {
    stop("Could not find given directory. Try re-installing marketeR.", call. = FALSE)
  }

  rmarkdown::render(rmdDir, output_file = '~/report.html')

}
