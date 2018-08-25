function [RMAT, midifile] = CreateRmat(midifile) % Takes the name of the midi file and creates RMAT

midifile=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/' midifile '.mid']);

RMAT=midifile(:,4:6);

end