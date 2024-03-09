library(dplyr)
library(stringr)
library(ggplot2)

builds <- read.csv2("~/src/refinedb/out.tsv", sep = "\t") |>
  mutate(
    enums = enums == "true",
    release = release == "true",
    Type = case_when(
      enums & release ~ "Release w/ Enums",
      enums & !release ~ "Debug w/ Enums",
      !enums & release ~ "Release w/o Enums",
      !enums & !release ~ "Debug w/o Enums",
    ) |> as.factor(),
    Seconds = as.numeric(user) + as.numeric(kernel),
    Migrations = n
  )

predicted = data.frame(Migrations = c((max(builds$Migrations)/500):30 * 500))
predicted$Seconds = predict(lm(Seconds ~ poly(Migrations, 2), data=(builds |> filter(release & enums))), predicted)

ggplot(builds, aes(x = Migrations, y = Seconds, color = Type)) +
  geom_point(data = predicted, size = 1, show.legend = FALSE, colour = "#00BFC4") +
  geom_smooth(se = FALSE) +
  labs(title = "Build Time", colour = "Build Type")


