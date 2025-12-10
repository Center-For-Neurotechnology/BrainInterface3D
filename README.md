# BrainInterface3D
BrainInterface3D is a modular pipeline incorporating multiple imaging modalites, 3D modelling, and making use of 3Dslicer to integrate magnetic resonance imaging (MRI), functional MRI (fMRI), computed tomography (CT), 3D electrode models, vasculature, and any relevant and useful information to be used in planning electrode placement such as for brain computer interfaces. The steps involve multiple software packages (listed below), most of which are open-source. 

## Overall steps
1) Preprocess DICOM imaging (CT, MRI, fMRI, vasculature)
2) Import imaging, 3D models of the brain, 3D models of the electrodes and pedestals to 3DSlicer
3) Co-register images to a main structural T1 MRI scan and use this transform to coregister everything to the same 3D space
4) 'Place' the electrodes, wires, pedastals, and craniotomy in 3Dslicer in pre-operative planning
5) 3D print output brains and skulls (with and without planned craniotomy)
6) Export planned locations with 3D models to DICOM using Karawun and upload DICOMS to Brainlab for use in the operating room as well as a display of the 3Dslicer Scene

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
The data included is the 3D reconstruction of the MNI brain (https://brainmap.org/training/BrettTransform.html or https://www.bic.mni.mcgill.ca/ServicesAtlases/ICBM152NLin2009) with additional models of the Utah array, pedestals, a morphed post-contrast MRI to MNI space (for the vasculature), and other detailed models are included for 3D reconstructions for planning. The data also include a model CT volume derived from the MNI brain:
https://www.dropbox.com/scl/fo/8zm1pg3f8wlmrj2noygtu/AO71cEXsEiqXnvAJbMow_Xw?rlkey=ta4s0azxmd7uunf5o3uyjmfq9&dl=0

## Preprocessing steps:
1. Convert the MRI, fMRI, and CT DICOM images to NIFTI using dcm2niix or any other toolbox
2. Identify best T1 MPRAGE structural scan
3. Identify best T2 SPACE structural scan
4. recon-all with Freesurfer 7.4, apply Glasser/HCP atlas transform
5. HCP Minimal Preprocessing Pipeline (MPP) to the preoperative MRI T1 and T2 scans (Structural Preprocessing)
6. fMRI preprocessing
7. Conversion of 3D surfaces to color-coded .ply files using surfaceMesh and writeSurfaceMesh (MATLAB 2022b and newer)
8. Download of electrode and pedestal 3D models

## Within 3DSlicer:
1. Import T1w_acpc_dc_restore.nii MRI  (in the HCP output folder: )
2. Import CT 
3. Import FreeSurfer T1.mgz MRI used for fMRI analysis
4. Import Post-contrast MRI
5. Coregister everything to T1w_acpc_dc_restore.nii (in the HCP output) with General Registration (ANTs) module (SlicerANTS, https://github.com/simonoxen/SlicerANTs), save and rename each Transform
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

## Karawun and BrainLab import
1. Take the NIFTI output from 3Dslicer and convert to DICOMs using Karawun instructions (example script included, https://developmentalimagingmcri.github.io/karawun/)
2. server -> Upload to VISAGE -> Push to Brainlab within VISAGE -> load files and folders into the BrainLab machine being used in the OR -> load the objects, scans, and views in order -> coregister the CT and/or MRIs to the patient either via fiducials skull landmarks

## Useful Software tutorials:
### 3D slicer-
- Download 3D slicer: https://www.slicer.org/
- Great playlist for basics, mapping, and so much more: https://www.youtube.com/playlist?list=PLeaIM0zUlEqswa6Pskg9uMq15LiWWYP39 
- Tips to go quicker + more accuracy on segmentation: https://www.youtube.com/watch?v=cybL5A0w3hw 
- More segmentation!: https://www.youtube.com/watch?v=S5tOn_AxrbM 
- Brain parcellation model tool: https://www.youtube.com/watch?v=kKXCv-JPikw 
- Brain volume rendering tool: https://www.youtube.com/watch?v=5OIXLCLZ3j4

### Freesurfer-
- Download freesurfer: https://surfer.nmr.mgh.harvard.edu/fswiki
- Website tutorials: https://surfer.nmr.mgh.harvard.edu/fswiki/Tutorials

### HCP Processing-
- Download: https://github.com/Washington-University/HCPpipelines
- Steps: https://github.com/Washington-University/HCPpipelines/wiki/Installation-and-Usage-Instructions

## Useful file formats:
- DICOM: - Digital Imaging and Communications in Medicine is a file format and network protocol for storing and transmitting medical images and related information
- NIFTI .nii : — Neuroimaging Informatics Technology Initiative- data file format for saving volumes, or multiple slices into a single volume (such as MRI or CT scans)
- CIFTI .nii : — Connectivity Informatics Technology Initiative- data file format intended to make it easier to work with data from multiple disjoint structures at the same time (https://www.humanconnectome.org/software/workbench-command/-cifti-help)
- GIFTI .gii : — Geometry format under the Neuroimaging Informatics Technology- data file format designed for surface-based data.
- .ply files : — Polygon File Format or Stanford Triangle Format, is a simple way to store 3D data as a polygonal model, and the vertices can be color-coded such as with colors for the parcellations or fMRI results
- .stl files : — data transmission format that stores 3D model information as a series of linked triangles, often used for 3D printing
- .obj files : — geometry definition file format first developed by Wavefront Technologies for its Advanced Visualizer animation package, can be used for
- .mgz files : — FreeSurfer volume files
- .label files: — Label files indicating parcellations of brain regions per surface reconstruction or relative to the volume
- Handy BALSA description of these file formats and HCP ouputs: https://balsa.wustl.edu/about/fileTypes

## Applying atlases
- Some steps involved applying HCP-MMP1.0 labels projected on fsaverage within Freesurfer 7.4 or within HCP (wbcommand), some of which is included in text files above.
- Further information and better descriptions including the lh.HCPMMP1.annot and rh.HCPMMP1.annot files are listed here (which includes wbcommand and Freesurfer commands): https://figshare.com/articles/dataset/HCP-MMP1_0_projected_on_fsaverage/3498446
- and here: https://figshare.com/articles/dataset/HCP-MMP1_0_volumetric_NIfTI_masks_in_native_structural_space/4249400

## Tips:
- It helps to organize the files within 3Dslicer into folders hierarchically as every loaded file goes to the end of the list. Organizing all the models into one folder and the transforms into another, and so on, helps to quickly navigate to the right image and overlay to check locations in close to real time.
- It is worthwhile to save a new folder and Slicer Scene per change to the plan or for different plans (Plan A-C) so that electrode locations could be separately viewed and checked against one another as well as track past plans.
- Useful note: The “N” in “NIFTI” stands for “Neuroscience” and the “G” in “GIFTI” stands for “Geometry.” (https://www.sciencedirect.com/science/article/pii/S1053811922000076?via%3Dihub)

<img width="2061" height="1276" alt="MNIDemo-Scene" src="https://github.com/user-attachments/assets/f8168250-6f0e-454f-b8d7-dc93ae9c3f64" />

