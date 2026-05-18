%% paths
% written by Zeyang Yu, edited by Angelique C Paulk
clear all

fdir_shareMain = pathtoCodeDirectory;
% Get the MNI files for processing https://www.bic.mni.mcgill.ca/ServicesAtlases/ICBM152NLin2009
MNIDirec=[pathtoMNItemplates,'\MNI_templates\'];
PatDirectory=[pathtoCSVorXLSXFilesWithChannelCoordinates,'\'];

addpath(genpath('V:\ElectrodeLocalizations\MNIMapping\warpToMNI\fieldtrip-20230602\fieldtrip-20230602'))

%% require use of new fieldtrip
% # check fieldtrip version >=
[ftver, ftpath] = ft_version;
if ischar(ftver)
    if strcmpi(ftver,'unknown')
        warning('Manually confirm Fieldtrip version is >= 2023-06')
    else
        assert(str2double(ftver)>=20230601,'Only tested with Fieldtrip version >= 2023-06')
    end
end

%% Base Config

ParticipantDesig='IP35'; %Example participant designation for processing

%% Options
save_warped = true;
save_warped_RAS = true;
warp_based_on_brain_masked = true; % 'true' = brain-masked, 'false' = full-mri
%
do_reslice_raw_mri = false;  % <this is not necessary>

%% Get MNI template
% choose MNI template
fdir_templateMNI_parent = fullfile(MNIDirec);
fdir_MNItemplate = fullfile(fdir_templateMNI_parent,'mni_icbm152_nlin_sym_09c');
fdir_MNItemplate = fullfile(fdir_templateMNI_parent,'mni_icbm152_nlin_sym_09c');
fdir_MNItemplate2 = fullfile(fdir_templateMNI_parent,'mni_icbm152_nlin_sym_09b');
fname_MNI_full_template = 'mni_icbm152_t1_tal_nlin_sym_09b_hires.nii';
%
fpath_templateMNI_full=fullfile(fdir_MNItemplate2,fname_MNI_full_template);
MNI_full_tempalte = ft_read_mri(fpath_templateMNI_full); % we used the dcm series
MNI_full_tempalte.coordsys = 'mni';
if ~'MNI brain template not extracted already'
    fname_brainMask = 'mni_icbm152_t1_tal_nlin_sym_09c_mask.nii';
    fpath_brainMask = fullfile(fdir_MNItemplate2,fname_brainMask);
    mask = ft_read_mri(fpath_brainMask); % we used the dcm series
    templateMNI = ft_read_mri(fpath_templateMNI_full); % we used the dcm series
    templateMNI.coordsys = 'mni';
    MNI_brain_template = templateMNI; MNI_brain_template.anatomy(~mask.anatomy)=0;
    cfg=[]; cfg.filename = sprintf('MNI152_2009c_BrainOnly.nii'); cfg.parameter='anatomy'; ft_volumewrite(cfg, MNI_brain_template)
end
fdir_MNItemplate_brain = fdir_MNItemplate;
fpath_templateMNI_brain=fullfile(fdir_MNItemplate_brain,'MNI152_2009c_BrainOnly.nii');
MNI_brain_template = ft_read_mri(fpath_templateMNI_brain); % we used the dcm series
MNI_brain_template.coordsys = 'mni';
%


%%
for iSubj=1:1

    PtN=ParticipantDesig{iSubj};
    % for iSubj = 79:79
    %% Determine directories
    subj2Analyze = PtN;
    subj2Analyze2 = PtN;


    %     ## this part needs change
    fdir_inpt = LoadDir;
    PatDirectory = fullfile(fdir_inpt,subj2Analyze);
    fdir_elecLoc = fullfile(PatDirectory,'\'); %Folder_containing_RAS_CSV_file#
    fdir_elecLocSave = fdir_elecLoc; %Folder_containing_RAS_CSV_file#
    fdir_elecLocSave2 = fdir_elecLoc; %DeID Folder_containing_RAS_CSV_file#
    saveDirec = fdir_elecLoc;
    mkdir(fdir_elecLocSave2)

    % fname_2 = sprintf('%s_unipol_RAS_-native_Full-MRI.csv',subj2Analyze);
    fname_ = sprintf('%s_unipol_RAS_MNI-norm_Full-MRI.csv',subj2Analyze2);
    fpath_save2 = fullfile(fdir_elecLocSave,fname_);


    if isempty(dir([fdir_elecLocSave,'*']))==0 && isempty(dir([fpath_elecLoc,'*']))==0 &&...
            isempty(dir([fpath_save2,'*']))==1

        ResearchElec1=NaN;ResearchElec2=NaN;ResearchElec3=NaN;
        if isempty(ChannelsRes)==0
            ResearchElec1=ChannelsRes(isnan(ChannelsRes(:,4))==0,1);
            ResearchElec2=ChannelsRes(isnan(ChannelsRes(:,4))==0,2);
            ResearchElec3=ChannelsRes(isnan(ChannelsRes(:,4))==0,3);
            ResChanNum=ChannelsRes(isnan(ChannelsRes(:,4))==0,4);
            plot3(ResearchElec1,ResearchElec2,ResearchElec3,'.','color',[0 0 .7],'linewidth',3,'markersize',20);
        end

        ClinicalElec1=NaN;ClinicalElec2=NaN;ClinicalElec3=NaN;ClinChanNum=1;
        if isempty(ChannelsClin)==0
            ClinicalElec1=ChannelsClin(isnan(ChannelsClin(:,4))==0,1);
            ClinicalElec2=ChannelsClin(isnan(ChannelsClin(:,4))==0,2);
            ClinicalElec3=ChannelsClin(isnan(ChannelsClin(:,4))==0,3);
            ClinChanNum=ChannelsClin(isnan(ChannelsClin(:,4))==0,4);
            plot3(ClinicalElec1,ClinicalElec2,ClinicalElec3,'.','color',[0 0 .7],'linewidth',3,'markersize',20);
        end


        Chan={'ResearchElec', ...
            'ClinicalElec', ...
        }';
        Len=length(ResearchElec1)+length(ClinicalElec1)+length(Tumor1)+length(Resection1)+length(Edema1)+length(Lesion1)+length(Necrosis1);
        Chan={};
        lens=0;
        for ChTot=1:length(ResearchElec1)
            Chan{ChTot}=['ResearchElec',num2str(ResChanNum(ChTot))];
        end
        lens=length(Chan);
        for ChTot=1:length(ClinicalElec1)
            Chan{ChTot+lens}=['ClinicalElec',num2str(ClinChanNum(ChTot))];
        end


        R=[ResearchElec1; ...
            ClinicalElec1; ...
            ];
        A=[ResearchElec2; ...
            ClinicalElec2; ...
            ];
        S=[ResearchElec3; ...
            ClinicalElec3; ...
            ];

        RASTable=table(Chan',R,A,S);

        %% Find "#SubjID#_brain.nii"
        MRIDirectory = fullfile(fdir_elecLoc); %'#SubjID#_SurferOutput'/'mri';

        %% Need to pre-convert "brain.mgz" to "#SubjID#_brain.nii" ##
        fname_subjectNative_brain = sprintf('%s_brain.nii',subj2Analyze);
        fpath_brainfile=dir([MRIDirectory,ScanUsed{iSubj},'.*']);
        %         fpath_brain=fullfile(MRIDirectory,fname_subjectNative_brain);
        fpath_brain = fullfile(MRIDirectory,fpath_brainfile(1).name);
        fpath_mri = fullfile(MRIDirectory,fpath_brainfile(1).name);
            if isempty(dir(fpath_brain))==1
                if isempty(dir([fullfile(MRIDirectory,sprintf('T1.mgz')),'*']))==0 % it can also look for Freesurfer output T1 files
                    fpath_brain = fullfile(MRIDirectory,sprintf('T1.mgz'));
                    % Need to un-zip "mri.nii.gz" to "mri.nii" ##
                    fpath_mri = fullfile(MRIDirectory,sprintf('T1.mgz'));
                    %             fpath_brain = fullfile(MRIDirectory,sprintf('anat_t1.nii'));
                    % Need to un-zip "mri.nii.gz" to "mri.nii" ##
                    %             fpath_mri = fullfile(MRIDirectory,sprintf('anat_t1.nii'));
                end
            end

        %% load full native mri
        mri_full_native = ft_read_mri(fpath_mri);
        %mri_full_native=ft_determine_coordsys(mri_full_native);
        mri_full_native.coordsys = 'ras'; %'acpc','scs','scanras': subject coordinate system
        %[mri_full_native] = ft_convert_coordsys(mri_full_native,'acpc');
        %mri_full_native=ft_determine_coordsys(mri_full_native);

        %% load brain
        mri_brain_native = ft_read_mri(fpath_brain);
        mri_brain_native.coordsys  = mri_full_native.coordsys;
        % imtool3D(mri_brain_native.anatomy);
        % --- cut down ---
        if do_reslice_raw_mri % <this is not necessary
            cfg = []; cfg.xrange=[-90,90]; cfg.yrange=[-110,110]; cfg.zrange=[-100,110];
            mri_brain_native_2 = ft_volumereslice(cfg, mri_brain_native);
        else
            mri_brain_native_2 = mri_brain_native;
        end
        %}
        % # convert coordnate system
        if ~'convert_coordsys'
            % DO NOT change coordsys, other wise elec is no longer co-registered
            [mri_brain_native] = ft_convert_coordsys(mri_brain_native, 'acpc','method',1);
        end
        % imtool3D(fsBrain_rs.anatomy);
        %}
        %% get RAS of electrodes

        %         Tbl = readtable(fpath_elecLoc); % Var1        R      A       S
        if ~isnumeric(RASTable.R)
            RASTable.R = str2double(RASTable.R);
            RASTable.A = str2double(RASTable.A);
            RASTable.S = str2double(RASTable.S);
        end
        RASTable.Chan = aAAC_regularizeLabels(table2cell(RASTable(:,1)),1);
        elec = [];
        elec.label   = RASTable.Chan; %cell-array of length N with the label of each channel
        elec.elecpos = [RASTable.R RASTable.A RASTable.S]; %Mx3 matrix with the cartesian coordinates of each electrode
        elec.chanpos = elec.elecpos; %Nx3 matrix with the cartesian coordinates of each channel
        %
        %% Which MNI template to use
        %#
        %To generalize the electrode coordinates to other brains or MNI-based neuroanatomical atlases in a later step,
        % register the subject s brain to the standard MNI brain and use the resulting deformation parameters to obtain the
        % electrodes in standard MNI space. The volume-based registration technique considers the overall geometry
        % of the brain and can be used for the spatial normalization of all types of electrodes, whether depth or on the surface.
        %% Normalize electrode to MRI
        if ~'<RETIRED> Normalize electrode separately [redundant, now do MNI warp on MRI first]'
            cfg            = [];
            cfg.elec       = elec;
            cfg.method     = 'mni';
            cfg.mri        = mri_full_native; % okay to directly specify the path
            cfg.spmversion = 'spm12';
            cfg.spmmethod  = 'new';
            cfg.nonlinear  = 'yes';
            cfg.templatemri = fpath_mni_template_mni2009c; % if omit => spm\T1.nii
            elec_mni = ft_electroderealign(cfg);
        end
        %% Normalize mri to MRI, Warp MRI to template with default parameters
        cfg = [];
        cfg.spmversion = 'spm12';
        cfg.nonlinear = 'yes';
        cfg.spmmethod = 'new';
        if warp_based_on_brain_masked
            cfg.template = fpath_templateMNI_full; % fpath_templateMNI_full, or fpath_templateMNI_brain
            mri_full_mni= ft_volumenormalise(cfg, mri_full_native);
            if save_warped
                mri_full_mni_rs = ft_volumereslice([], mri_full_mni);
                cfg=[]; cfg.filename = fullfile(fdir_elecLocSave,sprintf('%s_full_mni.nii',subj2Analyze)); cfg.parameter='anatomy'; ft_volumewrite(cfg, mri_full_mni_rs)
            end
            mri_MNI = mri_full_mni;

        end

        % ### Notes
        % the normalisation from original subject head coordinates to MNI consists of an initial rigid body transformation, followed by a more precise (non)linear transformation
        % 1) Initial coarse rigidi body transform
        %   - mri_mni.initial
        %       - >> post_init = ft_warp_apply(mri_mni.initial, elec.elecpos, 'homogeneous')
        % 2) followed by a more precise (non)linear transformation
        %   - mri_mni.params
        %       - >> ft_warp_apply(mri_mni.params, post_init, 'individual2sn');
        % overall
        %   - >> pos_mni = ft_warp_apply(mri_mni.params, ft_warp_apply(mri_mni.initial, elec.elecpos, 'homogeneous'), 'individual2sn');
        if 'apply warp to electrode pos'
            elec_mni = elec;
            elec_mni.elecpos = ft_warp_apply(mri_MNI.params, ft_warp_apply(mri_MNI.initial, elec.elecpos, 'homogeneous'), 'individual2sn');
            elec_mni.chanpos = elec_mni.elecpos;
            elec_mni.coordsys = 'mni';
        end
        if save_warped_RAS
            Tbl_mni = RASTable;
            Tbl_mni=renamevars(Tbl_mni,'Chan','chName');
            Tbl_mni.R_mni = elec_mni.chanpos(:,1);
            Tbl_mni.A_mni = elec_mni.chanpos(:,2);
            Tbl_mni.S_mni = elec_mni.chanpos(:,3);
            %
            fname_2 = sprintf('%s_unipol_RAS_-native_Full-MRI.csv',subj2Analyze);
            fpath_save2 = fullfile(fdir_elecLocSave,fname_2);
            writetable(RASTable,fpath_save2)

            fname_ = sprintf('%s_unipol_RAS_MNI-norm_Full-MRI.csv',subj2Analyze2);
            fpath_save2 = fullfile(fdir_elecLocSave2,fname_);
            writetable(Tbl_mni,fpath_save2)
        end
        %% Normalize mri to MRI, Warp MRI to template with default parameters
    end
end

