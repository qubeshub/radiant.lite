## ui for design menu in radiant
do.call(navbarPage,
  c("Radiant Lite", getOption("radiant.nav_ui"), getOption("radiant.shared_ui"),
    help_menu("help_ui"))
)
