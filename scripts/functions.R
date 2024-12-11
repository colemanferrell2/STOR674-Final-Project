run_combootcca <- function(X, Y, ref_solution, level = 0.9, nboots = 1000) {
  cca_ci_boot(
    X, Y,
    align = combootcca:::cca_align_hungarian_weighted,
    ref = ref_solution,
    level = level,
    nboots = nboots,
    boot_type = "basic"
  )
}

process_principal_components <- function(coef_matrix, pc_labels) {
  num_components <- nrow(coef_matrix)
  combined_data <- data.frame()
  
  for (i in seq_along(pc_labels)) {
    lower_bound <- as.data.frame(coef_matrix[, , 1][, i])
    upper_bound <- as.data.frame(coef_matrix[, , 2][, i])
    component_data <- cbind(lower_bound, upper_bound, seq(1:num_components))
    colnames(component_data) <- c("LB", "UB", "Index")
    component_data$CI_contains_zero <- component_data$LB <= 0 & component_data$UB >= 0
    component_data$PC <- pc_labels[i]
    combined_data <- rbind(combined_data, component_data)
  }
  
  combined_data
}

plot_confidence_intervals <- function(data, file_path, title, ylim_range = NULL) {
  plot <- ggplot(data, aes(x = Index, ymin = LB, ymax = UB, color = CI_contains_zero)) +
    geom_errorbar(width = 0.2) +
    geom_point(aes(y = (LB + UB) / 2)) +
    scale_color_manual(values = c("red", "blue")) +
    facet_wrap(~ PC, scales = "free_y", ncol = 1) +
    ggtitle(title) +
    geom_hline(yintercept = 0, color = "black") +
    labs(x = "Index", y = "Value", color = "CI Contains Zero") +
    theme_minimal()
  
  # Add ylim if specified
  if (!is.null(ylim_range)) {
    plot <- plot + ylim(ylim_range[1], ylim_range[2])
  }
  
  ggsave(file_path, plot = plot, width = 10, height = 6)
}


calculate_loadings <- function(ref_solution, idx1_X, idx2_X, idx1_Y, idx2_Y) {
  canonical_loadings_X <- ref_solution$scores$corr.X.xscores
  canonical_loadings_Y <- ref_solution$scores$corr.Y.yscores
  
  list(
    Loadings_X_Direction1 = canonical_loadings_X[idx1_X, 1],
    Loadings_X_Direction2 = canonical_loadings_X[idx2_X, 2],
    Loadings_Y_Direction1 = canonical_loadings_Y[idx1_Y, 1],
    Loadings_Y_Direction2 = canonical_loadings_Y[idx2_Y, 2]
  )
}

calculate_contributions <- function(loadings, component_indices) {
  selected_loadings <- loadings[, component_indices]
  squared_sums <- rowSums(selected_loadings^2)
  percentages <- (squared_sums / sum(loadings^2)) * 100
  data.frame(Variable = rownames(selected_loadings), Percentage_Contribution = percentages) %>%
    arrange(desc(Percentage_Contribution))
}

