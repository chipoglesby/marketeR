#-------------------------------------------------------------------------------
# weekperf.R (marketeR)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#' @title Weekly KPIs assessment
#' @description The \code{weekperf} function returns a plot designed to assess
#' your website KPIs during the past 7 days.
#' @param kpi A Google Analytics metric, such as \code{ga:metrics}.
#' @param website The unique Google Analytics table ID of the form 
#' \code{ga:XXXXXXX}, where \code{XXXXXXX} is the Analytics view (profile) ID 
#' for which the query will retrieve the data.
#' @param export If the export option is set as "TRUE", both raw data & graphics 
#' will be exported in the current working directory.
#' @note The triangles are representing the results of the past 7 days.
#' Their color may vary according to the mean (green is > mean, red is < mean).
#' The mean is represented by the letter \code{m}.
#' @examples \dontrun{
#' weekperf(kpi = "ga:sessions", website = "ga:XXXXXXX", export = TRUE)}
#' @export
#-------------------------------------------------------------------------------

weekperf <- function(kpi, website, export = FALSE) {

  #-----------------------------------------------------------------------------
  # Get past.data from Google Analytics Core Reporting API
  #-----------------------------------------------------------------------------

  query.list <- Init(start.date = as.character(Sys.Date() - 372),
                     end.date = as.character(Sys.Date() - 1),
                     metrics = kpi,
                     dimensions = "ga:week, ga:dayOfWeek",
                     table.id = website
                     )

  ga.query <- QueryBuilder(query.list)
  past.data <- GetReportData(ga.query, token)

  #-----------------------------------------------------------------------------
  # Get current.data from Google Analytics Core Reporting API
  #-----------------------------------------------------------------------------

  query.list <- Init(start.date = as.character(Sys.Date() - 7),
                     end.date = as.character(Sys.Date() - 1),
                     metrics = kpi,
                     dimensions = "ga:week, ga:dayOfWeek",
                     table.id = website
                     )

  ga.query <- QueryBuilder(query.list)
  current.data <- GetReportData(ga.query, token)

  #-----------------------------------------------------------------------------
  # Clean data
  #-----------------------------------------------------------------------------

  # Get the means for past.data ------------------------------------------------

  past.data <-
  past.data %>%
    group_by(dayOfWeek) %>%
    dplyr::summarise(mean(sessions))

  # Put current.data at the right format ---------------------------------------

  current.data <-
  current.data %>%
    select(dayOfWeek, sessions) %>%
    arrange(dayOfWeek)

  # Merge past.data & current.data to create final.data ------------------------

  dates.list <- list()

  for (i in 1:7) {
    
    dates.list[[i]] <- c(as.character(Sys.Date() - i),
                         as.POSIXlt(Sys.Date() - i)$wday)
  }

  dates.df <- as.data.frame(do.call(rbind, dates.list))
  dates.df <- arrange(dates.df, V2)

  final.data <- bind_cols(current.data, past.data, dates.df)
  
  colnames(final.data) <- c("DayOfWeek",
                            "sessions",
                            "DayOfWeek2",
                            "mean",
                            "dates",
                            "DayOfWeek3")
  
  final.data <- select(final.data, dates, mean, sessions)
  final.data <- mutate(final.data, new_dates = paste(weekdays(dates, as.Date(dates))))

  #-----------------------------------------------------------------------------
  # Create plot of final.data
  #-----------------------------------------------------------------------------

  final.plot <-
    ggplot(final.data, aes(x = new_dates, y = mean, ymin = 0)) +
    ggtitle(paste("Week KPIs assessment - ", Sys.Date() - 7, " / ", Sys.Date() -1, sep = "")) +
    xlab("Date") +
    ylab("Sessions") +
    geom_point(size = 4, shape = 109) +
    geom_point(data = final.data, aes(x = new_dates, y = sessions, colour  =  sessions > mean), shape = 17, size = 6) +
    scale_y_continuous(labels = comma) +
    scale_colour_manual(values = setNames(c("green","red"), c(T, F))) +
    theme_bw() +
    theme(legend.position="none")

  plot(final.plot)
  
  #-----------------------------------------------------------------------------
  # Export data
  #-----------------------------------------------------------------------------
  
  if (export == TRUE) {
    write.csv(final.data[1:3], "weekperf_data.csv")
    ggsave("weekperf_plot.png", final.plot, width = 14, height = 8)
    }

}
