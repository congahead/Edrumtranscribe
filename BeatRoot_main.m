

%%
inputstring = 'Janosch1' % here we put the name of our file

 
%RMAT=squeezed_mat_cell{5,3}{3}(:,4:6);

%trueclick_mat= clicks_On100ways
%Create RMAT
midi_data = inputstring
[RMAT, midifile] = CreateRmat(midi_data); 


% in the next section, we obtain the matrix with the true clicks
%str1 = ['clicks', '_' , inputstring]
%str2 = [str1, '.mat']
%y=load(str2)
%trueclick_mat= struct2array(y) 

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
   
   
   
    winning_agent2 = sort(cat(2,agentcell{3,2}, agentcell{5,2}), 'ascend');
    winning_agent2(end+1) = winning_agent2(end)+agentcell{1,2} ; %add one more prediction to get the last click, just in case there are notes played after the last click
   
    %   winning_agent3 = sort(cat(2,agentcell{3,3}, agentcell{5,3}), 'ascend');
    %   winning_agent3(end+1) = winning_agent3(end)+agentcell{1,3}  %add one more prediction to get the last click, just in case there are notes played after the last click
   
    %   winning_agent4 =  sort(cat(2,agentcell{3,4}, agentcell{5,4}), 'ascend');
    %   winning_agent4(end+1) = winning_agent4(end)+agentcell{1,4}  %add one more prediction to get the last click, just in case there are notes played after the last click
   
%%

clicks = (winning_agent)' ;


%%
%run Fscore 

Fscore_mat = zeros(3,2)

for i =1:3
     Fscore_mat(i,:) =Fscore(trueclick_mat{i} , clicks, 0.07)
end

[Score, Index] = max(Fscore_mat, [], 1);

Score
Index
%%

hold on
plot(RMAT(RMAT(:,1)<37,3), 0.9*ones(length(RMAT(RMAT(:,1)<37,3))),'k.'  ); %Bassdrums in black

ylim([0,2]);

plot(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3), ones(length(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3))),'k.'); %Snaredrums 

plot(RMAT(RMAT(:,1)>40,3), 0.95*ones(length(RMAT(RMAT(:,1)>40,3))),'k.'  ); %other instruments 

%plot([[18:1/2:179.00] [18:1/2:179.00]], [1.1*ones(length([18:1/2:179.00])) 0.9*ones(length([18:1/2:179.00]))] ,'m.')

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
%optional output

%agentcell(:, 1:10) %display the 10 best agents
%plot(linspace(0,length(agentnr)/3,length(agentnr)),agentnr ) %plot the number of agents against iteration count


%this section plots the best agents
%hold on

