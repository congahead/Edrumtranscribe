function agentcell = initializationPhase( RMAT )
%% initialization phase 
%this part is just to have a matrix to try out

startup_period=RMAT(1,3) + 5 ; %gives the endtime of initialization phase in sec 
startup_vec= unique(RMAT(RMAT(:,3)<startup_period, 3));
ev_count=length(startup_vec);  %counts events in the startup period ,
%note : instruments played exactly simultaneously are here seen as one event



%%

clusters = cell(2,1); %here the clusters will be stored:
clusters{1,1}=[startup_vec(2)-startup_vec(1)]; %the first row  contains the recent cluster interval, i.e. the mean of the vector in the second row 
clusters{2,1}= [startup_vec(2)-startup_vec(1)]; %the second row contains a vector with all intervals in that cluster
cluster_width = 0.025;  % the cluster width of the cluster interval





for i = 3:ev_count %in this for loop we sort the Inter-OIs into the clusters
    for j = 1:i-1   % the indexing originates from the fact that we only need the superdiaginal triangular part of the cartesian product matrix  
        [m,k]= min(abs(cell2mat(clusters(1,1:end))-ones(1,size(clusters,2))*(startup_vec(i)-startup_vec(j))));
            if  m <= cluster_width % if yes, put the event E_{i,j} in cluster k
                clusters{2,k}=cat(2, clusters{2,k}, (startup_vec(i)-startup_vec(j)));
                clusters{1,k}=mean(clusters{2,k}) ;    %update the cluster interval   
            else   
                clusters{1,size(clusters,2)+1}= startup_vec(i)-startup_vec(j); % make a new cluster, this row is the current cluster interval
                clusters{2,size(clusters,2)}=startup_vec(i)-startup_vec(j);    % this is the current list of the new cluster
            end
    end
end

%%
cluster_redlist=[]; %here the column numbers that will be deleted are stored   

for i = 2:size(clusters, 2) % in this loop clusters that still have a similar length are merged
    for j=1:i-1  % again, we only need superdiagonal upper triangle part of cartesian product matrix
        if abs(clusters{1,i}-clusters{1,j})<=cluster_width % if yes, clusters are merged 
           clusters{2,j}=cat(2, clusters{2,j},clusters{2,i}); % cluster lists are merged 
           clusters{1,j}= mean(clusters{2,j});   % interval is updated
           cluster_redlist(end+1)= i;  %store the indexes of the columns that are to be removed
        end
    end
end



%%
% we still have to delete the clusters that have been merged into other clusters
clusters(:, cluster_redlist)=[] ;

%% score the clusters

for i=1:size(clusters,2)   % start the scoring: each cluster gets 1 point for each IOI in his list!
                           %the score will be stored in the third row of
                           %the cell array
    clusters{3,i}=length(clusters{2,i});
end


%%
f=[10 4 3 2 1 1 1 1] ; %the f function from Dixon , page 11
%note that I multiplied the first element (supposed to be 5 in Dixon's text) in the list with 2 to make up for
%the additional factor 2 in front of every f(1) in the equation system on page 13

[~, inx]=sort([clusters{1,:}]); %sort the clusters according their interval length
clusters = clusters(:, inx);  % rearrange the cluster columns according to the index ofter sorting 
% we do this whole resorting thing in order to only have to iterate over
% the upper triangular part of cart. prod. matrix

for i=1:size(clusters,2)
    for j = 1:i
        for d=1:8
            if clusters{1,i}+cluster_width < d*clusters{1,j} %this if statement is just to avoid unnecessary iterations 
                break
            elseif abs(clusters{1,i}-d*clusters{1,j})<= cluster_width % here the actual scoring of related intervals happens
                clusters{3,i}=clusters{3,i}+f(d)*length(clusters{2,j});
                clusters{3,j}=clusters{3,j}+f(d)*length(clusters{2,i});
                break
            end
        end
    end
end


 %%

[~, inx]=sort([clusters{3,:}],'descend'); %sort the clusters according their score
clusters = clusters(:, inx) ; % rearrange the cluster columns according to the index ofter sorting 

if size(clusters,2)>30
    clusters = clusters(:, 1:30); % here we can chunk the clusters that did not
    %perform well to reduce computations
end

%initialisation of main loop
agentcell=cell(6, 0); %creating the initial agents
% first row : beatInterval
% second row : prediction
%third row : history
%fourth row: score
%fifth row: interpolated beats
%sixth row: instruments

merge_agent_threshold= 0.02;

for i=1:size(clusters,2) % one could instead use only the first 10 or 20 elements in the cluster list
    initialisation_redlist=[];
    M=cell(6, ev_count);
    for j=1:ev_count
        M{1, j} = clusters{1,i}; %beatInterval
        M{2, j} = RMAT(j,3)+clusters{1,i}; %prediction
        M{3, j} = [ RMAT(j,3) ];%history
        M{4,j} = 1 ; %score
        M{5,j} =[]; %interpolated beats
        M{6,j} =[ RMAT(j,1)]; %instrument
        if j>1   
            for k=1:j-1
                for l=0:8
                    if abs(M{3,j}- (M{2,j-k}+l*M{1,j-k}))< merge_agent_threshold 
               
                    %if abs(M{3,j}- M{2,j-k})< pred_hist_threshold
                    initialisation_redlist(end+1)=j;
                    break
                    end
                end  
            end
        end
    end
    M(:, initialisation_redlist)=[];
    agentcell = cat(2, agentcell, M);
    size(agentcell,2);
end


end

