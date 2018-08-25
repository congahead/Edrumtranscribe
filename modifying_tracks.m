
%in this document we prepare our tracks, i.e. cut off undesired beginnings
%of our tracks etc


precious=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/precious.mid']);
%%
precious = precious(precious(:,1)>39.9,:);

precious = precious(precious(:,1)<356,:);


writemidi(precious, 'precious.mid')
%%
Precious18 = precious(18:end-28, :); %we only cut off the first 17 notes. 
% Track still starts on '1 and' with cymbal pick up,and we cuf off the roll
% at the end
%writemidi(Precious18, 'Precious18.mid')

%save('Precious18.mid')

Precious24 = precious(24:end-28, :) ; % this one starts on the beat, ,and we cuf off the roll
% at the end

%writemidi(Precious24, 'Precious24.mid')



%Now we change the tempo

Precious24_129 = Precious24
Precious24_129(:,6)= (120/129)*Precious24_129(:,6)

writemidi(Precious24_129, 'Precious24_129.mid')


%%
%summertime

summertime=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/summertime.mid']);


summertime4=summertime(4:end,:) ;% delete first three notes, they mess up the initializetion phase

%writemidi(summertime4, 'summertime4.mid')

summertime4_no_perc=summertime4(summertime4(:,4)< 60, :); % take out the percussions

%writemidi(summertime4_no_perc, 'summertime4_no_perc.mid')

summertime7_no_perc = summertime4_no_perc(4:end, :) % this file starts on the one

%writemidi(summertime7_no_perc, 'summertime7_no_perc.mid')


%now we change the tempo


summertime7_no_perc_62 =summertime7_no_perc
summertime7_no_perc_62(:,6)= (120/62)*summertime7_no_perc_62(:,6)


%writemidi(summertime7_no_perc_62, 'summertime7_no_perc_62.mid')


%%
%key2you

key2you=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/key2you.mid']);

%key2you = key2you(5:1082,:); %there is a pause of more than 7 seconds after that index , thus our agents die

key2you_no_intro = key2you(42:end,:) ; 
%this file starts where the beat sets in , on the first Bass drum note

%key2you_intro = key2you(5:end,:);
%this file has the "count in" deleted, but contains the cymbal intro 
%%

writemidi(key2you, 'key2you.mid')
%%
writemidi(key2you_no_intro, 'key2you_no_intro.mid')

%%
%now we change the tempo from 120 to 80
%key2you_no_intro_80 = key2you_no_intro ;
%key2you_no_intro_80(:, 6)= (120/80)*key2you_no_intro(:, 6);



%writemidi(key2you_no_intro_80, 'key2you_no_intro_80.mid')




%key2you_intro_80 = key2you_intro;
%key2you_intro_80(:, 6)= (120/80)*key2you_intro(:, 6);

%change tempo

%key2you_intro_80 = key2you_intro ;
%key2you_intro_80(:, 6)= (120/80)*key2you_intro(:, 6);



%writemidi(key2you_intro_80, 'key2you_intro_80.mid')


%%
%On100ways


on100ways=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/On100ways.mid']);

on100ways= on100ways(on100ways(:,1)>7.99, :)


writemidi(on100ways, 'on100ways.mid')

%change tempo

%on100ways_groove_94= on100ways_groove ;

%on100ways_groove_94(:,6) = (120/94)*on100ways_groove(:,6); 

%writemidi(on100ways_groove_94, 'on100ways_groove_94.mid')


%%


Thru_fire=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/thru_fire.mid']);

Thru_fire_no_intro=Thru_fire(Thru_fire(:,1)>19.9, :)


writemidi(Thru_fire_no_intro, 'Thru_fire_no_intro.mid')

% change tempo


%thru_fire_no_intro_66=Thru_fire_no_intro
%thru_fire_no_intro_66(:,6) =(120/66)*thru_fire_no_intro_66(:,6)
 


%writemidi(thru_fire_no_intro_66, 'thru_fire_no_intro_66.mid')




%%
%moonlight shadow

moonlight=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/moonlight.mid']);

moonlight=moonlight(moonlight(:, 1)> 23.9416, :)  ;%from where the groove starts

writemidi(moonlight, 'moonlight.mid')

%%

%%change tempo

%moonlight_groove_129 = moonlight_groove;
%moonlight_groove_129(:,6) = (120/129)*moonlight_groove(:,6);
%

%writemidi(moonlight_groove_129, 'moonlight_groove_129.mid')


%%
%%chameleon

Chameleonq=readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/chameleonq.mid']);

Chameleonq = Chameleonq( 7.9< Chameleonq(:, 1) & Chameleonq(:, 1)< 670. , :); %chunk off beginning and end 


writemidi(Chameleonq, 'Chameleonq.mid')

 %change tempo
%Chameleonq_104 = Chameleonq;
%Chameleonq_104(:,6) =(120/104)* Chameleonq(:,6);

%writemidi(Chameleonq_104, 'Chameleonq_104.mid')

%%
shepert = readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/shepertbluesdrums.mid']);
shepert=shepert(shepert(:,1)>8.9,:);
writemidi(shepert, 'shepert.mid')