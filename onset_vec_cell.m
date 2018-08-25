
onsetvec_cell = cell(1,8);
onsetvec_cell{1}= unique(sort(permn([0 1/6 1/4 1/3 1/2 2/3 3/4 5/6 1], 1),2),'rows');

for i =2:8
    A = unique(sort(permn([0 1/6 1/4 1/3 1/2 2/3 3/4 5/6 1], i),2),'rows');

    [M, F]= mode(A');

    A=A(F<5,:);
    onsetvec_cell{1,i}=A
    
end
%%
%

lambda = 0.7;
depth_transformer=[1 2 3 4 6 12] ;
neg_ex_factor = [1.5 2 2.5 3 3.5 4.5] ; % modify this vector to in- or decrease the prior probabilities 

tic

for i=1:8
    priorlist = [];
    for j=1:size(onsetvec_cell{i},1)
        lcmlist=[];
        for k=1:size(onsetvec_cell{i},2)
            if onsetvec_cell{i}(j,k)==0
                lcmlist(end+1)=1;
            elseif  onsetvec_cell{i}(j,k)== 2/3
                lcmlist(end+1)=3;
            elseif  onsetvec_cell{i}(j,k)== 3/4
                lcmlist(end+1)=4;
            elseif  onsetvec_cell{i}(j,k)== 5/6
                lcmlist(end+1)=6;          
            else
                lcmlist(end+1)=1/onsetvec_cell{i}(j,k);
            end
            
        end
         depth_nr=lcm(sym(lcmlist));  % this depthnr is the inverse of the finest grid interpolating all quantized onsets. the higher this nr (bounded by 12), the more unlikely a pattern is
         
         %EVENTUALLY, WE SHOULD TRANSFORM THIS NR S.T. THE DIFFERENCE IN PROBABILITY IS
         %NOT THAT BIG
         priorlist(end+1)= exp((-1)*lambda*neg_ex_factor(depth_transformer==depth_nr)); %this list contains the unnormalized probabilities of each codevector. for each possible onsetvector, we will only pick out the codevectors that are realistic options and then normalize over those.
    end
    onsetvec_cell{i}(:,end+1)= priorlist ;
end

toc
%%

save('onsetvec_cell.mat', 'onsetvec_cell')