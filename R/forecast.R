#-------------------------------------------------------------------------------
# forecast.R (marketeR)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#' @title KPIs forecasts
#' @description The \code{forecast} function makes forecasts for your website KPIs
#' for the next 3 months, using time-series.
#' @param kpi A Google Analytics metric, such as \code{ga:metrics}.
#' @param website The unique Google Analytics table ID of the form 
#' \code{ga:XXXXXXX}, where \code{XXXXXXX} is the Analytics view (profile) ID 
#' for which the query will retrieve the data.
#' @param export If the export option is set as "TRUE", both raw data & graphics 
#' will be exported in the current working directory.
#' @note The black part is the past website traffic data; the blue part is the
#' graphical representation of the forecast.
#' @examples \dontrun{
#' forecast(kpi = "ga:sessions", website = "ga:XXXXXXX", export = FALSE)}
#' @export
#-------------------------------------------------------------------------------

forecast <- function(kpi, website, export = FALSE) {

  #-----------------------------------------------------------------------------
  # Get past.data from Google Analytics Core Reporting API
  #-----------------------------------------------------------------------------

  query.list <- Init(start.date = as.character(timeFirstDayInMonth(Sys.Date() %m-% months(72))),
                     end.date = as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))),
                     metrics = kpi,
                     dimensions = "ga:yearmonth",
                     table.id = website
                     )

  ga.query <- QueryBuilder(query.list)
  past.data <- GetReportData(ga.query, token)

  #-----------------------------------------------------------------------------
  # Clean past.data
  #-----------------------------------------------------------------------------

  past.data$yearmonth <- as.Date(as.yearmon(past.data$yearmonth, "%Y%m"))

  #-----------------------------------------------------------------------------
  # Turn past.data into an exploitable time-serie
  #-----------------------------------------------------------------------------

  ts.past.data <- ts(past.data[, -1],
                     start = c(as.numeric(substring(as.character(timeFirstDayInMonth(Sys.Date() %m-% months(72))), 1, 4)),
                           as.numeric(substring(as.character(timeFirstDayInMonth(Sys.Date() %m-% months(72))), 6, 7))),
                     end = c(as.numeric(substring(as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))), 1, 4)),
                         as.numeric(substring(as.character(timeLastDayInMonth(Sys.Date() %m-% months(1))), 6, 7))),
                     frequency = 12)

  #-----------------------------------------------------------------------------
  # Make predictions.data using the auto-ARIMA model
  #-----------------------------------------------------------------------------

  fit <- auto.arima(ts.past.data)
  predictions.data <- forecast::forecast(fit, 3)
  
  #-----------------------------------------------------------------------------
  # Create plot of predictions.data
  #-----------------------------------------------------------------------------
  
  plot(predictions.data)
  
  #-----------------------------------------------------------------------------
  # Export data
  #-----------------------------------------------------------------------------

  if (export == TRUE) {
    write.csv(predictions.data, "forecast_data.csv")
    png("forecast_plot.png")
    plot(predictions.data)
    dev.off()
    }

}
