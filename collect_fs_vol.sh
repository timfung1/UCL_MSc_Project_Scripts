#! /bin/bash

# WILL COATH
# 24th JAN 2023
# CALLS PYTHON SCRIPT

date_stamp=`date +"%Y%m%d%H%M%S"`
echo $date_stamp
export PATH=/var/drc/software/64bit/anaconda-4.4.0-py27/bin:${PATH}
data_root=/data/msc-scratch/tfung

#scripts
stats_script=${data_root}/scripts/fs_vol_stats.py
echo $stats_script

#csv header, needs to match tau_suvr_roi_stats_left-right.py
HEADER="subject,session,metric,Braak Stage 1,Braak Stage 2,Braak Stage 3,Braak Stage 4,Braak Stage 5,Braak Stage 6,Braak Stage_1_2,Braak Stage_3_4,Braak Stage_5_6,Brain Stem,CC_Anterior,CC_Central,CC_Mid_Anterior,CC_Mid_Posterior,CC_Posterior,CSF,Fourth Ventricle,L Braak Stage 1,L Braak Stage 2,L Braak Stage 3,L Braak Stage 4,L Braak Stage 5,L Braak Stage 6,L Braak Stage_1_2,L Braak Stage_3_4,L Braak Stage_5_6,Left Accumbens area,Left Amygdala,Left Caudate,Left Cerebellum Cortex,Left Cerebellum White Matter,Left Cerebral White Matter,Left Hippocampus,Left Inf Lat Vent,Left Lateral Ventricle,Left Pallidum,Left Putamen,Left Thalamus Proper,Left VentralDC,Left choroid plexus,Left vessel,Optic Chiasm,R Braak Stage 1,R Braak Stage 2,R Braak Stage 3,R Braak Stage 4,R Braak Stage 5,R Braak Stage 6,R Braak Stage_1_2,R Braak Stage_3_4,R Braak Stage_5_6,Right Accumbens area,Right Amygdala,Right Caudate,Right Cerebellum Cortex,Right Cerebellum White Matter,Right Cerebral White Matter,Right Hippocampus,Right Inf Lat Vent,Right Lateral Ventricle,Right Pallidum,Right Putamen,Right Thalamus Proper,Right VentralDC,Right choroid plexus,Third Ventricle,WM hypointensities,lh_bankssts,lh_caudalanteriorcingulate,lh_caudalmiddlefrontal,lh_cuneus,lh_entorhinal,lh_frontalpole,lh_fusiform,lh_inferiorparietal,lh_inferiortemporal,lh_insula,lh_isthmuscingulate,lh_lateraloccipital,lh_lateralorbitofrontal,lh_lingual,lh_medialorbitofrontal,lh_middletemporal,lh_paracentral,lh_parahippocampal,lh_parsopercularis,lh_parsorbitalis,lh_parstriangularis,lh_pericalcarine,lh_postcentral,lh_posteriorcingulate,lh_precentral,lh_precuneus,lh_rostralanteriorcingulate,lh_rostralmiddlefrontal,lh_superiorfrontal,lh_superiorparietal,lh_superiortemporal,lh_supramarginal,lh_temporalpole,lh_transversetemporal,not assigned,rh_bankssts,rh_caudalanteriorcingulate,rh_caudalmiddlefrontal,rh_cuneus,rh_entorhinal,rh_frontalpole,rh_fusiform,rh_inferiorparietal,rh_inferiortemporal,rh_insula,rh_isthmuscingulate,rh_lateraloccipital,rh_lateralorbitofrontal,rh_lingual,rh_medialorbitofrontal,rh_middletemporal,rh_paracentral,rh_parahippocampal,rh_parsopercularis,rh_parsorbitalis,rh_parstriangularis,rh_pericalcarine,rh_postcentral,rh_posteriorcingulate,rh_precentral,rh_precuneus,rh_rostralanteriorcingulate,rh_rostralmiddlefrontal,rh_superiorfrontal,rh_superiorparietal,rh_superiortemporal,rh_supramarginal,rh_temporalpole,rh_transversetemporal"


echo "COLLECTING VOL FROM T1 SPACED"
OUT_FILE=${data_root}/output/stats/FAD_fs_vol_stats_${date_stamp}.csv
echo $HEADER > $OUT_FILE

for LAB in `ls ${data_root}/data/FAD*/ses*/anat/freesurfer_6*/mri/aparc+aseg.nii.gz` ;  do 
    sub=`echo $LAB | cut -d / -f 6`
    ses=`echo $LAB | cut -d / -f 7`
    echo $sub $ses
    SCRATCH_OUT=`mktemp volstats.XXXXXX`
    python $stats_script ${LAB} --out ${SCRATCH_OUT}
    echo "${sub},${ses},volume,"`cat ${SCRATCH_OUT}` >> ${OUT_FILE}
    rm ${SCRATCH_OUT}

done 

echo "DONE"
