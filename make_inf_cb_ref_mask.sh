#! /bin/bash
gif_gm_mask=$1
gif_cereb=$2
output=$3
USAGE="Usage: $0 gif_gm gif_cereb output"

tmp_dir=/tmp/ref_mask
mkdir -p ${tmp_dir}

if [ $# -lt 3 ]
then
    echo "Three mandatory arguments are needed"
    echo ${USAGE}
    exit
fi
if [ ! -e "${gif_gm_mask}" ]
  then
    echo "No file called ${gif_gm_mask}. This is mandatory"
    echo ${USAGE}
    exit
fi
if [ ! -e "${gif_cereb}" ]
  then
    echo "No file called ${gif_cereb}. This is mandatory"
    echo ${USAGE}
    exit
fi

fslmaths "${gif_cereb}" -thr 5.5 -uthr 6.5 ${tmp_dir}/cerebellum_6.nii.gz
fslmaths "${gif_cereb}" -thr 7.5 -uthr 28.5 ${tmp_dir}/cerebellum_8_to_28.nii.gz

fslmaths ${tmp_dir}/cerebellum_6.nii.gz -add ${tmp_dir}/cerebellum_8_to_28.nii.gz -bin -mas "${gif_gm_mask}" "${output}"

#clean tmp_dir
rm -rfv ${tmp_dir}
