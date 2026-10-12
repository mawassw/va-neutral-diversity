# ==============================================================================
# lg_orthology.R — match size-numbered assembly chromosomes to linkage groups
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/lg_orthology.R
#
# Some recent assemblies number chromosomes by size (1, 2, 3, ...) while their
# linkage maps use avian homology names (1A, 4A, LGE22, ...). Name matching then
# silently mis-assigns. Here each query chromosome is assigned to the great tit
# (Parus major, GCF_001522545.3, standard avian names) chromosome that shares the
# plurality of its protein-coding gene symbols (LOC* symbols excluded).
#
# Output: data/lg_orthology.csv (tracked), one row per query chromosome, with
# the share of shared genes supporting the assignment. 00_prepare_data.R uses it
# to join the song sparrow map (spM) to GCF_035770615.1.
#
# Inputs: NCBI Datasets zips (GFF + sequence report) in genomic_data/<species>/,
# downloaded by fetch() in ncbi_helpers.R if absent.
# ==============================================================================

suppressPackageStartupMessages(library(dplyr))
source("scripts/R/ncbi_helpers.R")

reference <- c(Species = "parus_major", accession = "GCF_001522545.3")
queries <- tibble::tribble(
  ~Species,            ~accession,        ~map_code,
  "melospiza_melodia", "GCF_035770615.1", "spM"
)

gene_symbols <- function(species, acc) {
  zip <- fetch(species, acc)
  con <- unz(zip, zip_entry(zip, "genomic\\.gff$")); open(con); on.exit(close(con))
  out <- list()
  repeat {
    x <- readLines(con, n = 200000)
    if (length(x) == 0) break
    x <- x[grepl("\tgene\t", x, fixed = TRUE) & grepl("gene_biotype=protein_coding", x, fixed = TRUE)]
    if (!length(x)) next
    out[[length(out) + 1]] <- data.frame(
      seqid = sub("\t.*", "", x),
      sym   = sub(".*;gene=([^;]+).*", "\\1", x))
  }
  sr <- read_sequence_report(zip)
  do.call(rbind, out) %>%
    filter(!grepl("^LOC", sym)) %>%
    inner_join(sr %>% filter(role == "assembled-molecule") %>% select(SeqID, chrName),
               by = c(seqid = "SeqID")) %>%
    distinct(sym, .keep_all = TRUE)
}

ref <- gene_symbols(reference[["Species"]], reference[["accession"]]) %>%
  select(sym, ref_chr = chrName)

orth <- bind_rows(lapply(seq_len(nrow(queries)), function(i) {
  q <- queries[i, ]
  gene_symbols(q$Species, q$accession) %>%
    inner_join(ref, by = "sym") %>%
    count(chrName, ref_chr) %>%
    group_by(chrName) %>%
    mutate(n_shared = sum(n), share = n / n_shared) %>%
    slice_max(n, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    transmute(Species = q$Species, accession = q$accession, map_code = q$map_code,
              NCBI_Chromosome = chrName,
              # great tit splits chr 25 into 25LG1/25LG2; maps call it 25
              Linkage_Group = sub("^25LG[12]$", "25", ref_chr),
              n_shared, share)
}))

write.csv(orth, "data/lg_orthology.csv", row.names = FALSE)
message("Wrote data/lg_orthology.csv: ", nrow(orth), " rows")
print(as.data.frame(orth %>% filter(share < 0.95)))
