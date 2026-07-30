####### Load Libraries ########
library(ggplot2)
library(dplyr)
library(tidyr)
library(bayesplot)
library(readr)
library(patchwork)

####### GUARD (CLAUDE.md Rule 1): requires unlinked.R to have been sourced ####
# This script uses df_va (built in unlinked.R from alldistzip) and
# posterior.mode()/as.mcmc() from MCMCglmm/coda, which it never libraries
# itself. Without unlinked.R first, it either errors deep inside a loop or —
# worse, with RestoreWorkspace: Default — silently reuses a stale df_va from
# .RData and produces wrong numbers.
if (!exists("df_va")) {
  stop("data_gen.R: df_va not found. Source scripts/R/unlinked.R first ",
       "(it builds df_va and loads MCMCglmm/coda).", call. = FALSE)
}
if (!all(sapply(c("posterior.mode", "as.mcmc"), exists))) {
  stop("data_gen.R: posterior.mode()/as.mcmc() unavailable. Source ",
       "scripts/R/unlinked.R first (it loads MCMCglmm/coda).", call. = FALSE)
}

####### Define Publication Theme ########
theme_Publication <- function(base_size=14, base_family="serif") {
  theme_classic(base_size=base_size, base_family=base_family) +
    theme(
      axis.title = element_text(face = "bold", size = rel(1.05)),
      axis.text = element_text(size = rel(0.95)),
      axis.line = element_line(colour="black", linewidth = 0.8),
      axis.ticks = element_line(colour="black", linewidth = 0.8),
      legend.position = "right",
      legend.title = element_text(face = "bold"),
      strip.background = element_rect(fill="gray90", colour="black", linewidth=0.8),
      strip.text = element_text(face="bold", size=rel(1)),
      plot.margin = unit(c(5,5,5,5),"mm")
    )
}

####### Mathematical Integration Functions ########
# 1. Integrand for the average chromosome constraint over distance 'd'
integrand_avg_Q2 <- function(d, M, Z) {
  denom <- 1 - (Z / 2) * (1 + exp(-2 * d))
  return((M - d) / denom^2)
}

# 2. Calculate the exact chromosome-averaged cumulative constraint (Haldane map)
calc_avg_Q2_haldane <- function(M, Z) {
  if (M < 1e-6) return(1 / (1 - Z)^2)
  # Cap Z at 0.995 to prevent the integration singularity at perfect MSB
  Z_safe <- min(Z, 0.995) 
  res <- integrate(integrand_avg_Q2, lower = 0, upper = M, M = M, Z = Z_safe, rel.tol = 1e-8)$value
  return((2 / M^2) * res)
}
calc_avg_Q2_vec <- Vectorize(calc_avg_Q2_haldane, vectorize.args = c("M", "Z"))

# 3. Mating System Scalar (Model A: BV-Independent EPP)
calc_kappa <- function(alpha) {
  return(1 + (1 - alpha)^2)
}

####### 1. Data Preparation ########
load("alldistzip")
epp_data <- read.csv("data/species_EPP.csv", stringsAsFactors = FALSE, header = T)
chrom_data <- read_csv("data/master_chromosome_recomb_data.csv") %>%
  mutate(NCBI_Chromosome = as.character(NCBI_Chromosome)) %>%
  filter(!toupper(NCBI_Chromosome) %in% c("X", "Y", "Z", "W")) # Isolate autosomes

valid_codes <- intersect(names(df_va), epp_data$Code)
valid_codes <- intersect(valid_codes, unique(chrom_data$Code))

####### 2. Build the Genomic Architecture Map ########
arch_map <- chrom_data %>%
  filter(Code %in% valid_codes) %>%
  group_by(Code) %>%
  mutate(
    L_total = sum(Physical_Length_bp),
    L_coding_total = sum(L_coding_bp),
    # f_i: fraction of total functional sequence on chromosome i
    f_i = L_coding_bp / L_coding_total,      
    # L_weight: fraction of total physical length on chromosome i
    L_weight = Physical_Length_bp / L_total  
  ) %>%
  ungroup() %>%
  left_join(epp_data %>% select(Code, Ud, EPP, Species,
                                mu_1, X95ci_lower_1, X95ci_upper_1), by = "Code")

####### 3. Chromosome-Level Architecture Penalty (Mean Va) ########
# Define a biologically plausible grid for the mean heterozygous selection coefficient
# 0.005 (Weak coding selection) to 0.02 (Strong coding selection)
s_het_grid <- c(0.005, 0.01, 0.02)

chromosome_results <- data.frame()

