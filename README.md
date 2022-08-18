
# ggcycle

The goal of ggcycle is to plot recession or other vertical bars on ggplot2 graph

## Installation

Install ggcycle:

``` r
devtools::install_github("ChandlerLutz/ggcycle")
```

## Example Plots 

This is a basic example which shows you how to solve a common problem:

``` r
library(ggcycle)

# Example with Apple stock price data 
data(AAPL.data)
data(bear_dates); data(recession_dates)
p <- ggplot(AAPL.data, aes(x = index, y = AAPL.Close)) +
  geom_line() +
  theme_bw()

# Defaults to NBER recession bars
p + geom_cycle()

# Bear market shading 
p + geom_cycle(dates = bear_dates)

# Recession and bear market shading 
p + geom_cycle(dates = recession_dates) +
  geom_cycle(dates = bear_dates, fill="gray50")
```

