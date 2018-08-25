




function [squeezedmat, squeezedclicks]  = apply_tempo_trajectory(midimat, subdiv, tempotrack)  %  , stretchnsqueezvec )
%this function is supposed to apply a tempo trajectory to a given
%midimatrix.  the midimatrix needs to have th correct onsets in clicks in
%the first column, further the tempo has to be constant over the whole
%track

%subdiv  :  2 (eigthnotes) ,  3 (tripets), 4 (sixteenth),   6 (sixtuplets) , 8(32nds) 
%bpbar stands for beats per bar; how many beats are in one bar


%%
%just some data for testing
%midimat = Chameleonq;
%subdiv=4;
%tempotrack=2;
%%
tempofactor= midimat(2,1)/midimat(2,6); %here we assume that the tempo is constant over the whole drumfile 
l = size(midimat, 1); %nr of notes played in midimat
b = floor(midimat(l, 1))+1; % nr of beats played in midimat



%%


if subdiv==2
   subdiv_vec = [0.0000 double(1/2)];

elseif subdiv ==3
   subdiv_vec =[0.0000  double(1/3) double(2/3)];
    
elseif subdiv ==4
   subdiv_vec =[0.0000 double(1/4) double(1/2) double(3/4)];
   
elseif subdiv ==6
    subdiv_vec =[0.0000 double(1/6) double(1/3) double(1/2) double(2/3) double(5/6)];
    
elseif subdiv==8
    subdiv_vec =[0.0000 double(1/8) double(1/4) double(3/8) double(1/2) double(5/8) double(3/4) double(7/8)];

%elseif subdiv == 12
%    subdiv_vec =[0.0000 double(1/12) double(1/6) double(1/4) double(1/3) double(5/12)
%        double(1/2) double(7/12) double(2/3) double(3/4) double(5/6) double(11/12)];
else 
    subdiv_vec = [0.0000];
end


% We create A and B and C only to create our gridvector, the vector ot the
% gridpoints 
A = zeros(b,length(subdiv_vec));
for i=1:length(subdiv_vec)
    A(:, i)= [1:1:b];
end

B = zeros(b,length(subdiv_vec));

for i=1:length(subdiv_vec)
    B(:,i)=subdiv_vec(i)*ones(b,1);
end

C = (A+B)' ;
%%
grid_vec = C(:); % this is the vector of gridpoints, on which the tempochanges will be applied
grid_vec = grid_vec(grid_vec(:)> midimat(1,1)-0.0001) ;% we start ehere the midimat starts
%%
midicell = cell(0, 4) ;
% in this cell we section our  midimat vertically according to the gridvector
% first column: contains the grid_vec  
% second column: zero if no notes were played in the interval[grid_vec(i), 
%                grid_vec(i+1) ), one if a note is played on gridvec(i) and 
%                else two (i.e. there are notes played in interval but not on the grid_vec(i))
%third column : onsettimes in beats
%fourth column : onsettimes in seconds
%fifth column : corresponding click times in sec
 for i=1:length(grid_vec)-1
    midicell{i,1} = grid_vec(i);
    midicell{i,3} = midimat(and(grid_vec(i)<=midimat(:,1),  midimat(:,1) < grid_vec(i+1)), 1); %third column : onset times in beats from midimat
    if isempty(midicell{i,3})== 1
        midicell{i,2} = 0;
    elseif midicell{i,3}(1)== midicell{i,1}
            midicell{i,2} = 1;
    else
            midicell{i,2} = 2;
    end
    %midicell{i,7} = midimat(and(grid_vec(i)<=midimat(:,1),  midimat(:,1) < grid_vec(i+1)), 2) %tonelength in in beats
    %midicell{i,8} = midimat(and(grid_vec(i)<=midimat(:,1),  midimat(:,1) < grid_vec(i+1)), 3) %channel (maybe redundant?)
    %midicell{i,4} = midimat(and(grid_vec(i)<=midimat(:,1),  midimat(:,1) < grid_vec(i+1)), 4) %instrument
    %midicell{i,5} = midimat(and(grid_vec(i)<=midimat(:,1),  midimat(:,1) < grid_vec(i+1)), 5) %velocity
    midicell{i,4} = midimat(and(grid_vec(i)<=midimat(:,1),  midimat(:,1) < grid_vec(i+1)), 6); %onsettime in sec
    %midicell{i,9} = midimat(and(grid_vec(i)<=midimat(:,1),  midimat(:,1) < grid_vec(i+1)), 7) %tonelength in sec
   % midicell{i,5}= trueclick_vec(and(grid_vec(i)<= tempofactor*trueclick_vec ,   tempofactor*trueclick_vec < grid_vec(i+1))); %corresponding trueclicks
    
 
 end

