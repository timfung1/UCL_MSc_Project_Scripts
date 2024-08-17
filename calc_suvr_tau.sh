#!/bin/bash

#will coath
#06-06-2024

#calculate SUVR image from tau PET

echo calulating SUVR

#assigning input to variables

data_root=/data/msc-scratch/tfung

for pet_path in `ls ${data_root}/data/FAD*/ses*/pet/*rec-ac*.nii.gz`; do
	sub=`basename $pet_path | cut -d _ -f 1 | cut -d '-' -f 2-3`
	ses=`basename $pet_path | cut -d _ -f 2`
	
	#create outdir
	out_dir=${data_root}/output/tau_pet_suvr/${sub}/${ses}
	mkdir -p ${out_dir}/anat
	mkdir -p ${out_dir}/pet

	ref_path=${data_root}/output/labels_pet_space/${sub}/${ses}/anat/${sub}_${ses}_gif-inf-cereb-gm_space-pet_res.nii.gz
	#copy ref to out dir for clarity
	cp ${ref_path} ${out_dir}/anat

	pet_file=`basename $pet_path`
	ref_file=`basename $ref_path`

	pet_name=`echo "$pet_file" | cut -d'.' -f1`
	ref_name=`echo "$ref_file" | cut -d'.' -f1`

	echo $pet_name
	echo $ref_name

	#get mean uptake from cerebellum ROI to use as reference, save to text file
	ref_m_file=${out_dir}/pet/${sub}_${ses}_rec-ac_inf-cereb-gm_mean-uptake.txt
	fslstats $pet_path -k $ref_path -m > ${ref_m_file}

	#print reference uptake
	#assign value to variable
	ref_m=`cat ${ref_m_file}`
	echo "reference region ${ref_name} mean is: ${ref_m}"

	#divide whole PET image by this average to create SUVR image
	suvr_img=${out_dir}/pet/${sub}_${ses}_tau-suvr_ref-inf-cereb-gm.nii.gz
	fslmaths $pet_path -div ${ref_m} ${suvr_img}

	echo SUVR image created: ${suvr_img}

done


