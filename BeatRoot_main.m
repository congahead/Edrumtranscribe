

%%
midi_data = 'shepert' % refer to a midifile on you have and want to transcribe, here it's a midifile called 'shepert' 

 

%Create RMAT
[RMAT, midifile] = CreateRmat(midi_data); 



%%
%initialization phase
agentcell_init = initializationPhase(RMAT); 

%%
%beat tracking
sal_presets =0   %default value:0 other possibilities :1,2
create3agents =1 %default value:1, other posiibilities : 0
[agentcell, agentchangelist, agentnr] = beat_Tracking(agentcell_init, RMAT, sal_presets,create3agents); 

winning_agent = sort(cat(2,agentcell{3,1}, agentcell{5,1}), 'ascend'); %sort agents by their score
winning_agent(end+1) = winning_agent(end)+agentcell{1,1} ; %add one more prediction to get the last click, just in case there are notes played after the last click
    
winning_agent2 = sort(cat(2,agentcell{3,2}, agentcell{5,2}), 'ascend'); % winning_agent2 is the second best agent...
winning_agent2(end+1) = winning_agent2(end)+agentcell{1,2} ; %add one more prediction to get the last click, just in case there are notes played after the last click
   

%%

clicks = (winning_agent)' ;



%%

hold on
plot(RMAT(RMAT(:,1)<37,3), 0.9*ones(length(RMAT(RMAT(:,1)<37,3))),'k.'  ); %Bassdrums in black

ylim([0,2]);

plot(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3), ones(length(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3))),'k.'); %Snaredrums 

plot(RMAT(RMAT(:,1)>40,3), 0.95*ones(length(RMAT(RMAT(:,1)>40,3))),'k.'  ); %other instruments 

for i=1:length(winning_agent') %the winning agent is plotted in red
   plot([winning_agent(i) winning_agent(i)],[0.9 1],'r');
end

hold off

%%
if Index==1
    for i=1:length(trueclick_mat{1})
           plot([trueclick_mat{1}(i) trueclick_mat{1}(i)],[1 1.1], 'm') ;
    end
elseif Index==2
    for i=1:length(trueclick_mat{2})
          plot([trueclick_mat{2}(i) trueclick_mat{2}(i)],[1 1.1],'m') 
    end
else 
    for i=1:length(trueclick_mat{3})
           plot([trueclick_mat{3}(i) trueclick_mat{3}(i)],[1 1.1],'m') 
    end

end

hold off

%%

%Quantization section

%in this section,  we create the cell array  B , the first column has the beats,
%the second to fourth  columns store all the corresponding RMAT data in the half-open intervall [beat(i),
%beat(i+1)). 
%second column: instrument
%third column: velocity
%fourth column: onsettime 


B = BeatSegmentation(RMAT, clicks);



%%
%in this for loop , we quantize the segments and store the resulting
%quantized codevectors in the fifth column of B 
%Also, we store all quantized active quant. loc. in a vector in order to be
%able to compute a histogram

tic
histogramlist =[];
for i=1:size(B,1)-1
    
   B{i, 5} = perform_quantization(B{i,1},B{i+1,1}, B{i, 4}) ;
   histogramlist= horzcat(histogramlist,B{i, 5});
end

toc



%%
%here we compute a histogram of the acive quant.loc.

[shuffleornot, subdiv_in_beat]=analyze_histogram(histogramlist, 1)

%second argument is plot, if you want a histogramplot enter a 1 
%shuffleornot is either 0 (no shuffle) or 1 (shuffle)
%subdiv_in_beat: how many subdivs are in between two clicks.
     %examples : shuffled 8notes gives output [1,2], straight 8notes
     %gives[0,2], straight 16th gives [0,4] ... 
%%
% here we create a list of all played instruments, sorted by number of
% occurrence 


instrumentlist = unique(RMAT(:,1)); %list of all instruments that have been played

[a,b]= hist(RMAT(:,1), instrumentlist);

[Y,I]= sort(a, 'descend'); % here we sort the columns of C according to how often the corresponding instrument is played. 

instrumentlist = instrumentlist(I); % now instrumentlist is sorted by number of occurrence




%% 
%now we only need the number of counts in one bar and the subdivision_in_notation , then we have all info needed to make a transcription

[countnr, subdivision_in_notation] = find_time_signature(B, instrumentlist, subdiv_in_beat)



