function [D] = SplitInstruments(B, instrumentlist)

    C = cell(size(B,1), length(instrumentlist)); % each instrument gets its column

    location_vec = [0 1/12 1/6 1/4 1/3 5/12 1/2 7/12 2/3 3/4 5/6 11/12 1] ;
    tic
    for i=1:length(instrumentlist)
        for j= 1:size(B,1)-1
            if ismember(instrumentlist(i), B{j,2})
               [tf,loc]=ismember(B{j,2},instrumentlist(i));
               idx=[1:length(B{j,2})];
               idx=idx(tf);
               quantvec = cell2mat(B(j,5));
               quantvec = quantvec(idx);
               LIA = double(ismember(location_vec, quantvec));
               C{j,i}=LIA; 
               vel_vec = cell2mat(B(j,3));
               vel_vec = vel_vec(idx);
               C{j,i}(:, find(C{j,i}==1)) = vel_vec'; %write velocity information in the file

            else 
                C{j,i}=[0 0 0 0 0 0 0 0 0 0 0 0 0]; 
            end
            if (j>1 && C{j-1,i}(end) ~= 0)    %If a note is quantized to the last position, i.e. the next beat
                if  C{j,i}(1) ~= 0
                    C{j,i}(1) = C{j-1,i}(end); % put it on the first position of the next segment
                else
                    C{j,i}(1) = max(C{j,i}(1),C{j-1,i}(end)) ;% if that space is already occupied, just consider the bigger one
                end
            end
        end
    end
    toc
  
    D = cell(2,size(C,2)+1);


    pitchlist=[35:1:59];
    pitch2name={' Acoustic Bass Drum ', ' Bass Drum 1 ', ' Side Stick ', ' Acoustic Snare ',' Hand Clap ', ' Electric Snare ', ' Low Floor Tom ', ' Closed High-Hat ',' High Floor Tom ', ' Pedal High-Hat ', ' Low Tom ', ' Open High-Hat ' ,' Low Mid-Tom ',' High Mid-Tom ', ' Crash Cymbal1 ', ' High Tom ', ' Ride Cymbal 1 ', ' Chinese Cymbal ',' Ride Bell ', ' Tamburine ', ' Splash Cymbal ', ' Cowbell ', ' Crash Cymbal 2 ', ' Vibraslap ', ' Ride Cymbal 2 '};

  
    for i = 2: size(D,2)
        index=(pitchlist==instrumentlist(i-1));
        D{1,i}= pitch2name{index};
        A = cell2mat(C(:,i-1));
        A = A(:, 1:end-1); % we get rid of the last element since we have already put that info in the first element of the next row
        A = A';
        D{2,i} = A(:); 
    end

    % Now we make a time series with all instruments.   
    E= zeros(size(D{2,2}, 1), size(D,2)-1);
    for i = 2:size(D,2)-1
        E(:, i-1)= D{2, i} ;

    end

    E(:, end)= max(E(:,1:end-1), [], 2) ; % this is the vector combining all 
    %instruments.When several instruments are played at the same quantization
    %location, we use the max velocity value.   instead of max, one could
    %also compute a weighted sum 
    

    D{1,1} = 'all instruments combined' ;
    D{2,1} = E(:, end) ; %here we fill the combined time series into the first column
end