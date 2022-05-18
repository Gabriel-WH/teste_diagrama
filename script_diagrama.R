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
  file = ex_url,
  format = "fwf",
  header = TRUE,
  #col.names = c(
  #  "PRES(hPa)",
  #  "HGHT(m)",
  #  "TEMP(C)",
  #  "DWPT()",
  #  "RELH()",
  #  "MIXR()",
  #  "DRCT()",
  #  "SKNT()",
  #  "THTA()",
  #  "THTE()",
  #  "THTV()"
  #),
  nrows = 82,
  skip = 2,
  widths = rep(7, 11),
  #fill = TRUE
)

ytick <- (c(1000, 925, 850, 700, 500, 400, 300, 250, 200,
            150, 100, 50, 20, 10))

pdf(file = "tentativa_diagramastuve.pdf", width = 8, height = 14)

plot(x = ex_df[,3], y = ex_df[,1], col = 1, lwd = 2, type = "l", log = "y", ylab = "Pressão Atmosférica (hPa)",
     xlab = "Temperatura do Ar (ºC)" , ylim = rev(range(ex_df[,1])+c(-10,+10)), yaxt = "n")

axis(side=2, at=ytick, labels = FALSE)
text(par("usr")[1], ytick,  
     labels = ytick, srt = 45, pos = 2, xpd = TRUE)

lines(x = 40-ex_df[,2]*0.0065, y = ex_df[,1], lwd = 2, type = "l", ylim = rev(range(ex_df[,1])), log = "y", lty = "dashed",
      col = "gray")

dev.off()