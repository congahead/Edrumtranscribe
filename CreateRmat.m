function [RMAT] = CreateRmat(midifile) % Takes the name of the midi file and creates RMAT, i.e. extracts 4th to sixth column

midifile=readmidi(['midifile '.mid']);

RMAT=midifile(:,4:6);

end
