####### Load Libraries ########
library(ggplot2)
library(MCMCglmm)
library(bayesplot)
library(readxl)
library(dplyr)
library(tidyr)
library(bayestestR)
library(dplyr)
library(purrr)
library(patchwork)

####### Define Publication Theme ########
theme_Publication <- function(base_size=16, base_family="serif") {
  theme_classic(base_size=base_size, base_family=base_family) +
    theme(
      axis.title = element_text(face = "bold", size = rel(1.1)),
      axis.text = element_text(size = rel(0.9)),
      axis.line = element_line(colour="black", linewidth = 0.8),
      axis.ticks = element_line(colour="black", linewidth = 0.8),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      plot.margin = unit(c(5,5,5,5),"mm")
    )
}

####### The Mating System Scalars & Constraint Equations ########

# Model A: Extra-pair siring is independent of male breeding value
calc_kappa_A <- function(alpha) {
  return(1 + (1 - alpha)^2)
}

# Model B: Extra-pair siring is proportional to male breeding value
calc_kappa_B <- function(alpha) {
  return(2 * (1 - alpha + alpha^2))
}

# General exact constraint for unlinked loci
# Formula: Ne/N = 1 / (1 + 4 * Va * kappa)
calc_exact_constraint <- function(Va_vector, kappa) {
  return(1 / (1 + 4 * Va_vector * kappa))
}

####### Data Preparation ########
load("alldistzip")

# Extract id vectors (posterior Va)
id_vectors <- lapply(alldistzip, function(lst) lst$id)
species_names <- names(alldistzip)
df_va <- as.data.frame(setNames(id_vectors, species_names))
epp_data <- read.csv("species_EPP.csv", stringsAsFactors = FALSE)

valid_species <- intersect(names(df_va), epp_data$Code)
df_va_filtered <- df_va[, valid_species]

# Create Dataframes for the three models
ratio_baseline_df <- data.frame(matrix(ncol = length(valid_species), nrow = nrow(df_va_filtered)))
ratio_modelA_df <- data.frame(matrix(ncol = length(valid_species), nrow = nrow(df_va_filtered)))
ratio_modelB_df <- data.frame(matrix(ncol = length(valid_species), nrow = nrow(df_va_filtered)))

colnames(ratio_baseline_df) <- colnames(df_va_filtered)
colnames(ratio_modelA_df) <- colnames(df_va_filtered)
colnames(ratio_modelB_df) <- colnames(df_va_filtered)

for (sp in valid_species) {
  alpha_actual <- epp_data$EPP[epp_data$Code == sp]
  
  # MAIN TEXT BASELINE: Random mating, no mating system constraint (kappa = 1)
  ratio_baseline_df[[sp]] <- calc_exact_constraint(df_va_filtered[[sp]], kappa = 1)
  
  # MODEL A: Empirical EPP
  kappa_A <- calc_kappa_A(alpha_actual)
  ratio_modelA_df[[sp]] <- calc_exact_constraint(df_va_filtered[[sp]], kappa = kappa_A)
  
  # MODEL B: Empirical EPP
  kappa_B <- calc_kappa_B(alpha_actual)
  ratio_modelB_df[[sp]] <- calc_exact_constraint(df_va_filtered[[sp]], kappa = kappa_B)
}

# Rename Columns to Clean Species Names
clean_species_names <- epp_data$Species[match(valid_species, epp_data$Code)]
colnames(ratio_baseline_df) <- clean_species_names
colnames(ratio_modelA_df) <- clean_species_names
colnames(ratio_modelB_df) <- clean_species_names

# Reorder columns by the baseline mean constraint (lowest Ne/N to highest)
ordered_species <- names(sort(colMeans(ratio_baseline_df), decreasing = FALSE))
ratio_baseline_df <- ratio_baseline_df[, ordered_species]
ratio_modelA_df <- ratio_modelA_df[, ordered_species]
ratio_modelB_df <- ratio_modelB_df[, ordered_species]

####### MAIN MANUSCRIPT FIGURE: Baseline Posterior Areas ########

color_scheme_set("blue")

tiff("MainFig_Baseline_Constraint.tiff", units="in", width=8, height=10, res=300)
p_main <- mcmc_areas(ratio_baseline_df, 
                     prob = 0.95,        
                     point_est = "mean") + 
  # Replaced shaded polygon with a clean, theoretical boundary line
  geom_vline(xintercept = 0.1, linetype = "dotted", color = "red", linewidth = 1) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 1) + 
  scale_x_log10(breaks = c(0.01, 0.05, 0.1, 0.5, 1.0), 
                labels = c("0.01", "0.05", "0.1", "0.5", "1.0")) +
  labs(x = expression("Expected " * N[e] * "/N Ratio (Random Mating Baseline, Log Scale)"), 
       y = NULL) + 
  theme_Publication()

