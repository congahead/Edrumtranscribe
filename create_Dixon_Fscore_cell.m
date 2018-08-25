

load('/Users/joschischneider/Documents/MATLAB/Beatroot/Dixon_output_cell.mat')
load('/Users/joschischneider/Documents/MATLAB/Beatroot/squeezed_mat_cell.mat')


Dixons_Fscore_cell = cell(size(Dixon_output_cell));
%%
for i = 1:size(Dixon_output_cell,1)
    for j=1:size(Dixon_output_cell,2)
        if size(Dixon_output_cell{i,j},1)<1
            continue
        end                
        trueclick_mat = squeezed_mat_cell{i,j}{4};
        Fscore_mat = zeros(size(trueclick_mat,1),2) ;
        falses_mat = zeros(size(trueclick_mat,1),3) ;
        for k=1:2 %k=1: no noise
            for l=1:size(trueclick_mat,1)
                microcell = cell(1,2);
                
                [F1, F2, n, false_negatives, false_positives] =Fscore(trueclick_mat{l} , Dixon_output_cell{i,j}{k}, 0.07) ;    
                Fscore_mat(l,:) =[F1, F2];
                falses_mat(l,:) = [n, false_negatives, false_positives];
                
                [Y, Index] = max(Fscore_mat, [], 1);

                 %Score
                Index;
                Score=Fscore_mat(Index(1),:) ;
                falses= falses_mat(Index(1),:) ;
                microcell{1} = Score;
                microcell{2} = falses;
                Dixons_Fscore_cell{i,j}{k}= microcell;
            end
        end
    end
end
%%
save('Dixons_Fscore_cell.mat','Dixons_Fscore_cell')