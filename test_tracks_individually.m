
%test tracks individually

function [Score, falses] =test_tracks_individually(songnr, tempotrack, noise, sal_preset, create3agents ) 
  %%
  songnr=1 
  tempotrack=1
  noise =1
  sal_preset=0
  create3agents = 1
  %%
  load('squeezed_mat_cell.mat')
  load('Dixon_output_cell.mat')
  
  %%
    RMAT = squeezed_mat_cell{songnr,tempotrack}{noise+2}(:, 4:6);

    
  
    
    %%
    %initialization phase
    agentcell_init = initializationPhase(RMAT); 

    %%
    %beat tracking
    %sal_preset =0
    %create3agents = 0
    [agentcell, agentchangelist, agentnr]  = beat_Tracking(agentcell_init, RMAT, sal_preset,create3agents); 

        winning_agent = sort(cat(2,agentcell{3,1}, agentcell{5,1}), 'ascend'); %sort agents by their score
        winning_agent(end+1) = winning_agent(end)+agentcell{1,1} ; %add one more prediction to get the last click, just in case there are notes played after the last click



        %winning_agent2 = sort(cat(2,agentcell{3,2}, agentcell{5,2}), 'ascend');
        %winning_agent2(end+1) = winning_agent2(end)+agentcell{1,2} ; %add one more prediction to get the last click, just in case there are notes played after the last click

          % winning_agent3 = sort(cat(2,agentcell{3,3}, agentcell{5,3}), 'ascend');
          % winning_agent3(end+1) = winning_agent3(end)+agentcell{1,3} ; %add one more prediction to get the last click, just in case there are notes played after the last click

        %   winning_agent4 =  sort(cat(2,agentcell{3,4}, agentcell{5,4}), 'ascend');
        %   winning_agent4(end+1) = winning_agent4(end)+agentcell{1,4}  %add one more prediction to get the last click, just in case there are notes played after the last click

    %%

    clicks = (winning_agent)' ;

    %%
    %run Fscore
    trueclick_mat = squeezed_mat_cell{songnr,tempotrack}{4};
