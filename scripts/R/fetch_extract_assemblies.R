# ==============================================================================
# fetch_extract_assemblies.R — assemblies added 2026-10-10, per-chromosome stats
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/fetch_extract_assemblies.R
#
# For each accession below: download the NCBI Datasets zip (GFF + sequence
# report only) into genomic_data/<species>/ if it is not already there, then
# stream the GFF out of the zip and compute, per assembled molecule:
#   Physical_Length_bp  sequence length from the NCBI sequence report
#   L_coding_bp         collapsed (reduce()d) CDS bp, as in data_gen_2.R
#   Gene_Count          protein-coding genes
# Scaffold-level assemblies get one genome-wide row instead (Assembly_Level =
# "Genome_total"), since autosomes cannot be separated.
#
# Output: data/assembly_stats_added.csv (tracked). genomic_data/ is gitignored,
# so this CSV plus the accession list is what makes the numbers reproducible.
# It complements data/raw/clean_chromosome_data.csv (data_gen_2.R), and
# 00_prepare_data.R reads both.
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(IRanges)
})

assemblies <- tibble::tribble(
  ~Species,                  ~accession,        ~reason,
  "cyanistes_caeruleus",     "GCF_971803275.1", "chromosome-level blue tit (repo had scaffold-level GCF_002901205.1)",
  "tamiasciurus_hudsonicus", "GCA_057657825.1", "Kluane red squirrel; replaces wrong-species Sciurus vulgaris",
  "crocuta_crocuta",         "GCF_008692635.1", "spotted hyena; only annotated assembly, scaffold-level"
)

if (!dir.exists("genomic_data")) stop("Run from the repo root.", call. = FALSE)
source("scripts/R/ncbi_helpers.R")

extract <- function(species, acc) {
  zip <- fetch(species, acc)
  message("Extracting ", species, " (", acc, ")")
  sr <- read_sequence_report(zip)
  ft <- read_gff_features(zip)
  # GFF seqids may be RefSeq or GenBank accessions; match whichever is used.
  key <- if (mean(ft$cds$seqid %in% sr$SeqID) >= mean(ft$cds$seqid %in% sr$genbank)) "SeqID" else "genbank"
  cds_bp <- vapply(split(ft$cds, ft$cds$seqid), function(d)
    sum(width(reduce(IRanges(d$start, d$end)))), numeric(1))
  gene_n <- table(ft$genes)
  per_seq <- data.frame(seqid = names(cds_bp), L_coding_bp = unname(cds_bp)) %>%
    left_join(data.frame(seqid = names(gene_n), Gene_Count = as.integer(gene_n)), by = "seqid") %>%
    mutate(Gene_Count = coalesce(Gene_Count, 0L))
  mol <- sr %>% filter(role == "assembled-molecule", !toupper(chrName) %in% c("MT", "UN"))
  if (nrow(mol) > 0) {
    mol %>%
      left_join(per_seq, by = setNames("seqid", key)) %>%
      transmute(Species = species, accession = acc, NCBI_Chromosome = chrName,
                SeqID, Physical_Length_bp = length,
                L_coding_bp = coalesce(L_coding_bp, 0), Gene_Count = coalesce(Gene_Count, 0L),
                Coding_Density = L_coding_bp / Physical_Length_bp,
                Assembly_Level = "Chromosome")
  } else {
    data.frame(Species = species, accession = acc, NCBI_Chromosome = NA, SeqID = NA,
               Physical_Length_bp = sum(sr$length), L_coding_bp = sum(per_seq$L_coding_bp),
               Gene_Count = sum(per_seq$Gene_Count),
               Coding_Density = sum(per_seq$L_coding_bp) / sum(sr$length),
               Assembly_Level = "Genome_total")
  }
}

out <- bind_rows(Map(extract, assemblies$Species, assemblies$accession))
write.csv(out, "data/assembly_stats_added.csv", row.names = FALSE)
message("Wrote data/assembly_stats_added.csv: ", nrow(out), " rows")
print(out %>% group_by(Species, Assembly_Level) %>%
        summarise(n = n(), L_coding_bp = sum(L_coding_bp), .groups = "drop"))
