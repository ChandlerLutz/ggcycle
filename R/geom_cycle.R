##    Chandler Lutz
##    Questions/comments: cl.eco@cbs.dk
##    $Revisions:      1.0.0     $Date:  2016-11-03

#' Create a stat that uses ggproto to
#' that will calculate the the bars to show for the
#' cycle
#'
GeomCycle <- ggplot2::ggproto(
    "GeomCycle",
    Stat, ##Really, GeomCycle is going to be a stat
          ##This makes it easier to add the regression bars
          ##using external data as x an y will be missing from
          ##the data used to compute the regression bars
    required_aes = c("x", "y"),

    ##Create a compute_group method that is going to
    ##do the computation
    compute_group = function(data, scales, dates) {
        ##Get the range for x -- this will be a numeric date
        x.rng <- range(data$x, na.rm = TRUE)

        ##convert the the dates to numerics to match
        ##how ggplot2 converts to numeric
        dates[, 1] <- as.numeric(dates[, 1])
        dates[, 2] <- as.numeric(dates[, 2])

        ##subset the dates
        ##Make sure that the dates are within the x and y range
        ##Check the start of the data compared to the end of each bear market
        ##Check the end of the data compared to the end of each bear market
        dates <- dates[dates[, 2] >= x.rng[1], ]
        dates <- dates[dates[, 2] <= x.rng[2], ]

        ##if the first date is below the range for x, update
        if (dates[1, 1] < x.rng[1]) {
            dates[1, 1] <- x.rng[1]
        }
        ##if the last date is higher than the range of x, update
        if (dates[nrow(dates), 2] > x.rng[2]) {
            dates[nrow(dates), 2] <- x.rng[2]
        }

        ##the dataframe we want to return
        data.frame(xmin = dates[, 1], xmax = dates[, 2],
                   ymin = -Inf, ymax = Inf)

    }

)


#' A geom that draws vertical bars based on given dates. The default
#' dates are \code{recession_dates} corresponding to dates for NBER
#' recessions. The data also can use \code{bear_dates}
#'
#' @param dates (dataframe) a dataframe with the dates that will be
#'     used to create the vertical bars. The first column is the start
#'     of each cycle; the second column is the end of each
#'     cycle. Default is \code{recession_dates}
#' @param fill (string) a string with the color used to fill the cycle
#'     bars (corresponds to ggplot2 fill)
#' @param alpha (numeric) a number between 0 and 1 that specifies the
#'     transparency of the regression bars (corresponds to ggplot2
#'     alpha)
#' @param geom the ggplot2 geom to be plotted. Defaults to "rect"
#' @param position the ggplot2 position. Defaults to "identity"
#' @param show.legend Determines ggplot2 show legend
#'     behavior. Defaults to FALSE
#' @param inherit.aes Speficies if the aes should be inherited from
#'     previous plot. Defaults to TRUE
#' @param ... Other parameters to be passed to the layer
#'
#' @examples
#' ##Apple stock price with recessions and bear markets shaded
#' ##First, load the bear market dates and recession dates
#' data(bear_dates); data(recession_dates)
#' p <- ggplot(AAPL.data, aes(x = index, y = AAPL.Close)) +
#'   geom_line() +
#'   theme_bw()
#' p
#' p + geom_cycle(dates = bear_dates)
#' p + geom_cycle(dates = recession_dates) +
#'   geom_cycle(dates = bear_dates, fill="gray50")
#' 
#'
#' @export
geom_cycle <- function(dates = ggts::recession_dates, fill = "#003F87", alpha = 0.2,
                       geom = "rect", position = "identity", show.legend = FALSE,
                       inherit.aes = TRUE, ...) {
    ggplot2::layer(
        stat = GeomCycle,
        data = NULL,
        mapping = NULL,
        geom = geom,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(dates = dates,
                      fill = fill,
                      alpha = alpha,
                      ...
                      )
    )
}