%%
    Fscore_mat = zeros(size(trueclick_mat,1),2) ;
    falses_mat = zeros(size(trueclick_mat,1),3) ;
    for o =1:size(trueclick_mat,1)
         [F1, F2, n, false_negatives, false_positives] =Fscore(trueclick_mat{o} , clicks, 0.07) ;    
         Fscore_mat(o,:) =[F1, F2];
         falses_mat(o,:) = [n, false_negatives, false_positives];
    end

    [Y, Index] = max(Fscore_mat, [], 1);

    %Score
    Index;
    Score=Fscore_mat(Index(1),:) ;
    falses= falses_mat(Index(1),:) ;
    %%
     
    giveplot=1 ;
    if giveplot==1
       
        xagentnrplot = [1/3:1/3:(length(RMAT)-1)]
        figure
        plot(xagentnrplot,agentnr)
        title('number of agents')
        xlabel('number of onset')
        ylabel('number of agents')
        
        figure
        hold on
        plot(RMAT(RMAT(:,1)<37,3), 0.9*ones(length(RMAT(RMAT(:,1)<37,3))),'k.'  ); %Bassdrums in black

        ylim([0,2]);

        plot(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3), ones(length(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3))),'k.'); %Snaredrums 

        plot(RMAT(RMAT(:,1)>40,3), 0.95*ones(length(RMAT(RMAT(:,1)>40,3))),'k.'  ); %other instruments 
        
        plot(RMAT(agentchangelist, 3), ones(length(agentchangelist)), 'g*');
        %plot([[18:1/2:179.00] [18:1/2:179.00]], [1.1*ones(length([18:1/2:179.00])) 0.9*ones(length([18:1/2:179.00]))] ,'m.')

        for i=1:length(winning_agent') %the winning agent is plotted in red
           plot([winning_agent(i) winning_agent(i)],[0.9 1],'b');
        end

        %for i=1:length(winning_agent2')
        %     plot([winning_agent2(i) winning_agent2(i)],[0.8 0.9],'g');
        
        %end
        
        %for i=1:length(winning_agent3')
        %     plot([winning_agent3(i) winning_agent3(i)],[0.85 0.95],'b');
        
        %end
    

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
        
        
        xlabel('seconds')
       
        hold off

    end
    
    %%
        Ilist=[];
        reslist = [];
        Dreslist=[];
        DIlist=[];
        if Index(1)==1
            for i=1:length(trueclick_mat{1})
                [c, I] = min(abs(clicks- trueclick_mat{1}(i) ));
                res = clicks(I)- trueclick_mat{1}(i) ;
                Ilist(end+1)= I;
                reslist(end+1)= res ;
            end
            for i=1:length(Dixon_output_cell{songnr, tempotrack}{2})
            [Dc,DI]= min(abs(trueclick_mat{1}-Dixon_output_cell{songnr, tempotrack}{2}(i)));
             Dres= Dixon_output_cell{songnr, tempotrack}{2}(i)- trueclick_mat{1}(DI);
             Dreslist(end+1)= Dres;
             DIlist(end+1)=DI;
            end
        elseif Index(1)==2
            for i=1:length(trueclick_mat{2})
                [c, I] = min(abs(clicks- trueclick_mat{2}(i) ));
                res = clicks(I)- trueclick_mat{2}(i) ;
                Ilist(end+1)= I;
                reslist(end+1)= res ;
            end
            for i=1:length(Dixon_output_cell{songnr, tempotrack}{2})
            [Dc,DI]= min(abs(trueclick_mat{2}-Dixon_output_cell{songnr, tempotrack}{2}(i)));
             Dres= Dixon_output_cell{songnr, tempotrack}{2}(i)- trueclick_mat{2}(DI);
             Dreslist(end+1)= Dres;
             DIlist(end+1)=DI;
            end
        elseif Index(1)==3
            for i=1:length(trueclick_mat{3})
                [c, I] = min(abs(clicks- trueclick_mat{3}(i) ));
                res = clicks(I)- trueclick_mat{3}(i);
                Ilist(end+1)= I;
                reslist(end+1)= res ;
            end
            for i=1:length(Dixon_output_cell{songnr, tempotrack}{2})
            [Dc,DI]= min(abs(trueclick_mat{3}-Dixon_output_cell{songnr, tempotrack}{2}(i)));
             Dres= Dixon_output_cell{songnr, tempotrack}{2}(i)- trueclick_mat{3}(DI);
             Dreslist(end+1)= Dres;
             DIlist(end+1)=DI;
            end
        elseif Index(1)==4
            for i=1:length(trueclick_mat{4})
                [c, I] = min(abs(clicks- trueclick_mat{4}(i) ));
                res = clicks(I)- trueclick_mat{4}(i);
                Ilist(end+1)= I;
                reslist(end+1)= res ;
            end
            for i=1:length(Dixon_output_cell{songnr, tempotrack}{2})
            [Dc,DI]= min(abs(trueclick_mat{4}-Dixon_output_cell{songnr, tempotrack}{2}(i)));
             Dres= Dixon_output_cell{songnr, tempotrack}{2}(i)- trueclick_mat{4}(DI);
             Dreslist(end+1)= Dres;
             DIlist(end+1)=DI;
            end
        elseif Index(1)==5
            for i=1:length(trueclick_mat{5})
                [c, I] = min(abs(clicks- trueclick_mat{5}(i) ));
                res = clicks(I)- trueclick_mat{5}(i);
                Ilist(end+1)= I;
                reslist(end+1)= res ;
            end
            for i=1:length(Dixon_output_cell{songnr, tempotrack}{2})
            [Dc,DI]= min(abs(trueclick_mat{5}-Dixon_output_cell{songnr, tempotrack}{2}(i)));
             Dres= Dixon_output_cell{songnr, tempotrack}{2}(i)- trueclick_mat{5}(DI);
             Dreslist(end+1)= Dres;
             DIlist(end+1)=DI;
            end
        elseif Index(1)==6
            for i=1:length(trueclick_mat{6})
                [c, I] = min(abs(clicks- trueclick_mat{6}(i) ));
                res = clicks(I)- trueclick_mat{6}(i);
                Ilist(end+1)= I;
                reslist(end+1)= res; 
            end
            for i=1:length(Dixon_output_cell{songnr, tempotrack}{2})
            [Dc,DI]= min(abs(trueclick_mat{6}-Dixon_output_cell{songnr, tempotrack}{2}(i)));
             Dres= Dixon_output_cell{songnr, tempotrack}{2}(i)- trueclick_mat{6}(DI);
             Dreslist(end+1)= Dres;
             DIlist(end+1)=DI;
            end
            
            nr_of_false_positives = length(clicks)-length(Ilist);
            
            %indices =find(hist(Ilist,unique(Ilist))>1)]
            %more_than_once_used  = unique(Ilist)(indices)
            
        end
        
        for i=1:length(Dixon_output_cell{songnr, tempotrack})
            [Dc,DI]= min(abs(trueclick_mat{1}-Dixon_output_cell{songnr, tempotrack}{2}(i)));
             Dres= Dixon_output_cell{songnr, tempotrack}{2}(i)- trueclick_mat{1}(DI);
             Dreslist(end+1)= Dres;
             DIlist(end+1)=DI;
        end
        Dreslist;
        DIlist;
        figure
        hold on
        plot(reslist, 'b')
        plot(DIlist, Dreslist, 'r')
        
        title('visualization:false negatives')
        xlabel('')
        hold off
    end
    
    
    



