# BrainInterface3D
![image](https://github.com/user-attachments/assets/6f24d9c1-a6b8-4138-821c-e751b5aa88c4)
![image](https://github.com/user-attachments/assets/e2c15766-75c0-40b3-835a-313978bf1ced)
![image](https://github.com/user-attachments/assets/3139e1e4-9a66-4606-bf61-e19fe01a7c41)
BrainInterface3D is a modular pipeline incorporating multiple imaging modalites, 3D modelling, and making use of 3Dslicer to integrate magnetic resonance imaging (MRI), functional MRI (fMRI), computed tomography (CT), 3D electrode models, vasculature, and any relevant and useful information to be used in planning electrode placement such as for brain computer interfaces. The steps involve multiple software packages (listed below), most of which are open-source. 

## Overall steps
1) Preprocess imaging (CT, MRI, fMRI, vasculature)
2) Import imaging, 3D models of the brain, 3D models of the electrodes and pedestals to 3DSlicer
3) Co-register images to a main structural T1 MRI scan and use this transform to 

## Useful packages:
- Gifti library for MATLAB
https://github.com/gllmflndn/gifti
- Karawun
https://developmentalimagingmcri.github.io/karawun/
- Fieldtrip
https://www.fieldtriptoolbox.org/ 
- Freesurfer tools for MATLAB
https://github.com/freesurfer/freesurfer/tree/dev/matlab 
- Freesurfer
https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall 
- FSL
https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation 
- Human Bain Connectome pipeline
https://github.com/Washington-University/HCPpipelines 
- 3DSlicer
https://www.slicer.org/ 
- Blender
https://www.blender.org/
- dcm2niix (can use the downloadable executable)
https://github.com/rordenlab/dcm2niix
- SlicerANTS (used for automatic image co-registration and can be added via the Extensions Manager in 3DSlicer)
https://github.com/simonoxen/SlicerANTs

## Useful data for testing the pipeline:
The below data is the 3D reconstruction of the MNI brain (https://brainmap.org/training/BrettTransform.html) with a model brain Created by Mariano Coretti. (https://blenderartists.org/t/pretty-good-skull/702052) in a 3Dslicer scene. The data also include a model CT volume:
## ADD Data link!

## Preprocessing steps:
1. Identify best T1 MPRAGE structural scan
2. Identify best T2 SPACE structrual scan
3. recon-all with Freesurfer 7.4, apply Glasser/HCP atlas transform
4. HCP Minimal Preprocessing Pipeline (MPP) to the preoperative MRI T1 and T2 scans (Structural Preprocessing)
5. fMRI preprocessing
6. Conversion of 3D surfaces to color-coded .ply files using surfaceMesh and writeSurfaceMesh
7. Download of electrode and pedestal 3D models

## Within 3DSlicer:
1. Import T1w_acpc_dc_restore.nii MRI
2. Import CT
3. Import T1.mgz MRI used for fMRI analysis
4. Import Post-contrast MRI
5. Coregister everything to T1w_acpc_dc_restore.nii with General Registration (ANTs) module (SlicerANTS, https://github.com/simonoxen/SlicerANTs), save and rename each Transform
6. Import 3D models (.stl, .ply, or .obj) of Utah arrays and pedestals
7. Import 3D surfaces as models with color coded labelling, such as the HCP parcellations, the fMRI color coding, or other labels as needed
8. Use the earlier transforms to move the surfaces into the same space
9. Turn on per-slice view of the surfaces and compare with the coregistered volumes
10. Move the 3D device models to the right locations on the coregistered brain and skull, save and rename each transform
11. Segment bone to create both a model and a segmentation in 3D
12. Segment vessels or use the vascular toolbox
13. Make a copy of the segmented skull and add a ‘craniotomy’ in the planning
14. Use Markers in 3Dslicer to create curved lines for the wires, turning on the line measure feature
15. Convert the surface models into segmentations and then save them as NIFTI models for later DICOM conversion
16. For Brainlab visibility, convert Utah arrays into spheres or cubes
17. Save volumes as NIFTI files for later DICOM conversion

## Useful file formats:
- NIFTI: — Neuroimaging Informatics Technology Initiative- used for
- CIFTI: — Neuroimaging Informatics Technology Initiative- used for 
