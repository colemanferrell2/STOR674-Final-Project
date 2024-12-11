
# Perform Canonical Correlation Analysis
run_cca <- function(X, Y, nboots = 1000, level = 0.9) {
  ref_solution <- CCA::cc(X, Y)
  bootstrp_solution <- combootcca::cca_ci_boot(
    X, Y,
    align = combootcca:::cca_align_hungarian_weighted,
    ref = ref_solution,
    level = level,
    nboots = nboots,
    boot_type = "basic"
  )
  list(ref_solution = ref_solution, bootstrp_solution = bootstrp_solution)
}

# Extract confidence intervals and prepare data for plotting
extract_and_prepare_ci <- function(bootstrp_solution, coef_type = "xcoef", pc_indexes) {
  lower <- bootstrp_solution$basic[[coef_type]][, , 1]
  upper <- bootstrp_solution$basic[[coef_type]][, , 2]
  num_rows <- nrow(lower)
  data_frames <- lapply(pc_indexes, function(pc) {
    LB <- as.data.frame(lower[, pc])
    UB <- as.data.frame(upper[, pc])
    data <- cbind(LB, UB, seq(1:num_rows))
    colnames(data) <- c("LB", "UB", "Index")
    data$CI_contains_zero <- ifelse(data$LB <= 0 & data$UB >= 0, TRUE, FALSE)
    data$PC <- paste0("\u03B2", pc)
    data
  })
  do.call(rbind, data_frames)
}

# Plot confidence intervals
plot_ci <- function(data, title, output_path, y_limits = NULL) {
  plot <- ggplot2::ggplot(data, ggplot2::aes(x = Index, ymin = LB, ymax = UB, color = CI_contains_zero)) +
    ggplot2::geom_errorbar(width = 0.2) +
    ggplot2::geom_point(ggplot2::aes(y = (LB + UB) / 2)) +
    ggplot2::scale_color_manual(values = c("red", "blue")) +
    ggplot2::facet_wrap(~ PC, scales = "free_y", ncol = 1) +
    ggplot2::geom_hline(yintercept = 0, color = "black") +
    ggplot2::ggtitle(title) +
    ggplot2::labs(x = "Principal Component", y = "Value", color = "CI Contains Zero") +
    ggplot2::theme_minimal()
  if (!is.null(y_limits)) {
    plot <- plot + ggplot2::ylim(y_limits)
  }
  ggplot2::ggsave(output_path, plot = plot, width = 10, height = 6)
}

# Calculate percentage contributions for loadings
calculate_contributions <- function(loadings, indexes) {
  selected_loadings <- loadings[, indexes]
  squared_sums <- rowSums(selected_loadings^2)
  total_sum <- sum(loadings^2)
  percentage_contributions <- (squared_sums / total_sum) * 100
  data.frame(Variable = rownames(selected_loadings), Percentage_Contribution = percentage_contributions)
}
