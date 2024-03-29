## building radiant packages for mac and windows
setwd("~/gh/")

rv <- R.Version()
rv <- paste0(rv$major,".", strsplit(rv$minor,".", fixed = TRUE)[[1]][1])

rvprompt <- readline(prompt = paste0("Running for R version: ", rv, ". Is that what you wanted y/n: "))
if (grepl("[nN]", rvprompt))
  stop("Change R-version using RSwitch")

dirsrc <- file.path("minicran/src/contrib")

if (rv == "3.3") {
  dirmac <- file.path("minicran/bin/macosx/mavericks/contrib",rv)
} else {
  dirmac <- file.path("minicran/bin/macosx/el-capitan/contrib",rv)
}

dirwin <- file.path("minicran/bin/windows/contrib",rv)

if (!file.exists(dirsrc)) dir.create(dirsrc, recursive = TRUE)
if (!file.exists(dirmac)) dir.create(dirmac, recursive = TRUE)
if (!file.exists(dirwin)) dir.create(dirwin, recursive = TRUE)

## delete older version of radiant
rem_old <- function(app) {
	unlink(paste0(dirsrc, "/", app, "*"))
	unlink(paste0(dirmac, "/", app, "*"))
	unlink(paste0(dirwin, "/", app, "*"))
}

sapply("radiant.lite", rem_old)

apps <- c("radiant.lite", "radiant.lite.data")

## probably need to restart Rstudion before building
## avoid 'loaded namespace' stuff when building for mac
system(paste0(Sys.which("R"), " -e \"source('radiant.lite/build/build_mac.R')\""))

win <- readline(prompt = "Did you build on Windows? y/n: ")
if (grepl("[yY]", win)) {

  # system(paste0(Sys.which("R"), " -e \"source('radiant.lite/build/build_win.R')\""))

  ## move packages to radiant_miniCRAN. must package in Windows first
  setwd("~/gh/")
  sapply(list.files(".",pattern = "*.tar.gz"), file.copy, dirsrc)
  unlink("*.tar.gz")
  sapply(list.files(".",pattern = "*.tgz"), file.copy, dirmac)
  unlink("*.tgz")
  sapply(list.files(".",pattern = "*.zip"), file.copy, dirwin)
  unlink("*.zip")

  tools::write_PACKAGES(dirmac,type = 'mac.binary')
  tools::write_PACKAGES(dirwin,type = 'win.binary')
  tools::write_PACKAGES(dirsrc,type = 'source')

  # commit to repo
  setwd("~/gh/minicran")
  system("git add --all .")
  mess <- paste0("radiant.lite package updates: ", format(Sys.Date(), format="%m-%d-%Y"))
  system(paste0("git commit -m '",mess,"'"))
  system("git push")
  setwd("~/gh/radiant.lite")

}
