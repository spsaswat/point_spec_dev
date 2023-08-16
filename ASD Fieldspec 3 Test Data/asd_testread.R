
library(data.table)
library(ggplot2)

setwd(dirname(rstudioapi::getSourceEditorContext()$path)) # place script in same folder as data

raw_ASD_text_export <- read.csv("test2.txt")

spectral_data <- transpose(raw_ASD_text_export, make.names = "Wavelength")

spectral_data <- cbind(Sample = 0, Group = 0, spectral_data)

spectral_data$Sample <- colnames(spectra)[-1]

# Calibration is the default first measurement (sample 000)
spectral_data$Group <- c("calibration", "Solanaceae", "Solanaceae", "Myrtaceae", "Myrtaceae", "yellow leaf")

spectra_for_comparison <- spectral_data[2:5, ] # get only our 4 actual leaves

melted_spectra <- melt(spectra_for_comparison, id.vars = c("Group", 
                                             "Sample"), variable.name = "wavelength", value.name = "reflectance")

melted_spectra$wavelength=as.numeric(levels(melted_spectra$wavelength))[melted_spectra$wavelength]

graph <- ggplot(data = melted_spectra, aes(x=wavelength, y=reflectance, group=Sample, color=Group)) +
  geom_line() +
  scale_x_continuous(breaks = c(400, 700, 1000, 1500, 2000, 2500), expand = c(0.01,0.01)) +
  scale_y_continuous(breaks = c(0,0.2,0.4,0.6,0.8), expand = c(0.01,0.1)) +
  labs(x="Wavelength (nm)", y="Reflectance", color="Plant")

graph
