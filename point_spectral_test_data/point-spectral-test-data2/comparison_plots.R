# Load the tidyverse package
library(tidyverse)
library(data.table)
library(ggplot2)
library(tools)



# SVCC

# read the metadata
meta_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\metadata.csv"

# Read the CSV file
metadata <- read.csv(meta_path, stringsAsFactors = FALSE)

# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\2022-08-23_MC_test_SVC\\all_reflectance.csv"
raw_ASD_text_export <- read.csv(file_path)

spectral_data <- transpose(raw_ASD_text_export, make.names = "Wavelength")

spectral_data <- cbind(Sample = 0, Group = 0, spectral_data)

spectral_data$Sample <- colnames(raw_ASD_text_export)[-1]

# Determine the number of samples
num_samples <- ncol(raw_ASD_text_export) - 1

# Assign provided group names or col names
spectral_data$Group <-metadata$name

exclude_names <- metadata$name[toupper(metadata$ignore) == "Y"]

# Filter spectral_data to exclude rows with Group values in exclude_names
spectra_for_comparison <- spectral_data[!spectral_data$Group %in% exclude_names, ]

# Convert to data.table
setDT(spectra_for_comparison)

melted_spectra_SVCC <- melt(spectra_for_comparison, id.vars = c("Group", "Sample"), variable.name = "wavelength", value.name = "reflectance")
melted_spectra_SVCC$wavelength = as.numeric(levels(melted_spectra_SVCC$wavelength))[melted_spectra_SVCC$wavelength]

melted_spectra_SVCC[, reflectance := (reflectance/100)]


# ASD4


# read the metadata
# file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\metadata.csv"

# Read the CSV file
# metadata <- read.csv(file_path, stringsAsFactors = FALSE)


# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\2023-08-22-MC_test_ASD4\\all.txt"
raw_ASD_text_export <- read.csv(file_path)

spectral_data <- transpose(raw_ASD_text_export, make.names = "Wavelength")

spectral_data <- cbind(Sample = 0, Group = 0, spectral_data)

spectral_data$Sample <- colnames(raw_ASD_text_export)[-1]

# Determine the number of samples
num_samples <- ncol(raw_ASD_text_export) - 1

# Assign provided group names or col names
spectral_data$Group <-metadata$name

exclude_names <- metadata$name[toupper(metadata$ignore) == "Y"]

# Filter spectral_data to exclude rows with Group values in exclude_names
spectra_for_comparison <- spectral_data[!spectral_data$Group %in% exclude_names, ]

# Convert to data.table
setDT(spectra_for_comparison)

melted_spectra_ASD4 <- melt(spectra_for_comparison, id.vars = c("Group", "Sample"), variable.name = "wavelength", value.name = "reflectance")
melted_spectra_ASD4$wavelength = as.numeric(levels(melted_spectra_ASD4$wavelength))[melted_spectra_ASD4$wavelength]


# ASD3

# # read the metadata
# file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\metadata.csv"
# 
# # Read the CSV file
# metadata <- read.csv(file_path, stringsAsFactors = FALSE)


# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\2023-08-22_MC_test_ASD3\\all.txt"
raw_ASD_text_export <- read.csv(file_path)

spectral_data <- data.table::transpose(raw_ASD_text_export, make.names = "Wavelength")

spectral_data <- cbind(Sample = 0, Group = 0, spectral_data)

spectral_data$Sample <- colnames(raw_ASD_text_export)[-1]

# Determine the number of samples
num_samples <- ncol(raw_ASD_text_export) - 1

# Assign provided group names or col names
spectral_data$Group <-metadata$name

exclude_names <- metadata$name[toupper(metadata$ignore) == "Y"]

# Filter spectral_data to exclude rows with Group values in exclude_names
spectra_for_comparison <- spectral_data[!spectral_data$Group %in% exclude_names, ]

# Convert to data.table
setDT(spectra_for_comparison)

melted_spectra_ASD3 <- melt(spectra_for_comparison, id.vars = c("Group", "Sample"), variable.name = "wavelength", value.name = "reflectance")
melted_spectra_ASD3$wavelength = as.numeric(levels(melted_spectra_ASD3$wavelength))[melted_spectra_ASD3$wavelength]

# Interpolate function
interpolate_reflectance <- function(wavelength, reflectance, new_wavelength) {
  approx(x = wavelength, y = reflectance, xout = new_wavelength)$y
}

# Add method identifier
melted_spectra_SVCC$method <- "SVCC"
melted_spectra_ASD3$method <- "ASD3"
melted_spectra_ASD4$method <- "ASD4"

# file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\2023-08-22-MC_test_ASD4\\all.txt"
# Extract directory name from file_path
desired_name <- file_path_sans_ext(basename(dirname((dirname(file_path)))))
desired_name

# Extract target directory to save files
target_directory <- dirname(dirname(file_path))
target_directory

# Remove the sample column
melted_spectra_ASD3 <- select(melted_spectra_ASD3, -Sample)
melted_spectra_ASD4 <- select(melted_spectra_ASD4, -Sample)
melted_spectra_SVCC <- select(melted_spectra_SVCC, -Sample)


# Create new names for each data frame
file_name_SVCC <- file.path(target_directory, paste0(desired_name, "_SVCC.csv"))
file_name_ASD3 <- file.path(target_directory, paste0(desired_name, "_ASD3.csv"))
file_name_ASD4 <- file.path(target_directory, paste0(desired_name, "_ASD4.csv"))




# # Save data frames to CSV
# write.csv(melted_spectra_SVCC, file_name_SVCC, row.names = FALSE)
# write.csv(melted_spectra_ASD3, file_name_ASD3, row.names = FALSE)
# write.csv(melted_spectra_ASD4, file_name_ASD4, row.names = FALSE)

# Transform the data
df_transformed_SVCC <- melted_spectra_SVCC %>%
  select(-method) %>%  # remove 'method' if you want to keep it, remove this line
  pivot_wider(names_from = Group, values_from = reflectance) %>%
  mutate(method = "SVCC")  # add 'method' back with a constant value

# Round the 'wavelength' column to the nearest integer
df_transformed_SVCC$wavelength <- round(df_transformed_SVCC$wavelength)

# Transform the data
df_transformed_ASD3 <- melted_spectra_ASD3 %>%
  select(-method) %>%  # remove 'method' if you want to keep it, remove this line
  pivot_wider(names_from = Group, values_from = reflectance) %>%
  mutate(method = "ASD3")  # add 'method' back with a constant value

# Transform the data
df_transformed_ASD4 <- melted_spectra_ASD4 %>%
  select(-method) %>%  # remove 'method' if you want to keep it, remove this line
  pivot_wider(names_from = Group, values_from = reflectance) %>%
  mutate(method = "ASD4")  # add 'method' back with a constant value

# Save the transformed data back to CSV if needed
write.csv(df_transformed_SVCC, file_name_SVCC, row.names = FALSE)
write.csv(df_transformed_ASD3, file_name_ASD3, row.names = FALSE)
write.csv(df_transformed_ASD4, file_name_ASD4, row.names = FALSE)

# Merge the first two datasets
merged_data_1_2 <- merge(df_transformed_SVCC, df_transformed_ASD3, by = "wavelength", 
                         all = FALSE, suffixes = c("_SVCC", "_ASD3"))

# Merge the combined dataset with the third one
final_merged_data <- merge(merged_data_1_2, df_transformed_ASD4, by = "wavelength", 
                           all = FALSE, suffixes = c("", "_ASD4"))

# Print the merged data
print(merged_data)


