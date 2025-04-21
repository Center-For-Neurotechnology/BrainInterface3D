clear all
% Get the gifti toolbox
addpath(genpath('F:\Dropbox (Personal)\Dropbox (Personal)\ACPProjects\CashLab_DataOrganization\ReconPipeline\gifti-main'))

% Import the faces and vertices
gs = gifti(['F:\Dropbox (Partners HealthCare)\PlanningImages\HCPOutput\MRI_HCP_PtScan2\T1w\Native\MRI_HCP_PtScan2.L.pial.native.surf.gii']);
% Import the labels
cs = gifti(['N:\BrainGate_MRI\MRI_HCP_xxxxxxxx\HCPOutput\MRI_HCP_PtScan2\T1w\Native\MRI_HCP_PtScan2.left.native.label.gii']);

vertices=double(gs.vertices);
faces=double(gs.faces);

%View with all the colormap
COL5=cs.cdata;
COL5(COL5==0)=1;
mesh = surfaceMesh(vertices,faces);
mesh.VertexColors=cs.labels.rgba(COL5,1:3);
surfaceMeshShow(mesh)

%% This is the subsection to 'recolor' the labels
% Reading the labels that I want to plot
LI={'55b','4','8Ad','8C','8Av','55b','6ma','8BL','6d','s6-8','44','6v','43','3b','6r','PEF','3a','1','FOP4','FEF','6a','i6-8'};
ColTable=cs.labels.rgba;
Lab=cs.labels.name;

%This is to read the colortable and allow us to match the color table
%labels to the chosen labels (such as in the LI cell array)
colorLev=.5;
COLcl=[];
COLcl=repmat([colorLev colorLev colorLev 1],size(ColTable,1),1);
indCount=ones(size(ColTable,1),1);
for iwmn=1:length(LI)
    for LB=1:length(Lab)
        if contains(Lab{LB},['L_',LI{iwmn},'_ROI'])
            COLcl(LB,:)=[ColTable(iwmn,1:4) ];
            indCount(LB)=LB;
            ['L_',LI{iwmn},'_ROI']
            %%% Below is if you want to recolor based on your on color
            %%% scales
            %         elseif contains(Lab{iwmn},'9')
            %         COLcl(iwmn,:)=ColTable(ColTable(:,5)==labell(iwmn),1:3)/255;
            %         elseif contains(Lab{iwmn},'8A')
            %         COLcl(iwmn,:)=ColTable(ColTable(:,5)==labell(iwmn),1:3)/255;
            %         elseif contains(Lab{iwmn},'9-46')
            %         COLcl(iwmn,:)=ColTable(ColTable(:,5)==labell(iwmn),1:3)/255;
            %             pause
            %         else
            %             COLcl(LB,:)=[colorLev colorLev colorLev 1];
        end
    end
end


indCount=indCount(indCount>1);
Lab(indCount)'


% This is where I try to change the labels and colors to re-map the surfaces. 
% It is RGB but from 0 to 1 (and can be converted from integers like so: [100 177 200]/255
% This also only color codes the regions of interest here:
CData=cs.cdata;
labels=cs.labels;
labels.rgba=COLcl;
keyvl=labels.key;
%resetting to handle left side labels vs right side
keyvl(indCount)'-181
colCdataAll=zeros(size(CData,1),1);
for lw=1:length(indCount)
    if indCount(lw)==189 %this was to relabel region 4 as the occipital lobe
    colCdataAll(find(CData==keyvl(indCount(lw))))=2;
    else
    colCdataAll(find(CData==keyvl(indCount(lw))))=keyvl(indCount(lw));
    end
end

cs.cdata = int32(colCdataAll);

%View with just the sub-selection
COL5=cs.cdata;
COL5(COL5==0)=1;
mesh = surfaceMesh(vertices,faces);
mesh.VertexColors=cs.labels.rgba(COL5,1:3);
surfaceMeshShow(mesh)

%% Save the .ply file with the colors tied to the vertices
% writeSurfaceMesh(mesh,"F:\Dropbox (Partners HealthCare)\PlanningImages\3DStruct\ManifoldMeshSubset.ply")