for(sp_code in valid_codes) {
  sp_arch <- arch_map %>% filter(Code == sp_code)
  
  # Using posterior mode as requested
  mode_Va <- posterior.mode(as.mcmc(df_va[[sp_code]]))
  
  kappa_val <- calc_kappa(sp_arch$EPP[1])
  Ud_val <- sp_arch$Ud[1]
  
  # Loop through the selection coefficient grid
  for(s_val in s_het_grid) {
    
    # Calculate genome-wide Z under MSB for this specific s_het
    Vm <- Ud_val * s_val^2
    Z_val <- pmax(0, 1 - (Vm / mode_Va))
    
    for(i in 1:nrow(sp_arch)) {
      # BIOLOGICAL FILTER: Apply the 20 Mb empirical lower bound
      if(sp_arch$Physical_Length_bp[i] < 20e6) next
      
      v_i <- mode_Va * sp_arch$f_i[i]
      M_i <- sp_arch$M_morgans[i]
      
      Q2_bar <- calc_avg_Q2_vec(M_i, Z_val)
      
      # The pure linked penalty exponential
      linked_exp <- exp(-kappa_val * (v_i / 2) * Q2_bar)
      
      # Total Ne/N for this specific chromosome
      chrom_Ne_N <- linked_exp / (1 + 4 * kappa_val * (mode_Va - (v_i / 2)))
      
      # Global unlinked baseline Ne/N
      unlinked_Ne_N <- 1 / (1 + 4 * kappa_val * mode_Va)
      
      # Relative Linkage Penalty (Omega_i)
      Omega_i <- chrom_Ne_N / unlinked_Ne_N
      
      chromosome_results <- rbind(chromosome_results, data.frame(
        Code = sp_code,
        Species = sp_arch$Species.y[i],
        Chromosome = sp_arch$NCBI_Chromosome[i],
        Map_Length_Morgans = M_i,
        Functional_Fraction = sp_arch$f_i[i],
        Mean_Va = mode_Va,
        s_het = s_val, # Track the selection coefficient
        Omega_i = Omega_i
      ))
    }
  }
}

# Create clean facet labels for the plot
chromosome_results <- chromosome_results %>%
  mutate(s_het_label = factor(s_het, levels = s_het_grid, 
                              labels = paste0("Mean s_het = ", s_het_grid)))

####### Plot: Omega_i vs Map Length (Faceted by s_het) ########
tiff("Empirical_Macrochromosome_Penalty_Omega_Faceted.tiff", units="in", width=12, height=5, res=300)

p_omega <- ggplot(chromosome_results, aes(x = Map_Length_Morgans, y = Omega_i)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "black", linewidth = 1) +
  
  # The empirical points
  geom_point(aes(fill = Mean_Va, size = Functional_Fraction), shape = 21, color = "white", alpha = 0.8) +
  
  # Facet by the selection coefficient
  facet_wrap(~ s_het_label, ncol = 3) +
  
  scale_fill_viridis_c(option = "magma", direction = -1, name = expression(bolditalic(V[A]))) +
  scale_size_continuous(range = c(2, 8), name = expression("Functional Fraction (" * f[i] * ")")) +
  
  labs(
    x = "Chromosome Map Length, M (Morgans)",
    y = expression(bold("Relative Linkage Penalty, ") * bolditalic(Omega[i]))
  ) +
  
  coord_cartesian(ylim = c(0, 1.05)) +scale_x_log10()+
  theme_Publication() +
  
  # VISUAL FIX: Override the size legend aesthetics
  guides(
    size = guide_legend(override.aes = list(fill = "gray50", color = "black", alpha = 1)),
    fill = guide_colorbar(order = 1)
  ) +
  theme(legend.position = "bottom")

print(p_omega)
dev.off()


####### Chromosome-Level Penalty: The Functional Target (CNE) Sweep ########
# Lock the selection coefficient to a standard empirical expectation
s_het <- 0.01

# Define the Avian species list for taxonomic averages
avian_species <- c("Cyanistes caeruleus", "Ficedula albicollis", "Malurus cyaneus", 
                   "Melospiza melodia", "Notiomystis cincta", "Parus major", "Parus major (UK)", "Parus major (NL)")

# Define the CNE regimes
cne_regimes <- c("Strict Coding (1x)", "Taxonomic Average (2x/4x)", "Maximum Target (5x)")

chromosome_results_cne <- data.frame()

for(sp_code in valid_codes) {
  sp_arch <- arch_map %>% filter(Code == sp_code)
  
  # Skip species if we do not have a point mutation rate (mu_1) for them
  if(is.na(sp_arch$mu_1[1])) next
  
  mode_Va <- posterior.mode(as.mcmc(df_va[[sp_code]]))
  kappa_val <- calc_kappa(sp_arch$EPP[1])
  
  # Identify taxonomy for the middle regime
  taxon_mult <- ifelse(sp_arch$Species.y[1] %in% avian_species, 2.0, 4.0)
  
  # Define the specific multipliers for the three loops
  multipliers <- c(1.0, taxon_mult, 5.0)
  
  for(regime_idx in 1:3) {
    current_cne <- multipliers[regime_idx]
    current_label <- cne_regimes[regime_idx]
    
    # Manually build Vm using the mean point mutation rate (mu_1)
    # Vm = U_d * s^2 = (2 * mu * L_functional) * s^2
    L_functional <- sp_arch$L_coding_total[1] * current_cne
    Ud_calc <- 2 * sp_arch$mu_1[1] * L_functional
    Vm <- Ud_calc * s_het^2
    
    Z_val <- pmax(0, 1 - (Vm / mode_Va))
    
    for(i in 1:nrow(sp_arch)) {
      # BIOLOGICAL FILTER: Macrochromosomes only
      if(sp_arch$Physical_Length_bp[i] < 20e6) next
      
      # The variance allocated to this chromosome
      v_i <- mode_Va * sp_arch$f_i[i]
      M_i <- sp_arch$M_morgans[i]
      
      Q2_bar <- calc_avg_Q2_vec(M_i, Z_val)
      
      linked_exp <- exp(-kappa_val * (v_i / 2) * Q2_bar)
      chrom_Ne_N <- linked_exp / (1 + 4 * kappa_val * (mode_Va - (v_i / 2)))
      unlinked_Ne_N <- 1 / (1 + 4 * kappa_val * mode_Va)
      
      Omega_i <- chrom_Ne_N / unlinked_Ne_N
      
      chromosome_results_cne <- rbind(chromosome_results_cne, data.frame(
        Code = sp_code,
        Species = sp_arch$Species.y[i],
        Chromosome = sp_arch$NCBI_Chromosome[i],
        Map_Length_Morgans = M_i,
        Functional_Fraction = sp_arch$f_i[i],
        Mean_Va = mode_Va,
        CNE_Regime = current_label,
        Omega_i = Omega_i
      ))
    }
  }
}

