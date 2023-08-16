library(data.table)

file_path <- "D:\\Projects\\AnacondaFiles\\APPF_codes\\point_spec_dev\\point_spectral_test_data\\SVC_test_scan_default_overlap_correction_2023_07_25\\all.csv"
data <- read.csv(file_path, header = FALSE, stringsAsFactors = FALSE)

# Find the row that contains the headers you're interested in
header_row <- which(data$V1 == "Wavlen" & !is.na(data$V1))[1]

# Extract the header and the data below it
header <- data[header_row,]
data <- data[(header_row+1):nrow(data),]

# Remove blank rows
data <- data[rowSums(is.na(data)) != ncol(data),]

# Set the header
colnames(data) <- header

# Convert to data.table for easier manipulation
data <- data.table(data)

# Find the columns that have 'Reflect' in their names
reflect_cols <- grep("Reflect", names(data))

# Exclude the "Avg Reflect" column
reflect_cols <- reflect_cols[names(data)[reflect_cols] != "Avg Reflect"]

# Extract all 'Reflect' columns and rename them
output_data <- data[, ..reflect_cols]
setnames(output_data, paste0("Reflect_", 1:length(reflect_cols)))

# Remove rows that have all blank values
output_data <- output_data[rowSums(output_data == "") != ncol(output_data), ]

# Get directory and filename prefix from file_path
dir_path <- dirname(file_path)
file_prefix <- sub("\\.csv$", "", basename(file_path))

# Create the CSV filename
output_filename <- file.path(dir_path, paste0(file_prefix, "_reflectance.csv"))

# Write to CSV
fwrite(output_data, file = output_filename)
