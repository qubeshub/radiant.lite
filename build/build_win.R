## build for windows
rv <- R.Version()
rv <- paste0(rv$major,".", strsplit(rv$minor,".", fixed = TRUE)[[1]][1])

rvprompt <- readline(prompt = paste0("Running for R version: ", rv, ". Is that what you wanted y/n: "))
if (grepl("[nN]", rvprompt))
  stop("Change R-version using Rstudio > Tools > Global Options > Rversion")

apps <- c("radiant.lite.data","radiant.lite")

path <- "Z:/Desktop/GitHub"
curr <- getwd(); setwd(path)
build_app <- function(app) {
	f <- devtools::build(file.path(path, app))
	system(paste0("R CMD INSTALL --build ", f))
}
sapply(apps, build_app)
setwd(curr)