# Lock factor levels for plotting order
chromosome_results_cne$CNE_Regime <- factor(chromosome_results_cne$CNE_Regime, levels = cne_regimes)

####### Plot: Omega_i vs Map Length (Faceted by CNE Target Size) ########
tiff("Empirical_Macrochromosome_Penalty_Omega_CNE_Sweep.tiff", units="in", width=12, height=5, res=300)

p_omega_cne <- ggplot(chromosome_results_cne, aes(x = Map_Length_Morgans, y = Omega_i)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "black", linewidth = 1) +
  
  geom_point(aes(fill = Mean_Va, size = Functional_Fraction), shape = 21, color = "white", alpha = 0.8) +
  
  # Facet by the CNE Multiplier
  facet_wrap(~ CNE_Regime, ncol = 3) +
  
  scale_fill_viridis_c(option = "magma", direction = -1, name = expression(bolditalic(V[A]))) +
  scale_size_continuous(range = c(2, 8), name = expression("Functional Fraction (" * f[i] * ")")) +
  
  labs(
    x = "Chromosome Map Length, M (Morgans)",
    y = expression(bold("Relative Linkage Penalty, ") * bolditalic(Omega[i]))
  ) +
  
  coord_cartesian(ylim = c(0, 1.05)) +scale_x_log10()+
  theme_Publication() +
  
  guides(
    size = guide_legend(override.aes = list(fill = "gray50", color = "black", alpha = 1)),
    fill = guide_colorbar(order = 1)
  ) +
  theme(legend.position = "bottom")

print(p_omega_cne)
dev.off()












####### 1. Setup and Taxonomic Derivation ########
avian_species <- c("Cyanistes caeruleus", "Ficedula albicollis", "Malurus cyaneus", 
                   "Melospiza melodia", "Notiomystis cincta", "Parus major", "Parus major (UK)", "Parus major (NL)")

arch_map <- chrom_data %>%
  filter(Code %in% valid_codes) %>%
  group_by(Code) %>%
  mutate(
    L_total = sum(Physical_Length_bp),
    L_coding_total = sum(L_coding_bp),
    f_i = L_coding_bp / L_coding_total,      
    L_weight = Physical_Length_bp / L_total  
  ) %>%
  ungroup() %>%
  left_join(epp_data %>% select(Code, Ud, EPP, Species, mu_1,Scientific.name), by = "Code") %>%
  mutate(
    Taxon = ifelse(Scientific.name %in% avian_species, "Bird", "Mammal"),
    Taxonomic_Multiplier = ifelse(Taxon == "Bird", 2.0, 4.0),
    # First-Principles Derivation of Ud
    Ud_Derived = 2 * mu_1 * (L_coding_total * Taxonomic_Multiplier)
  )

####### 2. Full Bayesian Posterior Evaluation ########
s_het <- 0.01

calculate_Ne_N_shift <- function(sp_code) {
  Va_post <- df_va[[sp_code]]
  n_samples <- length(Va_post)
  sp_arch <- arch_map %>% filter(Code == sp_code)
  
  if(is.na(sp_arch$Ud_Derived[1]) | is.na(sp_arch$Ud[1])) return(NULL)
  
  kappa_val <- calc_kappa(sp_arch$EPP[1])
  
  # The two mutational regimes
  Ud_regimes <- list(
    "Classical Proxy" = sp_arch$Ud[1],
    "Sequence-Derived" = sp_arch$Ud_Derived[1]
  )
  
  results_list <- list()
  
  for(regime_name in names(Ud_regimes)) {
    current_Ud <- Ud_regimes[[regime_name]]
    species_Total_Ne_N <- numeric(n_samples)
    
    for(i in 1:n_samples) {
      Va <- Va_post[i]
      Vm <- current_Ud * s_het^2
      Z <- pmax(0, 1 - (Vm / Va))
      
      v_i <- Va * sp_arch$f_i
      M_i <- sp_arch$M_morgans
      L_weight <- sp_arch$L_weight
      
      Q2_bar <- calc_avg_Q2_vec(M_i, Z)
      
      linked_exp <- exp(-kappa_val * (v_i / 2) * Q2_bar)
      unlinked_denom <- 1 + 4 * kappa_val * (Va - (v_i / 2))
      
      # Total Chromosome-level Ne/N (incorporating both linked and unlinked)
      chrom_Ne_N <- linked_exp / unlinked_denom
      
      # Genome-wide Weighted Expectation
      species_Total_Ne_N[i] <- sum(L_weight * chrom_Ne_N)
    }
    
    results_list[[regime_name]] <- data.frame(
      Species = sp_arch$Species.y[1],
      Ud_Regime = regime_name,
      Total_Ne_N = species_Total_Ne_N
    )
  }
  
  return(do.call(rbind, results_list))
}

