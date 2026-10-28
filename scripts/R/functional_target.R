# ==============================================================================
# functional_target.R — annotated functional target per autosome (supplementary)
# ==============================================================================
# Run from the repo root:   Rscript scripts/R/functional_target.R
# Writes data/functional_target_lengths.csv (tracked), read by figS_noncoding.R.
#
# Relaxes "functional target = coding sequence". For every annotated assembly the
# GFF3/GTF is streamed once by the Python helper scripts/R/functional_target_gff.py
# (collapsed interval unions, strand ignored, nothing counted twice), and per
# assembled autosome of data/processed/chromosomes.csv this script records
#   L_cds    |CDS|                                   (reproduces L_coding_bp)
#   L_utr    |exons of protein-coding transcripts| outside CDS
#   L_ncrna  |exons of non-coding transcripts| outside CDS and those exons
#            (lnc_RNA, snoRNA, snRNA, tRNA, rRNA, misc/other ncRNA and non-coding
#            transcript variants; pseudogene exons excluded)
#   L_annot  L_cds + L_utr + L_ncrna = |CDS u UTR u ncRNA exons|
#   L_phys   sequence length from the NCBI sequence report (gaps included)
#   L_other  L_phys - L_annot  (introns, intergenic sequence, gaps)
# plus L_coding_bp_current (chromosomes.csv) for the agreement check.
#
# Scaffold-level assemblies (no per-chromosome rows):
#   hyena (NH)  genome-wide totals over all sequences of GCF_008692635.1, each
#               length scaled to autosomes by the meerkat's autosomal share of that
#               same length (autosomes / assembled molecules), the rule
#               00_prepare_data.R applies to CDS; level = "autosomes_scaled".
#   hihi (HT, HK)  no annotation file in genomic_data/ (B10K GenBank annotation of
#               GCA_013398075.1, protein-coding genes only, no UTR or ncRNA
#               features). L_cds is the current L_coding_bp; L_utr and L_ncrna are
#               L_cds times the mean ratio over the four chromosome-level passerines;
#               L_phys is the genome length times their mean autosomal physical
#               share; level = "autosomes_proxy".
#   superb fairy-wren (SFW) has no assembly and stays out.
#
# Inputs (genomic_data/ is gitignored; most genomic.gff files are Git LFS pointer
# stubs, resolved to <LFS_OBJECTS_DIR>/<oid[1:2]>/<oid[3:4]>/<oid>):
#   GENOMIC_DATA_DIR  default "genomic_data"
#   LFS_OBJECTS_DIR   default ".git/lfs/objects"
#   PYTHON            default "python"  (called with -I)
#   FT_CACHE          per-sequence helper output, default
#                     "genomic_data/functional_target_cache"; delete to re-stream
# From a worktree, point the first two at the main checkout, e.g.
#   GENOMIC_DATA_DIR="G:/.../project#3/genomic_data"
#   LFS_OBJECTS_DIR="G:/.../project#3/.git/lfs/objects"
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})
source("scripts/R/ncbi_helpers.R")      # read_sequence_report() for zips

gdir   <- Sys.getenv("GENOMIC_DATA_DIR", "genomic_data")
lfsdir <- Sys.getenv("LFS_OBJECTS_DIR", ".git/lfs/objects")
python <- Sys.getenv("PYTHON", "python")
cache  <- Sys.getenv("FT_CACHE", "genomic_data/functional_target_cache")
dir.create(cache, showWarnings = FALSE, recursive = TRUE)
sex_or_organelle <- c("X", "Y", "Z", "W", "MT", "M", "MITO", "W1", "Z1")

# The assemblies behind data/processed/chromosomes.csv and populations.csv
# (accessions as in data/genomic_parameters_summary.csv and assembly_stats_added.csv).
nd <- function(sp, acc, f) file.path(sp, "ncbi_dataset", "data", acc, f)
assemblies <- tibble::tribble(
  ~genome_sp,                ~accession,
  "cervus_elaphus",          "GCF_910594005.1",
  "chionomys_nivalis",       "GCF_950005125.1",
  "ficedula_albicollis",     "GCF_000247815.1",
  "macaca_mulatta",          "GCF_049350105.2",
  "melospiza_melodia",       "GCF_035770615.1",
  "ovis_aries",              "GCF_016772045.2",
  "ovis_canadensis",         "GCF_042477335.2",
  "papio_cynocephalus",      "GCF_008728515.1",
  "parus_major",             "GCF_001522545.3",
  "suricata_suricatta",      "GCF_006229205.1",
  "cyanistes_caeruleus",     "GCF_971803275.1",
  "tamiasciurus_hudsonicus", "GCA_057657825.1",
  "crocuta_crocuta",         "GCF_008692635.1"
) %>%
  mutate(zip = file.path(gdir, genome_sp, paste0(accession, ".zip")),
         from_zip = genome_sp %in% c("cyanistes_caeruleus", "tamiasciurus_hudsonicus",
                                     "crocuta_crocuta"),
         annotation = if_else(from_zip, zip,
                              file.path(gdir, nd(genome_sp, accession,
                                                 if_else(genome_sp == "ovis_canadensis",
                                                         "genomic.gtf", "genomic.gff")))))

