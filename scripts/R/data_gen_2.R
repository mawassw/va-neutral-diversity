# ==============================================================================
# 0. DEPENDENCIES
# ==============================================================================
if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!require("rtracklayer", quietly = TRUE)) BiocManager::install("rtracklayer")
if (!require("GenomicRanges", quietly = TRUE)) BiocManager::install("GenomicRanges")
if (!require("tidyverse", quietly = TRUE)) install.packages("tidyverse")

library(tidyverse)
library(rtracklayer)
library(GenomicRanges)

# ==============================================================================
# 1. SETUP PATHS
# ==============================================================================
root_dir <- "G:/My Drive/Chicago_project/Chicago_project#3/genomic_data"

# GUARD (CLAUDE.md Rule 3): root_dir above is a stale absolute path from an
# earlier checkout location. Stop loudly rather than silently mapping over an
# empty species list and writing a 0-row clean_chromosome_data.csv.
if (!dir.exists(root_dir)) {
  stop("data_gen_2.R: root_dir does not exist:\n  ", root_dir,
       "\nFix it to this checkout's genomic_data/ before running.",
       call. = FALSE)
}

species_dirs <- list.dirs(root_dir, recursive = FALSE)

# ==============================================================================
# 2. THE EXTRACTION FUNCTION
# ==============================================================================
process_chromosomes <- function(species_path) {
  
  species_name <- basename(species_path)
  message(paste("\nProcessing:", species_name))
  
  # --- A. Explicitly Locate the TSV and GTF Files ---
  data_path <- file.path(species_path, "ncbi_dataset", "data")
  tsv_file <- file.path(data_path, "sequence_report.tsv")
  
  if(!file.exists(tsv_file)) {
    message("  -> ERROR: Missing sequence_report.tsv file.")
    return(NULL)
  }
  
  gcf_folders <- list.dirs(data_path, recursive = FALSE)
  gcf_folder <- gcf_folders[grepl("GCF_|GCA_", basename(gcf_folders))]
  
  if(length(gcf_folder) == 0) {
    message("  -> ERROR: Missing GCF/GCA folder.")
    return(NULL)
  }
  gcf_folder <- gcf_folder[1] 
  
  anno_file <- list.files(gcf_folder, pattern = "\\.(gtf|gff|gff3)$", full.names = TRUE)[1]
  if(is.na(anno_file)) {
    message("  -> ERROR: Missing .gtf/.gff file.")
    return(NULL)
  }
  
  # --- B. Parse the TSV Sequence Report ---
  seq_report_raw <- read_tsv(tsv_file, show_col_types = FALSE) %>%
    rename_with(~ tolower(gsub(" ", "_", .x)))
  
  chr_col <- intersect(c("chromosome_name", "assigned_molecule"), names(seq_report_raw))[1]
  role_col <- intersect(c("role", "sequence_role"), names(seq_report_raw))[1]
  refseq_col <- if("refseq_seq_accession" %in% names(seq_report_raw)) "refseq_seq_accession" else NULL
  genbank_col <- if("genbank_seq_accession" %in% names(seq_report_raw)) "genbank_seq_accession" else NULL
  
  seq_report <- seq_report_raw %>%
    select(
      any_of(c(refseq_col, genbank_col)),
      Chr_Name = all_of(chr_col),
      Role = all_of(role_col)
    )
  
  has_chromosomes <- any(seq_report$Role == "assembled-molecule", na.rm = TRUE)
  
  # --- C. Import Annotation (GTF/GFF) ---
  gr <- tryCatch({ import(anno_file) }, error = function(e) NULL)
  if(is.null(gr)) {
    message("  -> ERROR: Failed to import annotation file (corrupted or memory limit).")
    return(NULL)
  }
  
  # --- D. Calculate Physical Lengths ---
  max_coords <- tapply(end(gr), seqnames(gr), max, na.rm = TRUE)
  chrom_df <- data.frame(
    SeqID = names(max_coords),
    Physical_Length_bp = as.numeric(max_coords),
    stringsAsFactors = FALSE
  )
  
  # --- E. Calculate Coding Target Size ---
  cds_gr <- gr[gr$type == "CDS"]
  if(length(cds_gr) > 0) {
    cds_by_seq <- split(cds_gr, seqnames(cds_gr))
    reduced_cds <- GenomicRanges::reduce(cds_by_seq)
    l_coding_df <- data.frame(
      SeqID = names(reduced_cds),
      L_coding_bp = sapply(width(reduced_cds), sum),
      stringsAsFactors = FALSE
    )
  } else {
    l_coding_df <- data.frame(SeqID = character(), L_coding_bp = numeric())
  }
  
  # --- F. Calculate Gene Count ---
  if ("gene" %in% unique(gr$type)) {
    genes_gr <- gr[gr$type == "gene"]
    gene_counts <- table(seqnames(genes_gr))
  } else if ("gene_id" %in% names(mcols(gr))) {
    genes_gr <- gr[!duplicated(gr$gene_id)]
    gene_counts <- table(seqnames(genes_gr))
  } else {
    gene_counts <- c()
  }
  gene_df <- data.frame(
    SeqID = names(gene_counts),
    Gene_Count = as.numeric(gene_counts),
    stringsAsFactors = FALSE
  )
  
  # --- G. MERGE AND APPLY SMART JOIN LOGIC ---
  merged_stats <- chrom_df %>%
    left_join(l_coding_df, by = "SeqID") %>%
    left_join(gene_df, by = "SeqID") %>%
    mutate(
      L_coding_bp = replace_na(L_coding_bp, 0),
      Gene_Count = replace_na(Gene_Count, 0),
      Coding_Density = L_coding_bp / Physical_Length_bp
    )
  
  gtf_ids <- unique(merged_stats$SeqID)
  join_by_vec <- NULL
  
  if (!is.null(refseq_col) && any(gtf_ids %in% seq_report[[refseq_col]])) {
    join_by_vec <- setNames(refseq_col, "SeqID")
  } else if (!is.null(genbank_col) && any(gtf_ids %in% seq_report[[genbank_col]])) {
    join_by_vec <- setNames(genbank_col, "SeqID")
  }
  
  if (has_chromosomes && !is.null(join_by_vec)) {
    final_stats <- merged_stats %>%
      inner_join(seq_report, by = join_by_vec) %>%
      filter(Role == "assembled-molecule") %>%
      filter(!Chr_Name %in% c("MT", "Un", "Pltd", NA)) %>%
      mutate(
        NCBI_Chromosome = as.character(Chr_Name),
        Assembly_Level = "Chromosome"
      ) %>%
      select(-Chr_Name, -Role) %>%
      arrange(suppressWarnings(as.numeric(NCBI_Chromosome)))
    
  } else {
    if(has_chromosomes && is.null(join_by_vec)) {
      message("  -> WARNING: GTF IDs do not match TSV IDs. Falling back to Scaffolds.")
    } else {
      message("  -> No assembled chromosomes found. Falling back to largest coding scaffolds.")
    }
    
    final_stats <- merged_stats %>%
      filter(L_coding_bp > 0) %>% 
      arrange(desc(Physical_Length_bp)) %>%
      mutate(
        NCBI_Chromosome = as.character(row_number()), 
        Assembly_Level = "Scaffold"
      )
  }
  
  if (nrow(final_stats) == 0) {
    message("  -> ERROR: Final dataset has 0 rows after filtering.")
    return(NULL)
  }
  
  message(paste("  -> Successfully extracted", nrow(final_stats), "sequences."))
  
  # Memory flush to prevent GRanges from crashing the loop
  rm(gr, cds_gr, reduced_cds, genes_gr)
  gc()
  
  return(final_stats %>%
           mutate(Species = species_name) %>%
           select(Species, NCBI_Chromosome, SeqID, Physical_Length_bp, L_coding_bp, Gene_Count, Coding_Density, Assembly_Level))
}