df_posterior_shift <- do.call(rbind, lapply(valid_codes, calculate_Ne_N_shift))

####### 3. Data Summarization for Plotting ########

# Summarize the Ne/N Posteriors
df_Ne_N_summary <- df_posterior_shift %>%
  group_by(Species, Ud_Regime) %>%
  summarize(
    Ne_N_mean = mean(Total_Ne_N),
    Ne_N_lower = quantile(Total_Ne_N, 0.025),
    Ne_N_upper = quantile(Total_Ne_N, 0.975),
    .groups = "drop"
  )

# Order species cleanly by their severity under the Derived Ud
ordered_species <- df_Ne_N_summary %>%
  filter(Ud_Regime == "Sequence-Derived") %>%
  arrange(Ne_N_mean) %>%
  pull(Species)

df_Ne_N_summary$Species <- factor(df_Ne_N_summary$Species, levels = ordered_species)

# Prepare the Ud Shift Data (Panel A)
df_Ud_shift <- arch_map %>%
  group_by(Species.y) %>%
  summarize(
    Ud_Lit = first(Ud),
    Ud_Der = first(Ud_Derived),
    .groups = "drop"
  ) %>%
  filter(!is.na(Ud_Lit) & !is.na(Ud_Der)) %>%
  mutate(Species = factor(Species.y, levels = ordered_species)) %>%
  # Determine direction of shift for coloring
  mutate(Shift_Direction = ifelse(Ud_Der > Ud_Lit, "Increased Ud", "Decreased Ud"))

####### 4. Generate the Two-Panel Figure ########

# Panel A: The Mutational Shift (Dumbbell Plot)
p_Ud <- ggplot(df_Ud_shift) +
  geom_segment(aes(x = Ud_Lit, xend = Ud_Der, y = Species, yend = Species, color = Shift_Direction), 
               linewidth = 1.2, arrow = arrow(length = unit(0.1, "inches"))) +
  geom_point(aes(x = Ud_Lit, y = Species), color = "gray60", size = 3) +
  geom_point(aes(x = Ud_Der, y = Species, color = Shift_Direction), size = 4) +
  scale_x_log10(breaks = c(0.1, 1, 10), labels = c("0.1", "1.0", "10.0")) +
  scale_color_manual(values = c("Increased Ud" = "#009E73", "Decreased Ud" = "#D55E00")) +
  labs(
    title = "A: Genome-Wide Mutational Target Shift",
    x = expression("Diploid Deleterious Mutation Rate, " * U[d] * " (Log Scale)"),
    y = NULL,
    color = "Shift in Genome-wide Mutation Rate:"
  ) +
  theme_Publication() +
  theme(legend.position = "top")

# Panel B: Total Genome-Wide Demographic Collapse
p_Ne <- ggplot(df_Ne_N_summary, aes(y = Species, color = Ud_Regime)) +
  # Critical Viability Thresholds
  geom_vline(xintercept = 0.1, linetype = "dotted", color = "#D55E00", linewidth = 1) + 
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 1) + 
  
  geom_errorbarh(aes(xmin = Ne_N_lower, xmax = Ne_N_upper), height = 0, linewidth = 1, position = position_dodge(width = 0.6)) +
  geom_point(aes(x = Ne_N_mean), size = 3, position = position_dodge(width = 0.6), fill = "white", shape = 21, stroke = 1.5) +
  
  scale_x_log10(breaks = c(0.01, 0.05, 0.1, 0.5, 1.0), labels = c("0.01", "0.05", "0.1", "0.5", "1.0")) +
  scale_color_manual(values = c("Classical Proxy" = "gray60", "Sequence-Derived" = "#0072B2")) +
  labs(
    title = "B: Posterior Total Expected Reduction in Diversity",
    x = expression("Total Expected " * N[e] * "/N Ratio (Log Scale)"), 
    y = NULL,
    color = "Mutational Regime:"
  ) + 
  coord_cartesian(xlim = c(0.005, 1.05)) +
  theme_Publication() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(), legend.position = "top")

####### Combine and Save ########
tiff("MainFig_Ud_Derivation_and_Total_Collapse.tiff", units="in", width=14, height=7, res=300)
main_fig_final <- p_Ud + p_Ne + plot_layout(widths = c(1, 1.2))
print(main_fig_final)
dev.off()











####### 1. Setup Architecture ########
arch_map <- chrom_data %>%
  filter(Code %in% valid_codes) %>%
  group_by(Code) %>%
  mutate(
    L_total = sum(Physical_Length_bp),
    L_coding_total = sum(L_coding_bp),
    f_i = L_coding_bp / L_coding_total,      
    L_weight = Physical_Length_bp / L_total  
  ) %>%
  ungroup() %>%
  left_join(epp_data %>% select(Code, Ud, EPP, Species.y), by = "Code")

