import argparse
import numpy as np
import nibabel as nib

#adapted from tau SUVR to get mean NODDI metrics for each region
 
rois = {'Braak Stage 1': [1006,2006], #entorhinal cortex
    'Braak Stage 2': [17,53], #hippocampus
    'Braak Stage 3': [18,54,1016,2016,1007,2007,1013,2013], 
    'Braak Stage 4': [1015,1002,1026,1023,1010,1035,1009,1033,
                      2015,2002,2026,2023,2010,2035,2009,2033], 
    'Braak Stage 5': [1028,1012,1014,1032,1003,1027,1018,1019,1020,1011,1031,1008,1030,1029,1025,1001,1034,
                      2028,2012,2014,2032,2003,2027,2018,2019,2020,2011,2031,2008,2030,2029,2025,2001,2034],
    'Braak Stage 6': [1021,1022,1005,1024,1017,
                      2021,2022,2005,2024,2017],
    'Braak Stage_1_2': [1006,2006,17,53],
    'Braak Stage_3_4': [18,54,1016,2016,1007,2007,1013,2013,1015,1002,
                        1026,1023,1010,1035,1009,1033,2015,
                        2002,2026,2023,2010,2035,2009,2033],
    'Braak Stage_5_6': [1028,1012,1014,1032,1003,1027,1018,1019,1020,1011,
                        1031,1008,1030,1029,1025,1001,1034,
                        2028,2012,2014,2032,2003,2027,2018,2019,2020,2011,
                        2031,2008,2030,2029,2025,2001,2034,
                        1021,1022,1005,1024,1017,
                        2021,2022,2005,2024,2017],
    'R Braak Stage 1': [2006],
    'L Braak Stage 1': [1006], 
    'R Braak Stage 2': [53], 
    'L Braak Stage 2': [17],
    'R Braak Stage 3': [54,2016,2007,2013], 
    'L Braak Stage 3': [18,1016,1007,1013], 
    'R Braak Stage 4': [2015,2002,2026,2023,2010,2035,2009,2033],
    'L Braak Stage 4': [1015,1002,1026,1023,1010,1035,1009,1033],
    'R Braak Stage 5': [2028,2012,2014,2032,2003,2027,2018,2019,2020,2011,
                        2031,2008,2030,2029,2025,2001,2034],
    'L Braak Stage 5': [1028,1012,1014,1032,1003,1027,1018,1019,1020,1011,
                        1031,1008,1030,1029,1025,1001,1034],
    'R Braak Stage 6': [2021,2022,2005,2024,2017],
    'L Braak Stage 6': [1021,1022,1005,1024,1017],
    'R Braak Stage_1_2': [2006,53],
    'L Braak Stage_1_2': [1006,17],
    'R Braak Stage_3_4': [54,2016,2007,2013,2015,2002,
                          2026,2023,2010,2035,2009,2033],
    'L Braak Stage_3_4': [18,1016,1007,1013,1015,1002,
                          1026,1023,1010,1035,1009,1033],
    'R Braak Stage_5_6': [2028,2012,2014,2032,2003,2027,
                          2018,2019,2020,2011,2031,2008,
                          2030,2029,2025,2001,2034,2021,
                          2022,2005,2024,2017],
    'L Braak Stage_5_6': [1028,1012,1014,1032,1003,1027,
                          1018,1019,1020,1011,1031,1008,
                          1030,1029,1025,1001,1034,1021,
                          1022,1005,1024,1017],
    'not assigned': [0],
    'Left Cerebral White Matter': [2],
    'Left Lateral Ventricle': [4],
    'Left Inf Lat Vent': [5],
    'Left Cerebellum White Matter': [7],
    'Left Cerebellum Cortex': [8],
    'Left Thalamus Proper': [10],
    'Left Caudate': [11],
    'Left Putamen': [12],
    'Left Pallidum': [13],
    'Third Ventricle': [14],
    'Fourth Ventricle': [15],
    'Brain Stem': [16],
    'Left Hippocampus': [17],
    'Left Amygdala': [18],
    'CSF': [24],
    'Left Accumbens area': [26],
    'Left VentralDC': [28],
    'Left vessel': [30],
    'Left choroid plexus': [31],
    'Right Cerebral White Matter': [41],
    'Right Lateral Ventricle': [43],
    'Right Inf Lat Vent': [44],
    'Right Cerebellum White Matter': [46],
    'Right Cerebellum Cortex': [47],
    'Right Thalamus Proper': [49],
    'Right Caudate': [50],
    'Right Putamen': [51],
    'Right Pallidum': [52],
    'Right Hippocampus': [53],
    'Right Amygdala': [54],
    'Right Accumbens area': [58],
    'Right VentralDC': [60],
    'Right choroid plexus': [63],
    'WM hypointensities': [77],
    'Optic Chiasm': [85],
    'CC_Posterior': [251],
    'CC_Mid_Posterior': [252],
    'CC_Central': [253],
    'CC_Mid_Anterior': [254],
    'CC_Anterior': [255],
    'lh_bankssts': [1001],
    'lh_caudalanteriorcingulate': [1002],
    'lh_caudalmiddlefrontal': [1003],
    'lh_cuneus': [1005],
    'lh_entorhinal': [1006],
    'lh_fusiform': [1007],
    'lh_inferiorparietal': [1008],
    'lh_inferiortemporal': [1009],
    'lh_isthmuscingulate': [1010],
    'lh_lateraloccipital': [1011],
    'lh_lateralorbitofrontal': [1012],
    'lh_lingual': [1013],
    'lh_medialorbitofrontal': [1014],
    'lh_middletemporal': [1015],
    'lh_parahippocampal': [1016],
    'lh_paracentral': [1017],
    'lh_parsopercularis': [1018],
    'lh_parsorbitalis': [1019],
    'lh_parstriangularis': [1020],
    'lh_pericalcarine': [1021],
    'lh_postcentral': [1022],
    'lh_posteriorcingulate': [1023],
    'lh_precentral': [1024],
    'lh_precuneus': [1025],
    'lh_rostralanteriorcingulate': [1026],
    'lh_rostralmiddlefrontal': [1027],
    'lh_superiorfrontal': [1028],
    'lh_superiorparietal': [1029],
    'lh_superiortemporal': [1030],
    'lh_supramarginal': [1031],
    'lh_frontalpole': [1032],
    'lh_temporalpole': [1033],
    'lh_transversetemporal': [1034],
    'lh_insula': [1035],
    'rh_bankssts': [2001],
    'rh_caudalanteriorcingulate': [2002],
    'rh_caudalmiddlefrontal': [2003],
    'rh_cuneus': [2005],
    'rh_entorhinal': [2006],
    'rh_fusiform': [2007],
    'rh_inferiorparietal': [2008],
    'rh_inferiortemporal': [2009],
    'rh_isthmuscingulate': [2010],
    'rh_lateraloccipital': [2011],
    'rh_lateralorbitofrontal': [2012],
    'rh_lingual': [2013],
    'rh_medialorbitofrontal': [2014],
    'rh_middletemporal': [2015],
    'rh_parahippocampal': [2016],
    'rh_paracentral': [2017],
    'rh_parsopercularis': [2018],
    'rh_parsorbitalis': [2019],
    'rh_parstriangularis': [2020],
    'rh_pericalcarine': [2021],
    'rh_postcentral': [2022],
    'rh_posteriorcingulate': [2023],
    'rh_precentral': [2024],
    'rh_precuneus': [2025],
    'rh_rostralanteriorcingulate': [2026],
    'rh_rostralmiddlefrontal': [2027],
    'rh_superiorfrontal': [2028],
    'rh_superiorparietal': [2029],
    'rh_superiortemporal': [2030],
    'rh_supramarginal': [2031],
    'rh_frontalpole': [2032],
    'rh_temporalpole': [2033],
    'rh_transversetemporal': [2034],
    'rh_insula': [2035]
}

parser = argparse.ArgumentParser(description='Compute SUVR')
parser.add_argument('roi_file',type=str,
                    help='ROI parcellation file')
parser.add_argument('--out',type=str,
                    help='Optional output file for volume values')
args=parser.parse_args()

# load the parcelation
roi_image = nib.load(args.roi_file)
vox_dim = np.product(roi_image.get_header().get_zooms())

roi_image = roi_image.get_data().ravel().astype('int')

valid_point = np.isfinite(roi_image)
# Volumes
regional_vols = np.bincount(roi_image[valid_point]) * vox_dim

vol_dict={}
for k in sorted(rois.iterkeys()):
    v=rois[k]
    vol_sum=0
    for label in v:
        volume=regional_vols[label]
        vol_sum += volume
    vol_dict[k]=vol_sum
    print('{}: {:.6f}'.format(k,vol_sum))
final_output=""
for k in sorted(vol_dict.iterkeys()):
    final_output += '{:.6f}, '.format(vol_dict[k])
print(','.join(sorted(vol_dict.keys())))
print(final_output)

if args.out:
    with open(args.out,'w') as file:
        file.write(final_output)
