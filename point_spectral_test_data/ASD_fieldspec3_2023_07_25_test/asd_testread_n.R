
library(data.table)
library(ggplot2)

# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\ASD_fieldspec3_2023_07_25_test\\all.txt"
raw_ASD_text_export <- read.csv(file_path)

spectral_data <- transpose(raw_ASD_text_export, make.names = "Wavelength")

spectral_data <- cbind(Sample = 0, Group = 0, spectral_data)

spectral_data$Sample <- colnames(raw_ASD_text_export)[-1]

# Determine the number of samples
num_samples <- ncol(raw_ASD_text_export) - 1

# Assign provided group names or col names
spectral_data$Group <- c("Reference", "Blank dark background", "Eucalyptus #1", "Eucalyptus #2", "Nb #1", "Nb #2", "Wheat #1", "Wheat #2")


spectra_for_comparison <- spectral_data[3:8, ] # get only our 4 actual leaves

# Convert to data.table
setDT(spectra_for_comparison)

melted_spectra <- melt(spectra_for_comparison, id.vars = c("Group", "Sample"), variable.name = "wavelength", value.name = "reflectance")
melted_spectra$wavelength = as.numeric(levels(melted_spectra$wavelength))[melted_spectra$wavelength]

graph <- ggplot(data = melted_spectra, aes(x=wavelength, y=reflectance, group=Sample, color=Group)) +
  geom_line() +
  scale_x_continuous(breaks = c(400, 700, 1000, 1500, 2000, 2500), expand = c(0.01,0.01)) +
  scale_y_continuous(breaks = c(0,0.2,0.4,0.6,0.8), expand = c(0.01,0.1)) +
  labs(x="Wavelength (nm)", y="Reflectance", color="Cal&Plant")

graph

# Constructing the save path for the graph
save_path <- file.path(dirname(file_path), paste0(tools::file_path_sans_ext(basename(file_path)), ".png"))

# Saving the graph
ggsave(filename = save_path, plot = graph, width = 10, height = 6)