print(p_main)
dev.off()

####### SUPPLEMENTARY FIGURE 1: Theoretical Kappa Comparison ########

# Generate theoretical data across the full range of EPP rates (0 to 1)
alpha_seq <- seq(0, 1, length.out = 200)
theoretical_Va <- 0.1 # Representative empirical Va for the visualization

# Create the bounding models and the empirical EPP models
df_theoretical <- data.frame(
  Alpha = rep(alpha_seq, 2),
  Model = rep(c("Model A (BV-Independent)", 
                "Model B (BV-Proportional)"), each = 200),
  Kappa = c(calc_kappa_A(alpha_seq), calc_kappa_B(alpha_seq))
) %>%
  mutate(Ne_N = 1 / (1 + 4 * theoretical_Va * Kappa))

# Lock the factor levels
df_theoretical$Model <- factor(df_theoretical$Model, 
                               levels = c("Model A (BV-Independent)", 
                                          "Model B (BV-Proportional)"))

tiff("SuppFig1_Theoretical_Mating_Models.tiff", units="in", width=5, height=5, res=300)
p_supp1 <- ggplot(df_theoretical, aes(x = Alpha, y = Ne_N, color = Model, linetype = Model)) +
  geom_line(linewidth = 1.2) + 
  geom_vline(xintercept = 0, linetype = "dashed", alpha=0.5, col="black") +
  geom_vline(xintercept = 1, linetype = "dashed", alpha=0.5, col="black") +
  labs(x = expression("Extra-Pair Paternity Rate (" * alpha * ")"),
       y = expression("Theoretical Unlinked " * N[e] * "/N Ratio")) +
  scale_color_manual(values = c("Model A (BV-Independent)" = "#D55E00", 
                                "Model B (BV-Proportional)" = "#0072B2")) +
  scale_linetype_manual(values = c("Model A (BV-Independent)" = "solid", 
                                   "Model B (BV-Proportional)" = "solid")) +
  theme_Publication() +
  theme(legend.title = element_blank(),
        legend.position = "top",
        # Shrink legend text and adjust margins to fit the smaller panel
        legend.text = element_text(size = 9),
        legend.margin = margin(t = 0, r = 0, b = 0, l = 0)) 

print(p_supp1)
dev.off()

####### SUPPLEMENTARY FIGURE 2: Monogamous Empirical Models vs Baseline ########

monogamous_species_list <- epp_data %>%
  filter(Mating.system == "monogamous") %>% 
  pull(Species)

summarize_posteriors <- function(df, model_name) {
  data.frame(
    Species = colnames(df),
    Model = model_name,
    Mean = colMeans(df),
    Lower = apply(df, 2, quantile, probs = 0.025),
    Upper = apply(df, 2, quantile, probs = 0.975)
  )
}

df_summary_base <- summarize_posteriors(ratio_baseline_df, "Random Mating (κ = 1)")
df_summary_A <- summarize_posteriors(ratio_modelA_df, "Model A")
df_summary_B <- summarize_posteriors(ratio_modelB_df, "Model B")

df_empirical_comp_mono <- bind_rows(df_summary_base, df_summary_A, df_summary_B) %>%
  filter(Species %in% monogamous_species_list) %>%
  mutate(
    Species = factor(Species, levels = intersect(ordered_species, monogamous_species_list)),
    Model = factor(Model, levels = c("Random Mating (κ = 1)", "Model A", "Model B"))
  )

tiff("SuppFig2_Monogamous_Models_Comp.tiff", units="in", width=8, height=8, res=300)
p_supp2 <- ggplot(df_empirical_comp_mono, aes(y = Species, color = Model)) +
  geom_errorbar(aes(xmin = Lower, xmax = Upper), height = 0, linewidth = 1.2, orientation = "y",
                alpha = 0.6, position = position_dodge(width = 0.6)) +
  geom_point(aes(x = Mean), size = 3, position = position_dodge(width = 0.6)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 1) + 
  scale_color_manual(values = c("Random Mating (κ = 1)" = "gray50", 
                                "Model A" = "#D55E00", 
                                "Model B" = "#0072B2")) +
  labs(x = expression("EPP-Adjusted " * N[e] * "/N Ratio"),
       y = NULL) +
  theme_Publication()

print(p_supp2)
dev.off()

####### SUPPLEMENTARY FIGURE 3: Va Deflation Sensitivity Analysis ########

