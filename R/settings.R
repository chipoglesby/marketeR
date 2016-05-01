#-------------------------------------------------------------------------------
# settings.R (marketeR)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#' @import RGoogleAnalytics forecast zoo dplyr ggplot2 grid scales rmarkdown 
#' knitr ggthemes
#' @importFrom lubridate %m-%
#' @importFrom timeDate timeFirstDayInMonth timeLastDayInMonth
#' @importFrom plyr ddply
#' @importFrom grDevices dev.off png
#' @importFrom graphics plot
#' @importFrom stats setNames ts
#-------------------------------------------------------------------------------

globalVariables(c("token",
                  "comma",
                  'sessions',
                  'socialNetwork',
                  'yearMonth',
                  'deviceCategory',
                  'percentages',
                  'percentNewsessions',
                  'avgSessionDuration',
                  'bounceRate',
                  'channelGrouping',
                  'userGender',
                  'userAgeBracket',
                  'dayOfWeek',
                  'sessions',
                  'V2',
                  'dates',
                  'new_dates'
                  )
                )