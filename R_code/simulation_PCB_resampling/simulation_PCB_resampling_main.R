# Following simulation is to test if under normal distribution, we can estimate the interaction effect unbaisly by proposed method

setwd("~/dev/projects/Chen_environmental_study/")
source("./R_code/Yang_REML.R")
source("./R_code/simulation_PCB_resampling/PCB_resampling_simulation_helpers.R")

library(sas7bdat)
library(MASS)
library(tidyverse)
library(foreach)
library(doRNG)
library(doParallel)



p <- 34
pro <- seq(0.1,0.9,0.1)
n <- round(1000*pro, 0)
combine <- FALSE
gene_args <- data.frame(pro = pro)
gene_args <- gene_args %>% split(x = ., f = seq(nrow(gene_args))) # generate a list from each row of a dataframe

result_list_fixed_fixed_main <- mapply(FUN = simulation_fn,
                                  n = n,
                                  gene_args = gene_args,
                                  MoreArgs = list(p = p,
                                                  tran_fun = null_tran,
                                                  combine = combine,
                                                  main_fixed = TRUE,
                                                  inter_fixed = TRUE,
                                                  generate_data = generate_PCB,
                                                  brep = 200,
                                                  nrep = 20,
                                                  seed = 123,
                                                  cores = 15,
                                                  interaction = 1,
                                                  interaction_m = 1),
                                  SIMPLIFY = FALSE)
save(result_list_fixed_fixed_main, file = "./result/PCB_resampling/simulation_result_list_fixed_fixed_main")


result_list_fixed_random_main <- mapply(FUN = simulation_fn,
                                   n = n,
                                   gene_args = gene_args,
                                   MoreArgs = list(p = p,
                                                   tran_fun = null_tran,
                                                   combine = combine,
                                                   main_fixed = TRUE,
                                                   inter_fixed = FALSE,
                                                   generate_data = generate_PCB,
                                                   brep = 200,
                                                   nrep = 20,
                                                   seed = 123,
                                                   cores = 15,
                                                   interaction = 1,
                                                   interaction_m = 1),
                                   SIMPLIFY = FALSE)
save(result_list_fixed_random_main, file = "./result/PCB_resampling/simulation_result_list_fixed_random_main")

result_list_random_random_main <- mapply(FUN = simulation_fn,
                                    n = n,
                                    gene_args = gene_args,
                                    MoreArgs = list(p = p,
                                                    tran_fun = null_tran,
                                                    combine = combine,
                                                    main_fixed = FALSE,
                                                    inter_fixed = FALSE,
                                                    generate_data = generate_PCB,
                                                    brep = 200,
                                                    nrep = 20,
                                                    seed = 123,
                                                    cores = 15,
                                                    interaction = 1,
                                                    interaction_m = 1),
                                    SIMPLIFY = FALSE)
save(result_list_random_random_main, file = "./result/PCB_resampling/simulation_result_list_random_random_main")

# no interaction 

result_list_fixed_fixed_main_no_interaction <- mapply(FUN = simulation_fn,
                                       n = n,
                                       gene_args = gene_args,
                                       MoreArgs = list(p = p,
                                                       tran_fun = null_tran,
                                                       combine = combine,
                                                       main_fixed = TRUE,
                                                       inter_fixed = TRUE,
                                                       generate_data = generate_PCB,
                                                       brep = 200,
                                                       nrep = 20,
                                                       seed = 123,
                                                       cores = 15,
                                                       interaction = 1,
                                                       interaction_m = 0),
                                       SIMPLIFY = FALSE)
save(result_list_fixed_fixed_main_no_interaction, file = "./result/PCB_resampling/simulation_result_list_fixed_fixed_main_no_interaction")


result_list_fixed_random_main_no_interaction <- mapply(FUN = simulation_fn,
                                        n = n,
                                        gene_args = gene_args,
                                        MoreArgs = list(p = p,
                                                        tran_fun = null_tran,
                                                        combine = combine,
                                                        main_fixed = TRUE,
                                                        inter_fixed = FALSE,
                                                        generate_data = generate_PCB,
                                                        brep = 200,
                                                        nrep = 20,
                                                        seed = 123,
                                                        cores = 15,
                                                        interaction = 1,
                                                        interaction_m = 0),
                                        SIMPLIFY = FALSE)
save(result_list_fixed_random_main_no_interaction, file = "./result/PCB_resampling/simulation_result_list_fixed_random_main_no_interaction")

result_list_random_random_main_no_interaction <- mapply(FUN = simulation_fn,
                                         n = n,
                                         gene_args = gene_args,
                                         MoreArgs = list(p = p,
                                                         tran_fun = null_tran,
                                                         combine = combine,
                                                         main_fixed = FALSE,
                                                         inter_fixed = FALSE,
                                                         generate_data = generate_PCB,
                                                         brep = 200,
                                                         nrep = 20,
                                                         seed = 123,
                                                         cores = 15,
                                                         interaction = 1,
                                                         interaction_m = 0),
                                         SIMPLIFY = FALSE)
save(result_list_random_random_main_no_interaction, file = "./result/PCB_resampling/simulation_result_list_random_random_main_no_interaction")