# Define systematic penalty multipliers for empirical Va
deflation_levels <- c("100% (Reported Va)" = 1.0,
                      "50% of Reported Va" = 0.5,
                      "25% of Reported Va" = 0.25,
                      "10% of Reported Va" = 0.10)

deflation_results <- data.frame()

# Recalculate baseline constraint under deflation scenarios
for (lvl_name in names(deflation_levels)) {
  multiplier <- deflation_levels[[lvl_name]]
  
  for (i in seq_along(valid_species)) {
    raw_sp <- valid_species[i]
    clean_sp <- clean_species_names[i]
    
    # Apply penalty to the full Va posterior
    deflated_Va <- df_va_filtered[[raw_sp]] * multiplier
    deflated_Ne_N <- calc_exact_constraint(deflated_Va, kappa = 1)
    
    deflation_results <- rbind(deflation_results, data.frame(
      Species = clean_sp,
      Deflation_Level = lvl_name,
      Mean = mean(deflated_Ne_N),
      Lower = quantile(deflated_Ne_N, 0.025),
      Upper = quantile(deflated_Ne_N, 0.975)
    ))
  }
}

# Lock factor levels
deflation_results$Deflation_Level <- factor(deflation_results$Deflation_Level, levels = names(deflation_levels))
deflation_results$Species <- factor(deflation_results$Species, levels = ordered_species)

tiff("SuppFig3_Va_Deflation_Analysis.tiff", units="in", width=8, height=10, res=300)
p_deflation <- ggplot(deflation_results, aes(x = Mean, y = Species, color = Deflation_Level)) +
  # Replaced shaded polygon with a clean, theoretical boundary line
  geom_vline(xintercept = 0.1, linetype = "dotted", color = "red", linewidth = 1) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "black", linewidth = 1) +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0, linewidth = 0.8, alpha = 0.7, position = position_dodge(width = 0.7)) +
  geom_point(size = 2, position = position_dodge(width = 0.7)) +
  scale_color_viridis_d(option = "mako", begin = 0.2, end = 0.8, direction = -1) +
  scale_x_log10(breaks = c(0.01, 0.05, 0.1, 0.5, 1.0), 
                labels = c("0.01", "0.05", "0.1", "0.5", "1.0")) +
  labs(x = expression("Expected " * N[e] * "/N Ratio (Random Mating Baseline, Log Scale)"),
       y = NULL,
       color = "Assumed True Additive Variance") +
  theme_Publication() +
  theme(legend.position = "top",
        legend.title = element_text(face = "bold"),
        # Shrink legend text slightly here as well to prevent wrapping issues
        legend.text = element_text(size = 10))+ guides(color = guide_legend(nrow = 4))

print(p_deflation)
dev.off()

####### SUPPLEMENTARY TABLE 1: Bayesian Indices ########

calc_bayes_indices <- function(posterior_vector) {
  shifted_posterior <- posterior_vector - 1
  
  pd_result <- p_direction(shifted_posterior)
  pmap_result <- p_map(shifted_posterior)
  rope_null <- rope(posterior_vector, range = c(0.98, 1.00), ci = 0.95)
  
  return(data.frame(
    Mean_Ratio = mean(posterior_vector),
    Lower_95 = quantile(posterior_vector, 0.025),
    Upper_95 = quantile(posterior_vector, 0.975),
    pd = as.numeric(pd_result),
    p_map = as.numeric(pmap_result),
    ROPE_95_Null = as.numeric(rope_null$ROPE_Percentage)
  ))
}

bayes_stats_base <- do.call(rbind, lapply(ratio_baseline_df, calc_bayes_indices))
bayes_stats_base$Species <- rownames(bayes_stats_base)
bayes_stats_base$Model <- "Random Mating (κ=1)"

bayes_stats_A <- do.call(rbind, lapply(ratio_modelA_df, calc_bayes_indices))
bayes_stats_A$Species <- rownames(bayes_stats_A)
bayes_stats_A$Model <- "Model A"

bayes_stats_B <- do.call(rbind, lapply(ratio_modelB_df, calc_bayes_indices))
bayes_stats_B$Species <- rownames(bayes_stats_B)
bayes_stats_B$Model <- "Model B"

supp_table_combined <- bind_rows(bayes_stats_base, bayes_stats_A, bayes_stats_B) %>%
  select(Species, Model, Mean_Ratio, Lower_95, Upper_95, pd, p_map, ROPE_95_Null) %>%
  arrange(Species, desc(Model))

write.csv(supp_table_combined, "SuppTable1_Bayesian_Indices.csv", row.names = FALSE)

