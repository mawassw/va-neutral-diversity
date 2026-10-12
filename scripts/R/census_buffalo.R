# ==============================================================================
# census_buffalo.R — census size N_c = density x range, after Buffalo (2021)
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/census_buffalo.R
#
# Buffalo (2021, eLife; github.com/vsbuffalo/paradox_variation) estimates census
# size as population density x geographic range:
#   density : Damuth (1987) allometry, log10 density ~ log10 adult body mass
#             (his Stan model fits the same linear relation on centred logs;
#             he predicts mass from body length, we use measured adult mass)
#   range   : alpha hull (alpha = 8 degrees, his terrestrial default) around
#             GBIF occurrences, intersected with land, area in km^2. He used
#             the first 30,000 raw records; we use GBIF's density tiles, which
#             bin every record into ~20 km cells (see gbif_occurrences)
# His published values exist for 12 of our 19 populations (species_EPP.csv,
# unnamed last column), but two of those are congeners (SFW: Malurus
# melanocephalus; AB: Papio anubis). This script reproduces the method for the
# species he did not cover, and also re-runs it on four species he did cover so
# the reimplementation can be checked against his numbers.
#
# Outputs (tracked):
#   data/census/census_buffalo_method.csv   one row per species, incl. checks
#   data/census/damuth1987.tsv              copy of his Damuth table (input)
# GBIF cells are cached in data/census/gbif_cache/ (gitignored); delete the
# cache to re-query GBIF, whose holdings change over time.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(sf)
  library(alphahull)
})

dir <- "data/census"
cache <- file.path(dir, "gbif_cache")
dir.create(cache, showWarnings = FALSE, recursive = TRUE)
raw_base <- "https://raw.githubusercontent.com/vsbuffalo/paradox_variation/master/data/"

# ------------------------------------------------------------------------------
# Species. Masses: AnAge via Buffalo's anage_data_updated.tsv unless noted.
# ------------------------------------------------------------------------------
species <- tibble::tribble(
  ~species,                  ~mass_g,  ~mass_source,                                         ~role,
  "Cervus elaphus",          200000,   "AnAge",                                              "new",
  "Chionomys nivalis",       42.01,    "Amniote Database (Myhrvold et al. 2015)",            "new",
  "Crocuta crocuta",         63000,    "AnAge",                                              "new",
  "Notiomystis cincta",      36,       "Walker et al. 2014 JEB: males c. 40 g, females c. 32 g (Amniote DB 89.5 g is an error)", "new",
  "Tamiasciurus hudsonicus", 200,      "AnAge",                                              "new",
  "Suricata suricatta",      776,      "AnAge",                                              "new",
  "Malurus cyaneus",         10.4,     "AnAge",                                              "new",
  "Papio cynocephalus",      17851.25, "Amniote Database (Myhrvold et al. 2015)",            "new",
  # validation: Buffalo's own published estimates exist for these
  "Cyanistes caeruleus",     11.2,     "Amniote Database (Myhrvold et al. 2015)",            "check",
  "Ficedula albicollis",     12.55,    "Amniote Database (Myhrvold et al. 2015)",            "check",
  "Ovis canadensis",         70275,    "AnAge",                                              "check",
  "Macaca mulatta",          8235,     "AnAge",                                              "check"
)

# ------------------------------------------------------------------------------
# 1. Density from body mass (Damuth 1987)
# ------------------------------------------------------------------------------
damuth_file <- file.path(dir, "damuth1987.tsv")
if (!file.exists(damuth_file)) download.file(paste0(raw_base, "damuth1987.tsv"), damuth_file, quiet = TRUE)
damuth <- read.delim(damuth_file) %>% filter(mass_g > 0, density > 0)
fit <- lm(log10(density) ~ log10(mass_g), data = damuth)
message(sprintf("Damuth fit: log10 density = %.3f %+.3f log10 mass (n = %d, R2 = %.2f)",
                coef(fit)[1], coef(fit)[2], nrow(damuth), summary(fit)$r.squared))
species$log10_density <- predict(fit, newdata = data.frame(mass_g = species$mass_g))

# ------------------------------------------------------------------------------
# 2. GBIF occurrences
# ------------------------------------------------------------------------------
gbif_key <- function(sp) {
  u <- paste0("https://api.gbif.org/v1/species/match?rank=SPECIES&strict=true&name=",
              utils::URLencode(sp))
  jsonlite::fromJSON(u)$usageKey
}

