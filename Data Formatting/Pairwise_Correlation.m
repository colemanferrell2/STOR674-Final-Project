clear

%First set your working directory to the project folder (an example is
%provided below
cd('C:\Users\colem\Desktop\STOR 674\STOR674 Final Project')

%Load Functional Connectivity Correlation Matrix from \data into Workspace
load("Data\FC\HCP_cortical_DesikanAtlas_FC.mat") 

%%% Transforming Correlation Matrix into Useable format

%Removing Subjects with Empty Entries
colsToRemove = all(cellfun(@isempty, hcp_cortical_fc), 1); 
rowsToRemove = transpose(colsToRemove);
hcp_cortical_fc(:, colsToRemove) = [];
subj_list(rowsToRemove,:) = [];
subj_list = ['Subject_ID';num2cell(subj_list)];

% Calculate the number of regions, unique pairs and number of subjects in the data
numRegions = size(hcp_cortical_fc{1}, 1); 
numPairs = numRegions * (numRegions - 1) / 2; 
numSubjects = size(hcp_cortical_fc,2);

% Use cellfun to extract the upper triangle of each correlation matrix
pairwiseData = cellfun(@(x) x(triu(true(size(x)), 1)), hcp_cortical_fc, 'UniformOutput', false);

%Combine all Pairwise Correlation matricies into one array
combinedData = zeros(numSubjects, numPairs);  

for i = 1:numSubjects
    combinedData(i, :) = pairwiseData{:,i};   
end

% Generate column names, and append column names and subject id's
columnNames = [];
idx = 1;
for j = 1:numRegions
    for k = (j+1):numRegions
        columnNames{idx} = sprintf('Region_%d_%d', j, k);
        idx = idx + 1;
    end
end

addColumnNames = [columnNames;num2cell(combinedData)];
addSubjectNames = [subj_list,addColumnNames];

%Writing to csv file for analysis into Analysis folder
Pairwise_Corr_FC = addSubjectNames;
save('Analysis/Pairwise_Corr_FC.mat','Pairwise_Corr_FC');
