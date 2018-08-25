



function [Score, falses] = test_Beatroot(midimat, subdiv , giveplot, tempotrack , sal_preset , create3agents)
   
   % midimat = key2you;   % the midimatrix corresponding to a
                                      %drumtrack
    %subdiv =6;   %the predominant subdivision of the drumtrack
                    %poss.values: [1 2 3 4 6 8 12]
   % giveplot =1  % 0: no plot  1:plot
   % tempotrack=3;  % here we have different tracks , speeding up or
                    %slowing down at different rates, possible values :[ 1 2 3 4]
    %noisestd= 1/150
   %  sal_preset = 0  %0 : all instruments have equal salience , 1: snare/
                      % BD get higher scores
   % create3agents = 0 %0: create new agents as in Dixon, 1: create new agents as in Gouyon 
   
%%   
   
    [squeezedmat, squeezedclicks]  = apply_tempo_trajectory(midimat, subdiv, tempotrack);
    

    [trueclick_mat] = create_trueclick_mat(squeezedclicks, subdiv);
%%
    for i= 1:size(trueclick_mat,1)
        trueclick_mat{i} = trueclick_mat{i}(trueclick_mat{i}(:) < squeezedclicks(end)+0.07);
    end

    %%
    RMAT = squeezedmat(:, 4:6);

    
  
    
    %%
    %initialization phase
    agentcell_init = initializationPhase(RMAT); 

    %%
    %beat tracking
    [agentcell, agentchangelist, agentnr]  = beat_Tracking(agentcell_init, RMAT, sal_preset,create3agents); 

        winning_agent = sort(cat(2,agentcell{3,1}, agentcell{5,1}), 'ascend'); %sort agents by their score
        winning_agent(end+1) = winning_agent(end)+agentcell{1,1} ; %add one more prediction to get the last click, just in case there are notes played after the last click



        %winning_agent2 = sort(cat(2,agentcell{3,2}, agentcell{5,2}), 'ascend');
        %winning_agent2(end+1) = winning_agent2(end)+agentcell{1,2} ; %add one more prediction to get the last click, just in case there are notes played after the last click

        %   winning_agent3 = sort(cat(2,agentcell{3,3}, agentcell{5,3}), 'ascend');
        %   winning_agent3(end+1) = winning_agent3(end)+agentcell{1,3}  %add one more prediction to get the last click, just in case there are notes played after the last click

        %   winning_agent4 =  sort(cat(2,agentcell{3,4}, agentcell{5,4}), 'ascend');
        %   winning_agent4(end+1) = winning_agent4(end)+agentcell{1,4}  %add one more prediction to get the last click, just in case there are notes played after the last click

    %%

    clicks = (winning_agent)' ;

    %%
    %run Fscore 

    Fscore_mat = zeros(size(trueclick_mat,1),2) ;
    falses_mat = zeros(size(trueclick_mat,1),3) ;
    for i =1:size(trueclick_mat,1)
         [F1, F2, n, false_negatives, false_positives] =Fscore(trueclick_mat{i} , clicks, 0.07) ;    
         Fscore_mat(i,:) =[F1, F2];
         falses_mat(i,:) = [n, false_negatives, false_positives];
    end

    [Y, Index] = max(Fscore_mat, [], 1);

    %Score
    Index;
    Score=Fscore_mat(Index(1),:) ;
    falses= falses_mat(Index(1),:) ;
    %%

    %giveplot=1
    if giveplot==1
        figure
        hold on
        plot(RMAT(RMAT(:,1)<37,3), 0.9*ones(length(RMAT(RMAT(:,1)<37,3))),'k.'  ); %Bassdrums in black

        ylim([0,2]);

        plot(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3), ones(length(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3))),'k.'); %Snaredrums 

        plot(RMAT(RMAT(:,1)>40,3), 0.95*ones(length(RMAT(RMAT(:,1)>40,3))),'k.'  ); %other instruments 

        %plot([[18:1/2:179.00] [18:1/2:179.00]], [1.1*ones(length([18:1/2:179.00])) 0.9*ones(length([18:1/2:179.00]))] ,'m.')

        for i=1:length(winning_agent') %the winning agent is plotted in red
           plot([winning_agent(i) winning_agent(i)],[0.9 1],'r');
        end


        if Index(1)==1
            for i=1:length(trueclick_mat{1})
                   plot([trueclick_mat{1}(i) trueclick_mat{1}(i)],[1 1.1], 'm') ;
            end
        elseif Index(1)==2
           for i=1:length(trueclick_mat{2})
                  plot([trueclick_mat{2}(i) trueclick_mat{2}(i)],[1 1.1],'m') ;
            end
        elseif Index(1)==3
            for i=1:length(trueclick_mat{3})
                   plot([trueclick_mat{3}(i) trueclick_mat{3}(i)],[1 1.1],'m') ;
            end
            
        elseif Index(1)==4
            for i=1:length(trueclick_mat{4})
                   plot([trueclick_mat{4}(i) trueclick_mat{3}(i)],[1 1.1],'m') 
            end
            
        elseif Index(1)==5
            for i=1:length(trueclick_mat{5})
                   plot([trueclick_mat{5}(i) trueclick_mat{3}(i)],[1 1.1],'m') ;
            end
        
        elseif Index(1)==6
            for i=1:length(trueclick_mat{6})
                   plot([trueclick_mat{6}(i) trueclick_mat{3}(i)],[1 1.1],'m') ;
            end

        end
        
       
        hold off


    end
    
end



