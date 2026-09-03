1/(r+s(1-r))

r <-  seq(10^-3, 0.5, length.out = 1000)
s1 <-  10^-1
s2 <-  10^-2
s3 <- 10^-3
s4 <- 10^-4

Q1 <-  1/(r+s1*(1-r))
Q2 <-  1/(r+s2*(1-r))
Q3 <-  1/(r+s3*(1-r))
Q4 <-  1/(r+s4*(1-r))

tiff("SuppFig4.tiff", units="in", width=5, height=5, res=300)
ggplot() +geom_line(aes(x = r, y = log10(Q1)), col="black")+geom_line(aes(x = r, y = log10(Q2)), col="blue")+
  geom_line(aes(x = r, y = log10(Q3)), col="green")+geom_line(aes(x = r, y = log10(Q4)), col="orange")+
  xlab("Recombination fraction, r")+ylab("Amplification Factor, Q (log10)")+
  geom_vline(xintercept = 0.5, col="red", alpha=0.5, linetype = "dashed")+ theme_Publication()
dev.off()
        
alpha <-  seq(0, 1, length.out = 5000)
model1 <- 1 + (1 - alpha)^2
model2 <-  2*(1 - alpha + alpha^2)


tiff("SuppFig3.tiff", units="in", width=5, height=5, res=300)
ggplot() +geom_line(aes(x = alpha, y = model1), col="#D55E00")+ geom_line(aes(x = alpha, y = model2), col="#0072B2")+
  xlab(expression("Extra-Pair Paternity, "*alpha))+ylab(expression("Mating System Scalar, "*kappa))+
  theme_Publication()
dev.off()

####### Generate Z vs Vm Data ########
# Define the three specific additive variance regimes
Va_values <- c(0.005, 0.01,0.05, 0.10)

# Define a biologically plausible sequence for mutational variance (Vm)
# Vm is proportional to U * s^2, typically on the order of 10^-4 to 10^-2
Vm_seq <- seq(10^-4, 0.009, length.out = 300)

# Build the dataframe
df_Z <- expand.grid(Vm = Vm_seq, Va = Va_values) %>%
  mutate(
    # Calculate Z = 1 - (Vm/Va)
    # pmax(0, ...) ensures Z doesn't drop below 0 if Vm exceeds Va
    Z = pmax(0, 1 - (Vm / Va)),
    
    # Create a clean factor for the legend
    Va_label = factor(Va, levels = Va_values, labels = paste0(Va_values))
  )

####### Plot Z as a function of Vm ########
tiff("Theoretical_Z_vs_Vm.tiff", units="in", width=8, height=5, res=300)

p_Z <- ggplot(df_Z, aes(x = Vm, y = Z, color = Va_label, linetype = Va_label)) +
  geom_line(linewidth = 1.2) +
  
  # Color palette matching previous theoretical figures
  scale_color_manual(values = c("#D55E00","#E69F00", "#009E73", "#0072B2")) +
  
  labs(
    x = expression("Mutational Input Variance, " * V[m] * " (" %~% U[d] * s^2 * ")"),
    y = expression(bold("Survival Rate of Selective Variance, ") * bolditalic(Z)),
    color = "Additive Variance",
    linetype = "Additive Variance"
  ) +
  
  # Lock axes to strict biological bounds (0 to 1)
  #coord_cartesian(ylim = c(0, 1), xlim = c(0, 0.01), expand = FALSE) +
  scale_y_log10()+scale_x_log10()+
  theme_Publication() +
  
  # Add slight padding so lines don't get clipped by the strict axis limits
  theme(plot.margin = margin(t = 10, r = 15, b = 5, l = 5))+
  theme_classic(base_size = 14)+
  theme(
    axis.title = element_text(face = "bold"),
    axis.line = element_line(colour = "black", linewidth = 0.8),
    axis.ticks = element_line(colour = "black", linewidth = 0.8),
    legend.position = "right",
    legend.title = element_text(face = "bold")
  )

print(p_Z)
dev.off()
####### Haldane-Bounded Spatial Constraint Functions #######

# Define the per-generation integrand
# x: position of selected locus
# y: position of focal neutral locus
# Z: generational survival rate of selective variance
integrand_haldane <- function(x, y, Z) {
  # (1 - (Z/2) * (1 + exp(-2|x-y|)))^(-2)
  denom <- 1 - (Z / 2) * (1 + exp(-2 * abs(x - y)))
  return(1 / denom^2)
}

