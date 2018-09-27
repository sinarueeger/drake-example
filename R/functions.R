create_plot <- function(data) {
  ggplot(data, aes(x = Petal.Width, fill = Species)) +
  geom_histogram(binwidth = 0.25) +
    theme_gray(20) + scale_fill_manual(values = c(1, 4,3 ))
}