####### 2. Full Bayesian Posterior Evaluation ########
s_het <- 0.01 # Standard baseline MSB selection coefficient

calculate_deconstruction <- function(sp_code) {
  Va_post <- df_va[[sp_code]]
  n_samples <- length(Va_post)
  sp_arch <- arch_map %>% filter(Code == sp_code)
  
  kappa_val <- calc_kappa(sp_arch$EPP[1])
  Ud_Lit <- sp_arch$Ud[1]
  
  species_Unlinked_Ne_N <- numeric(n_samples)
  species_Total_Ne_N <- numeric(n_samples)
  
  for(i in 1:n_samples) {
    Va <- Va_post[i]
    Vm <- Ud_Lit * s_het^2
    Z <- pmax(0, 1 - (Vm / Va))
    
    # 1. The Global Unlinked Baseline (Infinite Recombination)
    unlinked_baseline <- 1 / (1 + 4 * kappa_val * Va)
    species_Unlinked_Ne_N[i] <- unlinked_baseline
    
    # 2. The Total Linked Expectation
    v_i <- Va * sp_arch$f_i
    M_i <- sp_arch$M_morgans
    L_weight <- sp_arch$L_weight
    
    Q2_bar <- calc_avg_Q2_vec(M_i, Z)
    
    linked_exp <- exp(-kappa_val * (v_i / 2) * Q2_bar)
    unlinked_denom <- 1 + 4 * kappa_val * (Va - (v_i / 2))
    
    chrom_Ne_N <- linked_exp / unlinked_denom
    
    # Genome-wide Weighted Expectation
    species_Total_Ne_N[i] <- sum(L_weight * chrom_Ne_N)
  }
  
  return(data.frame(
    Species = sp_arch$Species.y[1],
    Unlinked_Ne_N = species_Unlinked_Ne_N,
    Total_Ne_N = species_Total_Ne_N
  ))
}

# Run the integration for all species
df_posterior_deconstruction <- do.call(rbind, lapply(valid_codes, calculate_deconstruction))

####### 3. Data Summarization for Plotting ########

df_summary <- df_posterior_deconstruction %>%
  group_by(Species) %>%
  summarize(
    Unlinked_mean = mean(Unlinked_Ne_N),
    Total_mean = mean(Total_Ne_N),
    Total_lower = quantile(Total_Ne_N, 0.025),
    Total_upper = quantile(Total_Ne_N, 0.975),
    .groups = "drop"
  )

# Order species cleanly by their severity under the TOTAL Ne/N ratio
ordered_species <- df_summary %>%
  arrange(Total_mean) %>%
  pull(Species)

df_summary$Species <- factor(df_summary$Species, levels = ordered_species)

# VISUAL FIX: Convert the categorical factor into a numeric proxy. 
# This allows us to manually dodge elements vertically within each species' horizontal track.
df_summary <- df_summary %>%
  mutate(Species_num = as.numeric(Species))

####### 4. Generate the Dodged Deconstruction Plot ########

tiff("MainFig_Demographic_Deconstruction_Dodged.tiff", units="in", width=10, height=8, res=300)

p_main <- ggplot(df_summary) +
  
  # Critical Thresholds
  geom_vline(xintercept = 0.1, linetype = "dotted", color = "#D55E00", linewidth = 1.2) + 
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 1.2) + 
  
  # 1. The Error Bars (Shifted DOWN by 0.2 units)
  geom_errorbar(aes(xmin = Total_lower, xmax = Total_upper, y = Species_num - 0.2), 
                 width = 0, linewidth = 1, color = "#0072B2", orientation="y") +
  
  # 2. The Linkage Penalty Arrow (Diagonal Drop from +0.2 down to -0.2)
  geom_segment(aes(x = Unlinked_mean, xend = Total_mean, 
                   y = Species_num + 0.2, yend = Species_num - 0.2), 
               color = "gray50", linewidth = 1.2, arrow = arrow(length = unit(0.12, "inches"))) +
  
  # 3. Point 1: Unlinked Baseline (Shifted UP by 0.2 units)
  geom_point(aes(x = Unlinked_mean, y = Species_num + 0.2, 
                 fill = "Unlinked Baseline (Independent Assortment)"), 
             shape = 21, color = "black", size = 3.5, stroke = 1.2) +
  
  # 4. Point 2: Total Ne/N (Shifted DOWN by 0.2 units, rendered strictly on top of the arrow tip)
  geom_point(aes(x = Total_mean, y = Species_num - 0.2, 
                 fill = "Total Expectation (Linked + Unlinked)"), 
             shape = 21, color = "black", size = 4, stroke = 1) +
  
  # Aesthetics and Labels
  scale_x_log10(breaks = c(0.01, 0.05, 0.1, 0.5, 1.0), labels = c("0.01", "0.05", "0.1", "0.5", "1.0")) +
  
  # VISUAL FIX: Map the numeric y-axis directly back to the original Species names
  scale_y_continuous(breaks = 1:nlevels(df_summary$Species), labels = levels(df_summary$Species)) +
  
  scale_fill_manual(values = c("Unlinked Baseline (Independent Assortment)" = "white", 
                               "Total Expectation (Linked + Unlinked)" = "#0072B2")) +
  
  labs(
    x = expression("Expected " * N[e] * "/N Ratio (Log Scale)"), 
    y = NULL,
    fill = "Genomic Architecture Component:"
  ) + 
  
  coord_cartesian(xlim = c(0.005, 1.05)) +
  theme_Publication() +
  
  # Annotations placed explicitly on row 2 to ensure they don't clip at the bottom margin
  annotate("text", x = 0.09, y = 2, label = "Viability Threshold (0.1)", color = "#D55E00", angle = 90, size = 4) +
  annotate("text", x = 0.9, y = 2, label = "Neutrality", color = "black", angle = 90, size = 4)

