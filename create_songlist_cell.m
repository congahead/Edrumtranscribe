
%%
load('Chameleonq.mat')

Chameleonq_cell = cell(3,1)

Chameleonq_cell{1}= 'Chameleonq' %name 

Chameleonq_cell{2}= 4 % subdiv

Chameleonq_cell{3}= Chameleonq

%%
load('key2you.mat')

key2you_cell = cell(3,1)

key2you_cell{1}= 'key2you' %name 

key2you_cell{2}= 4 % subdiv

key2you_cell{3}= key2you

%%
load('key2you_no_intro.mat')

key2you_no_intro_cell = cell(3,1)

key2you_no_intro_cell{1}= 'key2you_no_intro' %name 

key2you_no_intro_cell{2}= 4 % subdiv

key2you_no_intro_cell{3}= key2you_no_intro

%%
load('moonlight.mat')

moonlight_cell = cell(3,1)

moonlight_cell{1}= 'moonlight' %name 

moonlight_cell{2}= 2 % subdiv

moonlight_cell{3}= moonlight

%%

load('On100ways.mat')

On100ways_cell = cell(3,1)

On100ways_cell{1}= 'On100ways' %name 

On100ways_cell{2}= 4% subdiv

On100ways_cell{3}= On100ways

%%
load('precious.mat')

precious_cell = cell(3,1)

precious_cell{1}= 'precious' %name 

precious_cell{2}= 4 % subdiv

precious_cell{3}= precious

%%
load('shepert.mat')

shepert_cell = cell(3,1)

shepert_cell{1}= 'shepert' %name 

shepert_cell{2}= 3 % subdiv

shepert_cell{3}= shepert

%%
load('summertime7_no_perc.mat')

summertime7_no_perc_cell = cell(3,1)

summertime7_no_perc_cell{1}= 'summertime7_no_perc' %name 

summertime7_no_perc_cell{2}= 6 % subdiv

summertime7_no_perc_cell{3}= summertime7_no_perc

%%
load('Thru_fire_no_intro.mat')

Thru_fire_no_intro_cell = cell(3,1)

Thru_fire_no_intro_cell{1}= 'Thru_fire_no_intro' %name 

Thru_fire_no_intro_cell{2}= 4 % subdiv

Thru_fire_no_intro_cell{3}= Thru_fire_no_intro



%%
songlist_cell = {Chameleonq_cell, key2you_cell ,key2you_no_intro_cell, moonlight_cell , On100ways_cell, precious_cell, shepert_cell, summertime7_no_perc_cell, Thru_fire_no_intro_cell}
%%
save('songlist_cell.mat', 'songlist_cell')
