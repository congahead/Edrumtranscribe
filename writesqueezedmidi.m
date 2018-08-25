

for i = 8%1:size(squeezed_mat_cell,1)
    for j= 4%1:size(squeezed_mat_cell,2)
        string= strcat(strcat(squeezed_mat_cell{i,j}{1}(1), (num2str(squeezed_mat_cell{i,j}{1}{3}))),'.mid') ;        
        string_noise150= strcat(strcat(squeezed_mat_cell{i,j}{1}(1), (num2str(squeezed_mat_cell{i,j}{1}{3})), 'noise150'),'.mid')   ;      
        string_squeezedclicks =strcat('squeezedclicks_', squeezed_mat_cell{i,j}{1}(1), (num2str(squeezed_mat_cell{i,j}{1}{3})),'.mat');
        writemidi(squeezed_mat_cell{i,j}{2}, char(string));
        writemidi(squeezed_mat_cell{i,j}{3}, char(string_noise150));
        squeezedclicks = squeezed_mat_cell{i,j}{4};
        save(char(string_squeezedclicks), 'squeezedclicks');

    end
end
        