print(p_main)
dev.off()
















####### Capstone Analysis: Sensitivity to Point Mutation Uncertainty ########

# We lock the architecture to the maximum plausible functional target to give the 
# genome the highest possible chance of mutational rescue.
s_het <- 0.01
CNE_Maximum_Rescue <- 5.0

calculate_mu_uncertainty_bounds <- function(sp_code) {
  Va_post <- df_va[[sp_code]]
  n_samples <- length(Va_post)
  sp_arch <- arch_map %>% filter(Code == sp_code)
  
  # Skip species lacking point mutation rate data
  if(is.na(sp_arch$mu_1[1]) | is.na(sp_arch$X95ci_lower_1[1]) | is.na(sp_arch$X95ci_upper_1[1])) {
    return(NULL)
  }
  
  kappa_val <- calc_kappa(sp_arch$EPP[1])
  L_functional <- sp_arch$L_coding_total[1] * CNE_Maximum_Rescue
  
  # Define the three regimes based strictly on point mutation confidence intervals
  Ud_Lower <- 2 * sp_arch$X95ci_lower_1[1] * L_functional
  Ud_Mean  <- 2 * sp_arch$mu_1[1] * L_functional
  Ud_Upper <- 2 * sp_arch$X95ci_upper_1[1] * L_functional
  
  mu_scenarios <- list(
    "Lower 95% CI" = Ud_Lower,
    "Mean Point Mutation Rate" = Ud_Mean,
    "Upper 95% CI" = Ud_Upper
  )
  
  results_list <- list()
  
  for(scenario_name in names(mu_scenarios)) {
    current_Ud <- mu_scenarios[[scenario_name]]
    
    species_Total_Ne_N <- numeric(n_samples)
    species_Global_Omega <- numeric(n_samples)
    
    for(i in 1:n_samples) {
      Va <- Va_post[i]
      Vm <- current_Ud * s_het^2
      Z <- pmax(0, 1 - (Vm / Va))
      
      v_i <- Va * sp_arch$f_i
      M_i <- sp_arch$M_morgans
      L_weight <- sp_arch$L_weight
      
      Q2_bar <- calc_avg_Q2_vec(M_i, Z)
      
      linked_exp <- exp(-kappa_val * (v_i / 2) * Q2_bar)
      unlinked_denom <- 1 + 4 * kappa_val * (Va - (v_i / 2))
      
      chrom_Ne_N <- linked_exp / unlinked_denom
      global_unlinked_Ne_N <- 1 / (1 + 4 * kappa_val * Va)
      chrom_Omega_i <- chrom_Ne_N / global_unlinked_Ne_N
      
      species_Total_Ne_N[i] <- sum(L_weight * chrom_Ne_N)
      species_Global_Omega[i] <- sum(L_weight * chrom_Omega_i)
    }
    
    results_list[[scenario_name]] <- data.frame(
      Species = sp_arch$Species.y[1],
      Mu_Regime = scenario_name,
      Total_Ne_N = species_Total_Ne_N,
      Global_Omega = species_Global_Omega
    )
  }
  
  return(do.call(rbind, results_list))
}

# Run the MCMC integration across the mutation uncertainty regimes
df_mu_bounds <- do.call(rbind, lapply(valid_codes, calculate_mu_uncertainty_bounds))

####### Summarize and Plot the Capstone Figure ########
df_mu_summary <- df_mu_bounds %>%
  group_by(Species, Mu_Regime) %>%
  summarize(
    Ne_N_mean = mean(Total_Ne_N),
    Ne_N_lower = quantile(Total_Ne_N, 0.025),
    Ne_N_upper = quantile(Total_Ne_N, 0.975),
    Omega_mean = mean(Global_Omega),
    Omega_lower = quantile(Global_Omega, 0.025),
    Omega_upper = quantile(Global_Omega, 0.975),
    .groups = "drop"
  )

# Order species by their severity under the Mean Point Mutation Rate
ordered_species_mu <- df_mu_summary %>%
  filter(Mu_Regime == "Mean Point Mutation Rate") %>%
  arrange(Ne_N_mean) %>%
  pull(Species)

df_mu_summary$Species <- factor(df_mu_summary$Species, levels = ordered_species_mu)

