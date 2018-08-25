
load('/Users/joschischneider/Documents/MATLAB/Beatroot/squeezed_mat_cell.mat')


squeezed_mat_Fscore_cell = cell(2,1,size(squeezed_mat_cell,1) , 4, 2);

squeezed_mat_falses_cell = cell(2,1,size(squeezed_mat_cell,1) , 4,2);
%first dimentsion % create3agents, if 0: no, if 1: yes
%second dimension different sal_presets
%third dimension songs
%fourth dimension tempotracks
%fifth dimension no noise (1) or noise (2)


%test_tracks_individually(songnr, tempotrack, noise, sal_preset, create3agents ) 



for g=0:1 % create3agents, if 1: no, if 2: yes
    for h=0%:2 %loop over different sal_presets
        for i=1:size(squeezed_mat_cell,1)   %loop over all drumtracks
            for j =1:4  %loop over tempo trajectories
                for k=0:1 %k=0 : no noise, k=1:noise150
                    microcell1 =cell(2,1);
                    microcell2 =cell(2,1);
                    
                    [Score,falses]= test_tracks_individually(i, j, k, h, g ); 
                    
                   
                    squeezed_mat_Fscore_cell{g+1,h+1,i,j, k+1}= Score;
                    
                    squeezed_mat_falses_cell{g+1,h+1,i,j,k+1}= falses;
                    
                end
            end
        end
    end
end


save('squeezed_mat_Fscore_cell.mat', 'squeezed_mat_Fscore_cell' )


save('squeezed_mat_falses_cell.mat', 'squeezed_mat_falses_cell' )

