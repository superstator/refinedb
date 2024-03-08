library(dplyr)
library(stringr)
library(ggplot2)

builds <- read.csv2("~/src/refinedb/out1.tsv", sep = "\t") |>
  mutate(
    enums = enums == "true",
    release = release == "true",
    Type = case_when(
      enums & release ~ "Release w/ Enums",
      enums & !release ~ "Debug w/ Enums",
      !enums & release ~ "Release w/o Enums",
      !enums & !release ~ "Debug w/o Enums",
    ) |> as.factor(),
    Seconds = str_remove(time, "s") |> as.numeric(),
    Migrations = n
  ) |> select(Migrations, Seconds, Type)


ggplot(builds, aes(x = Migrations, y = Seconds, color = Type)) +
  geom_smooth(se = FALSE) +
  labs(title = "Build Time", colour = "Build Type")

