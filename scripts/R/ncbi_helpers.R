# ==============================================================================
# ncbi_helpers.R — download and stream NCBI Datasets genome zips
# ==============================================================================
# Sourced by fetch_extract_assemblies.R and lg_orthology.R. Zips (GFF + sequence
# report only) live in genomic_data/<species>/<accession>.zip, which is
# gitignored; files are read straight out of the zip, never unpacked.
# ==============================================================================

fetch <- function(species, acc) {
  dir <- file.path("genomic_data", species)
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  zip <- file.path(dir, paste0(acc, ".zip"))
  if (!file.exists(zip)) {
    url <- paste0("https://api.ncbi.nlm.nih.gov/datasets/v2/genome/accession/", acc,
                  "/download?include_annotation_type=GENOME_GFF",
                  "&include_annotation_type=SEQUENCE_REPORT")
    message("Downloading ", acc)
    download.file(url, zip, mode = "wb", quiet = TRUE)
  }
  zip
}

zip_entry <- function(zip, pattern) {
  e <- unzip(zip, list = TRUE)$Name
  hit <- e[grepl(pattern, e)]
  if (length(hit) != 1) stop(zip, ": expected one entry matching ", pattern)
  hit
}

# Stream the GFF in chunks, keeping only CDS and protein-coding gene rows.
read_gff_features <- function(zip) {
  con <- unz(zip, zip_entry(zip, "genomic\\.gff$"))
  open(con)
  on.exit(close(con))
  cds <- list(); genes <- list()
  repeat {
    x <- readLines(con, n = 200000)
    if (length(x) == 0) break
    x <- x[!startsWith(x, "#")]
    f <- strsplit(x, "\t", fixed = TRUE)
    type <- vapply(f, `[`, "", 3)
    keep_cds  <- type == "CDS"
    keep_gene <- type == "gene" & grepl("gene_biotype=protein_coding", x, fixed = TRUE)
    if (any(keep_cds)) {
      m <- do.call(rbind, f[keep_cds])
      cds[[length(cds) + 1]] <- data.frame(seqid = m[, 1], start = as.integer(m[, 4]),
                                           end = as.integer(m[, 5]))
    }
    if (any(keep_gene)) {
      genes[[length(genes) + 1]] <- vapply(f[keep_gene], `[`, "", 1)
    }
  }
  list(cds = do.call(rbind, cds), genes = unlist(genes))
}

read_sequence_report <- function(zip) {
  con <- unz(zip, zip_entry(zip, "sequence_report\\.jsonl$"))
  sr <- jsonlite::stream_in(con, verbose = FALSE)
  id <- if ("refseqAccession" %in% names(sr)) dplyr::coalesce(sr$refseqAccession, sr$genbankAccession) else sr$genbankAccession
  data.frame(SeqID = id, genbank = sr$genbankAccession, chrName = sr$chrName,
             role = sr$role, length = sr$length)
}