# Lock the factor levels for clean chronological plotting
mu_levels <- c(
  "Lower 95% CI",
  "Mean Point Mutation Rate",
  "Upper 95% CI"
)
df_mu_summary$Mu_Regime <- factor(df_mu_summary$Mu_Regime, levels = mu_levels)

####### Panel A: Total Ne/N Ratio Sensitivity ########
p_Ne_N_Mu <- ggplot(df_mu_summary, aes(y = Species, color = Mu_Regime)) +
  geom_vline(xintercept = 0.1, linetype = "dotted", color = "#D55E00", linewidth = 1) + 
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 1) + 
  geom_errorbarh(aes(xmin = Ne_N_lower, xmax = Ne_N_upper), height = 0, linewidth = 0.8, alpha = 0.7, position = position_dodge(width = 0.6)) +
  geom_point(aes(x = Ne_N_mean), size = 2.5, position = position_dodge(width = 0.6)) +
  scale_x_log10(breaks = c(0.01, 0.05, 0.1, 0.5, 1.0), labels = c("0.01", "0.05", "0.1", "0.5", "1.0")) +
  scale_color_manual(values = c("#D55E00", "gray40", "#0072B2")) +
  labs(
    title = "A: Sensitivity to Point Mutation Uncertainty",
    x = expression("Expected Total " * N[e] * "/N Ratio (Log Scale)"), 
    y = NULL,
    color = expression("Point Mutation Estimate (" * mu * "):")
  ) + 
  theme_Publication() +
  theme(legend.position = "top", legend.direction = "horizontal")

####### Panel B: Global Linkage Penalty Sensitivity ########
p_Omega_Mu <- ggplot(df_mu_summary, aes(y = Species, color = Mu_Regime)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 1) + 
  geom_errorbarh(aes(xmin = Omega_lower, xmax = Omega_upper), height = 0, linewidth = 0.8, alpha = 0.7, position = position_dodge(width = 0.6)) +
  geom_point(aes(x = Omega_mean), size = 2.5, position = position_dodge(width = 0.6)) +
  scale_color_manual(values = c("#D55E00", "gray40", "#0072B2")) +
  labs(
    title = "B: Global Linkage Penalty Uncertainty",
    x = expression("Global Linkage Penalty (" * bar(Omega) * ")"), 
    y = NULL,
    color = expression("Point Mutation Estimate (" * mu * "):")
  ) + 
  coord_cartesian(xlim = c(0, 1.05)) +
  theme_Publication() +
  theme(legend.position = "none", 
        axis.text.y = element_blank(), axis.ticks.y = element_blank()) 

####### Combine and Save ########
tiff("MainFig_Empirical_Sensitivity_MutationRate.tiff", units="in", width=14, height=8, res=300)
main_fig_mu <- p_Ne_N_Mu + p_Omega_Mu + plot_layout(widths = c(1.3, 1))
print(main_fig_mu)
dev.off()









####### 1. Generate the Theoretical Boundaries ########
# Delta is the critical Ne/N fraction
delta_seq <- seq(0.01, 1.0, length.out = 300)

df_bounds <- data.frame(
  Delta = rep(delta_seq, 2),
  # Kappa = 1 (Random Mating), Kappa = 2 (Strict Monogamy)
  Kappa = rep(c("Random Mating (κ = 1)", "Obligate Monogamy (κ = 2)"), each = length(delta_seq)),
  Kappa_val = rep(c(1, 2), each = length(delta_seq))
) %>%
  mutate(
    # The Equation: V_{A,max} = (1 - \delta) / (4 * \kappa * \delta)
    Va_max = (1 - Delta) / (4 * Kappa_val * Delta)
  )

####### 2. Extract Empirical Va Distributions ########
# We extract the posterior Va samples to plot them as density strips on the y-axis
empirical_va_long <- df_va %>%
  select(all_of(valid_codes)) %>%
  pivot_longer(cols = everything(), names_to = "Code", values_to = "Va") %>%
  left_join(epp_data %>% select(Code, Species), by = "Code")

####### 3. Generate the V_A,max Plot ########
tiff("MainFig_Va_Max_Boundary.tiff", units="in", width=9, height=6, res=300)

p_vamax <- ggplot() +
  # 1. Shade the "Impossible" Zone (Above the Random Mating bound)
  geom_ribbon(data = df_bounds %>% filter(Kappa_val == 1), 
              aes(x = Delta, ymin = Va_max, ymax = Inf), 
              fill = "gray80", alpha = 0.5) +
  
  # 2. Draw the Theoretical Bounds
  geom_line(data = df_bounds, aes(x = Delta, y = Va_max, color = Kappa, linetype = Kappa), linewidth = 1.2) +
  
  # 3. Add the Empirical Va Distributions as a Rug/Density on the Y-axis
  # Placed at x = 0 to show the raw magnitude of the estimates
  geom_point(data = empirical_va_long, aes(x = 0.005, y = Va), 
             color = "#D55E00", alpha = 0.01, size = 1, shape = 16, 
             position = position_jitter(width = 0.002)) +
  
  # Aesthetics
  scale_color_manual(values = c("black", "gray40")) +
  scale_linetype_manual(values = c("dashed", "solid")) +
  
  # Lock the y-axis to the biological range of the empirical estimates (0 to ~0.5)
  coord_cartesian(ylim = c(0, 0.4), xlim = c(0, 1.0), expand = FALSE) +
  
  labs(
    x = expression("Minimum Acceptable Neutral Diversity Fraction, " * delta * " (" * N[e]/N * ")"),
    y = expression("Maximum Sustainable Variance (" * V[A * ",max"] * ")"),
    color = "Mating System Boundary:",
    linetype = "Mating System Boundary:"
  ) +
  
  theme_Publication() +
  
  # Annotations
  annotate("text", x = 0.5, y = 0.25, label = "Theoretically Impossible Zone\n(Extinction or Assumptional Failure)", 
           color = "red4", fontface = "bold", size = 5, hjust = 0.5) +
  annotate("text", x = 0.03, y = 0.35, label = "Empirical\nEstimates", 
           color = "#D55E00", fontface = "bold", size = 4, hjust = 0)