# Calculate exact Q^2(y) via split numerical integration
# We split the integral at 'y' to prevent algorithm failure at the absolute value kink.
calc_Q2_y_haldane <- function(y, M, Z) {
  
  # Integrate from 0 to y (left flank)
  if (y > 0) {
    int_left <- integrate(integrand_haldane, lower = 0, upper = y, 
                          y = y, Z = Z, rel.tol = 1e-8)$value
  } else {
    int_left <- 0
  }
  
  # Integrate from y to M (right flank)
  if (y < M) {
    int_right <- integrate(integrand_haldane, lower = y, upper = M, 
                           y = y, Z = Z, rel.tol = 1e-8)$value
  } else {
    int_right <- 0
  }
  
  # Divide by map length (M) to get the expected value
  return((int_left + int_right) / M)
}

# Vectorize to allow clean operation within dplyr and ggplot
calc_Q2_y_vec <- Vectorize(calc_Q2_y_haldane, vectorize.args = c("y", "Z"))

####### Data Generation and Plotting #######

# Define theoretical parameters
M_val <- 1.5  # Map length in Morgans (e.g., 150 cM)
Z_vals <- c(0.85, 0.90, 0.95, 0.98) # Sequence of survival rates (Z = 1 - Vm/Va)

# Generate high-resolution coordinate sequence across the chromosome
y_seq <- seq(0, M_val, length.out = 300)

# Build the plotting dataframe
df_constraint <- expand.grid(y = y_seq, Z = Z_vals) %>%
  mutate(
    Q2 = calc_Q2_y_vec(y, M = M_val, Z),
    # Format Z for clean legend labels
    Z_label = factor(Z, levels = Z_vals, labels = paste0("Z = ", Z_vals))
  )

# Plot the topography of Q^2(y)
tiff("Q_y_decay.tiff", units="in", width=10, height=6, res=300)
p_topography <- ggplot(df_constraint, aes(x = y, y = Q2, color = Z_label)) +
  geom_line(linewidth = 1.2) +
  scale_color_viridis_d(option = "mako", begin = 0.2, end = 0.8, direction = -1) +
  labs(
    x = "Position of Focal Neutral Locus, y (Morgans)",
    y = expression(bold("Cumulative Constraint, ") * bolditalic(Q^2(y))),
    color = "Variance Survival Rate"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.title = element_text(face = "bold"),
    axis.line = element_line(colour = "black", linewidth = 0.8),
    axis.ticks = element_line(colour = "black", linewidth = 0.8),
    legend.position = "right",
    legend.title = element_text(face = "bold")
  )

print(p_topography)
dev.off()
####################################################################################
# Define the integrand for the average chromosome constraint over distance 'd'
# Formula: (M - d) * (1 / (1 - (Z/2)*(1 + exp(-2d))))^2
integrand_avg_Q2 <- function(d, M, Z) {
  denom <- 1 - (Z / 2) * (1 + exp(-2 * d))
  return((M - d) / denom^2)
}

calc_avg_Q2_haldane <- function(M, Z) {
  if (M < 1e-6) return(1 / (1 - Z)^2)
  
  # Protect the numerical integration from the d=0 singularity
  # Cap Z internally at 0.995 to prevent evaluate-to-infinity errors
  Z_safe <- min(Z, 0.995) 
  res <- integrate(integrand_avg_Q2, lower = 0, upper = M, M = M, Z = Z_safe, rel.tol = 1e-8)$value
  return((2 / M^2) * res)
}

# Vectorize across both M and Z for seamless dplyr application
calc_avg_Q2_vec <- Vectorize(calc_avg_Q2_haldane, vectorize.args = c("M", "Z"))

####### Plot 1: Average Cumulative Constraint vs Map Length ########

# Generate theoretical parameter sequences
M_seq <- seq(0.1, 3.0, length.out = 100) # Map lengths from 10 cM to 300 cM
Z_vals <- c(0.85, 0.90, 0.95, 0.98)      # Sequence of survival rates

df_avg_constraint <- expand.grid(M = M_seq, Z = Z_vals) %>%
  mutate(
    Avg_Q2 = calc_avg_Q2_vec(M, Z),
    Z_label = factor(Z, levels = Z_vals, labels = paste0("Z = ", Z_vals))
  )

tiff("Theoretical_Avg_Constraint.tiff", units="in", width=10, height=5, res=300)
p_avg <- ggplot(df_avg_constraint, aes(x = M, y = Avg_Q2, color = Z_label)) +
  geom_line(linewidth = 1.2) +
  scale_y_log10() + # Log scale highlights the decay dynamic perfectly
  scale_color_viridis_d(option = "mako", begin = 0.2, end = 0.8, direction = -1) +
  labs(
    x = "Chromosome Map Length, M (Morgans)",
    y = expression(bold("Avg Cumulative Constraint, ") * bolditalic(bar(Q^2)[linked]) * bold(" (Log Scale)")),
    color = "Variance Survival (Z)"
  ) +
  theme_Publication()+scale_x_log10()+
  theme_classic(base_size = 14) +
  theme(
    axis.title = element_text(face = "bold"),
    axis.line = element_line(colour = "black", linewidth = 0.8),
    axis.ticks = element_line(colour = "black", linewidth = 0.8),
    legend.position = "right",
    legend.title = element_text(face = "bold")
  )