% best agent
%plot(RMAT(:,3),ones(length(RMAT(:,3))),'k.');
%for i=1:length(winning_agent') %the winning agent is plotted in red
%   plot([winning_agent(i) winning_agent(i)],[0.9 1],'r');
%end

% second best agent
%for i=1:length(winning_agent2') %2nd best plotted in blue
%   plot([winning_agent2(i) winning_agent2(i)],[1.1 1],'b');  
%end

%third best agent
%for i=1:length(winning_agent3') %3d best plotted in green
%   plot([winning_agent3(i) winning_agent3(i)],[1.2 1.1],'g');
%end   

%fourth best agent
%for i=1:length(winning_agent4') %4th best plotted in yellow 
%   plot([winning_agent4(i) winning_agent4(i)],[1.3 1.2],'y');
%end  

%ylim([0,2]);


%hold off


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
[countnr, subdivision_in_notation] = find_time_signature(B, instrumentlist, subdiv_in_beat)





%from here everything is in the find_time_signature function


%%
%now we create D. each column contains the name of an instrument in the
%first row and a time series in the second row. the time series gives the
%active quantization positions with the according velocity information for
%that particular instrument. 
% the first column is a file that combines all instruments. after that, 
%the instruments are ordered by occurrence (i.e. , D{1,2} is the most occurring instrument)

D = SplitInstruments(B, instrumentlist)

%%
pitchlist=[35:1:81];

pitch2name = {' Acoustic Bass Drum ', ' Bass Drum 1 ', ' Side Stick ', ' Acoustic Snare ',' Hand Clap ', ' Electric Snare ', ' Low Floor Tom ', ' Closed High-Hat ',' High Floor Tom ', ' Pedal High-Hat ', ' Low Tom ', ' Open High-Hat ' ,' Low Mid-Tom ',' High Mid-Tom ', ' Crash Cymbal1 ', ' High Tom ', ' Ride Cymbal 1 ', ' Chinese Cymbal ',' Ride Bell ', ' Tamburine ', ' Splash Cymbal ', ' Cowbell ', ' Crash Cymbal 2 ', ' Vibraslap ', ' Ride Cymbal 2 ', 'Hi Bongo',' Low Bongo ', ' Mute Hi Conga ', ' Open Hi Conga ' , 'Low Conga', 'High Timbale', 'Low Timbale' , 'High Agogo', 'Low Agogo', 'Cabasa', 'Maracas', 'Short Whistle', 'Long Whistle', 'Short Guiro', 'Long Guiro', 'Claves', 'Hi Wood Block', 'Low Wood Block', 'Mute Cuica', 'Open Cuica', 'Mute Triangle', 'Open Triangle'};


pitch2name(instrumentlist-34)

%%
% now we look at the autocorrelations to determine the time signature


if size(clicks,1)*12-1<1000
    lagnr = (size(clicks,1)-1)*12-1
else
    lagnr = 1000
end
    
%%

acf1=autocorr(D{2,1}, lagnr);
if length(instrumentlist)>1
    acf2=autocorr(D{2,2}, lagnr);
    
    if length(instrumentlist)>2
        acf3=autocorr(D{2,3}, lagnr);
        
        if length(instrumentlist)>3
            acf4=autocorr(D{2,3}, lagnr);
            
            if length(instrumentlist)>4
                acf5=autocorr(D{2,5}, lagnr);
                
                if length(instrumentlist)>5
                    acf6=autocorr(D{2,6}, lagnr);
                    
                     if length(instrumentlist)>6
                        acf7=autocorr(D{2,7}, lagnr);
                     end
                end
            end
        end
    end    
end

%%

autocorr_relevance_threshold=0.4;
%only when the peak of the autocorrelation is higher than this value, it is
%considered

[Y1, I1] = max(acf1(2:end));
maxlist=[I1];
if length(instrumentlist)>1
    [Y2, I2] = max(acf2(2:end));
    if Y2>autocorr_relevance_threshold
        maxlist(end+1)=[I2];
    end
    if length(instrumentlist)>2
        [Y3, I3] = max(acf3(2:end));
        if Y3>autocorr_relevance_threshold
        maxlist(end+1)=[I3];
        end
        if length(instrumentlist)>3
            [Y4, I4] = max(acf4(2:end));
            if Y4>autocorr_relevance_threshold
            maxlist(end+1)=[I4];
            end
            if length(instrumentlist)>4
                [Y5, I5] = max(acf5(2:end));
                if Y5>autocorr_relevance_threshold
                maxlist(end+1)=[I5];
                end
                if length(instrumentlist)>5         
                    [Y6, I6] = max(acf6(2:end));
                    if Y6>autocorr_relevance_threshold
                    maxlist(end+1)=[I6];
                    end
                    if length(instrumentlist)>6         
                    [Y7, I7] = max(acf7(2:end));
                        if Y7>autocorr_relevance_threshold
                            maxlist(end+1)=[I7];
                        end
                    end
                end
            end
        end
    end
end



instrumentswecareaboutlist = [35,36,37,38,39,40,41,42,43,44,45,46,47, 48, 50,51,52,53,54, 56,59];
%here we exclude Crash- and splash cymbals as well as most percussion
%sounds. This can be improved , formulating rules when you want to consider
%an instrument and when not . for now, this hopefully does the job on our
%dataset. 




%%
%in this section we sort out instrumnts that might not help to find the
%meter: the ones that are not in instrumentswecareaboutlist


careaboutlist=[1];
for i=2:6 % note here that acf1 represents the file "all instruments combined "
    if ismember(instrumentlist(i), instrumentswecareaboutlist)==1
        careaboutlist(end+1)= i;
    end
end
%%
%pitch2name(instrumentlist-34) % here we can see the names of the 6 most
%played instruments

maxlist = maxlist(careaboutlist)/12
%%
clickcyclelength= max(maxlist') %after how many clicks do we get the highest autocorrelation

totalsubdivsinbar=clickcyclelength*subdiv_in_beat
%this number gives the total nr of subdivisions in one cycle (which usually corresponds to one bar)
%%
prime_factors = factor(clickcyclelength) %we look at the prime factors to determine the number of beats 
%Are there nonbinary numbers like 3,5,7,... if yes , those refer most
%likely to the beat number . Unless It's a three and there is three beats i
%in a subdivision


if sum(abs(prime_factors-2*ones(size(prime_factors))))==0
    countnr=4
    nonbinary_factors = []
else 
    indexvec=find((prime_factors-2*ones(size(prime_factors))))
    nonbinary_factors=prime_factors(indexvec)
end
if length(nonbinary_factors)==1
    countnr = nonbinary_factors
elseif length(nonbinary_factors)>1 && subdiv_in_beat>1
    countnr= prod(nonbinary_factors)
elseif length(nonbinary_factors)>1 && subdiv_in_beat==1 && nonbinary_factors(1)==3
    countnr =prod(nonbinary_factors(2:end))
    
end
        


%%
% here we determine the time signature finally 
%if countnr==4
%    if totalsubdivsinbar >6*countnr % in this case , write as a multiple bar pattern
%        time_signature= [4, sixteenthnotes]
%    elseif totalsubdivsinbar ==6*countnr 
%        time_signature = [4, sixteenthtriplets]
%    elseif totalsubdivsinbar ==4*countnr  
%        time_signature= [4, sixteenthnotes]   
%    elseif  totalsubdivsinbar ==3*countnr
%        time_signature = [4, eightnotetriplets]
%    elseif totalsubdivsinbar ==2*countnr
%        time_signature = [4, eightnotes]
%    elseif totalsubdivsinbar ==countnr
%        time_signature = [4, quarternotes]
%    end       
%elseif countnr==3
%    if totalsubdivsinbar >6*countnr % in this case , write as a multiple bar pattern
%        time_signature= [3, sixteenthnotes]
%    elseif totalsubdivsinbar ==6*countnr 
%        time_signature = [3, sixteenthtriplets]
%    elseif totalsubdivsinbar ==4*countnr  
%        time_signature= [3, sixteenthnotes]       
%    elseif  totalsubdivsinbar ==3*countnr
%        time_signature = [3, eightnotetriplets]
%    elseif totalsubdivsinbar ==2*countnr
%        time_signature = [3, eightnotes]
%    elseif totalsubdivsinbar ==countnr
%        time_signature = [3, quarternotes]
%    end
        
%else
     if totalsubdivsinbar >6*countnr % in this case , write as a multiple bar pattern
        time_signature= [countnr, 'sixteenthnotes']
    elseif totalsubdivsinbar ==6*countnr 
        time_signature = [countnr, 'sixteenthtriplets']
    elseif totalsubdivsinbar ==4*countnr  
        time_signature= [countnr, 'sixteenthnotes']       
    elseif  totalsubdivsinbar ==3*countnr
        time_signature = [countnr, 'eightnotetriplets']
    elseif totalsubdivsinbar ==2*countnr
        time_signature = [countnr, 'eightnotes']
    elseif totalsubdivsinbar ==countnr
        time_signature = [countnr, 'quarternotes']
    end







%%
% We make it new from here 



A1 = D{2,1} ; %This instrument is played the most 
A1 = A1(:, 1:end-1);
A1 = A1';
Avec1 = A1(:);
 %%
A2 = cell2mat(D{2,2}); %this instrument is played the second most
A2 = A2(:, 1:end-1);
A2 = A2';
Avec2 = A2(:);


A3 = cell2mat(D{2,3}); %this instrument is played the third most
A3 = A3(:, 1:end-1);
A3 = A3';
Avec3 = A3(:);

A4 = cell2mat(D{2,4});%this instrument is played the fourth most
A4 = A4(:, 1:end-1);
A4 = A4';
Avec4 = A4(:);
%%












%% From here, we will make it new

 
%Now we give each instrument that has been played an own column, so that we can check the autocorrelattion individually
instrumentlist = unique(RMAT(:,1)); %list of all instruments that have been played
 
C = cell(length(clicks), length(instrumentlist)); % each instrument gets its column

for i=1:length(instrumentlist)
    disp(i)
   for j=1:length(clicks)-1
       %if or(ismember(instrumentlist(i),B{j,5}),ismember(instrumentlist(i),B{j,2})) %if the instrument is played on click or between click
           
           
          %if and(ismember(instrumentlist(i),B{j,5}),ismember(instrumentlist(i),B{j,2})) %if instrument played on click and between click
           if ismember(B{j,2},instrumentlist(i))
           [tf,loc]=ismember(B{j,2},instrumentlist(i));
           idx=[1:length(B{j,2})];
           idx=idx(tf);
           disp(j)
           onsetvec = cell2mat(B(j,4));
           onsetvec = onsetvec(idx)
           quantvec=quantize_microbeats1(clicks(j), clicks(j+1),onsetvec);
           C{j,i}=horzcat([1],quantvec);
           
           
            %elseif ismember(instrumentlist(i),B{j,5}) %if instrument is played on click
                  
                %C{j,i}=[1 0 0 0 0 0 0 0 0 0 0 0];
                   
                %else %if instrument played only between clicks
%                    [tf,loc]=ismember(B{j,2},instrumentlist(i));
%                    idx=[1:length(B{j,2})];
%                    idx=idx(tf);
%            
%                    onsetvec = cell2mat(B(j,4));
%                    onsetvec = onsetvec(idx);
%                    quantvec=quantize_microbeats1(clicks(j), clicks(j+1),onsetvec);
%                    C{j,i}=horzcat([0],quantvec);
%            
%           end
       
           else
                C{j,i}=[0 0 0 0 0 0 0 0 0 0 0 0 0];
         
            end
   end
end
toc

[a,b]= hist(RMAT(:,1), instrumentlist);

 
 [Y,I]= sort(a, 'descend'); % here we sort the columns of C according to how often the corresponding instrument is played. 
 
 
 
 
 %%
A1 = cell2mat(C(:,I(1))); %This instrument is played the most 
A1 = A1';
Avec1 = A1(:);

A2 = cell2mat(C(:,I(2))); %this instrument is played the second most
A2 = A2';
Avec2 = A2(:);


A3 = cell2mat(C(:,I(3))); %this instrument is played the third most
A3 = A3';
Avec3 = A3(:);

A4 = cell2mat(C(:,I(4)));%this instrument is played the fourth most
A4 = A4';
Avec4 = A4(:);

A5 = cell2mat(C(:,I(5))); %this instrument is played the fifth most
A5 = A5';
Avec5 = A5(:);

%A6 = cell2mat(C(:,I(6))); %this instrument is played the sixth most
%A6 = A6';
%Avec6 = A6(:);

%%
%in this part, we will take care of finding the instruments name
%corresponding to the pitch number 

pitchlist=[35:1:59];
pitch2name={' Acoustic Bass Drum ', ' Bass Drum 1 ', ' Side Stick ', ' Acoustic Snare ',' Hand Clap ', ' Electric Snare ', ' Low Floor Tom ', ' Closed High-Hat ',' High Floor Tom ', ' Pedal High-Hat ', ' Low Tom ', ' Open High-Hat ' ,' Low Mid-Tom ',' High Mid-Tom ', ' Crash Cymbal1 ', ' High Tom ', ' Ride Cymbal 1 ', ' Chinese Cymbal ',' Ride Bell ', ' Tamburine ', ' Splash Cymbal ', ' Cowbell ', ' Crash Cymbal 2 ', ' Vibraslap ', ' Ride Cymbal 2 '};
%%
acf1=autocorr(Avec1,480);
ACF1 =acf1(1:12:end); %only every twelfth sample of acf1 , corresponding to shifting by one click
index=(pitchlist==instrumentlist(I(1)));
instrumentname= pitch2name{index};
figure(1)
scatter( [0:length(acf1(1:12:end))-1],ACF1) %this is the acf when shifting by twelve
title( [' ACF of  instrument:', instrumentname ])
ax = gca;
ax.XGrid =  'on';
ax.YGrid = 'off';



acf2=autocorr(Avec2,480);
ACF2 =acf1(1:12:end); %only every twelfth sample of acf2 , corresponding to shifting by one click
index=(pitchlist==instrumentlist(I(2)));
instrumentname= pitch2name{index} ;
figure(2)
scatter( [0:length(acf1(1:12:end))-1],ACF2) %this is the acf when shifting by twelve
title( [' ACF of  instrument:', instrumentname ])
ax = gca;
ax.XGrid =  'on';
ax.YGrid = 'off';


acf3=autocorr(Avec3,480);
ACF3 =acf3(1:12:end); %only every twelfth sample of acf3 , corresponding to shifting by one click
index=(pitchlist==instrumentlist(I(3))); 
instrumentname= pitch2name{index};
figure(3)
scatter( [0:length(acf1(1:12:end))-1],ACF3) %this is the acf when shifting by twelve
title( [' ACF of  instrument:', instrumentname ])
ax = gca;
ax.XGrid =  'on';
ax.YGrid = 'off';


acf4=autocorr(Avec4,480);
ACF4 =acf4(1:12:end); %only every twelfth sample of acf4 , corresponding to shifting by one click
index=(pitchlist==instrumentlist(I(4)));
instrumentname= pitch2name{index};
figure(4)
scatter( [0:length(acf1(1:12:end))-1],ACF4) %this is the acf when shifting by twelve
title( [' ACF of  instrument:', instrumentname ])
ax = gca;
ax.XGrid =  'on';
ax.YGrid = 'off';


acf5=autocorr(Avec5,480);
ACF5 =acf5(1:12:end); %only every twelfth sample of acf5 , corresponding to shifting by one click
index=(pitchlist==instrumentlist(I(5)));
instrumentname= pitch2name{index};
figure(5)
scatter( [0:length(acf1(1:12:end))-1],ACF5) %this is the acf when shifting by twelve
title( [' ACF of  instrument:', instrumentname ])
ax = gca;
ax.XGrid =  'on';
ax.YGrid = 'off';


%acf6=autocorr(Avec6,480);
%ACF6 =acf3(1:12:end) ;%only every twelfth sample of acf6 , corresponding to shifting by one click
%index=(pitchlist==instrumentlist(I(6)));
%instrumentname= pitch2name{index};
%figure(6)
%scatter( [0:length(acf1(1:12:end))-1],ACF6) %this is the acf when shifting by twelve
%title( [' ACF of  instrument:', instrumentname ])
%ax = gca;
%ax.XGrid =  'on';
%ax.YGrid = 'off';


%%

%in this part, we look at the peaks of the ACF of all instrument to
%determine the time signature

[Y,acf_peak1]=max(ACF1(2:end));
[Y,acf_peak2]=max(ACF2(2:end));
[Y,acf_peak3]=max(ACF3(2:end));
[Y,acf_peak4]=max(ACF4(2:end));
[Y,acf_peak5]=max(ACF5(2:end));
%[Y,acf_peak6]=max(ACF6(2:end));

acf_peak_vec=[acf_peak1, acf_peak2, acf_peak3, acf_peak4, acf_peak5]


%%

%     