#!/bin/bash

#makes final brain masks with 'make_inf_cb_ref_mask.sh' with probability GM thresholded at 90% 

gif_dir=/data/msc-scratch/tfung/output/gifv2_labels

for gif_cereb in `ls ${gif_dir}/FAD*/*_t1_anat_Cerebellum.nii.gz` ; do

	sub=`basename $gif_cereb | cut -d _ -f 1`
	echo $sub

	gif_seg=${gif_cereb/_t1_anat_Cerebellum.nii.gz/_t1_anat_NeuroMorph_Segmentation.nii.gz}

	output=${gif_cereb/_Cerebellum.nii.gz/_inf-cereb-gm_cleaned.nii.gz}


	#first we need to split 4D GIF segmentaton file into 3D files 
	out_base=${gif_seg/.nii.gz/_}
	gif_gm=${out_base}0002.nii.gz
 	gif_gm_mask=${gif_gm/.nii.gz/_90perc-binmask.nii.gz}

	if [ ! -f "${gif_gm_mask}" ] ; then
		echo "output does not exist, splitting seg"

		fslsplit ${gif_seg} ${out_base}
		#we want GM probabilistic mask _0002
		ls ${gif_gm}
		fslmaths ${gif_gm} -thr 0.9 -bin ${gif_gm_mask}

	else 
		echo "gif_gm_mask already exists"
	fi
	

	/data/msc-scratch/tfung/scripts/make_inf_cb_ref_mask.sh ${gif_gm_mask} ${gif_cereb} ${output}

done