print(p_avg)
dev.off()

####### Plot 2: Total Demographic Reduction (Ne/N) vs Additive Variance ########

# Define biological parameters
kappa_val <- 1.0  # Random mating baseline
Va_levels <- c(0.005, 0.01, 0.05, 0.10) # Low, Moderate, and High Additive Variance

####### Panel A: Spatial Rescue (Ne/N vs Map Length M) ########
Vm_fixed <- 0.005 # Biologically realistic mutational variance
M_seq <- seq(0.1, 3.0, length.out = 100) # 10 cM to 300 cM chromosomes

df_panel_A <- expand.grid(M = M_seq, Va = Va_levels) %>%
  mutate(
    # Z is dynamically calculated. If Va is small, turnover is high (Z is low).
    # If Va is massive, turnover is negligible (Z approaches 1).
    Z = pmax(0, 1 - (Vm_fixed / Va)),
    Avg_Q2 = calc_avg_Q2_vec(M, Z),
    Ne_N = 1 / (1 + kappa_val * Avg_Q2 * Va),
    Va_label = factor(Va, levels = Va_levels, labels = paste0(Va_levels))
  )

pA <- ggplot(df_panel_A, aes(x = M, y = Ne_N, color = Va_label, linetype = Va_label)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 0.1, linetype = "dotted", color = "red", linewidth = 1) +
  scale_color_manual(values = c("#D55E00", "#E69F00", "#009E73", "#0072B2")) +
  labs(
    title = "A: Spatial Rescue via Recombination",
    x = "Chromosome Map Length, M (Morgans)",
    y = expression(bold("Expected ") * bolditalic(N[e]/N) * bold(" Ratio")),
    color = "Additive Variance",
    linetype = "Additive Variance"
  ) +
  coord_cartesian(ylim = c(0, 1)) +
  theme_Publication()+theme()+  theme_classic(base_size = 14) +
  theme(
    axis.title = element_text(face = "bold"),
    axis.line = element_line(colour = "black", linewidth = 0.8),
    axis.ticks = element_line(colour = "black", linewidth = 0.8),
    legend.position = "none"
  )

####### Panel B: Temporal Rescue (Ne/N vs Variance Survival Z) ########
M_fixed <- 1.0 # Standard 100 cM chromosome
Vm_seq <- seq(0.0001, 0.05, length.out = 500)

df_panel_B <- expand.grid(Vm = Vm_seq, Va = Va_levels) %>%
  # VITAL FIX: Remove biologically impossible states where Mutational Input > Additive Variance
  filter(Vm <= Va) %>% 
  mutate(
    # Z is now strictly a function of the Vm x-axis
    Z = 1 - (Vm / Va),
    Avg_Q2 = calc_avg_Q2_vec(M_fixed, Z),
    Ne_N = 1 / (1 + kappa_val * Avg_Q2 * Va),
    Va_label = factor(Va, levels = Va_levels, labels = paste0(Va_levels))
  )

pB <- ggplot(df_panel_B, aes(x = Vm, y = Ne_N, color = Va_label, linetype = Va_label)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 0.1, linetype = "dotted", color = "red", linewidth = 1) +
  scale_color_manual(values = c("#D55E00","#E69F00", "#009E73", "#0072B2")) +
  labs(
    title = "B: Temporal Rescue via Background Turnover",
    x = expression(bold("Mutational Variance, ") * bolditalic(V[m]) * bold("  (") %~% bolditalic(U[d] * s^2) * bold(")")),
    y = expression(bold("Expected ") * bolditalic(N[e]/N) * bold(" Ratio")),
    color = "Additive Variance",
    linetype = "Additive Variance"
  ) +
  coord_cartesian(ylim = c(0, 1)) +
  theme_Publication()+theme()+  theme_classic(base_size = 14) +scale_x_log10()+
  theme(
    axis.title = element_text(face = "bold"),
    axis.line = element_line(colour = "black", linewidth = 0.8),
    axis.ticks = element_line(colour = "black", linewidth = 0.8),
    legend.position = "none"
  )