# A Git LFS pointer stub -> the object it names; any other file -> itself.
resolve_lfs <- function(path) {
  head <- readLines(path, n = 3, warn = FALSE)
  if (!length(head) || !startsWith(head[1], "version https://git-lfs")) return(path)
  oid <- sub("^oid sha256:", "", grep("^oid sha256:", head, value = TRUE))
  obj <- file.path(lfsdir, substr(oid, 1, 2), substr(oid, 3, 4), oid)
  if (!file.exists(obj)) stop(path, " is an LFS stub and ", obj, " is missing", call. = FALSE)
  obj
}

per_seq <- function(sp, ann) {
  out <- file.path(cache, paste0(sp, ".csv"))
  if (!file.exists(out)) {
    src <- if (endsWith(ann, ".zip")) ann else resolve_lfs(ann)
    message("Streaming ", sp, ": ", src)
    st <- system2(python, c("-I", shQuote("scripts/R/functional_target_gff.py"),
                            shQuote(src), shQuote(out)))
    if (st != 0) stop("functional_target_gff.py failed for ", sp, call. = FALSE)
  }
  read_csv(out, show_col_types = FALSE)
}

# Sequence lengths and both accessions, for joining GFF seqids to chromosomes.csv
seq_lengths <- function(sp, acc, from_zip) {
  if (from_zip) {
    sr <- read_sequence_report(file.path(gdir, sp, paste0(acc, ".zip")))
    return(tibble(refseq = if_else(sr$SeqID == sr$genbank, NA_character_, sr$SeqID),
                  genbank = sr$genbank, role = sr$role, length = sr$length))
  }
  sr <- read_tsv(file.path(gdir, sp, "ncbi_dataset", "data", "sequence_report.tsv"),
                 show_col_types = FALSE, col_types = cols(.default = col_character()))
  tibble(refseq = na_if(sr$`RefSeq seq accession`, "na"), genbank = sr$`GenBank seq accession`,
         role = sr$Role, length = as.numeric(sr$`Seq length`))
}

ps <- bind_rows(lapply(seq_len(nrow(assemblies)), function(k) {
  a <- assemblies[k, ]
  d <- per_seq(a$genome_sp, a$annotation)
  sl <- seq_lengths(a$genome_sp, a$accession, a$from_zip)
  # GFF seqids are RefSeq or GenBank accessions; attach the length either way
  d <- d %>%
    left_join(sl %>% filter(!is.na(refseq)) %>% select(seqid = refseq, len_r = length), by = "seqid") %>%
    left_join(sl %>% select(seqid = genbank, len_g = length), by = "seqid") %>%
    mutate(seq_length = coalesce(len_r, len_g)) %>% select(-len_r, -len_g)
  d %>% mutate(genome_sp = a$genome_sp, accession = a$accession,
               genome_length = sum(sl$length))
}))

# --- chromosome-level assemblies: one row per assembled autosome ---------------
chrom <- read_csv("data/processed/chromosomes.csv", show_col_types = FALSE,
                  col_types = cols(NCBI_Chromosome = col_character()))
chrom_rows <- chrom %>%
  inner_join(ps, by = c("genome_sp", "SeqID" = "seqid")) %>%
  transmute(code, genome_sp, accession, NCBI_Chromosome, SeqID, is_autosome,
            level = "chromosome",
            L_cds, L_utr = L_cds_mrna - L_cds, L_ncrna = L_annot - L_cds_mrna, L_annot,
            L_phys = seq_length, L_other = L_phys - L_annot,
            L_cds_stranded, L_coding_bp_current = L_coding_bp,
            Physical_Length_bp_current = Physical_Length_bp)
missing <- anti_join(chrom %>% filter(genome_sp %in% ps$genome_sp),
                     chrom_rows, by = c("code", "NCBI_Chromosome"))
if (nrow(missing)) {
  print(missing %>% select(code, NCBI_Chromosome, SeqID, L_coding_bp))
  stop("chromosomes.csv rows without helper output (above)", call. = FALSE)
}
stopifnot(all(!is.na(chrom_rows$L_phys)))

# autosomal share of each length within the assembled molecules of one species
auto_shares <- function(sp) {
  r <- chrom_rows %>% filter(genome_sp == sp) %>% distinct(NCBI_Chromosome, .keep_all = TRUE)
  sh <- function(x) sum(x[r$is_autosome]) / sum(x)
  c(cds = sh(r$L_cds), cds_mrna = sh(r$L_cds + r$L_utr), annot = sh(r$L_annot),
    phys = sh(r$L_phys))
}

