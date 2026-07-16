#############################################################
# Define parameters
p_L_values <- seq(0.05, 0.3, by = 0.05)  # Example fraction of large-effect sites (adjust as needed)
gamma_L <- 2*10000*10^seq(-4, -3, by = 0.01)  # Range of gamma_i^S values
rho <- function(gamma) {
  2*gamma/(1-exp(-2*gamma))
} 

# Create a grid of gamma_i^S and d(gamma_i^S) values
grid <- expand.grid(p_L = p_L_values, gamma_L = gamma_L)

# Calculate gamma_j^L * rho(-gamma_j^L) for each combination of gamma_i^S and d(gamma_i^S)
grid$gamma_S_d_gamma_S <- 2*(grid$gamma_L * grid$p_L * rho(-grid$gamma_L)) / (1-grid$p_L)
grid$gamma_S <- sqrt(grid$gamma_S_d_gamma_S)/sqrt(2)
grid$d_gamma_S <- rho(grid$gamma_S)-rho(-grid$gamma_S)
# Plot the results
custom_break_x <- c(10^-7, 10^-5, 10^-3, 10^-1)
custom_labels_x <- c(expression(10^-7),expression(10^-5),expression(10^-3),expression(10^-1))

# Plot the results
custom_break_y <- c(10^-7, 10^-5, 10^-3, 10^-1)
custom_labels_y <- c(expression(10^-7),expression(10^-5),expression(10^-3),expression(10^-1))

tiff("plot_equ_1.tiff", units="in", width=8, height=8, res=300)
p <- ggplot(grid, aes(x = gamma_L*rho(-gamma_L), y = gamma_S_d_gamma_S)) +
  geom_line(linewidth =2)+scale_x_log10()+
  scale_y_log10()+
  labs(
    title = "Mutation-Selection Equilibrium",
    x = expression(gamma^L * rho(-gamma^L)),
    y = expression(gamma^S * d(gamma^S))
  ) +
  facet_wrap(~ p_L, labeller = label_value) +  # Create separate plots for different values of p_L
  theme_Publication() +
  theme(legend.position = "bottom")
p
dev.off()

tiff("plot_equ_2.tiff", units="in", width=8, height=8, res=300)
p <- ggplot(grid, aes(x = gamma_L, y = gamma_S)) +
  geom_line(linewidth =2)+scale_x_log10()+
  scale_y_log10()+
  labs(
    title = "Mutation-Selection Equilibrium",
    x = expression(gamma^L),
    y = expression(gamma^S)
  ) +
  facet_wrap(~ p_L, labeller = label_value) +  # Create separate plots for different values of p_L
  theme_Publication() +
  theme(legend.position = "bottom")
p
dev.off()

tiff("plot_equ_3.tiff", units="in", width=8, height=8, res=300)
p <- ggplot(grid, aes(x = gamma_L, y = d_gamma_S)) +
  geom_line(linewidth =2)+scale_x_log10()+
  scale_y_log10()+
  labs(
    title = "Mutation-Selection Equilibrium",
    x = expression(gamma^L),
    y = expression(d(gamma^S))
  ) +
  facet_wrap(~ p_L, labeller = label_value) +  # Create separate plots for different values of p_L
  theme_Publication() +
  theme(legend.position = "bottom")
p
dev.off()

tiff("plot_equ_4.tiff", units="in", width=8, height=8, res=300)
p <- ggplot(grid, aes(x = gamma_L, y = gamma_S_d_gamma_S)) +
  geom_line(linewidth =2)+scale_x_log10()+
  scale_y_log10()+
  labs(
    title = "Mutation-Selection Equilibrium",
    x = expression(gamma^L),
    y = expression(gamma^S * d(gamma^S))
  ) +
  facet_wrap(~ p_L, labeller = label_value) +  # Create separate plots for different values of p_L
  theme_Publication() +
  theme(legend.position = "bottom")
p
dev.off()