% compute the mean Fscore

load('/Users/joschischneider/Documents/MATLAB/Beatroot/compare_Fscore_cell.mat')
%%
F1score_cell = compare_Fscore_cell(2,:,:)


        
compare_Fscore_cell(2,:,:)
dixonscore = 0
Standardscore =0
create3score=0

%F1score_cell{1,3,:} = []
%%

for i=9%1:2%4:9
    for j=4        
        if size(F1score_cell{1,i,j},1) == 0
            continue
        else
          dixonscore =dixonscore+F1score_cell{1,i,j}{1,1}
          Standardscore =Standardscore+F1score_cell{1,i,j}{2,1}
          create3score =create3score+F1score_cell{1,i,j}{3,1}
        end
    end
end

%%
dixonscore = dixonscore/4

Standardscore=Standardscore/4

create3score=create3score/4
