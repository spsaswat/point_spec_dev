

library(dplyr)
library(purrr)
library(data.table)
library(ggplot2)

# jump_correction <- function(stacked, jumps) {
#   if (length(jumps) > 0) {
#     stacked <- map(stacked, function(data_frame) {
#       value <- data_frame$value
#       wave <- data_frame$wave
#       
#       for (jump in jumps) {
#         j <- jump / 1000
#         j_1 <- (jump - 1) / 1000
#         j1 <- (jump + 1) / 1000
#         j2 <- (jump + 2) / 1000
#         
#         if (!(j_1 %in% wave) || !(j %in% wave) || !(j1 %in% wave) || !(j2 %in% wave)) {
#           next # skip to next iteration if any of the jumps don't exist in wave
#         }
#         
#         o_index <- which(wave == j_1)[1]
#         o_val <- value[o_index]
#         o <- c(j_1, o_val)
#         
#         p_index <- which(wave == j)[1]
#         p_val <- value[p_index]
#         p <- c(j, p_val)
#         
#         q_index <- which(wave == j1)[1]
#         q_val <- value[q_index]
#         q <- c(j1, q_val)
#         
#         r_index <- which(wave == j2)[1]
#         r_val <- value[r_index]
#         r <- c(j2, r_val)
#         
#         t1 <- (p[2] - o[2]) / (p[1] - o[1])
#         t2 <- (r[2] - q[2]) / (r[1] - q[1])
#         
#         qqy <- ((t1 + t2) * (q[1] - p[1])) / 2 + p[2]
#         correction <- qqy / q[2]
#         
#         value[(p_index + 1):length(value)] <- value[(p_index + 1):length(value)] * correction
#       }
#       
#       data_frame$value <- value
#       return(data_frame)
#     })
#   }
#   
#   return(stacked)
# }


# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\ASD_fieldspec3_2023_07_25_test\\all.txt"
raw_ASD_text_export <- read.csv(file_path)

spectral_data <- data.table::transpose(raw_ASD_text_export, make.names = "Wavelength")

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

# # Assuming you have known jump points
# jumps <- c(1000, 2000) # replace with your actual jump wavelengths
# 
# # Preparing data for jump correction
# list_data <- split(melted_spectra, melted_spectra$Sample)
# corrected_data <- jump_correction(list_data, jumps)
# 
# # Binding all the corrected data back into a single data frame
# melted_spectra_corrected <- bind_rows(corrected_data)

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

