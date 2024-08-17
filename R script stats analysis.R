#################                   CREATING BILATERAL REGION WEIGHTED MEANS         ###########################

## Since one participant visited twice but had two Tau PET scans but ndata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAbElEQVR4Xs2RQQrAMAgEfZgf7W9LAguybljJpR3wEse5JOL3ZObDb4x1loDhHbBOFU6i2Ddnw2KNiXcdAXygJlwE8OFVBHDgKrLgSInN4WMe9iXiqIVsTMjH7z/GhNTEibOxQswcYIWYOR/zAjBJfiXh3jZ6AAAAAElFTkSuQmCCot two diffusion scans, the closest tau PET scan was used, with the unused PET scan removed from analysis.
## Some participants are NA, therefore are excluded in the analysis. Note that two participants have ‘NA’ rather than positive or negative status -  these have a family mutation *******.
# This mutation was decided to be classified as non-pathogenic; as such genetic status wasn’t included in these cases as it was agreed within the FAD study to not include/analyse data from these individuals in any projects.
#### file paths are removed to maintain privacy and confidentiality. They are replated with "###"

# load necessary libraries 
install.packages("tidyverse")
install.packages("ggh4x")
library(tidyverse)
library(dplyr)
library(readr)
new_id_status_info <- read_csv(###)
out_dir='###'

#### define weighted mean functions 
weighted_mean_region=function(df, region) {
  df %>%
    dplyr::select(subject,session,matches(region)) %>%
    rowwise() %>%
    mutate(weighted_mean = weighted.mean(c_across(!contains(c('volume','subject','session'))), #values (anything that doesn't contain volume in the column name, must also remove subject and session)
                                         w = c_across(contains('volume') #weighting by volume
                                         ), na.rm = TRUE),
           region = region) %>%
    dplyr::select(subject,session,region,weighted_mean)
}


#####                                         tau-volume-weighted-bilateral regions              ################# 
# load spreadsheets of volumes (replace file name with actual file name )
vol.df=read_csv(###) %>%
  #select only subject, session, metric and lh or rh columns, this removes all other regions we don't want to average
  dplyr::select(subject,session,metric,starts_with('lh_') | starts_with('rh_')) 

### remove participant line with no corresponding diffusion scan
vol.df=vol.df[-3,]

# load tau dataset
tau.df=read_csv(###) %>%
  #select only subject, session, metric and lh or rh columns, this removes all other regions we don't want to average
  dplyr::select(subject,session,metric,starts_with('lh_') | starts_with('rh_')) 

### remove participant line with no corresponding diffusion scan
tau.df=tau.df[-3,]

# combine data sets and make them wider (less rows more columns)
tau.vol.df=rbind(tau.df,vol.df) %>%
  pivot_wider(id_cols = subject:session, names_from = "metric", values_from = c(starts_with('lh_'), starts_with('rh_')))

# Get list of unique regions (debugged and changed the code to remove the sessions column)
regions=unique(sub("^.*(lh_|rh_)([^_]+)_volume.*$", "\\2", names(tau.vol.df %>%
                                                                      dplyr::select(contains('volume'),-subject:-session))))

# calculate weighted mean, using function
result_list=lapply(regions, function(region) weighted_mean_region(tau.vol.df, region)) 

# Combine the results into a single data frame
tau.bilateral.df=do.call(rbind, result_list) %>%
  pivot_wider(id_cols = subject:session,names_from = region,values_from = weighted_mean)

# add bilateral regions to tau.df
tau.df=left_join(tau.df,tau.bilateral.df)

rm(tau.bilateral.df)

#####                                         MD-volume-weighted-bilateral regions              ################# 
# load MD dataset
MD.df=read_csv(###) %>%
  #select only subject, session, metric and lh or rh columns, this removes all other regions we don't want to average
  dplyr::select(subject,session,metric,starts_with('lh_') | starts_with('rh_')) 

# combine data sets and make them wider (less rows more columns)
MD.vol.df=rbind(MD.df,vol.df) %>%
  pivot_wider(id_cols = subject:session, names_from = "metric", values_from = c(starts_with('lh_'), starts_with('rh_')))

# calculate weighted mean, using function
result_list=lapply(regions, function(region) weighted_mean_region(MD.vol.df, region)) 

# Combine the results into a single data frame
MD.bilateral.df=do.call(rbind, result_list) %>%
  pivot_wider(id_cols = subject:session,names_from = region,values_from = weighted_mean)

# add bilateral regions to tau.df
MD.df=left_join(MD.df,MD.bilateral.df)

rm(MD.bilateral.df)

#####                                         FA-volume-weighted-bilateral regions              ################# 
# load FA dataset
FA.df=read_csv(###) %>%
  #select only subject, session, metric and lh or rh columns, this removes all other regions we don't want to average
  dplyr::select(subject,session,metric,starts_with('lh_') | starts_with('rh_')) 

# combine data sets and make them wider (less rows more columns)
FA.vol.df=rbind(FA.df,vol.df) %>%
  pivot_wider(id_cols = subject:session, names_from = "metric", values_from = c(starts_with('lh_'), starts_with('rh_')))

# calculate weighted mean, using function
result_list=lapply(regions, function(region) weighted_mean_region(FA.vol.df, region)) 

# Combine the results into a single data frame
FA.bilateral.df=do.call(rbind, result_list) %>%
  pivot_wider(id_cols = subject:session,names_from = region,values_from = weighted_mean)

# add bilateral regions to tau.df
FA.df=left_join(FA.df,FA.bilateral.df)

rm(FA.bilateral.df)

#####                                         ODI-volume-weighted-bilateral regions              ################# 
# load ODI dataset
ODI.df=read_csv(###) %>%
  #select only subject, session, metric and lh or rh columns, this removes all other regions we don't want to average
  dplyr::select(subject,session,metric,starts_with('lh_') | starts_with('rh_')) 

# combine data sets and make them wider (less rows more columns)
ODI.vol.df=rbind(ODI.df,vol.df) %>%
  pivot_wider(id_cols = subject:session, names_from = "metric", values_from = c(starts_with('lh_'), starts_with('rh_')))

# calculate weighted mean, using function
result_list=lapply(regions, function(region) weighted_mean_region(ODI.vol.df, region)) 

# Combine the results into a single data frame
ODI.bilateral.df=do.call(rbind, result_list) %>%
  pivot_wider(id_cols = subject:session,names_from = region,values_from = weighted_mean)

# add bilateral regions to tau.df
ODI.df=left_join(ODI.df,ODI.bilateral.df)

rm(ODI.bilateral.df)

#####                                         NDI-volume-weighted-bilateral regions              ################# 
# load NDI dataset
NDI.df=read_csv(###) %>%
  #select only subject, session, metric and lh or rh columns, this removes all other regions we don't want to average
  dplyr::select(subject,session,metric,starts_with('lh_') | starts_with('rh_')) 

# combine data sets and make them wider (less rows more columns)
NDI.vol.df=rbind(NDI.df,vol.df) %>%
  pivot_wider(id_cols = subject:session, names_from = "metric", values_from = c(starts_with('lh_'), starts_with('rh_')))

# calculate weighted mean, using function
result_list=lapply(regions, function(region) weighted_mean_region(NDI.vol.df, region)) 

# Combine the results into a single data frame
NDI.bilateral.df=do.call(rbind, result_list) %>%
  pivot_wider(id_cols = subject:session,names_from = region,values_from = weighted_mean)

# add bilateral regions to tau.df
NDI.df=left_join(NDI.df,NDI.bilateral.df)

rm(NDI.bilateral.df)

#####                                    CTh-volume-weighted-bilateral regions                   ################# 
# load CTh dataset
CTh.df=read_csv(###) 

### change column names with: 
CTh.df=CTh.df %>% 
  rename_with(~gsub("\\.","_",.))

### remove participant line with no corresponding diffusion scan
CTh.df=CTh.df[-3,]

# combine data sets and make them wider (less rows more columns)
CTh.vol.df=rbind(CTh.df,vol.df) %>%
  pivot_wider(id_cols = subject:session, names_from = "metric", values_from = c(starts_with('lh_'), starts_with('rh_')))

# calculate weighted mean, using function
result_list=lapply(regions, function(region) weighted_mean_region(CTh.vol.df, region)) 

# Combine the results into a single data frame
CTh.bilateral.df=do.call(rbind, result_list) %>%
  pivot_wider(id_cols = subject:session,names_from = region,values_from = weighted_mean)

# add bilateral regions to tau.df
CTh.df=left_join(CTh.df,CTh.bilateral.df)

rm(CTh.bilateral.df)


#######                                             DIVIDING ODI AND NDI BY TF                        #################


#load TF file and repeat step above to get bilateral volumes 
TF.df=read_csv(###) %>%
  #select only subject, session, metric and lh or rh columns, this removes all other regions we don't want to average
  dplyr::select(subject,session,metric,starts_with('lh_') | starts_with('rh_')) 


# combine data sets and make them wider (less rows more columns)
TF.vol.df=rbind(TF.df,vol.df) %>%
  pivot_wider(id_cols = subject:session, names_from = "metric", values_from = c(starts_with('lh_'), starts_with('rh_')))

# calculate weighted mean, using function
result_list=lapply(regions, function(region) weighted_mean_region(TF.vol.df, region)) 

# Combine the results into a single data frame
TF.bilateral.df=do.call(rbind, result_list) %>%
  pivot_wider(id_cols = subject:session,names_from = region,values_from = weighted_mean)

# add bilateral regions to tau.df
TF.df=left_join(TF.df,TF.bilateral.df)

rm(TF.bilateral.df)

### dividing mean NDI*TF and mean ODI*TF measures by the mean TF 

# NDI/TF
NDI_DIVIDED=NDI.df %>%
  select(-subject, -session, -metric) %>%
  mutate(across(everything(), ~ .x / TF.df[[cur_column()]]))

NDI_TW.df=NDI.df %>%
  select(subject, session, metric) %>%
  bind_cols(NDI_DIVIDED)

rm(NDI_DIVIDED)
# ODI/TF
ODI_DIVIDED=ODI.df %>%
  select(-subject, -session, -metric) %>%
  mutate(across(everything(), ~ .x / TF.df[[cur_column()]]))

ODI_TW.df=ODI.df %>%
  select(subject, session, metric) %>%
  bind_cols(ODI_DIVIDED)

rm(ODI_DIVIDED, ODI.df, NDI.df)

#### joining datasets with ID for volume weighted 
# Define the function to join and select columns
join_and_select=function(df, id_info, key, columns_to_select) {
  selected_id_status_info=new_id_status_info %>%
    select(new_code, STATUS, Gender, taueyo1)
  
  joined_data=left_join(df, selected_id_status_info, by = setNames("new_code", key))
  result=joined_data %>%
    select(all_of(columns_to_select), everything())
  
  return(result)
}

# Specify the columns to select
columns_to_select <- c("subject", "STATUS", "session", "Gender", "taueyo1")

# Apply the function to each dataframe
tau.df <- join_and_select(tau.df, new_id_status_info, "subject", columns_to_select)
MD.df <- join_and_select(MD.df, new_id_status_info, "subject", columns_to_select)
FA.df <- join_and_select(FA.df, new_id_status_info, "subject", columns_to_select)
ODI_TW.df <- join_and_select(ODI_TW.df, new_id_status_info, "subject", columns_to_select)
NDI_TW.df <- join_and_select(NDI_TW.df, new_id_status_info, "subject", columns_to_select)
TF.df <- join_and_select(TF.df, new_id_status_info, "subject", columns_to_select)
vol.df <- join_and_select(vol.df, new_id_status_info, "subject", columns_to_select)
CTh.df <- join_and_select(CTh.df, new_id_status_info, "subject", columns_to_select)

rm(columns_to_select, join_and_select)

###### create new value for the second ROI of posterior cingulate which combines
###### posterior cingulate and isthmus cingulate
### multiply thickness by corresponding weight, sum all values, divide by sum of weights (in this case volumes)

#tau
tau.df=tau.vol.df %>%
  dplyr::select(subject, session,lh_posteriorcingulate_tau_pet, lh_posteriorcingulate_volume, 
                rh_posteriorcingulate_tau_pet,rh_posteriorcingulate_volume, lh_isthmuscingulate_tau_pet,
                lh_isthmuscingulate_volume, rh_isthmuscingulate_tau_pet, rh_isthmuscingulate_volume) %>%
  rowwise() %>%
  mutate(ROIposteriorcingulate = weighted.mean(c_across(contains('tau_pet')), # calls all thickness columns 
                                               w = c_across(contains('volume') #weighting by volume
                                               ), na.rm = TRUE)) %>%
  select(subject, session, ROIposteriorcingulate) %>%
  left_join(tau.df, .) 

#CTh
CTh.df=CTh.vol.df %>%
  dplyr::select(subject, session,lh_posteriorcingulate_thickness, lh_posteriorcingulate_volume, 
                rh_posteriorcingulate_thickness,rh_posteriorcingulate_volume, lh_isthmuscingulate_thickness,
                lh_isthmuscingulate_volume, rh_isthmuscingulate_thickness, rh_isthmuscingulate_volume) %>%
  rowwise() %>%
  mutate(ROIposteriorcingulate = weighted.mean(c_across(contains('thickness')), # calls all thickness columns 
                               w = c_across(contains('volume') #weighting by volume
                               ), na.rm = TRUE)) %>%
  select(subject, session, ROIposteriorcingulate) %>%
  left_join(CTh.df, .) 

# FA

FA.df=FA.vol.df %>%
  dplyr::select(subject, session,lh_posteriorcingulate_fa, lh_posteriorcingulate_volume, 
                rh_posteriorcingulate_fa,rh_posteriorcingulate_volume, lh_isthmuscingulate_fa,
                lh_isthmuscingulate_volume, rh_isthmuscingulate_fa, rh_isthmuscingulate_volume) %>%
  rowwise() %>%
  mutate(ROIposteriorcingulate = weighted.mean(c_across(contains('fa')), # calls all thickness columns 
                               w = c_across(contains('volume') #weighting by volume
                               ), na.rm = TRUE)) %>%
  select(subject, session, ROIposteriorcingulate) %>%
  left_join(FA.df, .) 

# MD
MD.df=MD.vol.df %>%
  dplyr::select(subject, session,lh_posteriorcingulate_md, lh_posteriorcingulate_volume, 
                rh_posteriorcingulate_md,rh_posteriorcingulate_volume, lh_isthmuscingulate_md,
                lh_isthmuscingulate_volume, rh_isthmuscingulate_md, rh_isthmuscingulate_volume) %>%
  rowwise() %>%
  mutate(ROIposteriorcingulate = weighted.mean(c_across(contains('md')), # calls all thickness columns 
                               w = c_across(contains('volume') #weighting by volume
                               ), na.rm = TRUE)) %>%
  select(subject, session, ROIposteriorcingulate) %>%
  left_join(MD.df, .) 

# NDI
NDI_TW.df=NDI.vol.df %>%
  dplyr::select(subject, session,lh_posteriorcingulate_ficvf_modulated, lh_posteriorcingulate_volume, 
                rh_posteriorcingulate_ficvf_modulated,rh_posteriorcingulate_volume, lh_isthmuscingulate_ficvf_modulated,
                lh_isthmuscingulate_volume, rh_isthmuscingulate_ficvf_modulated, rh_isthmuscingulate_volume) %>%
  rowwise() %>%
  mutate(ROIposteriorcingulate = weighted.mean(c_across(contains('ficvf_modulated')), # calls all thickness columns 
                               w = c_across(contains('volume') #weighting by volume
                               ), na.rm = TRUE)) %>%
  select(subject, session, ROIposteriorcingulate) %>%
  left_join(NDI_TW.df, .) 


# ODI_TW
ODI_TW.df=ODI.vol.df %>%
  dplyr::select(subject, session,lh_posteriorcingulate_odi_modulated, lh_posteriorcingulate_volume, 
                rh_posteriorcingulate_odi_modulated,rh_posteriorcingulate_volume, lh_isthmuscingulate_odi_modulated,
                lh_isthmuscingulate_volume, rh_isthmuscingulate_odi_modulated, rh_isthmuscingulate_volume) %>%
  rowwise() %>%
  mutate(ROIposteriorcingulate = weighted.mean(c_across(contains('odi_modulated')), # calls all thickness columns 
                               w = c_across(contains('volume') #weighting by volume
                               ), na.rm = TRUE)) %>%
  select(subject, session, ROIposteriorcingulate) %>%
  left_join(ODI_TW.df, .) 

# TF
TF.df=TF.vol.df %>%
  dplyr::select(subject, session,lh_posteriorcingulate_fiso_TF, lh_posteriorcingulate_volume, 
                rh_posteriorcingulate_fiso_TF,rh_posteriorcingulate_volume, lh_isthmuscingulate_fiso_TF,
                lh_isthmuscingulate_volume, rh_isthmuscingulate_fiso_TF, rh_isthmuscingulate_volume) %>%
  rowwise() %>%
  mutate(ROIposteriorcingulate = weighted.mean(c_across(contains('fiso_TF')), # calls all thickness columns 
                                               w = c_across(contains('volume') #weighting by volume
                                               ), na.rm = TRUE)) %>%
  select(subject, session, ROIposteriorcingulate) %>%
  left_join(TF.df, .) 


rm(tau.vol.df, MD.vol.df, FA.vol.df, ODI.vol.df, NDI.vol.df, TF.vol.df, CTh.vol.df, result_list, regions)

#### multiply all MD values by 1000 to make it easier to see 
MD.df= MD.df %>% mutate_if(is.numeric, ~ . * 1000)



#######           # ADD BRAAK STAGES TO DATASETS, MAKE SURE TO TISSUE WEIGHT THE ODI AND NDI METRICS!                    ##############

# tau PET
tau.braak.df=read_csv(###) %>%
  dplyr::select(starts_with('Braak'))
tau.braak.df=tau.braak.df[-3,]
tau.df=cbind(tau.df, tau.braak.df)
rm(tau.braak.df)

# FA
FA.braak.df=read_csv(###) %>%
  dplyr::select(starts_with('Braak'))
FA.df=cbind(FA.df, FA.braak.df)
rm(FA.braak.df)

# MD
MD.braak.df=read_csv(###) %>%
  dplyr::select(starts_with('Braak'))
MD.braak.df= MD.braak.df %>% mutate_if(is.numeric, ~ . * 1000)
MD.df=cbind(MD.df, MD.braak.df)
rm(MD.braak.df)

#######                             Tissue-weighted ODI and NDI braak stages                        ###############
# TF
TF.braak.df=read_csv(###) %>%
  dplyr::select(starts_with('Braak'))

# NDI
NDI.braak.df=read_csv(###) %>%
  dplyr::select(starts_with('Braak'))

# ODI
ODI.braak.df=read_csv(###) %>%
  dplyr::select(starts_with('Braak'))


### dividing mean NDI_TF and mean ODI_TF measures by the mean TF 

# NDI/TF
NDI.braak.df=NDI.braak.df %>%
  mutate(across(everything(), ~ .x / TF.braak.df[[cur_column()]]))
NDI_TW.df=cbind(NDI_TW.df, NDI.braak.df)
rm(NDI.braak.df)
# ODI/TF
ODI.braak.df=ODI.braak.df %>%
  mutate(across(everything(), ~ .x / TF.braak.df[[cur_column()]]))
ODI_TW.df=cbind(ODI_TW.df, ODI.braak.df)
rm(ODI.braak.df)

#TF
TF.df=cbind(TF.df, TF.braak.df)
rm(TF.braak.df)


### MANUAL ADDITION OF BRAAK STAGES TO THE CTh DATASETS

CThbraakstage3and4 <- ((CTh.df$parahippocampal + CTh.df$fusiform + CTh.df$lingual + CTh.df$middletemporal + CTh.df$caudalanteriorcingulate + CTh.df$rostralanteriorcingulate + CTh.df$posteriorcingulate + CTh.df$isthmuscingulate + CTh.df$insula + CTh.df$inferiortemporal + CTh.df$temporalpole) / 11)
CTh.df$"Braak Stage_3_4" <- CThbraakstage3and4
rm(CThbraakstage3and4)

CThbraakstage5and6 <- ((CTh.df$superiorfrontal + CTh.df$lateralorbitofrontal + CTh.df$medialorbitofrontal + CTh.df$frontalpole + CTh.df$caudalmiddlefrontal + CTh.df$rostralmiddlefrontal + CTh.df$parsopercularis + CTh.df$parsorbitalis + CTh.df$parstriangularis + CTh.df$lateraloccipital + CTh.df$supramarginal + CTh.df$inferiorparietal + CTh.df$superiortemporal + CTh.df$superiorparietal + CTh.df$precuneus + CTh.df$bankssts + CTh.df$transversetemporal + CTh.df$pericalcarine + CTh.df$postcentral + CTh.df$cuneus + CTh.df$precentral + CTh.df$paracentral) / 22)
CTh.df$"Braak Stage_5_6" <- CThbraakstage5and6
rm(CThbraakstage5and6)

rm(new_id_status_info, weighted_mean_region)


#####                                             ACTUAL ANALYSIS PLAN                                  ##############  

### The 5 ROIs REPEAT FOR EACH METRIC vs Tau PET
# (1) $precuneus
# (2) $ROIposteriorcingulate
# (3) tau.braak.df$`Braak Stage 1` #### this equates to braak I and II since we are not using the HPC
# (4) tau.braak.df$`Braak Stage_3_4` #### medial temporal lobe structures
# (5) tau.braak.df$`Braak Stage_5_6` ####

##################### REMOVE WHEN DONE
### first test whether there is a difference in Tau SUVR between MC and non-MC 

###### means 
# Function to check normality and choose appropriate test
#choose_statistical_test <- function(x, y) {
  # Shapiro-Wilk test for normality
#  shapiro_x <- shapiro.test(x)
#  shapiro_y <- shapiro.test(y)
  
#  if (shapiro_x$p.value > 0.05 & shapiro_y$p.value > 0.05) {
#    cat("Both variables are normally distributed. Use t-test.\n")
#    return(t.test(x, y))
#  } else {
#    cat("At least one variable is not normally distributed. Use Wilcoxon test.\n")
#    return(wilcox.test(x, y))
#  }
#}

#result <- choose_statistical_test()
#print(result)
#rm(choose_statistical_test)

##### difference in tau SUVR. ses-1 only. 

mutation = tau.df %>%
  filter(STATUS== "Positive", session=="ses-1")
n.mutation = tau.df %>%
  filter(STATUS== "Negative", session=="ses-1")
wilcox.test(mutation$precuneus, n.mutation$precuneus, exact=T)
wilcox.test(mutation$ROIposteriorcingulate, n.mutation$ROIposteriorcingulate, exact=T)
wilcox.test(mutation$`Braak Stage 1`, n.mutation$`Braak Stage 1`, exact=T)
wilcox.test(mutation$`Braak Stage_3_4`, n.mutation$`Braak Stage_3_4`, exact=T)
wilcox.test(mutation$`Braak Stage_5_6`, n.mutation$`Braak Stage_5_6`, exact=T)
rm(mutation,n.mutation)

wilcox.test(mutation$pBS5_6, n.mutation$pBS5_6, exact=T)

#### visualise the differences 
library(ggh4x)
tauSUVRplots= tau.df %>%
  filter(!is.na(STATUS), session=="ses-1") %>%
  select("subject", "STATUS", "session", "precuneus", "ROIposteriorcingulate", "Braak Stage 1", "Braak Stage_3_4", "Braak Stage_5_6") %>%
  pivot_longer(cols = precuneus:"Braak Stage_5_6", names_to = "region", values_to = "tau SUVR")
tauSUVRplots$region=factor(tauSUVRplots$region, levels = c("precuneus", "ROIposteriorcingulate", "Braak Stage 1", "Braak Stage_3_4", "Braak Stage_5_6"),
                           labels = c("Precuneus", "Posterior Cingulate", "Braak Stage 1", "Braak Stage_3_4", "Braak Stage_5_6"))

design <- c(
  "
##AABB##
#CCDDEE#
"
)


### boxplots showing session 1 only! 
custom_colours=c("Negative" = "#F8766D", "Positive" = "#00BFC4" )

boxplot=tauSUVRplots %>% ggplot(aes(x = STATUS, y = `tau SUVR`, fill = STATUS)) +
  geom_boxplot (aes(group = STATUS)) + 
  labs(y = "Tau SUVR") +
  scale_fill_manual(values = custom_colours) +
  theme(axis.title.x = element_text(size = 10))
png(file.path(out_dir,"boxplots.png"), res = 600, units = "in", width=6, height=5) ### change all instances of png to pdf (remove res), 
boxplot + ggh4x::facet_manual( ~ region, design = design)
dev.off()
print(boxplot)

rm(custom_colours)
#### Spaghetti plots 

#### visualise the differences 
library(ggh4x)
tauSUVRplots= tau.df %>%
  filter(!is.na(STATUS)) %>%
  select("subject", "STATUS", "session", "precuneus", "ROIposteriorcingulate", "Braak Stage 1", "Braak Stage_3_4", "Braak Stage_5_6") %>%
  pivot_longer(cols = precuneus:"Braak Stage_5_6", names_to = "region", values_to = "tau SUVR")
tauSUVRplots$region=factor(tauSUVRplots$region, levels = c("precuneus", "ROIposteriorcingulate", "Braak Stage 1", "Braak Stage_3_4", "Braak Stage_5_6"),
                           labels = c("Precuneus", "Posterior Cingulate", "Braak Stage 1", "Braak Stage_3_4", "Braak Stage_5_6"))
 

tauSUVR_diff=tauSUVRplots %>% ggplot(aes(x = session, y = `tau SUVR`, group = subject, col = STATUS)) + 
  geom_point(size = 0.75) +
  geom_line() +
  theme(axis.title.x = element_text(size = 10)) + 
  labs(x = "Session",y = "Tau SUVR") 
png(file.path(out_dir,"tauSUVRdifference.png"), res = 600, units = "in", width=6, height=5) ### change all instances of png to pdf (remove res), 
tauSUVR_diff + ggh4x::facet_manual( ~ region, design = design)
dev.off()

print(tauSUVR_diff)



#####                   COMBINING THE NECESSARY TWO METRICS TOGETHER TO RUN CORRELATION ANALYSIS                #############
### check whether to use spearmans or pearson's correlation! 
## Function to check normality and choose correlation test. use Shapiro-Wilk test, p value less than 0.05 means dataset
#choose_correlation_test <- function(x, y) {
  # Shapiro-Wilk test for normality
#  shapiro_x <- shapiro.test(x)
#  shapiro_y <- shapiro.test(y)
  
#  if (shapiro_x$p.value > 0.05 & shapiro_y$p.value > 0.05) {
 #   cat("Both variables are normally distributed. Use Pearson's correlation.\n")
 #   return(cor.test(x, y, method = "pearson"))
 # } else {
 #   cat("At least one variable is not normally distributed. Use Spearman's correlation.\n")
#    return(cor.test(x, y, method = "spearman"))
#  }
#}
# Check which test to apply 
#result <- choose_correlation_test(ODI_TW.mutation.df$precuneus, tau.mutation.df$precuneus)
#print(result)

# Since at least one dataset shows significance from the Shapiro wilk test, to be consistent, 
# all analysis will be performed with SPEARMANS 


# (1) 
# Function to perform Spearman's correlation and return rho and p-value
get_correlation_results <- function(TAU_data, metric_data, metric_name) {
  result <- data.frame(
    Metric = metric_name,
    ROI = c("Precuneus", "Posterior Cingulate", "Braak Stage I", "Braak Stage III & IV", "Braak Stage V & VI", "pBS5_6"),
    rho = c(
      cor(TAU_data$precuneus, metric_data$precuneus, method = "spearman"),
      cor(TAU_data$ROIposteriorcingulate, metric_data$ROIposteriorcingulate, method = "spearman"),
      cor(TAU_data$`Braak Stage 1`, metric_data$`Braak Stage 1`, method = "spearman"),
      cor(TAU_data$`Braak Stage_3_4`, metric_data$`Braak Stage_3_4`, method = "spearman"),
      cor(TAU_data$`Braak Stage_5_6`, metric_data$`Braak Stage_5_6`, method = "spearman"),
      cor(TAU_data$`pBS5_6`, metric_data$`pBS5_6`, method = "spearman"),
    ),
    p_value = c(
      cor.test(TAU_data$precuneus, metric_data$precuneus, method = "spearman")$p.value,
      cor.test(TAU_data$ROIposteriorcingulate, metric_data$ROIposteriorcingulate, method = "spearman")$p.value,
      cor.test(TAU_data$`Braak Stage 1`, metric_data$`Braak Stage 1`, method = "spearman")$p.value,
      cor.test(TAU_data$`Braak Stage_3_4`, metric_data$`Braak Stage_3_4`, method = "spearman")$p.value,
      cor.test(TAU_data$`Braak Stage_5_6`, metric_data$`Braak Stage_5_6`, method = "spearman")$p.value,
      cor.test(TAU_data$`pBS5_6`, metric_data$`pBS5_6`, method = "spearman")$p.value,
    )
  )
  return(result)
}

# Prepare the TAU data
TAU <- tau.df %>%
  filter(session == "ses-1", STATUS == "Positive")


# ODI correlations
ODI <- ODI_TW.df %>%
  filter(session == "ses-1", STATUS == "Positive")
ODI_correlation_results <- get_correlation_results(TAU, ODI, "ODI")
ODI_correlation_results <- ODI_correlation_results %>%
  mutate(
    annotation = paste0("Rho = ", signif(rho, 3), ", p = ", signif(p_value, 3))
  )


# NDI correlations
NDI <- NDI_TW.df %>%
  filter(session == "ses-1", STATUS == "Positive")
NDI_correlation_results <- get_correlation_results(TAU, NDI, "NDI")
NDI_correlation_results <- NDI_correlation_results %>%
  mutate(
    annotation = paste0("Rho = ", signif(rho, 3), ", p = ", signif(p_value, 3))
  )

# TF correlations
TF <- TF.df %>%
  filter(session == "ses-1", STATUS == "Positive")
TF_correlation_results <- get_correlation_results(TAU, TF, "TF")
TF_correlation_results <- TF_correlation_results %>%
  mutate(
    annotation = paste0("Rho = ", signif(rho, 3), ", p = ", signif(p_value, 3))
  )

# MD correlations (set `exact = FALSE`)
MD <- MD.df %>%
  filter(session == "ses-1", STATUS == "Positive")
MD_correlation_results <- get_correlation_results(TAU, MD, "MD")
MD_correlation_results <- MD_correlation_results %>%
  mutate(
    annotation = paste0("Rho = ", signif(rho, 3), ", p = ", signif(p_value, 3))
  )


# CTh correlations (set `exact = FALSE`)
CTh <- CTh.df %>%
  filter(session == "ses-1", STATUS == "Positive")
CTh_correlation_results <- data.frame(
  Metric = "CTh",
  ROI = c("Precuneus", "Posterior Cingulate", "Braak Stage I", "Braak Stage III & IV", "Braak Stage V & VI"),
  rho = c(
    cor(TAU$precuneus, CTh$precuneus, method = "spearman"),
    cor(TAU$ROIposteriorcingulate, CTh$ROIposteriorcingulate, method = "spearman"),
    cor(TAU$`Braak Stage 1`, CTh$entorhinal, method = "spearman"),
    cor(TAU$`Braak Stage_3_4`, CTh$`Braak Stage_3_4`, method = "spearman"),
    cor(TAU$`Braak Stage_5_6`, CTh$`Braak Stage_5_6`, method = "spearman")
  ),
  p_value = c(
    cor.test(TAU$precuneus, CTh$precuneus, method = "spearman", exact = FALSE)$p.value,
    cor.test(TAU$ROIposteriorcingulate, CTh$ROIposteriorcingulate, method = "spearman", exact = FALSE)$p.value,
    cor.test(TAU$`Braak Stage 1`, CTh$entorhinal, method = "spearman", exact = FALSE)$p.value,
    cor.test(TAU$`Braak Stage_3_4`, CTh$`Braak Stage_3_4`, method = "spearman", exact = FALSE)$p.value,
    cor.test(TAU$`Braak Stage_5_6`, CTh$`Braak Stage_5_6`, method = "spearman", exact = FALSE)$p.value
  )
)
CTh_correlation_results <- CTh_correlation_results %>%
  mutate(
    annotation = paste0("Rho = ", signif(rho, 3), ", p = ", signif(p_value, 3))
  )

rm(ODI, NDI, TF, MD, CTh, TAU)

########                                SCATTERPLOT CREATION WITH BOTH MC AND NON-MC                     ##########


#### general save for plots! 
#p=ggplot(TAUvsODI.mutation.df, aes(x=precuneus_tau_pet, y=precuneus_odi_modulated)) + geom_point(color = "turquoise1", size = 2, shape=16, stroke=1.5) + geom_smooth(method = "lm", color = "red", se = FALSE) + labs(title = "Precuneus", x = "Tau SUVR", y= "ODI") + theme_classic() + theme(plot.title = element_text(size = 20, face = "bold", hjust=0.5, colour = "black"), axis.title.x = element_text(size = 18, face= "bold"), axis.title.y = element_text(size=18, face = "bold"), axis.text.x = element_text(size = 15), axis.text.y = element_text(size = 15))
#out_dir='C:\\Users\\zcbthtf\\OneDrive - University College London\\UCL\\MSc in Dementia, Causes Treatments and Research\\CLNE0037 Research Project MSC Dementia (Neuroscience)'
#png(paste0(out_dir,"\\test.png"), res=600, units = "in",width=6, height=5) ### change all instances ofpng to pdf (remove res), 
#p 
#dev.off()

##### get all dataframes
df1=tau.df %>%
  filter(!is.na(STATUS), session=="ses-1") %>%
  select(subject, STATUS, session, metric, precuneus, ROIposteriorcingulate, `Braak Stage 1`, `Braak Stage_3_4`, `Braak Stage_5_6`) 

# replace this dataframe with necessary metrics 
df2=ODI_TW.df %>%
  filter(!is.na(STATUS), session=="ses-1") %>%
  select(subject, STATUS, session, metric, precuneus, ROIposteriorcingulate, `Braak Stage 1`, `Braak Stage_3_4`, `Braak Stage_5_6`) 

df3=NDI_TW.df %>%
  filter(!is.na(STATUS), session=="ses-1") %>%
  select(subject, STATUS, session, metric, precuneus, ROIposteriorcingulate, `Braak Stage 1`, `Braak Stage_3_4`, `Braak Stage_5_6`) 

df4=TF.df %>%
  filter(!is.na(STATUS), session=="ses-1") %>%
  select(subject, STATUS, session, metric, precuneus, ROIposteriorcingulate, `Braak Stage 1`, `Braak Stage_3_4`, `Braak Stage_5_6`) 

df5=MD.df %>%
  filter(!is.na(STATUS), session=="ses-1") %>%
  select(subject, STATUS, session, metric, precuneus, ROIposteriorcingulate, `Braak Stage 1`, `Braak Stage_3_4`, `Braak Stage_5_6`) 

df6=CTh.df %>%
  filter(!is.na(STATUS), session=="ses-1") %>%
  select(subject, STATUS, session, metric, precuneus, ROIposteriorcingulate, `entorhinal`, `Braak Stage_3_4`, `Braak Stage_5_6`) %>%
  rename(`Braak Stage 1` = entorhinal)


# Combine and reshape the data 
Tau_vs_metrics=bind_rows(df1,df2,df3,df4,df5,df6) %>%
  pivot_longer(cols = c(precuneus, ROIposteriorcingulate, `Braak Stage 1`, `Braak Stage_3_4`, `Braak Stage_5_6`),
               names_to = "region", values_to = "value") %>%
  pivot_wider(names_from = metric, values_from = value)
Tau_vs_metrics$region=factor(Tau_vs_metrics$region, levels = c("precuneus", "ROIposteriorcingulate", "Braak Stage 1", "Braak Stage_3_4", "Braak Stage_5_6"),
                       labels = c("Precuneus", "Posterior Cingulate", "Braak Stage I", "Braak Stage III & IV", "Braak Stage V & VI"))

rm(df1,df2,df3,df4,df5,df6)


### generate scatterplot designs 
scatterplotdesign <- c(
  "
A
B
C
D
E
"
)

###### TAU VS ODI #####
ROISTATS=c(
  "Precuneus" = "Precuneus
  (Rho = 0.035   p = 0.921)",
  "Posterior Cingulate" = "Posterior Cingulate 
  (Rho = 0.196   p = 0.543)",
  "Braak Stage I" = "Braak Stage I
  (Rho = 0.371   p = 0.237)",
  "Braak Stage III & IV" = "Braak Stage III & IV
  (Rho = 0.014   p = 0.974)", 
  "Braak Stage V & VI" = "Braak Stage V & VI 
  (Rho = -0.476   p = 0.121)")

TauvsODI_scat=ggplot() + 
  # Plot the points for STATUS = "Positive"
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Positive"),
             aes(x = tau_pet, y = odi_modulated, col = STATUS, group = subject),
             size = 1) + 
  # Add the linear model line for STATUS = "Positive"
  geom_smooth(data = subset(Tau_vs_metrics, STATUS == "Positive"),
              aes(x = tau_pet, y = odi_modulated),
              method = "lm",
              se = F,
              color = "#00BFC4",
              linetype = "solid") +
  # Add non-MC data 
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Negative"),
             aes(x = tau_pet, y = odi_modulated, col = STATUS, group = subject),
             size = 1) + 
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none", plot.margin = unit(c(0.5,1,0.5,0.25), "cm")) +
  labs(x = "Tau SUVR", y = "ODI", title = "Tau PET vs ODI") +
png(file.path(out_dir,"tauvsODIscatterplot.png"), res = 600, units = "in", width=4, height=10) ### change all instances of png to pdf (remove res), 
TauvsODI_scat + ggh4x::facet_manual( ~ region, design = scatterplotdesign, scales = "free",
                                     labeller = labeller(region = ROISTATS))
dev.off()


###### TAU VS NDI #####
ROISTATS=c(
  "Precuneus" = "Precuneus
  (Rho = -0.441   p = 0.154)",
  "Posterior Cingulate" = "Posterior Cingulate 
  (Rho = 0.154   p = 0.635)",
  "Braak Stage I" = "Braak Stage I
  (Rho = -0.385   p = 0.218)",
  "Braak Stage III & IV" = "Braak Stage III & IV
  (Rho = -0.322   p = 0.308)", 
  "Braak Stage V & VI" = "Braak Stage V & VI 
  (Rho = -0.580   p = 0.052)")

TauvsNDI_scat=ggplot() + 
  # Plot the points for STATUS = "Positive"
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Positive"),
             aes(x = tau_pet, y = ficvf_modulated, col = STATUS, group = subject),
             size = 1) + 
  # Add the linear model line for STATUS = "Positive"
  geom_smooth(data = subset(Tau_vs_metrics, STATUS == "Positive"),
              aes(x = tau_pet, y = ficvf_modulated),
              method = "lm",
              se = F,
              color = "#00BFC4",
              linetype = "solid") +
  # Add non-MC data 
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Negative"),
             aes(x = tau_pet, y = ficvf_modulated, col = STATUS, group = subject),
             size = 1) + 
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none", plot.margin = unit(c(0.5,1,0.5,0.25), "cm")) +
  labs(x = "Tau SUVR", y = "NDI", title = "Tau PET vs NDI") +
  png(file.path(out_dir,"tauvsNDIscatterplot.png"), res = 600, units = "in", width=4, height=10) ### change all instances of png to pdf (remove res), 
TauvsNDI_scat + ggh4x::facet_manual( ~ region, design = scatterplotdesign, scales = "free",
                                     labeller = labeller(region = ROISTATS))
dev.off()

###### TAU VS TF #####
ROISTATS=c(
  "Precuneus" = "Precuneus
  (Rho = -0.084   p = 0.800)",
  "Posterior Cingulate" = "Posterior Cingulate 
  (Rho = -0.098   p = 0.766)",
  "Braak Stage I" = "Braak Stage I
  (Rho = -0.098   p = 0.766)",
  "Braak Stage III & IV" = "Braak Stage III & IV
  (Rho = -0.133   p = 0.683)", 
  "Braak Stage V & VI" = "Braak Stage V & VI 
  (Rho = -0.126   p = 0.700)")

TauvsTF_scat=ggplot() + 
  # Plot the points for STATUS = "Positive"
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Positive"),
             aes(x = tau_pet, y = fiso_TF, col = STATUS, group = subject),
             size = 1) + 
  # Add the linear model line for STATUS = "Positive"
  geom_smooth(data = subset(Tau_vs_metrics, STATUS == "Positive"),
              aes(x = tau_pet, y = fiso_TF),
              method = "lm",
              se = F,
              color = "#00BFC4",
              linetype = "solid") +
  # Add non-MC data 
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Negative"),
             aes(x = tau_pet, y = fiso_TF, col = STATUS, group = subject),
             size = 1) + 
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none", plot.margin = unit(c(0.5,1,0.5,0.25), "cm")) +
  labs(x = "Tau SUVR", y = "TF", title = "Tau PET vs TF") +
  png(file.path(out_dir,"tauvsTFscatterplot.png"), res = 600, units = "in", width=4, height=10) ### change all instances of png to pdf (remove res), 
TauvsTF_scat + ggh4x::facet_manual( ~ region, design = scatterplotdesign, scales = "free",
                                     labeller = labeller(region = ROISTATS))
dev.off()


###### TAU VS MD
ROISTATS=c(
  "Precuneus" = "Precuneus
  (Rho = 0.161   p = 0.618)",
  "Posterior Cingulate" = "Posterior Cingulate 
  (Rho = 0.063   p = 0.846)",
  "Braak Stage I" = "Braak Stage I
  (Rho = -0.270   p = 0.397)",
  "Braak Stage III & IV" = "Braak Stage III & IV
  (Rho = 0.0   p = 1.0)", 
  "Braak Stage V & VI" = "Braak Stage V & VI 
  (Rho = 0.263   p = 0.409)")

TauvsMD_scat=ggplot() + 
  # Plot the points for STATUS = "Positive"
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Positive"),
             aes(x = tau_pet, y = md, col = STATUS, group = subject),
             size = 1) + 
  # Add the linear model line for STATUS = "Positive"
  geom_smooth(data = subset(Tau_vs_metrics, STATUS == "Positive"),
              aes(x = tau_pet, y = md),
              method = "lm",
              se = F,
              color = "#00BFC4",
              linetype = "solid") +
  # Add non-MC data 
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Negative"),
             aes(x = tau_pet, y = md, col = STATUS, group = subject),
             size = 1) + 
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none", plot.margin = unit(c(0.5,1,0.5,0.25), "cm")) +
  labs(x = "Tau SUVR", y = expression("MD (mm"^2 * "/s x 10"^-3 * ")"), title = "Tau PET vs MD") +
  png(file.path(out_dir,"tauvsMDscatterplot.png"), res = 600, units = "in", width=4, height=10) ### change all instances of png to pdf (remove res), 
TauvsMD_scat + ggh4x::facet_manual( ~ region, design = scatterplotdesign, scales = "free",
                                    labeller = labeller(region = ROISTATS))
dev.off()



###### TAU VS CTh #####
ROISTATS=c(
  "Precuneus" = "Precuneus
  (Rho = -0.629   p = 0.028)",
  "Posterior Cingulate" = "Posterior Cingulate 
  (Rho = -0.140   p = 0.966)",
  "Braak Stage I" = "Braak Stage I
  (Rho = 0.203   p = 0.527)",
  "Braak Stage III & IV" = "Braak Stage III & IV
  (Rho = -0.060   p = 0.863)", 
  "Braak Stage V & VI" = "Braak Stage V & VI 
  (Rho = -0.154   p = 0.633)")

TauvsCTh_scat=ggplot() + 
  # Plot the points for STATUS = "Positive"
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Positive"),
             aes(x = tau_pet, y = thickness, col = STATUS, group = subject),
             size = 1) + 
  # Add the linear model line for STATUS = "Positive"
  geom_smooth(data = subset(Tau_vs_metrics, STATUS == "Positive"),
              aes(x = tau_pet, y = thickness),
              method = "lm",
              se = F,
              color = "#00BFC4",
              linetype = "solid") +
  # Add non-MC data 
  geom_point(data = subset(Tau_vs_metrics, STATUS == "Negative"),
             aes(x = tau_pet, y = thickness, col = STATUS, group = subject),
             size = 1) + 
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none", plot.margin = unit(c(0.5,1,0.5,0.25), "cm")) +
  labs(x = "Tau SUVR", y = "CTh (mm)", title = "Tau PET vs CTh") +
  png(file.path(out_dir,"tauvsCThscatterplot.png"), res = 600, units = "in", width=4, height=10) ### change all instances of png to pdf (remove res), 
TauvsCTh_scat + ggh4x::facet_manual( ~ region, design = scatterplotdesign, scales = "free",
                                    labeller = labeller(region = ROISTATS))
dev.off()



###################### HANDY CODE SNIPPETS ######################################################

plot_build <- ggplot_build(TauvsODI_scat)

# Extract colors used
colors_used <- plot_build$data[[1]]$colour

# View the colors
print(colors_used)

"#00BFC4"
"#F8766D"