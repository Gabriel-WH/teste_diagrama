library(rio)
library(readr)
library(dplyr)

ex_url <- "https://weather.uwyo.edu/cgi-bin/sounding?region=samer&TYPE=TEXT%3ALIST&YEAR=2022&MONTH=05&FROM=1512&TO=1512&STNM=83937"

ex_txt <- read_lines(ex_url)
ex_arq <- "skewt_sm_20220515_12z.txt"

write_lines(
  x = ex_txt,
  file = ex_arq
)

ex_df <- import(
  file = ex_arq,
  format = "fwf",
  header = FALSE,
  col.names = c(
    "PRES_hPa",
    "HGHT_m",
    "TEMP_C",
    "DWPT",
    "RELH",
    "MIXR",
    "DRCT",
    "SKNT",
    "THTA",
    "THTE",
    "THTV"
  ),
  nrows = 82,
  skip = 9,
  widths = rep(7, 11)
)

temp <- ex_df[,3]
press <- ex_df[,1]
alti <- ex_df[,2]

ytick <- (c(1000, 925, 850, 700, 500, 400, 300, 250, 200,
            150, 100, 50, 20, 10))

pdf(file = "tentativa_diagramastuve.pdf", width = 8, height = 14)

plot(x = temp, y = press, col = 1, lwd = 2, type = "l", log = "y", ylab = "Pressão Atmosférica (hPa)",
     xlab = "Temperatura do Ar (ºC)" , ylim = rev(range(press)+c(-10,+10)), yaxt = "n")

axis(side=2, at=ytick, labels = FALSE)
text(par("usr")[1], ytick,  
     labels = ytick, srt = 45, pos = 2, xpd = TRUE)

lines(x = 40-alti*0.0065, y = press, lwd = 2, type = "l", ylim = rev(range(press)), log = "y", lty = "dashed",
      col = "gray")

dev.off()