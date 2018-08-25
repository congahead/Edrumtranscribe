function [agentcell, agentchangelist, agentnr] =  beat_Tracking(agentcell, RMAT, sal_presets, create3agents) % , punish_short_int)
%agentcell : initial agents 
%RMAT : reduced mdi matrix
%sal_presets  : Salience presets
%punish_short_int : score shorter interlvals less than long intervals in
%order to avoid high frequency output ? 
tic
timeout = 9 ; % if agent fails to predict for longer than timeout, he's on the redlist!

tempo_changer=0.5;
error_punisher=0.99;

interpolation_punisher = 5;
inner_tol=0.07; %inner tolerance window 
%inner_tol = 0.04 ; %smaller inner tolerance

OW = 0.2;   % factor for outer tolerance window, the outer window is relative to IOI length
%OW = 0.1 
merge_agent_threshold= 0.05;


agentnr=[];
%URMAT=unique(RMAT(:,3));

agentchangelist = [];
 for i=1:length(RMAT)-1  %"for all events..."
    if isequal(RMAT(i,3),RMAT(i+1,3))
        continue
    end
     newagents= zeros(6,0); %here new agents will be stored
     mainloop_redlist =[]; % agents on this list will be killed after the for loop
     succeeded_to_process=[] ; %in this list we can check which agents succeeded to process event i.
                  %whenever an agent succeds to process event i , we look in this list if there is an agent of similar interval length 
                  %(since they will have a joined path from event i onwards). the one with a lower score will thus  be deleted.
     for j=1:size(agentcell, 2)  % "for all Tempo hypothesis..."
         if RMAT(i,3)- agentcell{3,j}(end) > timeout % if agent hasnt tracked an event for more than time_out
             %mainloop_redlist(end+1)=j;
         else 
             outer_tol = OW*agentcell{1,j}; 
             while agentcell{2,j}+outer_tol < RMAT(i,3)
                 agentcell{5,j}(end+1)=agentcell{2,j}; %in the 5th row of agentcell we  store the interpolated beats
                 agentcell{2,j}= agentcell{2,j}+ agentcell{1,j}; %update prediction by prediction + interval
                 agentcell{4,j}=agentcell{4,j}-interpolation_punisher; %punish score for interpolated beats
                 agentcell{6,j}(end+1) = 0;%add a zero for instrument on interpolated beat
             end
             if abs(agentcell{2,j}-RMAT(i,3)) < outer_tol
                 error = RMAT(i,3)-agentcell{2,j};  %will be used to update the interval length
                 relative_error = error/outer_tol; %this will be used to update the score
                        
                 if create3agents==0

                     if abs(agentcell{2,j}-RMAT(i,3)) > inner_tol %in this case, we create a new agent (or several new agents if create3agents==1)

                        
                         newagents{1,end+1} = agentcell{1,j}; % beatInterval
                         newagents{2,end} = agentcell{2,j}; %prediction
                         newagents{3,end} = agentcell{3,j} ; %history
                         newagents{4,end} = agentcell{4,j}; %score
                         newagents{5,end} = agentcell{5,j} ; %interpolated beats
                         newagents{6,end} = agentcell{6,j} ;
                         % here we temporarily
                         %store all new agents until we add them to agentcell in the end of the outmost for loop 

                     end

                     agentcell{1,j} = agentcell{1,j}+tempo_changer* error; % update interval, factor in front of error has to be optimised empirically
                     %IN THE NEXT LINE , I CHANGED AGENTCELL{1,J} TO outer_tol
                     agentcell{2,j} = RMAT(i,3)+agentcell{1,j}; %update prediction
                     agentcell{3,j}(end+1) =  RMAT(i,3); % add event to history
                     %if punish_short_int =1
                     %   agentcell{4,j} = agentcell{4,j}+(agentcell{1,j}/max(cell2mat(agentcell(1,:))))*salience(RMAT(i,1), RMAT(i,2), sal_presets) *(1-error_punisher*(relative_error)); 
                        %update the score

                     %else
                     %I CHANGED THE NEXT LINE ,APPLIED THE SALIENCE FUNCTION
                     agentcell{4,j} = agentcell{4,j}+ salience(RMAT(i,1), RMAT(i,2), sal_presets) *(1-error_punisher*(relative_error)); %update the score
                     %end
                     agentcell{6,j}(end+1) = RMAT(i,1); %add instrument played to the list
                     % factor (here 1 ) can be adjusted make more salient events worth more
                     if length(succeeded_to_process)>0
                        [m, k]=min(cell2mat(agentcell(1, succeeded_to_process))-agentcell{1,j}*ones(1,length(succeeded_to_process)));
                        if  m < merge_agent_threshold
                              if agentcell{4, succeeded_to_process(k)} < agentcell{4,j} %only the the  agent with the higher score will survive. 
                                 %If agent j has higher score than the agent that processed the event earlier 
                                 %(i.e. if statement true), agent j will take over the corresponding column in the matrix
                                agentcell{1, succeeded_to_process(k)} = agentcell{1,j};
                                agentcell{2, succeeded_to_process(k)} = agentcell{2,j};
                                agentcell{3, succeeded_to_process(k)} = agentcell{3,j};
                                agentcell{4, succeeded_to_process(k)} = agentcell{4,j};
                                agentcell{5, succeeded_to_process(k)} = agentcell{5,j};
                              end
                            mainloop_redlist(end+1)=  j;


                        end
                        else    
                        succeeded_to_process(end+1)=j;


                     end
                 elseif create3agents ==1
                     
                     if abs(agentcell{2,j}-RMAT(i,3)) > inner_tol %in this case, we create three new agents 
                         
                         %first let's update the agent
                         
                         %agentcell{1,j} =  agentcell{1,j}; %interval doesnt change
                         agentcell{5,j}(end+1)=agentcell{2,j}; %in the 5th row of agentcell we  store the interpolated beats
                         if agentcell{2,j} < RMAT(i,3) %we only go another step if we did not pass the event yet
                            agentcell{2,j} = agentcell{2,j}+agentcell{1,j}; %update prediction
                         end
                         agentcell{3,j} = agentcell{3,j} ;% no event is added to history
                         agentcell{4,j} = agentcell{4,j}-interpolation_punisher; %punish score for interpolated beats
                         agentcell{6,j}(end+1) = 0;%add a zero for instrument on interpolated beat
             
                         
                         newagents{1,end+1} = agentcell{1,j}; % beatInterval
                         newagents{2,end} = agentcell{2,j} + 2*error; %prediction
                         newagents{3,end} = agentcell{3,j} ; %history
                         newagents{3,end}(end+1) = RMAT(i,3);  %history, add event to history
                         newagents{4,end} = 0.95*agentcell{4,j}+salience(RMAT(i,1), RMAT(i,2), sal_presets) *(1-error_punisher*(relative_error));   %score , 95% of score of old agent, following Gouyon +score for predicting current event 
                         newagents{5,end} = agentcell{5,j} ; %interpolated beats
                         newagents{6,end} = agentcell{6,j} ;
                         newagents{6,end}(end+1) = RMAT(i,1); %add instrument played to the list
                         
                         newagents{1,end+1} = agentcell{1,j}+error; % beatInterval
                         newagents{2,end} = agentcell{2,j} + error; %prediction
                         newagents{3,end} = agentcell{3,j} ; %history
                         newagents{3,end}(end+1) = RMAT(i,3);  %history, add event to history
                         newagents{4,end} = 0.95*agentcell{4,j}+ salience(RMAT(i,1), RMAT(i,2), sal_presets) *(1-error_punisher*(relative_error)); %score , add 95% of score of old agent, following Gouyon+score for predicting current event
                         newagents{5,end} = agentcell{5,j} ; %interpolated beats
                         newagents{6,end} = agentcell{6,j} ;
                         newagents{6,end}(end+1) = RMAT(i,1); %add instrument played to the list
                     
                         newagents{1,end+1} = agentcell{1,j}+0.5*error; % beatInterval
                         newagents{2,end} = agentcell{2,j} + error; %prediction
                         newagents{3,end} = agentcell{3,j} ; %history
                         newagents{3,end}(end+1) = RMAT(i,3);  %history, add event to history
                         newagents{4,end} = 0.95*agentcell{4,j}+ salience(RMAT(i,1), RMAT(i,2), sal_presets) *(1-error_punisher*(relative_error)); %score , add 95% of score of old agent, following Gouyon+score for predicting current event
                         newagents{5,end} = agentcell{5,j} ; %interpolated beats
                         newagents{6,end} = agentcell{6,j} ;
                         newagents{6,end}(end+1) = RMAT(i,1); %add instrument played to the list
     
                         % here we temporarily
                         %store all new agents until we add them to agentcell in the end of the outmost for loop 

                     end
                     
                     agentcell{1,j} = agentcell{1,j}+tempo_changer* error; % update interval, factor in front of error has to be optimised empirically
                     %IN THE NEXT LINE , I CHANGED AGENTCELL{1,J} TO outer_tol
                     agentcell{2,j} = RMAT(i,3)+agentcell{1,j}; %update prediction
                     agentcell{3,j}(end+1) =  RMAT(i,3); % add event to history
                     %if punish_short_int =1
                     %   agentcell{4,j} = agentcell{4,j}+(agentcell{1,j}/max(cell2mat(agentcell(1,:))))*salience(RMAT(i,1), RMAT(i,2), sal_presets) *(1-error_punisher*(relative_error)); 
                        %update the score

                     %else
                     %I CHANGED THE NEXT LINE ,APPLIED THE SALIENCE FUNCTION
                     agentcell{4,j} = agentcell{4,j}+ salience(RMAT(i,1), RMAT(i,2), sal_presets) *(1-error_punisher*(relative_error)); %update the score
                     %end
                     agentcell{6,j}(end+1) = RMAT(i,1); %add instrument played to the list
                     % factor (here 1 ) can be adjusted make more salient events worth more
                     if length(succeeded_to_process)>0
                        [m, k]=min(cell2mat(agentcell(1, succeeded_to_process))-agentcell{1,j}*ones(1,length(succeeded_to_process)));
                        if  m < merge_agent_threshold
                              if agentcell{4, succeeded_to_process(k)} < agentcell{4,j} %only the the  agent with the higher score will survive. 
                                 %If agent j has higher score than the agent that processed the event earlier 
                                 %(i.e. if statement true), agent j will take over the corresponding column in the matrix
                                agentcell{1, succeeded_to_process(k)} = agentcell{1,j};
                                agentcell{2, succeeded_to_process(k)} = agentcell{2,j};
                                agentcell{3, succeeded_to_process(k)} = agentcell{3,j};
                                agentcell{4, succeeded_to_process(k)} = agentcell{4,j};
                                agentcell{5, succeeded_to_process(k)} = agentcell{5,j};
                              end
                            mainloop_redlist(end+1)=  j;


                        end
                        else    
                        succeeded_to_process(end+1)=j;
                                             
                     end
                 end
                 
                 
             end
         end
     end
    % i
    % disp('before removing:')
    % size(agentcell,2)
     agentnr(end+1)=size(agentcell,2);
     agentcell(:, mainloop_redlist)=[]; %delete agents on the redlist
  %   disp('after removing:')
  %   size(agentcell,2)
     agentnr(end+1)=size(agentcell,2);
     agentcell = cat(2, agentcell, newagents); %append new agents
 %    disp('after concatenation')
 %    size(agentcell,2)
     agentnr(end+1)=size(agentcell,2);
     [~, inx]=sort([agentcell{4,:}],'descend'); %sort the agentcells according their score
     agentcell = agentcell(:, inx) ; %sort the agents by their score   
     if inx(1) ~= 1
         agentchangelist(end+1)=i ;
         %if create3agents==1 % and killfalses=1  %suggestion by guoyon to get rid of too many false positives and false negatives 
         %    if agentcell{,inx(1)}
                 
         %    end
         %end
     end
     if size(agentcell,2)>100 
     agentcell = agentcell(:, 1:100) ; %keep the best 100 agents
     end    
     
     
     
     
 end
 
 [~, inx]=sort([agentcell{4,:}],'descend'); %sort the agentcells according their score
 agentcell = agentcell(:, inx) ; % rearrange the agentcells columns according to the index ofter sorting 

 agentchangelist;
 toc 
end
