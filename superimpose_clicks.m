% now we create a midifile were we superimpose the click (played on a
% cowbell) onto squeezedmat



trueclicksmat= zeros(length(trueclicks), 7);
trueclicksmat(:,6)= trueclicks' ;

trueclicksmat(:,3) = midimat(1,3); %use same channel as midimat
trueclicksmat(:,4) = 56; % play a cowbell on the click
trueclicksmat(:,5) = 95; % clowbell velocity
trueclicksmat(:,7) = mode(midimat(:,7)); 

[onsets_n_trueclicks, I] = sort(vertcat(squeezedmat(:,6), trueclicks'));
squeezedmat_n_click = [squeezedmat; trueclicksmat];

squeezedmat_n_click=squeezedmat_n_click(I,:);