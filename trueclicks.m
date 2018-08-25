


%load files

precious= readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/precious.mid']);
save('precious.mat', 'precious')

%%
Chameleonq =readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/Chameleonq.mid']);
save('Chameleonq.mat', 'Chameleonq')
%%
key2you = readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/key2you.mid']);
save('key2you.mat', 'key2you')
%%
key2you_no_intro = readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/key2you_no_intro.mid']);
save('key2you_no_intro.mat', 'key2you_no_intro')
%%
moonlight =readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/moonlight.mid']);
save('moonlight.mat', 'moonlight')
%%
On100ways =readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/On100ways.mid']);
save('On100ways.mat', 'On100ways')
%%
shepert =readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/shepert.mid']);
save('shepert.mat', 'shepert')
%%
Thru_fire_no_intro =readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/Thru_fire_no_intro.mid']);
save('Thru_fire_no_intro.mat', 'Thru_fire_no_intro')
%%
summertime7_no_perc = readmidi(['/Users/joschischneider/Documents/MATLAB/Beatroot/midifiles_for_master/summertime7_no_perc.mid']);
save('summertime7_no_perc.mat', 'summertime7_no_perc')

%%

%Precious
clicks_precious = cell(1,3)

clicks_precious{1}=[20.0000:1:177.7500]
clicks_precious{2}=[20.0000:.5:177.7500]
clicks_precious{3}=[20.0000:0.25:177.7500]


save('clicks_precious.mat', 'clicks_precious')


%%
%Chameleonq

clicks_Chameleonq = cell(1,3)

clicks_Chameleonq{1}=[4.0000:0.5:334.7500]
clicks_Chameleonq{2}=[4.0000:0.25:334.7500]
clicks_Chameleonq{3}=[4.0000:0.125:334.7500]


save('clicks_Chameleonq.mat', 'clicks_Chameleonq')




%%
%summertime


clicks_summertime7_no_perc = cell(1,3)

clicks_summertime7_no_perc{1}=[18:1/2:178.75]
clicks_summertime7_no_perc{2}=[18:1/4:178.75]
clicks_summertime7_no_perc{3}=[18:1/6:178.75]

save('clicks_summertime7_no_perc.mat', 'clicks_summertime7_no_perc')



%%
%key2you

clicks_key2you = cell(1,3)

clicks_key2you{1} = [4.0000:1:131.5000]
clicks_key2you{2} = [4.0000:0.5:131.5000]
clicks_key2you{3} = [4.0000:0.25:131.5000]



save('clicks_key2you.mat', 'clicks_key2you')

%%
%key2you_no_intro


clicks_key2you_no_intro = cell(1,3)

clicks_key2you_no_intro{1} = [12.0000:1:131.5000]
clicks_key2you_no_intro{2} = [12.0000:0.5:131.5000]
clicks_key2you_no_intro{3} = [12.0000:0.25:131.5000]

save('clicks_key2you_no_intro.mat', 'clicks_key2you_no_intro')



%%
%thru_fire

clicks_Thru_fire_no_intro = cell(1,3)

clicks_Thru_fire_no_intro{1} = [10.0000:0.5:143.875]
clicks_Thru_fire_no_intro{2} = [10.0000:0.25:143.875]
clicks_Thru_fire_no_intro{3}  =[10.0000:0.125:143.875]


save('clicks_Thru_fire_no_intro.mat', 'clicks_Thru_fire_no_intro')


%%
%moonlight_shadow


clicks_moonlight =cell(1,3);

clicks_moonlight{1}=[12.0000:1:238.0000] ;
clicks_moonlight{2}=[12.0000:0.5:238.0000] ;
clicks_moonlight{3}=[12.0000:0.25:238.0000] ;


save('clicks_moonlight.mat', 'clicks_moonlight')


%%
clicks_shepert = cell(1,3) ;

clicks_shepert{1}=[4.5000:1:196.0000] ;
clicks_shepert{2}=[4.5000:0.5:196.0000] ;
clicks_shepert{3}=[4.5000:1/6:196.0000] ;

save('clicks_shepert.mat', 'clicks_shepert')


%%


clicks_On100ways = cell(1,3) ;

clicks_On100ways{1}=[3.0000:0.5:199.0000] ;
clicks_On100ways{2}=[3.0000:0.25:199.0000]  ;
clicks_On100ways{3}=[3.0000:0.125:199.0000]  ;

save('clicks_On100ways.mat', 'clicks_On100ways')





