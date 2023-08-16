# Please donot rerun the code unles you are just starting a project

# Directory path
dir_path <- "D:/Projects/AnacondaFiles/APPF_codes/point_spec_dev"

# Capturing R version
r_version <- R.version$version.string

# Capturing package versions
pkg_versions <- installed.packages()[, "Version"]
pkg_info <- paste0(names(pkg_versions), "=", pkg_versions)

# Combining the information
all_info <- c(r_version, pkg_info)

# Full path for requirements.txt
file_path <- file.path(dir_path, "requirements.txt")

# Writing to the file in the specified directory
writeLines(all_info, file_path)

