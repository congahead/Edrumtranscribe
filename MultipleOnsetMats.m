one_onset_mat =1
%%
A = permn([1 2], 2)
two_onset_mat= A(A(:,1) <= A(:,2) & A(:,1)==1 , :)

%%
A = permn([1 2 3], 3);

A = A((A(:,1) <= A(:,2)) & (A(:,2) <= A(:,3)) & (A(:,1)==1) , :);

B = (A(:,2:end)-A(:,1:end-1)<2);

three_onset_mat = A((B(:,1)+B(:,2)==2), :)

%%

A = permn([1 2 3 4], 4);

A = A((A(:,1) <= A(:,2)) & (A(:,2) <= A(:,3)) & (A(:,3) <= A(:,4)) & (A(:,1)==1), :);

B = (A(:,2:end)-A(:,1:end-1)<2);

four_onset_mat = A((B(:,1)+B(:,2)+B(:,3)==3), :)

%%

A = permn([1 2 3 4 5], 5);

A = A((A(:,1) <= A(:,2)) & (A(:,2) <= A(:,3)) & (A(:,3) <= A(:,4)) & (A(:,4) <= A(:,5)) & (A(:,1)==1), :);

B = (A(:,2:end)-A(:,1:end-1)<2);

five_onset_mat = A((B(:,1)+B(:,2)+B(:,3)+B(:,4)==4), :)

%%
A = permn([1 2 3 4 5 6], 6);

A = A((A(:,1) <= A(:,2)) & (A(:,2) <= A(:,3)) & (A(:,3) <= A(:,4)) & (A(:,4) <= A(:,5)) & (A(:,5) <= A(:,6)) &  (A(:,1)==1), :);

B = (A(:,2:end)-A(:,1:end-1)<2);

six_onset_mat = A((B(:,1)+B(:,2)+B(:,3)+B(:,4)+B(:,5)==5), :)
%%

A = permn([1 2 3 4 5 6 7], 7);

A = A((A(:,1) <= A(:,2)) & (A(:,2) <= A(:,3)) & (A(:,3) <= A(:,4)) & (A(:,4) <= A(:,5)) & (A(:,5) <= A(:,6)) & (A(:,6) <= A(:,7)) & (A(:,1)==1), :);

B = (A(:,2:end)-A(:,1:end-1)<2);

seven_onset_mat = A((B(:,1)+B(:,2)+B(:,3)+B(:,4)+B(:,5)+B(:,6)==6), :)

%%


A = permn([1 2 3 4 5 6 7 8], 8);

A = A((A(:,1) <= A(:,2)) & (A(:,2) <= A(:,3)) & (A(:,3) <= A(:,4)) & (A(:,4) <= A(:,5)) & (A(:,5) <= A(:,6)) & (A(:,6) <= A(:,7)) & (A(:,7) <= A(:,8)) &(A(:,1)==1), :);

B = (A(:,2:end)-A(:,1:end-1)<2);

eight_onset_mat = A((B(:,1)+B(:,2)+B(:,3)+B(:,4)+B(:,5)+B(:,6)+B(:,7)==7), :)

%%


%this one is not running . the permn command is to expensive. how can I solve this problem?

% I figured out there is a way , but I dont have to do it now. Trick : use
% that first column is always one . and highest numer in lower left corner
% is only used once. this earns you one more iteration. When that is not
% enough, use that second column is never higher than two . etc



A = permn([1 2 3 4 5 6 7 8], 8);

a = ones(size(A,1),1);

A = horzcat(a,A);

A = A((A(:,1) <= A(:,2)) & (A(:,2) <= A(:,3)) & (A(:,3) <= A(:,4)) & (A(:,4) <= A(:,5)) & (A(:,5) <= A(:,6)) & (A(:,6) <= A(:,7)) & (A(:,7) <= A(:,8)) & (A(:,8) <= A(:,9)) & (A(:,1)==1), :);

B = (A(:,2:end)-A(:,1:end-1)<2);

nine_onset_mat = A((B(:,1)+B(:,2)+B(:,3)+B(:,4)+B(:,5)+B(:,6)+B(:,7)+B(:,8)==8), :);

nine_onset_mat = vertcat(nine_onset_mat, [1 2 3 4 5 6 7 8 9])

%%

FindTheRigthMat = cell(9,1)
FindTheRigthMat{1}= one_onset_mat
FindTheRigthMat{2}=two_onset_mat
FindTheRigthMat{3}=three_onset_mat
FindTheRigthMat{4}=four_onset_mat
FindTheRigthMat{5}=five_onset_mat
FindTheRigthMat{6}= six_onset_mat
FindTheRigthMat{7}=seven_onset_mat
FindTheRigthMat{8}=eight_onset_mat
FindTheRigthMat{9}=nine_onset_mat

