
load('squeezed_mat_Fscore_cell.mat')
%load('Dixon_output_cell.mat')
load('Dixons_Fscore_cell.mat')

compare_Fscore_cell = cell(2,9,4);
%first dimension: 1: no noise, 2:noise150
%second dimension songs
%third dimension: tempotracks

for i=1:2 %1:no noise, 2 :noise150
    for j=1:size(Dixons_Fscore_cell,1) %songs
        for k=1:size(Dixons_Fscore_cell,2)%tempotracks
            if size(Dixons_Fscore_cell{j,k})<1
                continue
            else
            microcell=cell(3,2);
            microcell{1,1} = Dixons_Fscore_cell{j,k}{i}{1}(1) %Dixons score
            microcell{2,1} = squeezed_mat_Fscore_cell{1,1,j,k, i}(1)%our score without create 3agents
            microcell{3,1} = squeezed_mat_Fscore_cell{2,1,j,k, i}(1)%our score with create 3agents
            
            
            microcell{1,2} = Dixons_Fscore_cell{j,k}{i}{1}(2) %Dixons score
            microcell{2,2} = squeezed_mat_Fscore_cell{1,1,j,k, i}(2)%our score without create 3agents
            microcell{3,2} = squeezed_mat_Fscore_cell{2,1,j,k, i}(2)%our score with create 3agents
            
            compare_Fscore_cell{i,j,k}= microcell
            
            end
           
        end
    end
end

%%
save('compare_Fscore_cell.mat', 'compare_Fscore_cell')