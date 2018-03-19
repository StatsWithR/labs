library(dplyr)

if(!file.exists("brfss2013.RData"))
  download.file("http://stat.duke.edu/~cr173/Sta102_Sp16/Proj/brfss2013.RData",  
                destfile="brfss2013.RData")

load("brfss2013.RData")

set.seed("34308078")

n = 5000

brfss = brfss2013 %>% 
  select(weight2, height3, sex, exerany2, fruit1, fvgreen) %>%
  mutate(weight2 = as.numeric(as.character(weight2))) %>%
  filter(height3 >= 200 & height3 <= 711) %>%
  filter(weight2 > 50 & weight2 < 500) %>%
  filter(fruit1 %in% c(0,101:109)) %>%
  filter(fvgreen %in% c(0,101:109)) %>%
  na.omit() %>%
  transmute(weight = weight2,
            height = floor(height3/100)*12+height3 %% 100,
            sex    = sex,
            exercise = exerany2,
            fruit_per_day = fruit1 %% 100,
            vege_per_day  = fvgreen %% 100) %>%
  tbl_df()


n_male = rbinom(1, n, 0.4862)
n_female = n - n_male

brfss_male = brfss %>% filter(sex == "Male") %>% sample_n(n_male)
brfss_female = brfss %>% filter(sex == "Female") %>% sample_n(n_female)

brfss = rbind(brfss_male, brfss_female) %>% sample_n(n)


save(brfss, file="brfss.rda")
        
