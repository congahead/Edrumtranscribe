


load('songlist_cell.mat')

squeezed_mat_cell = cell(size(songlist_cell,2), 4)


    for i=1:size(songlist_cell,2)
        for j =1:4
            [squeezedmat, squeezedclicks]  = apply_tempo_trajectory(songlist_cell{i}{3}, songlist_cell{i}{2}, j);
            %%
            [trueclick_mat] = create_trueclick_mat(squeezedclicks, songlist_cell{i}{2});
            %%            
            %now we add a gaussian noise to the onsets 
            noisestd = 1/150
            noisevec= normrnd(0, noisestd, size(squeezedmat,1),1);
            squeezedmat_noise = squeezedmat
            squeezedmat_noise(:,6) = squeezedmat(:,6) + noisevec ;
            microcell=cell(1,4)

            microcell{1,1}= [ songlist_cell{1, i}(1) , 'tempotrack: ' j ]
            microcell{1,2} =  squeezedmat;
            microcell{1,3} = squeezedmat_noise;
            microcell{1,4} = trueclick_mat;
            squeezed_mat_cell{i,j} = microcell;
        end
    end
 

save('squeezed_mat_cell.mat', 'squeezed_mat_cell')
%%

writemidi(squeezed_mat_cell{4,3}{2},'moonlight3midi.mid')

%%
writemidi(squeezed_mat_cell{4,3}{3},'moonlight3noise150midi.mid')

%%

writemidi(squeezed_mat_cell{4,4}{2},'moonlight4midi.mid')

%%
writemidi(squeezed_mat_cell{4,4}{3},'moonlight4 noise150midi.mid')

%%

writemidi(squeezed_mat_cell{5,3}{2},'On100ways3midi.mid')
%%
writemidi(squeezed_mat_cell{5,3}{3},'On100ways3noise150midi.mid')

%%

writemidi(squeezed_mat_cell{5,4}{2},'On100ways4midi.mid')
%%
writemidi(squeezed_mat_cell{5,4}{3},'On100ways4noise150midi.mid')

%%

writemidi(squeezed_mat_cell{6,4}{2},'precious4midi.mid')
%%
writemidi(squeezed_mat_cell{6,4}{3},'precious4noise150midi.mid')

%%

writemidi(squeezed_mat_cell{8,4}{2},'summertime7_no_perc4midi.mid')
%%
writemidi(squeezed_mat_cell{8,4}{3},'summertime7_no_perc4noise150midi.mid')
