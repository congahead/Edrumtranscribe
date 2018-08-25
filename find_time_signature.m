function [countnr, subdivision_in_notation] = find_time_signature(B, instrumentlist, subdiv_in_beat)


autocorr_relevance_threshold=0.4;
%only when the peak of the autocorrelation is higher than this value, it is
%considered


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


pitch2name(instrumentlist-34);

%%
% now we look at the autocorrelations to determine the time signature


if size(B,1)*12-1<1000
    lagnr = (size(B,1)-1)*12-1
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


careaboutlist=[1]; % we always care about the  'all instruments combined' time series
for i=1:5 % note here that acf1 represents the file "all instruments combined "
    if ismember(instrumentlist(i), instrumentswecareaboutlist)==1
        careaboutlist(end+1)= i+1;
    end
end
%%
pitch2name(instrumentlist-34) % here we can see the names of the 6 most
%played instruments
if size(maxlist,2)>size(careaboutlist,2)
    maxlist = maxlist(careaboutlist)/12
else
    maxlist=maxlist/12
end
%%
clickcyclelength= max(maxlist') %after how many clicks do we get the highest autocorrelation

totalsubdivsinbar=clickcyclelength*subdiv_in_beat
%this number gives the total nr of subdivisions in one cycle (which usually corresponds to one bar)

%%
%in this section , we can create the ACF plots but you have to insert some
%things manually 

%hold on 
%ACF=acf1(1:12:480)
%plot([0:1:39] , ACF,'ro')
%for i =0:39
% plot([i i],[0 ACF(i+1)], 'Color', [0.7 0.7 0.7]) ;
%end
%plot([4 4],[0 ACF(4+1)], 'g') 
%hold off
%xlabel('Lag')
%ylabel('Sample Autocorrelation')
%title('ACF, Shepert Blues , tempo track 2, instrument: all instruments combined')

%%
prime_factors = factor(clickcyclelength) %we look at the prime factors to determine the number of beats 
%Are there nonbinary numbers like 3,5,7,... if yes , those refer most
%likely to the beat number . Unless It's a three and there is three beats i
%in a subdivision


if sum(abs(prime_factors-2*ones(size(prime_factors))))==0
    countnr=4
    non2_factors = []
else 
    indexvec=find((prime_factors-2*ones(size(prime_factors))))
    non2_factors=prime_factors(indexvec)
end
if length(non2_factors)==1
    countnr = non2_factors
elseif length(non2_factors)>1 && subdiv_in_beat>1
    countnr= prod(non2_factors)
elseif length(non2_factors)>1 && subdiv_in_beat==1 && non2_factors(1)==3
    countnr =prod(non2_factors(2:end))
    
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
        subdivision_in_notation = 'sixteenthnotes'
    elseif totalsubdivsinbar ==6*countnr 
        subdivision_in_notation = 'sixteenthtriplets'
    elseif totalsubdivsinbar ==4*countnr  
        subdivision_in_notation =  'sixteenthnotes'       
    elseif  totalsubdivsinbar ==3*countnr
        subdivision_in_notation =  'eighthnotetriplets'
    elseif totalsubdivsinbar ==2*countnr
        subdivision_in_notation =  'eighthnotes'
    elseif totalsubdivsinbar ==countnr
        subdivision_in_notation =  'quarternotes'
    end




