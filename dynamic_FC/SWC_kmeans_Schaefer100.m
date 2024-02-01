function [IDX,C]=SWC_kmeans(k,window_length)
%% Calculate sliding-window correlations between ROIs extracted from Schaefer 100-region atlas in one fMRI run
% This function perform kmeans clustering on sliding-window functional connectivity matrices and plots

% Required input:
% 1. k (number of clusters)
% 2. Window length in seconds for sliding-window correlations (assumes TR=2sec)
 
% Upon running, you must select a text file that contains BOLD time series extracted from the Schaefer100 atals

%% settings
TR=2;
window_length=window_length/TR; % 
cluster_iterations=100; % # of iterations for kmeans clustering

%% Load atlas time series data
[filename,pathname]=uigetfile('*.txt');
atlas_ts=importdata([pathname filename]);

%% Preserve only nodes in DMN, DAN, FPCN and SN
DMN=atlas_ts(:,[38:50 90:100]);
DAN=atlas_ts(:,[16:23 67:73]);
FPCN=atlas_ts(:,[34:37 81:89]);
SN=atlas_ts(:,[24:30 74:78]);
all_timeseries=[DMN DAN FPCN SN];
TRs=size(all_timeseries,1);
num_ROIs=size(all_timeseries,2);

%% Make static FC matrix
FC_matrix=corrcoef(all_timeseries);
FC_matrix=fisherz(FC_matrix);

%% Make sliding window FC matrices(Fisher-z transformed) 
for i=1:1:TRs-window_length
    j=i+window_length;
    window_ts=all_timeseries(i:j,:);
    window_corr=corrcoef(window_ts);
    window_fisher=fisherz(window_corr);
    all_windows(:,:,i)=window_fisher;           
end

%% Convert windowed matrices from 3D to 2D (for kmeans clustering input)
nwindows=size(all_windows,3);
window_vector_size=(num_ROIs*num_ROIs-num_ROIs)/2;
window_mat_size=num_ROIs*num_ROIs;

for i=1:nwindows
    window=[];
    window=squeeze(all_windows(:,:,i));
    window(isinf(window))=NaN; % convert inf (diagonal) to NaNs
    window=tril(window);
    window(find(window==0))=NaN;
    window=window(:);
    % keep indices of NaNs within vector
    nan_indices=find(isnan(window)==1);
    real_indices=find(isnan(window)==0);
    % remove NaNs (for kmeans input)
    window(isnan(window))=[]; % remove NaNs
    allwindows_FC_2D(:,i)=window; % vectorized lower triangle
end

% kmeans clustering
[IDX,C] = kmeans(allwindows_FC_2D',k,'distance','sqEuclidean','display','final','replicate',cluster_iterations,'maxiter',250);

%% Back-reconstruct state centroids (C) to anatomy and plot
DMN_interval=size(DMN,2);
DAN_interval=DMN_interval+size(DAN,2);
FPCN_interval=DAN_interval+size(FPCN,2);
SN_interval=FPCN_interval+size(SN,2);
DMN_tick=round(size(DMN,2)/2);
DAN_tick=size(DMN,2)+round(size(DAN,2)/2);
FPCN_tick=size(DMN,2)+size(DAN,2)+round(size(FPCN,2)/2);
SN_tick=size(DMN,2)+size(DAN,2)+size(FPCN,2)+round(size(SN,2)/2);

figure('Position',[200, 200, 350*k 500]);
for i=1:k
    subplot(2,k,i)
    curr_cluster=NaN(1,window_mat_size);
    curr_cluster(real_indices)=C(i,:);
    curr_cluster_mat=reshape(curr_cluster,num_ROIs,num_ROIs);
    curr_cluster_mat(isnan(curr_cluster_mat))=0;
    imagesc(curr_cluster_mat,[-1 1]); h=colorbar('vert');
    set(gcf,'color','w');
    set(h,'fontsize',12);
    title(['State ' num2str(i)])
    xticks=[DMN_tick DAN_tick FPCN_tick SN_tick];
    xlabels={'DMN'; 'DAN'; 'FPCN'; 'SN'};
    set(gca,'XTick',[DMN_tick DAN_tick FPCN_tick SN_tick],'XTickLabel',xlabels,'FontSize',14);
    set(gca,'YTick',[DMN_tick DAN_tick FPCN_tick SN_tick],'YTickLabel',xlabels,'FontSize',14);
    hold on;
    xline(size(DMN,2)+.5,'linewidth',2);
    yline(size(DMN,2)+.5,'linewidth',2);
    xline(DMN_interval+size(DAN,2)+0.5,'linewidth',2);
    yline(DMN_interval+size(DAN,2)+0.5,'linewidth',2);
    xline(DAN_interval+size(FPCN,2)+0.5,'linewidth',2);
    yline(DAN_interval+size(FPCN,2)+0.5,'linewidth',2);
    xline(FPCN_interval+size(SN,2)+0.5,'linewidth',2);
    yline(FPCN_interval+size(SN,2)+0.5,'linewidth',2);
end
hold on;
subplot(2,k,[k+1 k+k])
plot(IDX)
ylim([.5 k+.5]);
xlabel('Window Number'); ylabel('State');

%% Plot static FC matrix
figure(2)
    imagesc(FC_matrix,[-1 1]); h=colorbar('vert');
    set(gcf,'color','w');
    set(h,'fontsize',12);
    title(['Static FC'])
    xticks=[DMN_tick DAN_tick FPCN_tick SN_tick];
    xlabels={'DMN'; 'DAN'; 'FPCN'; 'SN'};
    set(gca,'XTick',[DMN_tick DAN_tick FPCN_tick SN_tick],'XTickLabel',xlabels,'FontSize',14);
    set(gca,'YTick',[DMN_tick DAN_tick FPCN_tick SN_tick],'YTickLabel',xlabels,'FontSize',14);
    hold on;
    xline(size(DMN,2)+.5,'linewidth',2);
    yline(size(DMN,2)+.5,'linewidth',2);
    xline(DMN_interval+size(DAN,2)+0.5,'linewidth',2);
    yline(DMN_interval+size(DAN,2)+0.5,'linewidth',2);
    xline(DAN_interval+size(FPCN,2)+0.5,'linewidth',2);
    yline(DAN_interval+size(FPCN,2)+0.5,'linewidth',2);
    xline(FPCN_interval+size(SN,2)+0.5,'linewidth',2);
    yline(FPCN_interval+size(SN,2)+0.5,'linewidth',2);
    
 %% Silhoutte plot
 %figure(3)
 %silhouette(allwindows_FC_2D',IDX,'Euclidean')
 %hold on
 %xline(0.6,'k--')