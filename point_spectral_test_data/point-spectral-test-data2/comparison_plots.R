# Load the tidyverse package
library(tidyverse)
library(data.table)
library(ggplot2)
library(tools)



# SVC

# read the metadata
meta_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\metadata.csv"

# Read the CSV file
metadata <- read.csv(meta_path, stringsAsFactors = FALSE)

# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\2022-08-23_MC_test_SVC\\all_reflectance.csv"
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

melted_spectra_SVC <- melt(spectra_for_comparison, id.vars = c("Group", "Sample"), variable.name = "wavelength", value.name = "reflectance")
melted_spectra_SVC$wavelength = as.numeric(levels(melted_spectra_SVC$wavelength))[melted_spectra_SVC$wavelength]

melted_spectra_SVC[, reflectance := (reflectance/100)]


# ASD4


# read the metadata
# file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\metadata.csv"

# Read the CSV file
# metadata <- read.csv(file_path, stringsAsFactors = FALSE)


# add your file path here
file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\2023-08-22-MC_test_ASD4\\all.txt"
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


# # Add method identifier
# melted_spectra_SVC$method <- "SVC"
# melted_spectra_ASD3$method <- "ASD3"
# melted_spectra_ASD4$method <- "ASD4"

# file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\point-spectral-test-data2\\2023-08-22-MC_test_ASD4\\all.txt"
# Extract directory name from file_path
desired_name <- file_path_sans_ext(basename(dirname((dirname(file_path)))))


# Extract target directory to save files
target_directory <- dirname(dirname(file_path))


# Remove the sample column
melted_spectra_ASD3 <- select(melted_spectra_ASD3, -Sample)
melted_spectra_ASD4 <- select(melted_spectra_ASD4, -Sample)
melted_spectra_SVC <- select(melted_spectra_SVC, -Sample)


# Create new names for each data frame
file_name_SVC <- file.path(target_directory, paste0(desired_name, "_SVC.csv"))
file_name_ASD3 <- file.path(target_directory, paste0(desired_name, "_ASD3.csv"))
file_name_ASD4 <- file.path(target_directory, paste0(desired_name, "_ASD4.csv"))


# https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/splinefun
# Create a function to interpolate values
interpolate_column <- function(column_data, wavelengths, all_wavelengths){
  spline_interpolator <- splinefun(wavelengths, column_data, method = "natural")
  return(spline_interpolator(all_wavelengths))
}

# # Save data frames to CSV
# write.csv(melted_spectra_SVC, file_name_SVC, row.names = FALSE)
# write.csv(melted_spectra_ASD3, file_name_ASD3, row.names = FALSE)
# write.csv(melted_spectra_ASD4, file_name_ASD4, row.names = FALSE)

# Transform the data
df_transformed_SVC <- melted_spectra_SVC %>%
  # select(-method) %>%  # remove 'method' if you want to keep it, remove this line
  pivot_wider(names_from = Group, values_from = reflectance)

# Round the 'wavelength' column to the nearest integer
df_transformed_SVC$wavelength <- round(df_transformed_SVC$wavelength)

# interpolate SVC columns for every wavelength
# Extract the minimum and maximum wavelength from the dataframe
min_wavelength <- min(df_transformed_SVC$wavelength)
max_wavelength <- max(df_transformed_SVC$wavelength)

# Get all wavelengths from the minimum to the maximum
all_wavelengths <- min_wavelength:max_wavelength

# Apply the function to all columns excluding "wavelength"
new_data <- lapply(df_transformed_SVC[-1], interpolate_column, wavelengths = df_transformed_SVC$wavelength, all_wavelengths = all_wavelengths)

# Convert the list back to a dataframe
new_df <- as.data.frame(new_data)
new_df$wavelength <- all_wavelengths

# Bind original data and new interpolated data, remove duplicates and sort
df_transformed_SVC <- bind_rows(df_transformed_SVC, new_df) %>%
  distinct(wavelength, .keep_all = TRUE) %>%
  arrange(wavelength)



# Transform the data
df_transformed_ASD3 <- melted_spectra_ASD3 %>%
  pivot_wider(names_from = Group, values_from = reflectance)

# Transform the data
df_transformed_ASD4 <- melted_spectra_ASD4 %>%
  pivot_wider(names_from = Group, values_from = reflectance)

# Add a method column to SVC
df_transformed_SVC$method <- "SVC"
df_transformed_ASD3$method <- "ASD3"
df_transformed_ASD4$method <- "ASD4"

# Save the transformed data back to CSV if needed
write.csv(df_transformed_SVC, file_name_SVC, row.names = FALSE)
write.csv(df_transformed_ASD3, file_name_ASD3, row.names = FALSE)
write.csv(df_transformed_ASD4, file_name_ASD4, row.names = FALSE)