####### Combine and Save ########
tiff("Theoretical_Constraint_Mechanisms.tiff", units="in", width=12, height=6, res=300)

# Patchwork seamlessly aligns the plots side-by-side with a shared legend
combined_plot <- pA + pB + plot_layout(guides = "collect")+theme(legend.position = "right")+guides(color = guide_legend(nrow = 4))

print(combined_plot)
dev.off()

####################################################################################
####### Mathematical Integration Functions ########
integrand_avg_Q2 <- function(d, M, Z) {
  denom <- 1 - (Z / 2) * (1 + exp(-2 * d))
  return((M - d) / denom^2)
}

calc_avg_Q2_haldane <- function(M, Z) {
  if (M < 1e-6) return(1 / (1 - Z)^2)
  Z_safe <- min(Z, 0.995) # Protect MSB boundary
  res <- integrate(integrand_avg_Q2, lower = 0, upper = M, M = M, Z = Z_safe, rel.tol = 1e-8)$value
  return((2 / M^2) * res)
}

calc_avg_Q2_vec <- Vectorize(calc_avg_Q2_haldane, vectorize.args = c("M", "Z"))

####### Shared Parameters ########
kappa_val <- 1.0  # Random mating baseline to isolate the physical/genetic mechanics

####### Panel A: The Phase Space of Genomic Viability (Heatmap) ########
# We generate a high-resolution grid of Va and Map Length
Va_seq_A <- seq(0.001, 0.1, length.out = 300)
M_seq_A <- seq(0.01, 3.0, length.out = 300)
Vm_fixed <- 0.0009 # A representative moderate mutational input

df_panel_A <- expand.grid(Va = Va_seq_A, M = M_seq_A) %>%
  mutate(
    Z = pmax(0, 1 - (Vm_fixed / Va)),
    Avg_Q2 = calc_avg_Q2_vec(M, Z),
    Ne_N = 1 / (1 + kappa_val * Avg_Q2 * Va)
  )

pA <- ggplot(df_panel_A, aes(x = M, y = Va, fill = Ne_N, z = Ne_N)) +
  geom_raster(interpolate = TRUE) +
  # Draw a stark white contour line exactly at the 0.1 viability threshold
  geom_contour(breaks = 0.1, color = "white", linetype = "dashed", linewidth = 1.2) +
  geom_contour(breaks = 0.5, color = "grey", linetype = "dashed", linewidth = 1.2) +
  scale_fill_viridis_c(option = "magma", limits = c(0, 1), name = expression(bolditalic(N[e]/N) * bold(" Ratio"))) +
  labs(
    title = "B: Phase Space of Genomic Viability",
    x = "Chromosome Map Length, M (Morgans)",
    y = expression(bold("Additive Variance, ") * bolditalic(V[A]))
  ) +
  #scale_x_log10() +
  #scale_y_log10() +
  theme_Publication() +
  theme(
    legend.key.width = unit(2, "cm"),
    legend.title.align = 0.5
  )

####### Panel B: The Mutational Singularity (Ne/N vs Va) ########
Va_seq_B <- seq(0.001, 0.30, length.out = 500)
M_fixed <- 1.0 # 100 cM standard chromosome
Vm_levels <- c(0.001, 0.005, 0.015) # Low, Moderate, and High mutation rates

df_panel_B <- expand.grid(Va = Va_seq_B, Vm = Vm_levels) %>%
  mutate(
    Z = pmax(0, 1 - (Vm / Va)),
    Avg_Q2 = calc_avg_Q2_vec(M_fixed, Z),
    Ne_N = 1 / (1 + kappa_val * Avg_Q2 * Va),
    Vm_label = factor(Vm, levels = Vm_levels, labels = paste0(Vm_levels))
  )

pB <- ggplot(df_panel_B, aes(x = Va, y = Ne_N, color = Vm_label, linetype = Vm_label)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 0.1, linetype = "dotted", color = "gray30", linewidth = 1) +
  scale_color_manual(values = c("#D55E00", "#009E73", "#0072B2")) +
  labs(
    title = "A: The Mutational Singularity",
    x = expression(bold("Additive Variance, ") * bolditalic(V[A])),
    y = expression(bold("Expected ") * bolditalic(N[e]/N) * bold(" Ratio")),
    color = "Mutational Variance",
    linetype = "Mutational Variance"
  ) +
  coord_cartesian(ylim = c(0, 1)) +scale_x_log10()+
  theme_Publication()

####### Combine and Save ########
tiff("Theoretical_Phase_Space_Collapse.tiff", units="in", width=13, height=6, res=300)

combined_plot <- pB + pA + plot_layout(widths = c(1, 1))
print(combined_plot)

dev.off()