# ==============================================================================
# 3. EXTRACTION EXECUTION
# ==============================================================================
all_chrom_results <- purrr::map_dfr(species_dirs, process_chromosomes)

# Save intermediate raw assembly output
write_csv(all_chrom_results, file.path(root_dir, "clean_chromosome_data.csv"))
message("\nRaw assembly extraction complete.")

# ==============================================================================
# 4. FILTERING & RECOMBINATION MERGE
# ==============================================================================
# Load recombination data
recomb_df <- read_csv("recomb_data.csv", show_col_types = FALSE)

# Clean Assembly Data (Drop MT and specific species)
chrom_clean <- all_chrom_results %>%
  mutate(NCBI_Chromosome = as.character(NCBI_Chromosome)) %>%
  filter(Species != "notiomystis_cincta") %>%
  filter(!toupper(NCBI_Chromosome) %in% c("MT", "M", "MITO")) 

# Clean Recombination Data
recomb_clean <- recomb_df %>%
  mutate(NCBI_Chromosome = as.character(NCBI_Chromosome)) %>%
  filter(!toupper(NCBI_Chromosome) %in% c("MT", "M", "MITO"))

# Diagnostics: Identify what is about to be dropped due to missing linkage maps
missing_maps <- chrom_clean %>%
  anti_join(recomb_clean, by = c("Species" = "Species_code", "NCBI_Chromosome")) %>%
  distinct(Species)
message("\nNote: The following species from the assembly pull will be dropped because they lack linkage maps:")
print(missing_maps$Species)

# Execute the final strict Inner Join
# This strictly enforces that only chromosomes with BOTH physical lengths and cM maps survive
master_linked_data <- recomb_clean %>%
  inner_join(chrom_clean, 
             by = c("Species_code" = "Species", "NCBI_Chromosome" = "NCBI_Chromosome")) %>%
  mutate(M_morgans = Total_cM / 100) # Convert cM to Morgans for continuous integration

# Sanity Check: Verify the Parus major split (UK/NL) worked correctly
message("\nParus major population split check:")
master_linked_data %>%
  filter(Species_code == "parus_major") %>%
  select(Species, NCBI_Chromosome, Total_cM, Physical_Length_bp, L_coding_bp) %>%
  arrange(NCBI_Chromosome, Species) %>%
  head() %>%
  print()

# Save the final dataset ready for the theoretical model
write_csv(master_linked_data, "master_chromosome_recomb_data.csv")
message(paste("\nPipeline Complete! Final dataset saved to: master_chromosome_recomb_data.csv"))




