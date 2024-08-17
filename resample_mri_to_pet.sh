#! /bin/bash

#script for registering freesurfer labs to tau PET space

data_root=/data/msc-scratch/tfung

for ses_path in `ls -d ${data_root}/data/FAD-*/ses-*` ; do
 
  ses=`basename ${ses_path}`
  echo ${ses}

  sub=`echo $ses_path | cut -d / -f 6`
  echo ${sub}
  
  #check T1 exists
  fs_t1=${ses_path}/anat/freesurfer_6_*/mri/T1.nii.gz
  
  if [ -f $fs_t1 ]; then
     echo "T1 scan exists."
     fs_t1=`ls ${fs_t1}`
     #find freesurfer labels
     fs_par=${fs_t1/T1.nii.gz/aparc+aseg.nii.gz}
     
     #find matching GIF labels
     #get session date from orignal mri in data
     #use this to match to relevant gif files
     date_str=`ls ${ses_path}/anat/*_t1_anat.nii.gz`
     date_str=`basename $date_str | cut -d _ -f 2`
     gif_path=${data_root}/output/gifv2_labels/${sub}_${date_str}_t1_anat
     gif_ref=`ls ${gif_path}/*_inf-cereb-gm_cleaned.nii.gz`
     gif_t1_biasc=`ls ${gif_path}/*_BiasCorrected.nii.gz`
     
     #find nac and ac PET
     nac_pet=`ls ${ses_path}/pet/*rec-nac*.nii.gz`
     ac_pet=`ls ${ses_path}/pet/*rec-ac*.nii.gz`
     
     #output directory
     out_dir=${data_root}/output/labels_pet_space
     mkdir -p ${out_dir}/${sub}/${ses}/anat
     mkdir -p ${out_dir}/${sub}/${ses}/xfm

     # resample freesurfer T1 to PET space (calculate transformation parameters to align images)
     out_file=${out_dir}/${sub}/${ses}/anat/${sub}_${ses}_fs-T1_to_space-pet_res.nii.gz
     out_aff=${out_dir}/${sub}/${ses}/xfm/${sub}_${ses}_xfm_fs-T1_to_nac-pet.txt
     reg_aladin -ref ${nac_pet} -flo ${fs_t1} -rigOnly -res ${out_file} -aff ${out_aff}
     
     # next resample GIF to FS dimensions (no registration)

     fs_ref=${out_dir}/${sub}/${ses}/anat/${sub}_${ses}_gif-inf-cereb-gm_space-fs.nii.gz
     reg_resample -ref ${fs_t1} -flo ${gif_ref} -res ${fs_ref} -inter 0 
    
     fs_t1_biasc=${out_dir}/${sub}/${ses}/anat/${sub}_${ses}_gif-t1-biasc_space-fs.nii.gz
     reg_resample -ref ${fs_t1} -flo ${gif_t1_biasc} -res ${fs_t1_biasc} -inter 0

     #resample freesurfer labels to PET space 

     out_file=${out_dir}/${sub}/${ses}/anat/${sub}_${ses}_gif-inf-cereb-gm_space-pet_res.nii.gz
     reg_resample -ref ${nac_pet} -flo ${fs_ref} -res ${out_file} -trans ${out_aff} -inter 0

     out_file=${out_dir}/${sub}/${ses}/anat/${sub}_${ses}_fs-t1-biasc_space-pet_res.nii.gz
     reg_resample -ref ${nac_pet} -flo ${fs_t1_biasc} -res ${out_file} -trans ${out_aff} -inter 0

     out_file=${out_dir}/${sub}/${ses}/anat/${sub}_${ses}_fs-aparc-aseg_space-pet_res.nii.gz
     reg_resample -ref ${nac_pet} -flo ${fs_par} -res ${out_file} -trans ${out_aff} -inter 0
     echo "Done"
     echo "===================="  
  else
     echo "T1 scan does not exist."
  fi


done