print(p_vamax)
dev.off()







####### Variance Allocation Sensitivity Analysis ########
# Select a representative species with high variance and clear macrochromosomes
# (Replace "RD" with whatever your focal species code is)
focal_code <- "RD" 

# Filter data and calculate the three competing f_i assumptions
alloc_check <- chrom_data %>%
  filter(Code == focal_code & Physical_Length_bp >= 20e6) %>% # Macrochromosomes only
  mutate(
    # Total targets for the species
    Sum_Physical = sum(Physical_Length_bp),
    Sum_Coding = sum(L_coding_bp),
    Sum_Genes = sum(Gene_Count), # Assuming your master data has this column
    
    # 1. Physical Null Model
    f_Physical = Physical_Length_bp / Sum_Physical,
    
    # 2. Continuous Target Model (Your Baseline)
    f_Coding = L_coding_bp / Sum_Coding,
    
    # 3. Discrete Target Model
    f_Gene = Gene_Count / Sum_Genes
  )

# Calculate Omega_i under all three regimes
mean_Va <- posterior.mode(as.mcmc(df_va[[focal_code]]))
sp_EPP <- epp_data$EPP[epp_data$Code == focal_code]
kappa_val <- 1 + (1 - sp_EPP)^2
Ud_val <- epp_data$Ud[epp_data$Code == focal_code]
Vm <- Ud_val * 0.01^2
Z_val <- pmax(0, 1 - (Vm / mean_Va))

# Function to calculate Omega for a specific f_i regime
calc_regime_Omega <- function(f_vector, M_vector) {
  v_vector <- mean_Va * f_vector
  Q2_vector <- calc_avg_Q2_vec(M_vector, Z_val)
  linked_exp <- exp(-kappa_val * (v_vector / 2) * Q2_vector)
  chrom_Ne_N <- linked_exp / (1 + 4 * kappa_val * (mean_Va - (v_vector / 2)))
  unlinked_Ne_N <- 1 / (1 + 4 * kappa_val * mean_Va)
  return(chrom_Ne_N / unlinked_Ne_N)
}

# Apply the function to the three regimes
alloc_check <- alloc_check %>%
  mutate(
    Omega_Physical = calc_regime_Omega(f_Physical, M_morgans),
    Omega_Coding = calc_regime_Omega(f_Coding, M_morgans),
    Omega_Gene = calc_regime_Omega(f_Gene, M_morgans)
  )

####### Reshape and Plot ########
df_plot_alloc <- alloc_check %>%
  select(NCBI_Chromosome, Physical_Length_bp, Omega_Physical, Omega_Coding, Omega_Gene) %>%
  pivot_longer(
    cols = starts_with("Omega_"),
    names_to = "Allocation_Model",
    values_to = "Omega_i"
  ) %>%
  mutate(
    Allocation_Model = case_when(
      Allocation_Model == "Omega_Physical" ~ "Null Model (Physical Length)",
      Allocation_Model == "Omega_Coding" ~ "Continuous Target (Coding bp)",
      Allocation_Model == "Omega_Gene" ~ "Discrete Target (Gene Count)"
    ),
    # Order chromosomes by physical length for a logical x-axis
    NCBI_Chromosome = reorder(NCBI_Chromosome, -Physical_Length_bp)
  )

tiff("SuppFig_Variance_Allocation_Robustness.tiff", units="in", width=10, height=6, res=300)

p_alloc <- ggplot(df_plot_alloc, aes(x = NCBI_Chromosome, y = Omega_i, color = Allocation_Model, group = Allocation_Model)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "black", linewidth = 1) +
  geom_line(linewidth = 1, alpha = 0.6) +
  geom_point(size = 3, alpha = 0.9) +
  scale_color_manual(values = c("Null Model (Physical Length)" = "gray50", 
                                "Continuous Target (Coding bp)" = "#D55E00", 
                                "Discrete Target (Gene Count)" = "#0072B2")) +
  labs(
    title = paste("Sensitivity to Variance Allocation Architecture (", focal_code, ")"),
    x = "Macrochromosomes (Largest to Smallest)",
    y = expression(bold("Relative Linkage Penalty, ") * bolditalic(Omega[i])),
    color = "Variance Proxy:"
  ) +
  theme_Publication() +
  coord_cartesian(ylim = c(0, 1.05))

print(p_alloc)
dev.off()