# --- hyena: genome totals scaled by the meerkat's autosomal shares -------------
pops <- read_csv("data/processed/populations.csv", show_col_types = FALSE)
hy <- ps %>% filter(genome_sp == "crocuta_crocuta")
sh_mk <- auto_shares("suricata_suricatta")
hy_cds <- sum(hy$L_cds) * sh_mk[["cds"]]
hy_mrna <- sum(hy$L_cds_mrna) * sh_mk[["cds_mrna"]]
hy_annot <- sum(hy$L_annot) * sh_mk[["annot"]]
hy_phys <- hy$genome_length[1] * sh_mk[["phys"]]
hyena <- tibble(code = "NH", genome_sp = "crocuta_crocuta", accession = hy$accession[1],
                NCBI_Chromosome = NA_character_, SeqID = NA_character_, is_autosome = TRUE,
                level = "autosomes_scaled",
                L_cds = hy_cds, L_utr = hy_mrna - hy_cds, L_ncrna = hy_annot - hy_mrna,
                L_annot = hy_annot, L_phys = hy_phys, L_other = hy_phys - hy_annot,
                L_cds_stranded = sum(hy$L_cds_stranded) * sh_mk[["cds"]],
                L_coding_bp_current = pops$L_coding_bp[pops$code == "NH"],
                Physical_Length_bp_current = NA_real_)

# --- hihi: passerine ratios applied to the current autosomal CDS ---------------
passerines <- c("ficedula_albicollis", "parus_major", "melospiza_melodia", "cyanistes_caeruleus")
pas <- chrom_rows %>% filter(genome_sp %in% passerines, is_autosome) %>%
  distinct(genome_sp, NCBI_Chromosome, .keep_all = TRUE) %>%
  group_by(genome_sp) %>%
  summarise(utr = sum(L_utr) / sum(L_cds), nc = sum(L_ncrna) / sum(L_cds), .groups = "drop")
phys_share <- mean(vapply(passerines, function(sp) auto_shares(sp)[["phys"]], numeric(1)))
hihi_len <- read_csv("data/genomic_parameters_summary.csv", show_col_types = FALSE) %>%
  filter(Species == "notiomystis_cincta")
hihi <- bind_rows(lapply(c("HT", "HK"), function(cd) {
  Lc <- pops$L_coding_bp[pops$code == cd]
  tibble(code = cd, genome_sp = "notiomystis_cincta", accession = hihi_len$Source_GCF,
         NCBI_Chromosome = NA_character_, SeqID = NA_character_, is_autosome = TRUE,
         level = "autosomes_proxy",
         L_cds = Lc, L_utr = Lc * mean(pas$utr), L_ncrna = Lc * mean(pas$nc),
         L_annot = Lc * (1 + mean(pas$utr) + mean(pas$nc)),
         L_phys = hihi_len$Genome_Length_bp * phys_share,
         L_cds_stranded = NA_real_, L_coding_bp_current = Lc,
         Physical_Length_bp_current = NA_real_) %>%
    mutate(L_other = L_phys - L_annot)
}))

out <- bind_rows(chrom_rows %>% filter(is_autosome), hyena, hihi) %>%
  select(code, genome_sp, accession, level, NCBI_Chromosome, SeqID,
         L_cds, L_utr, L_ncrna, L_annot, L_other, L_phys,
         L_cds_stranded, L_coding_bp_current, Physical_Length_bp_current)
stopifnot(all(out$L_other > 0), all(out$L_utr >= 0), all(out$L_ncrna >= 0))
write_csv(out, "data/functional_target_lengths.csv")
message("Wrote data/functional_target_lengths.csv: ", nrow(out), " rows, ",
        n_distinct(out$code), " populations")

# --- report -------------------------------------------------------------------
chk <- out %>% filter(level == "chromosome")
cat("\nCDS agreement with chromosomes.csv L_coding_bp (autosomes, per chromosome):\n")
print(as.data.frame(chk %>% group_by(genome_sp) %>% distinct(NCBI_Chromosome, .keep_all = TRUE) %>%
  summarise(n = n(), max_abs_diff_unstranded = max(abs(L_cds - L_coding_bp_current)),
            max_abs_diff_stranded = max(abs(L_cds_stranded - L_coding_bp_current)),
            total_rel_diff = sum(L_cds) / sum(L_coding_bp_current) - 1,
            max_len_diff = max(abs(L_phys - Physical_Length_bp_current)), .groups = "drop")))
cat("\nHyena: autosomal CDS ", round(hy_cds), " vs populations.csv ",
    round(pops$L_coding_bp[pops$code == "NH"]), "; meerkat shares:\n", sep = "")
print(round(sh_mk, 4))
cat("Hihi proxy: passerine UTR/CDS", round(mean(pas$utr), 3), "ncRNA/CDS", round(mean(pas$nc), 3),
    "autosomal physical share", round(phys_share, 4), "\n")
cat("\nAutosomal totals per species (Mb):\n")
print(as.data.frame(out %>% distinct(genome_sp, NCBI_Chromosome, level, .keep_all = TRUE) %>%
  group_by(genome_sp, level) %>%
  summarise(across(c(L_cds, L_utr, L_ncrna, L_annot, L_other, L_phys), ~ round(sum(.x) / 1e6, 1)),
            .groups = "drop") %>%
  mutate(annot_over_cds = round(L_annot / L_cds, 2))))