# Merge the first two datasets
merged_data_1_2 <- merge(df_transformed_SVC, df_transformed_ASD3, by = "wavelength", 
                         all = FALSE, suffixes = c("_SVC", "_ASD3"))

# Rename the columns in df_transformed_ASD4 to add the _ASD4 suffix
colnames(df_transformed_ASD4) <- ifelse(colnames(df_transformed_ASD4) == "wavelength", 
                                        "wavelength", 
                                        paste0(colnames(df_transformed_ASD4), "_ASD4"))

# Then proceed with the merge as usual
final_merged_data <- merge(merged_data_1_2, df_transformed_ASD4, by = "wavelength", all = FALSE)

# # Merge the combined dataset with the third one
# final_merged_data <- merge(merged_data_1_2, df_transformed_ASD4, by = "wavelength", 
#                            all = FALSE, suffixes = c("", "_ASD4"))

file_merged_data <- file.path(target_directory, paste0(desired_name, "_merged.csv"))

# saved the merged data
write.csv(final_merged_data, file_merged_data, row.names = FALSE)


cols_SVC <- grep("_SVC", names(final_merged_data), value = TRUE)
cols_ASD3 <- grep("_ASD3", names(final_merged_data), value = TRUE)
cols_ASD4 <- grep("_ASD4", names(final_merged_data), value = TRUE)

# Remove 'method_' columns
cols_SVC <- cols_SVC[!grepl("method_", cols_SVC)]
cols_ASD3 <- cols_ASD3[!grepl("method_", cols_ASD3)]
cols_ASD4 <- cols_ASD4[!grepl("method_", cols_ASD4)]



# Calculating ratios
for (col in 1:length(cols_SVC)) {
  print(paste("For column:", cols_SVC[col]))
  final_merged_data[paste0("Ratio_SVC_ASD3_", cols_SVC[col])] <- final_merged_data[[cols_SVC[col]]] / final_merged_data[[cols_ASD3[col]]]
  final_merged_data[paste0("Ratio_SVC_ASD4_", cols_SVC[col])] <- final_merged_data[[cols_SVC[col]]] / final_merged_data[[cols_ASD4[col]]]
  final_merged_data[paste0("Ratio_ASD3_ASD4_", cols_ASD3[col])] <- final_merged_data[[cols_ASD3[col]]] / final_merged_data[[cols_ASD4[col]]]
  # You can also print the ratios before adding them to the dataframe
  # print(head(final_merged_data[[cols_SVC[col]]] / final_merged_data[[cols_ASD3[col]]]))
}

file_merged_data_wr <- file.path(target_directory, paste0(desired_name, "_merged_wr.csv"))

# saved the merged data
write.csv(final_merged_data, file_merged_data_wr, row.names = FALSE)


####################################SVC v/s ASD3########################################################
# Filter out only the relevant columns (wavelength and Ratio_SVC_ASD3_*)
final_long_data <- final_merged_data %>% 
  select(wavelength, starts_with("Ratio_SVC_ASD3")) %>% 
  gather(key = "RatioType", value = "Value", -wavelength)


# Calculate the absolute difference between each ratio and 1
final_long_data$Abs_Difference_From_1 <- abs(final_long_data$Value - 1)

# Calculate the average distance from 1 for each ratio type
average_distances <- final_long_data %>%
  group_by(RatioType) %>%
  summarise(Avg_Distance = mean(Abs_Difference_From_1))
# 
# Calculate the average of the average distances
overall_avg_distance <- mean(average_distances$Avg_Distance)

# print(paste("The overall average distance from 1 is:", overall_avg_distance))
# 


# Create the ggplot
p <- ggplot(final_long_data, aes(x = wavelength, y = Value, color = RatioType)) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 1 - overall_avg_distance, linetype = "dotted", color = "blue") +
  annotate("text", x = Inf, y = 1, label = "1", hjust = 1.1, vjust = 0, fontface = "bold", color = "red") +
  annotate("text", x = Inf, y = 1 - overall_avg_distance, label = paste("1 - ", round(overall_avg_distance, 3)), hjust = 1.1, vjust = 0, fontface = "bold", color = "red") +
  geom_text(data = average_distances, 
              aes(x = Inf, y = Inf, label = paste("Avg Distance from base, y=1: ", round(overall_avg_distance, 3))),
              hjust = 1.1, vjust = 1.1, 
              nudge_x = -max(final_long_data$wavelength) * 0.05, 
              nudge_y = -0.05)+
  labs(title = "Deviations from Base 1 for Reflectance SVC:ASD3",
       y = "Reflectance Ratio",
       x = "Wavelength",
       color = "Ratio Type")

# Show the plot
p


desired_name <- file_path_sans_ext(basename(dirname((dirname(file_path)))))

# Extract target directory to save files
target_directory <- dirname(dirname(file_path))


