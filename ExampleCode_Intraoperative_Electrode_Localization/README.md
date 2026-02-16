Below are useful commands used in the intraoperative code pipeline:
____________________________________________________________________

## Running MiDaS 
After installing Midas (https://pytorch.org/hub/intelisl_midas_v2/), place the images into the '/usr/local/MiDaS-master/input'

OS command window (e.g. WSL in Ubuntu 24) where the midas-py310 environment is installed:

```
$ cd /usr/local/MiDaS-master
$ conda activate midas-py310
$ ## sudo find . -name "*.Identifier" -type f -delete ## Run if using WSL and copying over files create non-image files
$ python run.py --model_type dpt_beit_large_512 --input_path /usr/local/MiDaS-master/input --output_path /usr/local/MiDaS-master/output

```

Get the MiDaS output depth maps and files from the output folder above

____________________________________________________________________

## Running Mango commands to convert DICOM images to NIfTI files automatically with file names per scan (e.g. T2, pre-T1)

OS command window where the Install Utilities (https://mangoviewer.com/mango_guide_utilities.html) is installed:

```
$ mango-convert2nii -a Y:\IntraOp_Micro\IP35\IP35_Notes_and_Images\IP35CTPostop\IMAGES\*

```
____________________________________________________________________

## Geodesic measurements using the pymeshlab library 
(https://github.com/cnr-isti-vclab/PyMeshLab)

Open MATLAB via the Miniforge window (or wherever python and the pymeshlab library is installed). 

Run the below command (replacing the directory with the correct location. 
- This first step takes the entire brain surface and calculates the distance of every point on the surface to the electrode contacts per channel (ch) and outputs a .csv file per channel which can then be used to measure geodesic distance from that nearest point to anywhere around the brain, including the closest pathology point: 
- The brain surfaces and electrode locations should all be in the same relative RAS space.

```
PythonCode='V:\IntraoperativeRecordings\Code\GeodesicMapping\extract_geodesic_distances.py';

pyrunfile([PythonCode,' ',FiLoadRight,' ',num2str(ChLocations(ch,1)),' ',num2str(ChLocations(ch,2)),' ',num2str(ChLocations(ch,3)),' ',num2str(ch)])
% Variable names- FiLoadRight- file of the right or left pial surface to load; ChLocations(ch,1:3) are the R, A, S locations relative to the brain, ch is the channel number

```
____________________________________________________________________

## Exporting Blender meshes into .csv files with vertice mapped in RAS space for later data processing. 

Within the tab of Blender of your file, load the 'ExportBlenderVerticesWorldViewDeID.py' py file, select the electrode of interest, change the csv file names and locations, and hit 'Run' (play button):

<img width="1905" height="987" alt="ScreenBlenderScripting" src="https://github.com/user-attachments/assets/2268752c-14f3-4be9-9658-7966f2f880ce" />

<img width="2339" height="1429" alt="ScreenBlenderScripting2" src="https://github.com/user-attachments/assets/2e52c87f-24ea-4235-a473-ad6fe2903032" />