# GBIF density map tiles (api.gbif.org/v2/map): every georeferenced record for
# the taxon, pre-binned into occupied cells. At zoom 2 the world is 4 x 4 Web
# Mercator tiles and cells are ~20 km, far finer than the 8-degree hull.
# Deviation from Buffalo, who used the first 30,000 raw records from the
# occurrence search API: the tiles cover all records, need 16 requests per
# species instead of 100, and are not throttled. Records beyond +/-85 degrees
# latitude (outside Web Mercator) are dropped, irrelevant for these species.
gbif_occurrences <- function(sp, z = 2) {
  f <- file.path(cache, paste0(gsub(" ", "_", sp), ".csv"))
  if (file.exists(f)) return(read.csv(f))
  key <- gbif_key(sp)
  n <- 2^z
  cells <- list()
  for (x in 0:(n - 1)) for (y in 0:(n - 1)) {
    tile <- tempfile(fileext = ".mvt")
    try(download.file(sprintf("https://api.gbif.org/v2/map/occurrence/density/%d/%d/%d.mvt?taxonKey=%s",
                          z, x, y, key), tile, mode = "wb", quiet = TRUE), silent = TRUE)
    if (isTRUE(file.size(tile) > 0)) {   # empty tiles return no content
      pts <- suppressWarnings(st_read(tile, quiet = TRUE,
                                      options = c(paste0("X=", x), paste0("Y=", y), paste0("Z=", z))))
      if (nrow(pts) > 0) cells[[length(cells) + 1]] <- st_coordinates(st_transform(pts, 4326))
    }
    unlink(tile)
  }
  d <- as.data.frame(do.call(rbind, cells))
  names(d) <- c("decimalLongitude", "decimalLatitude")
  message("  ", sp, ": ", nrow(d), " occupied GBIF cells")
  write.csv(d, f, row.names = FALSE)
  d
}

# ------------------------------------------------------------------------------
# 3. Range = alpha hull around occurrences, clipped to land
# ------------------------------------------------------------------------------
# Planar union (as in Buffalo's sf code); the spherical (s2) union of all
# country polygons is impractically slow.
sf_use_s2(FALSE)
land <- st_union(st_make_valid(st_geometry(
  rnaturalearth::ne_countries(scale = "medium", returnclass = "sf"))))
sf_use_s2(TRUE)

alpha_hull_area <- function(d, alpha = 8) {
  # Unique 0.05-degree positions; the triangulation behind alphahull
  # (interp::tri.mesh) rejects near-duplicates. A small jitter breaks exact
  # collinearity of the tile grid.
  d <- round(d[stats::complete.cases(d), ] / 0.05) * 0.05
  d <- d[!duplicated(d), ]
  set.seed(1)
  xy <- as.matrix(d) + matrix(stats::runif(2 * nrow(d), -0.005, 0.005), ncol = 2)
  a <- ashape(xy, alpha = alpha)
  e <- a$edges
  lines <- st_sfc(lapply(seq_len(nrow(e)), function(i)
    st_linestring(rbind(e[i, c("x1", "y1")], e[i, c("x2", "y2")]))), crs = 4326)
  sf_use_s2(FALSE)
  poly <- st_collection_extract(st_polygonize(st_union(lines)), "POLYGON")
  poly <- suppressMessages(st_intersection(st_make_valid(st_union(poly)), land))
  # Area in an equal-area projection (Mollweide); s2 rejects some hull edges.
  area <- st_area(st_make_valid(st_transform(poly, "+proj=moll +datum=WGS84")))
  sf_use_s2(TRUE)
  as.numeric(sum(area)) / 1e6   # m^2 -> km^2
}

species$n_cells <- NA_integer_
species$range_km2 <- NA_real_
for (i in seq_len(nrow(species))) {
  message("Range: ", species$species[i])
  occ <- gbif_occurrences(species$species[i])
  species$n_cells[i] <- nrow(occ)
  species$range_km2[i] <- alpha_hull_area(occ)
}

# ------------------------------------------------------------------------------
# 4. Census and comparison with Buffalo's published values
# ------------------------------------------------------------------------------
buff_file <- file.path(cache, "combined_data.tsv")
if (!file.exists(buff_file)) download.file(paste0(raw_base, "combined_data.tsv"), buff_file, quiet = TRUE)
buff <- read.delim(buff_file) %>%
  select(species, buffalo_log10_density = log10_density,
         buffalo_range_km2 = range, buffalo_log10_Nc = log10_popsize)

out <- species %>%
  mutate(log10_range = log10(range_km2),
         log10_Nc = log10_density + log10_range,
         method = "Damuth density (measured mass) x alpha-hull range (alpha = 8) on GBIF density cells",
         gbif_accessed = as.character(Sys.Date())) %>%
  left_join(buff, by = "species")

write.csv(out, file.path(dir, "census_buffalo_method.csv"), row.names = FALSE)
print(as.data.frame(out %>% transmute(species, role, n_cells, log10_density = round(log10_density, 2),
                                      buffalo_log10_density = round(buffalo_log10_density, 2),
                                      log10_range = round(log10_range, 2),
                                      buffalo_log10_range = round(log10(buffalo_range_km2), 2),
                                      log10_Nc = round(log10_Nc, 2),
                                      buffalo_log10_Nc = round(buffalo_log10_Nc, 2))))