# Constructing the save path for the graph
save_path <- file.path(target_directory, paste0(desired_name, "_SVC_ASD3.png"))

# Saving the graph
ggsave(filename = save_path, plot = p, width = 16, height = 8)



####################################ASD3 v/s ASD4########################################################
# Filter out only the relevant columns (wavelength and Ratio_ASD3_ASD4_*)
final_long_data <- final_merged_data %>% 
  select(wavelength, starts_with("Ratio_ASD3_ASD4")) %>% 
  gather(key = "RatioType", value = "Value", -wavelength)


# Calculate the absolute difference between each ratio and 1
final_long_data$Abs_Difference_From_1 <- abs(final_long_data$Value - 1)

# Calculate the average distance from 1 for each ratio type
average_distances <- final_long_data %>%
  group_by(RatioType) %>%
  summarise(Avg_Distance = mean(Abs_Difference_From_1))

# Calculate the average of the average distances
overall_avg_distance <- mean(average_distances$Avg_Distance)

# print(paste("The overall average distance from 1 is:", overall_avg_distance))
# 


# Create the ggplot
p <- ggplot(final_long_data, aes(x = wavelength, y = Value, color = RatioType)) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 1 - overall_avg_distance, linetype = "dotted", color = "blue") +
  annotate("text", x = Inf, y = 1, label = "1", hjust = 1.1, vjust = 0, fontface = "bold", color = "red") +
  annotate("text", x = Inf, y = 1 - overall_avg_distance, label = paste("1 - ", round(overall_avg_distance, 3)), hjust = 1.1, vjust = 0, fontface = "bold", color = "red") +
  geom_text(data = average_distances, 
            aes(x = Inf, y = Inf, label = paste("Avg Distance from base, y=1: ", round(overall_avg_distance, 3))),
            hjust = 1.1, vjust = 1.1, 
            nudge_x = -max(final_long_data$wavelength) * 0.05, 
            nudge_y = -0.05)+
  labs(title = "Deviations from Base 1 for Reflectance ASD3:ASD4",
       y = "Reflectance Ratio",
       x = "Wavelength",
       color = "Ratio Type")

# Show the plot
p


desired_name <- file_path_sans_ext(basename(dirname((dirname(file_path)))))

# Extract target directory to save files
target_directory <- dirname(dirname(file_path))


# Constructing the save path for the graph
save_path <- file.path(target_directory, paste0(desired_name, "_ASD3_ASD4.png"))

# Saving the graph
ggsave(filename = save_path, plot = p, width = 16, height = 8)






####################################SVC v/s ASD4########################################################
# Filter out only the relevant columns (wavelength and Ratio_SVC_ASD4_*)
final_long_data <- final_merged_data %>% 
  select(wavelength, starts_with("Ratio_SVC_ASD4")) %>% 
  gather(key = "RatioType", value = "Value", -wavelength)


# Calculate the absolute difference between each ratio and 1
final_long_data$Abs_Difference_From_1 <- abs(final_long_data$Value - 1)

# Calculate the average distance from 1 for each ratio type
average_distances <- final_long_data %>%
  group_by(RatioType) %>%
  summarise(Avg_Distance = mean(Abs_Difference_From_1))

# Calculate the average of the average distances
overall_avg_distance <- mean(average_distances$Avg_Distance)

# print(paste("The overall average distance from 1 is:", overall_avg_distance))
# 


# Create the ggplot
p <- ggplot(final_long_data, aes(x = wavelength, y = Value, color = RatioType)) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 1 - overall_avg_distance, linetype = "dotted", color = "blue") +
  annotate("text", x = Inf, y = 1, label = "1", hjust = 1.1, vjust = 0, fontface = "bold", color = "red") +
  annotate("text", x = Inf, y = 1 - overall_avg_distance, label = paste("1 - ", round(overall_avg_distance, 3)), hjust = 1.1, vjust = 0, fontface = "bold", color = "red") +
  geom_text(data = average_distances, 
            aes(x = Inf, y = Inf, label = paste("Avg Distance from base, y=1: ", round(overall_avg_distance, 3))),
            hjust = 1.1, vjust = 1.1, 
            nudge_x = -max(final_long_data$wavelength) * 0.05, 
            nudge_y = -0.05)+
  labs(title = "Deviations from Base 1 for Reflectance SVC:ASD4",
       y = "Reflectance Ratio",
       x = "Wavelength",
       color = "Ratio Type")

# Show the plot
p


desired_name <- file_path_sans_ext(basename(dirname((dirname(file_path)))))

# Extract target directory to save files
target_directory <- dirname(dirname(file_path))


# Constructing the save path for the graph
save_path <- file.path(target_directory, paste0(desired_name, "_SVC_ASD4.png"))

# Saving the graph
ggsave(filename = save_path, plot = p, width = 16, height = 8)