%%

stretchnsqueez_vec = create_stretchnsqueez(grid_vec, subdiv, tempotrack) ;

%%
%new version, with a fifth column in midicell
%in this for loop, we apply the  tempochanges as given in
%stretchnsqueez_vec to our onsets

IGI_length = 1/(subdiv*tempofactor); % the distance between two gridpoints  (IGI) in the synthetic drumfile in seconds
InnerbeatIOIs =[] ; %here we will store inner-beat IOIs temporarily

%we still have to initialize the first entry in the fourth column
midicell{1,5}= midimat(1,1)/tempofactor;

for i=2:length(grid_vec)-1
     midicell{i,5} = midicell{i-1,5}(1)+stretchnsqueez_vec(i-1)*IGI_length ;   % fill in the grid_vec in seconds in the fifth column. 
     %this will be our trueclick track
    if midicell{i,2}==0 %if there is  no onset at all ...
        midicell{i,4} =[] ; %do nothing
    elseif and(midicell{i,2}==1,length(midicell{i,4})==1) %if there is  only one onset on the beat
        midicell{i,4} = midicell{i,5}(1);
        
    elseif and(midicell{i,2}==1, length(midicell{i,4}>1)) % onset on beat, but more onsets
        for j=2:length(midicell{i,4})
            InnerbeatIOIs(j-1)=midicell{i,4}(j)-midicell{i,4}(j-1); % here we store the IOIs within that beat temporarily, need them to apply onsetshift
        end
        midicell{i,4}(1)=midicell{i,5} ;% first onset identical with the click
        for j=2:length(midicell{i,4})
            midicell{i,4}(j)=midicell{i,4}(j-1)+stretchnsqueez_vec(i)* InnerbeatIOIs(j-1); %shift remaining onsets
        end
        InnerbeatIOIs =[]; %delete IOIs
    elseif and(midicell{i,2}==2, length(midicell{i,4}>1))  % i.e. : there are several  onsets, but not on beat
        InnerbeatIOIs(1)= midicell{i,4}(1)-midicell{i,5};
        for j=2:length(midicell{i,4})
           InnerbeatIOIs(j)=midicell{i,4}(j)-midicell{i,4}(j-1); % here we store the IOIs within that beat temporarily, need them to apply onsetshift.    
        end
        for j=1:length(midicell{i,4})
            midicell{i,4}(j)= midicell{i,5}+stretchnsqueez_vec(i)*InnerbeatIOIs(j); %shift onsets 
        end
        InnerbeatIOIs =[];
    else %i.e. there is one onset , but not on beat
        InnerbeatIOIs(1)= midicell{i,4}-midicell{i,5};
        midicell{i,4}=midicell{i,5}(1)+stretchnsqueez_vec(i)*InnerbeatIOIs(1); 
        InnerbeatIOIs = [];
    end
    
end
%%


squeezedmat= midimat;
squeezedmat(:,6)= cell2mat(midicell(:,4)); % here we replace the old onsettimes with the new ones

squeezedclicks= cell2mat(midicell(:,5));
%%
%here we chunk off the ending if track is to long
if size(midicell,1)> subdiv*275
    midicell= midicell(1:subdiv*275, :);

squeezedmat = squeezedmat(1:length(cell2mat(midicell(:,4))),:) ;
squeezedclicks= squeezedclicks(1:(subdiv*275),:) ;
end

end

%%



