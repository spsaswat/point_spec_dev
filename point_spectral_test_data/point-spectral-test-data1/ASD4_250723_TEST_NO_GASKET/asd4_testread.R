
library(data.table)
library(ggplot2)

# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\ASD4_250723_TEST_NO_GASKET\\all_reflectance.txt"
raw_ASD_text_export <- read.csv(file_path)

spectral_data <- transpose(raw_ASD_text_export, make.names = "Wavelength")

spectral_data <- cbind(Sample = 0, Group = 0, spectral_data)

spectral_data$Sample <- colnames(raw_ASD_text_export)[-1]

# Determine the number of samples
num_samples <- ncol(raw_ASD_text_export) - 1

# Assign provided group names or col names # Calib may be actually reflectance from white reference
spectral_data$Group <- c("Eucalyptus #1", "Eucalyptus #2", "Nb #1", "Nb #2", "Wheat #1", "Wheat #2")


spectra_for_comparison <- spectral_data[1:6, ] # get all actual leaves

# Convert to data.table
setDT(spectra_for_comparison)

melted_spectra <- melt(spectra_for_comparison, id.vars = c("Group", "Sample"), variable.name = "wavelength", value.name = "reflectance")
melted_spectra$wavelength = as.numeric(levels(melted_spectra$wavelength))[melted_spectra$wavelength]

min_val <- min(melted_spectra$reflectance, na.rm = TRUE)
max_val <- max(melted_spectra$reflectance, na.rm = TRUE)

print(min_val)
print(max_val)

melted_spectra[, normalized_reflectance := (reflectance - min_val) / (max_val - min_val)]

# if want to use normalization please change y=reflectance to y = normalized_reflectance
graph <- ggplot(data = melted_spectra, aes(x=wavelength, y=reflectance, group=Sample, color=Group)) +
  geom_line() +
  scale_x_continuous(breaks = c(400, 700, 1000, 1500, 2000, 2500), expand = c(0.01,0.01)) +
  scale_y_continuous(breaks = c(0,0.2,0.4,0.6,0.8), limits = c(0, 1), expand = c(0.01,0.1)) +
  labs(x="Wavelength (nm)", y="Reflectance", color="Plant")

graph

# Constructing the save path for the graph
save_path <- file.path(dirname(file_path), paste0(tools::file_path_sans_ext(basename(file_path)), ".png"))

# Saving the graph
ggsave(filename = save_path, plot = graph, width = 10, height = 6)

