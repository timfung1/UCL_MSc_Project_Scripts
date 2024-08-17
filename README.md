**Bash scripts upload**

include:
- collection of the imaging metric maps
- collecting the inferior cerebellum reference region
- registering and resampling of Freesurfer parcellations into native dMRI and PET space
- calculation of regional mean values
- calculation of tau SUVR values

**Statistical analysis R script**

Before statistical calculations, the metric data was additionally changed to account for volume and, for the NODDI metrics, tissue weighting. 
The statistical analysis performed were: 
- calculating mean differences in tau SUVR between mutation carriers and non mutatation carriers,
    and correlation analysis between tau SUVR and imaging metrics including:
     - Orientation Dispersion index (ODI)
     - Neurite Density Index (NDI)
     - Tissue Fraction (TF)
     - Mean Diffusivity (MD)
     - Cortical Thickness (CTh)
