



load('squeezed_mat_cell.mat')
load('Dixon_output_cell.mat')
%%
title_mat= cell(9,4)
songs = [{'Chameleon, '},{'Key to you, '}, {' Key to you (no intro), '},{'Moonlight Shadow, '}, {'On 100 ways, '}  , {'Precious, '}, {'The Shepert Blues, '}, {'Summertime, '}, {'Through the fire, '} ]
for j=1:9
    for k =1:4
         if k==1
            trackstring='tempo decreases from 120 to 60'
         elseif k==2
             trackstring='tempo increases from 60 to 120'
         elseif k==3
             trackstring='tempo decreases from 160 to 40'
         elseif k==4
             trackstring='tempo increases from 40 to 160'
         end
         title_mat{j,k}= strcat(songs(j), trackstring)
    end
end
%%
compare_clicks_cell = cell(2,9,4);

compare_index_mat= zeros(3,9,4);
%first dim : 1: without create3agents, 2:with create3agents
%2nd dim: songs 
%3rd dim : tempotracks
%%
for i =1:2    
    for j=1:9        
        for k=1:4
            
            RMAT = squeezed_mat_cell{j,k}{3}(:, 4:6);
            
            
            agentcell_init = initializationPhase(RMAT); 
            
            [agentcell, agentchangelist, agentnr]  = beat_Tracking(agentcell_init, RMAT, 0,i-1); 

            winning_agent = sort(cat(2,agentcell{3,1}, agentcell{5,1}), 'ascend'); %sort agents by their score
            winning_agent(end+1) = winning_agent(end)+agentcell{1,1} ; %add one more prediction to get the last click, just in case there are notes played after the last click

            clicks = (winning_agent)' ;
            compare_clicks_cell{i,j,k}= clicks;
            
           
            trueclick_mat = squeezed_mat_cell{j,k}{4};
            
             Fscore_mat = zeros(size(trueclick_mat,1),2) ;
           %  falses_mat = zeros(size(trueclick_mat,1),3) ;
          
           for o =1:size(trueclick_mat,1)
                [F1, F2, n, false_negatives, false_positives] =Fscore(trueclick_mat{o} , clicks, 0.07) ;    
                Fscore_mat(o,:) =[F1, F2];
                %falses_mat(o,:) = [n, false_negatives, false_positives];
            end

             [Y, Index] = max(Fscore_mat, [], 1);
             
             compare_index_mat(i,j,k)= Index(1);
  
             
        end
    end
end
%%

%false negatives

%for j=9%1:2
%    for k=1:4
j=6
 k=3
 
       
        if isempty(Dixon_output_cell{j,k})==1
            compare_index_mat(3,j,k)= 0;
        else    
            compare_clicks_cell{3,j,k}= Dixon_output_cell{j,k}{2}';
            
            trueclick_mat = squeezed_mat_cell{j,k}{4};
    
            Fscore_mat = zeros(size(trueclick_mat,1),2) ;
            falses_mat = zeros(size(trueclick_mat,1),3) ;
        
            clicks= compare_clicks_cell{3,j,k};
            for o =1:size(trueclick_mat,1)
            
                 [F1, F2, n, false_negatives, false_positives] =Fscore(trueclick_mat{o} , clicks, 0.07) ;    
                Fscore_mat(o,:) =[F1, F2];
                %falses_mat(o,:) = [n, false_negatives, false_positives];
            end

            [Y, Index] = max(Fscore_mat, [], 1);
            compare_index_mat(3,j,k)= Index(1);
        end
   



        [nr, I]=min(compare_index_mat(:,j,k));
        if nr ==0
            [nr, I]=max(compare_index_mat(:,j,k))
        end
        maxlength = size(squeezed_mat_cell{j,k}{4}{nr},1);
        
        %false negatives
        neg_I_cell = cell(3,1);
        neg_res_cell = cell(3,1);
        
        for i=1:length(trueclick_mat{compare_index_mat(1,j,k)})
       
            [c, Index1] = min(abs(compare_clicks_cell{1,j,k}- trueclick_mat{compare_index_mat(1,j,k)}(i) ));
            res = compare_clicks_cell{1,j,k}(Index1)- trueclick_mat{compare_index_mat(1,j,k)}(i) ;
            neg_I_cell{1}(end+1)= Index1;
            neg_res_cell{1}(end+1)= res ;
        end
        
        
        for i=1:length(trueclick_mat{compare_index_mat(2,j,k)})
            [c, Index2] = min(abs(compare_clicks_cell{2,j,k}- trueclick_mat{compare_index_mat(2,j,k)}(i) ));
            res = compare_clicks_cell{2,j,k}(Index2)- trueclick_mat{compare_index_mat(2,j,k)}(i) ;
            neg_I_cell{2}(end+1)= Index2;
            neg_res_cell{2}(end+1)= res ;
        end
        %next part is for Dixon, comment out if data not available
        
        for i=1:length(trueclick_mat{compare_index_mat(3,j,k)})
            [c, I] = min(abs(compare_clicks_cell{3,j,k}- trueclick_mat{compare_index_mat(3,j,k)}(i) ));
            res = compare_clicks_cell{3,j,k}(I)- trueclick_mat{compare_index_mat(3,j,k)}(i) ;
            neg_I_cell{3}(end+1)= I;
            neg_res_cell{3}(end+1)= res ;
        end
            
 %      figure
  %      hold on
%        if length(neg_res_cell{1})== maxlength
%            plot([1:1:maxlength],neg_res_cell{1}, 'b.', 'MarkerSize', 16)
%            ylim([-0.3 0.3])
%        else
%            plot([1:2:maxlength], neg_res_cell{1},'b.','MarkerSize', 16)
%            ylim([-0.3 0.3])
%        end
%
%        if length(neg_res_cell{2})== maxlength
%            plot([1:1:maxlength],neg_res_cell{2}, 'g.','MarkerSize', 12)
%            ylim([-0.3 0.3])
%        else
%            plot([1:2:maxlength], neg_res_cell{2},'g.','MarkerSize', 12)
%            ylim([-0.3 0.3])
%
 %       end
%        if length(neg_res_cell{3})== maxlength
%            plot([1:1:maxlength],neg_res_cell{3}, 'r.','MarkerSize', 16)
%            ylim([-0.3 0.3])
%        else
%            plot([1:2:maxlength], neg_res_cell{3},'r.','MarkerSize', 16)
%            ylim([-0.3 0.3])
%
%        end
%
%        hold off
%        title(strcat('false negatives:  ', title_mat{j,k}))
%        xlabel('True Beat nr')
%        ylabel('magnitude of error (in seconds)')
%        refline(0,0.07)
%        refline(0, -0.07)
%      


        %false positives
        pos_I_cell = cell(3,1);
        pos_res_cell = cell(3,1);
        
        for i=1:length(compare_clicks_cell{1,j,k})
            [c, I] = min(abs(compare_clicks_cell{1,j,k}(i)- trueclick_mat{compare_index_mat(1,j,k)}));
           res = trueclick_mat{compare_index_mat(1,j,k)}(I)- compare_clicks_cell{1,j,k}(i) ;
            pos_I_cell{1}(end+1)= I;
            pos_res_cell{1}(end+1)= res ;
        end
        
        for i=1:length(compare_clicks_cell{2,j,k})
            [c, I] = min(abs(compare_clicks_cell{2,j,k}(i)- trueclick_mat{compare_index_mat(2,j,k)}));
            res = trueclick_mat{compare_index_mat(2,j,k)}(I)- compare_clicks_cell{2,j,k}(i) ;
            pos_I_cell{2}(end+1)= I;
            pos_res_cell{2}(end+1)= res ;
        end
       
        for i=1:length(compare_clicks_cell{3,j,k})
            [c, I] = min(abs(compare_clicks_cell{3,j,k}(i)- trueclick_mat{compare_index_mat(3,j,k)}));
            res = trueclick_mat{compare_index_mat(3,j,k)}(I)- compare_clicks_cell{3,j,k}(i) ;
            pos_I_cell{3}(end+1)= I;
            pos_res_cell{3}(end+1)= res ;
        end
       
       
       
%        figure 
%        hold on 
%        plot(compare_clicks_cell{1,j,k}, pos_res_cell{1}, 'b.' , 'MarkerSize', 21)
%        ylim([-0.3 0.3])
%        plot(compare_clicks_cell{2,j,k}, pos_res_cell{2}, 'g.', 'MarkerSize', 17)
%        ylim([-0.3 0.3])
%        plot(compare_clicks_cell{3,j,k}, pos_res_cell{3}, 'r.', 'MarkerSize', 21)
%        ylim([-0.3 0.3])
%        hold off
%        title(strcat('false positives:  ', title_mat{j,k}))
 %       xlabel('seconds')
 %       ylabel('magnitude of error (in seconds)')
%        refline(0,0.07)
%        refline(0,-0.07)
%        
    %        
            f = figure;
            p = uipanel('Parent',f,'BorderType','none'); 
            p.Title = title_mat{j,k}; 
            p.TitlePosition = 'centertop'; 
            p.FontSize = 12;
            p.FontWeight = 'bold';
               subplot(2,1,1,'Parent',p) 
            hold on
            if length(neg_res_cell{1})== maxlength
                plot(trueclick_mat{compare_index_mat(1,j,k)}',neg_res_cell{1}, 'b.', 'MarkerSize', 16)
                %ylim([-0.3 0.3])
                ylim([-0.5 0.5])
            else
                plot(trueclick_mat{compare_index_mat(1,j,k)}', neg_res_cell{1},'b.','MarkerSize', 16)
                %ylim([-0.3 0.3])
                ylim([-0.5 0.5])
            end

           if length(neg_res_cell{2})== maxlength
                plot(trueclick_mat{compare_index_mat(2,j,k)}',neg_res_cell{2}, 'g.','MarkerSize', 12)
                %ylim([-0.3 0.3])
                ylim([-0.5 0.5])
            else
                plot(trueclick_mat{compare_index_mat(2,j,k)}', neg_res_cell{2},'g.','MarkerSize', 12)
                %ylim([-0.3 0.3])
                ylim([-0.5 0.5])

            end
            if length(neg_res_cell{3})== maxlength
                plot(trueclick_mat{compare_index_mat(3,j,k)}',neg_res_cell{3}, 'r.','MarkerSize', 16)
                %ylim([-0.3 0.3])
                ylim([-0.7 0.7])
            else
                plot(trueclick_mat{compare_index_mat(3,j,k)}', neg_res_cell{3},'r.','MarkerSize', 16)
                %ylim([-0.3 0.3])
                ylim([-0.7 0.7])

            end

            hold off
            title('false negatives')
            xlabel('true beats \beta_i (in seconds)')
            ylabel('errors \epsilon^{neg}_i (in seconds)')           
            refline(0,0.07)
            refline(0, -0.07)
            x = linspace(0,10,50);
            
            %legend('Standard','Create3agents','Dixon', 'Location','Best') 
            %legend('Standard','Create3agents','Dixon', 'Location','North') 
            %legend('Standard','Create3agents','Dixon', 'Location','South') 
            %legend('Standard','Create3agents','Dixon', 'Location','northeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southhwest')
            %legend('Standard','Create3agents','Dixon', 'Location','northwest')

            subplot(2,1,2,'Parent',p) 
            hold on 
            plot(compare_clicks_cell{1,j,k}, (-1)*pos_res_cell{1}, 'b.' , 'MarkerSize', 16)
            %ylim([-0.3 0.3])
            ylim([-0.9 0.9])
            plot(compare_clicks_cell{2,j,k}, (-1)*pos_res_cell{2}, 'g.', 'MarkerSize', 12)
            %ylim([-0.3 0.3])
            ylim([-0.9 0.9])
            plot(compare_clicks_cell{3,j,k}, (-1)*pos_res_cell{3}, 'r.', 'MarkerSize', 16)
            %ylim([-0.3 0.3])
            ylim([-0.9 0.9])
            hold off
            title('false positives')
            xlabel('reported beats \tau_j (in seconds)')
            ylabel('errors \epsilon^{pos}_j (in seconds)')
            refline(0,0.07)
            refline(0,-0.07)
            legend('Standard','Create3agents','Dixon', 'Location','Best') 
            %legend('Standard','Create3agents','Dixon', 'Location','North') 
            %legend('Standard','Create3agents','Dixon', 'Location','South')
            %legend('Standard','Create3agents','Dixon', 'Location','northeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southhwest')
            %legend('Standard','Create3agents','Dixon', 'Location','northwest')            
            %string = strcat(strcat('falses_', strcat(squeezed_mat_cell{j,k}{1}(1),num2str(squeezed_mat_cell{j,k}{1}{3}))), '.png')
            %saveas(gcf,char(string))
       
        
        
%    end
%end
%    
%    

%%

% this part is to create the plots for the tracks where we have no output
% from dixon
%copypasted from before , then I will mess around with it 


%false negatives


j=6
k=4

trueclick_mat = squeezed_mat_cell{j,k}{4};
       



        [nr, I]=min(compare_index_mat(:,j,k));
        if nr ==0
            [nr, I]=max(compare_index_mat(:,j,k))
        end
        maxlength = size(squeezed_mat_cell{j,k}{4}{nr},1);
        
        %false negatives
        neg_I_cell = cell(2,1);
        neg_res_cell = cell(2,1);
 
      
        for i=1:length(trueclick_mat{compare_index_mat(1,j,k)})
       
            [c, Index1] = min(abs(compare_clicks_cell{1,j,k}- trueclick_mat{compare_index_mat(1,j,k)}(i) ));
            res = compare_clicks_cell{1,j,k}(Index1)- trueclick_mat{compare_index_mat(1,j,k)}(i) ;
            neg_I_cell{1}(end+1)= Index1;
            neg_res_cell{1}(end+1)= res ;
        end
        
        
        for i=1:length(trueclick_mat{compare_index_mat(2,j,k)})
            [c, Index2] = min(abs(compare_clicks_cell{2,j,k}- trueclick_mat{compare_index_mat(2,j,k)}(i) ));
            res = compare_clicks_cell{2,j,k}(Index2)- trueclick_mat{compare_index_mat(2,j,k)}(i) ;
            neg_I_cell{2}(end+1)= Index2;
            neg_res_cell{2}(end+1)= res ;
        end
        



        %false positives
        pos_I_cell = cell(2,1);
        pos_res_cell = cell(2,1);
       
        for i=1:length(compare_clicks_cell{1,j,k})
            [c, index1] = min(abs(compare_clicks_cell{1,j,k}(i)- trueclick_mat{compare_index_mat(1,j,k)}));
           res = trueclick_mat{compare_index_mat(1,j,k)}(index1)- compare_clicks_cell{1,j,k}(i) ;
            pos_I_cell{1}(end+1)= index1;
            pos_res_cell{1}(end+1)= res ;
        end
       
        for i=1:length(compare_clicks_cell{2,j,k})
            [c, index2] = min(abs(compare_clicks_cell{2,j,k}(i)- trueclick_mat{compare_index_mat(2,j,k)}));
            res = trueclick_mat{compare_index_mat(2,j,k)}(index2)- compare_clicks_cell{2,j,k}(i) ;
            pos_I_cell{2}(end+1)= index2;
            pos_res_cell{2}(end+1)= res ;
        end
       
 

         
            f = figure;
            p = uipanel('Parent',f,'BorderType','none'); 
            p.Title = title_mat{j,k}; 
            p.TitlePosition = 'centertop'; 
            p.FontSize = 12;
            p.FontWeight = 'bold';
               subplot(2,1,1,'Parent',p) 
            hold on
            if length(neg_res_cell{1})== maxlength
                plot(trueclick_mat{compare_index_mat(1,j,k)}',neg_res_cell{1}, 'b.', 'MarkerSize', 16)
                ylim([-0.9 0.9])
                %ylim([-0.4 0.4])
            else
                plot(trueclick_mat{compare_index_mat(1,j,k)}', neg_res_cell{1},'b.','MarkerSize', 16)
                ylim([-0.9 0.9])
                %ylim([-0.4 0.4])
            end

           if length(neg_res_cell{2})== maxlength
                plot(trueclick_mat{compare_index_mat(2,j,k)}',neg_res_cell{2}, 'g.','MarkerSize', 12)
                ylim([-0.9 0.9])
                %ylim([-0.4 0.4])
            else
                plot(trueclick_mat{compare_index_mat(2,j,k)}', neg_res_cell{2},'g.','MarkerSize', 12)
                ylim([-0.9 0.9])
                %ylim([-0.4 0.4])

            end

            hold off
            title('false negatives')
            xlabel('true beats \beta_i (in seconds)')
            ylabel('errors \epsilon^{neg}_i (in seconds)')
            refline(0,0.07)
            refline(0, -0.07)
            x = linspace(0,10,50);
            
            %legend('Standard','Create3agents','Dixon', 'Location','Best') 
            %legend('Standard','Create3agents','Dixon', 'Location','North') 
            %legend('Standard','Create3agents','Dixon', 'Location','South') 
            %legend('Standard','Create3agents','Dixon', 'Location','northeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southhwest')
            %legend('Standard','Create3agents','Dixon', 'Location','northwest')

            subplot(2,1,2,'Parent',p) 
            hold on 
            plot(compare_clicks_cell{1,j,k}, (-1)*pos_res_cell{1}, 'b.' , 'MarkerSize', 16)
            ylim([-0.9 0.9])
            %ylim([-0.4 0.4])
            plot(compare_clicks_cell{2,j,k}, (-1)*pos_res_cell{2}, 'g.', 'MarkerSize', 12)
            ylim([-0.9 0.9])
            %ylim([-0.4 0.4])
            %plot(compare_clicks_cell{3,j,k}, (-1)*pos_res_cell{3}, 'r.', 'MarkerSize', 16)
            %ylim([-0.3 0.3])
            %ylim([-0.4 0.4])
            hold off
            title('false positives')
            xlabel('reported beats \tau_j (in seconds)')
            ylabel('errors \epsilon^{pos}_j (in seconds)')
            refline(0,0.07)
            refline(0,-0.07)
            legend('Standard','Create3agents', 'Location','Best') 
            %legend('Standard','Create3agents','Dixon', 'Location','North') 
            %legend('Standard','Create3agents','Dixon', 'Location','South')
            %legend('Standard','Create3agents','Dixon', 'Location','northeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southeast')
            %legend('Standard','Create3agents','Dixon', 'Location','southhwest')
            %legend('Standard','Create3agents','Dixon', 'Location','northwest')            
            %string = strcat(strcat('falses_', strcat(squeezed_mat_cell{j,k}{1}(1),num2str(squeezed_mat_cell{j,k}{1}{3}))), '.png')
            %saveas(gcf,char(string))





%%


%false positives

for j=7%:9
    for k=3 %1:4
        if isempty(Dixon_output_cell{j,k})==1
            compare_index_mat(3,j,k)= 0;
        else    
            compare_clicks_cell{3,j,k}= Dixon_output_cell{j,k}{2}';
        
            trueclick_mat = squeezed_mat_cell{j,k}{4};
    
            Fscore_mat = zeros(size(trueclick_mat,1),2) ;
            falses_mat = zeros(size(trueclick_mat,1),3) ;
        
            clicks= compare_clicks_cell{3,j,k};
            for o =1:size(trueclick_mat,1)
            
                 [F1, F2, n, false_negatives, false_positives] =Fscore(trueclick_mat{o} , clicks, 0.07) ;    
                Fscore_mat(o,:) =[F1, F2];
                %falses_mat(o,:) = [n, false_negatives, false_positives];
            end

            [Y, Index] = max(Fscore_mat, [], 1);
            compare_index_mat(3,j,k)= Index(1);
        end
   



        [nr, I]=min(compare_index_mat(:,j,k));
        if nr ==0
            [nr, I]=max(compare_index_mat(:,j,k))
        end
        %maxlength = size(squeezed_mat_cell{j,k}{4}{nr},1);

        
       % maxvalue = max(squeezed_mat_cell{j,k}{4}{1}(end), compare_clicks_cell{1,j,k}(end), compare_clicks_cell{2,j,k}(end), compare_clicks_cell{3,j,k}(end))
        
        pos_I_cell = cell(3,1)
        pos_res_cell = cell(3,1)
        
        for i=1:length(compare_clicks_cell{1,j,k})
            [c, I] = min(abs(compare_clicks_cell{1,j,k}(i)- trueclick_mat{compare_index_mat(1,j,k)}));
            res = trueclick_mat{compare_index_mat(1,j,k)}(I)- compare_clicks_cell{1,j,k}(i) ;
            pos_I_cell{1}(end+1)= I;
            pos_res_cell{1}(end+1)= res ;
        end
        
        for i=1:length(compare_clicks_cell{2,j,k})
            [c, I] = min(abs(compare_clicks_cell{2,j,k}(i)- trueclick_mat{compare_index_mat(2,j,k)}));
            res = trueclick_mat{compare_index_mat(2,j,k)}(I)- compare_clicks_cell{2,j,k}(i) ;
            pos_I_cell{2}(end+1)= I;
            pos_res_cell{2}(end+1)= res ;
        end
        %next part is for Dixon , if data not available, comment out 
        
        %for i=1:length(compare_clicks_cell{3,j,k})
        %    [c, I] = min(abs(compare_clicks_cell{3,j,k}(i)- trueclick_mat{compare_index_mat(3,j,k)}));
        %    res = trueclick_mat{compare_index_mat(3,j,k)}(I)- compare_clicks_cell{3,j,k}(i) ;
        %    pos_I_cell{3}(end+1)= I;
        %    pos_res_cell{3}(end+1)= res ;
        %end
        
        
        
        figure 
        hold on 
        plot(compare_clicks_cell{1,j,k}, pos_res_cell{1}, 'b.' , 'MarkerSize', 21)
        ylim([-0.3 0.3])
        plot(compare_clicks_cell{2,j,k}, pos_res_cell{2}, 'g.', 'MarkerSize', 17)
        ylim([-0.3 0.3])
        %plot(compare_clicks_cell{3,j,k}, pos_res_cell{3}, 'r.', 'MarkerSize', 21)
        %ylim([-0.3 0.3])
        hold off
        title(strcat('false positives:  ', title_mat{j,k}))
        xlabel('seconds')
        ylabel('magnitude of error (in seconds)')
    end
end

 


%%
%here we create the the old clickplot in a newer version
j=6 
k=3







 RMAT = squeezed_mat_cell{j,k}{3}(:, 4:6);
trueclick_mat = squeezed_mat_cell{j,k}{4};

figure
        hold on
        
        %plot(RMAT(agentchangelist, 3), ones(length(agentchangelist)), 'm*');
        
        plot(RMAT(RMAT(:,1)<37,3), ones(length(RMAT(RMAT(:,1)<37,3))),'k.', 'MarkerSize', 12  ); %Bassdrums in black

        ylim([0.8,1.3]);

        plot(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3), ones(length(RMAT((36<RMAT(:,1)& RMAT(:,1)<41),3))),'k.', 'MarkerSize', 12 ); %Snaredrums 

        plot(RMAT(RMAT(:,1)>36,3), ones(length(RMAT(RMAT(:,1)>36,3))),'k.' ,'MarkerSize', 12  ); %other instruments 
        
         
        %plot([[18:1/2:179.00] [18:1/2:179.00]], [1.1*ones(length([18:1/2:179.00])) 0.9*ones(length([18:1/2:179.00]))] ,'m.')

        
        if size(trueclick_mat,1)==4
            for i=1:length(trueclick_mat{1})
                plot([trueclick_mat{1}(i) trueclick_mat{1}(i)],[0 2], 'Color', [0.9 0.9 0.9]) ;
            end
            for i=1:length(trueclick_mat{2})
                plot([trueclick_mat{2}(i) trueclick_mat{2}(i)],[0 2], 'Color', [0.75 0.75 0.75]) ;
            end
            for i=1:length(trueclick_mat{3})
                plot([trueclick_mat{3}(i) trueclick_mat{3}(i)],[0 2], 'Color', [0.55 0.55 0.55]) ;
            end
            for i=1:length(trueclick_mat{4})
                plot([trueclick_mat{4}(i) trueclick_mat{4}(i)],[0 2], 'Color', [0.3 0.3 0.3]) ;
            end
        end
        
        if size(trueclick_mat,1)==3  
            for i=1:length(trueclick_mat{1})
                plot([trueclick_mat{1}(i) trueclick_mat{1}(i)],[0 2], 'Color', [0.75 0.75 0.75]) ;
            end
            for i=1:length(trueclick_mat{2})
                plot([trueclick_mat{2}(i) trueclick_mat{2}(i)],[0 2], 'Color', [0.55 0.55 0.55]) ;
            end
            for i=1:length(trueclick_mat{3})
                plot([trueclick_mat{3}(i) trueclick_mat{3}(i)],[0 2], 'Color', [0.3 0.3 0.3]) ;
            end
        end
        if size(trueclick_mat,1)==2  
            for i=1:length(trueclick_mat{1})
                plot([trueclick_mat{1}(i) trueclick_mat{1}(i)],[0 2], 'Color', [0.55 0.55 0.55]) ;
            end
            for i=1:length(trueclick_mat{2})
                plot([trueclick_mat{2}(i) trueclick_mat{2}(i)],[0 2], 'Color', [0.3 0.3 0.3]) ;
            end
        end
        
       % if size(trueclick_mat,1)>2
       %     for i=1:length(trueclick_mat{end-2})
       %     plot([trueclick_mat{end-2}(i) trueclick_mat{end-1}(i)],[0 2], 'Color', [0.8 0.8 0.8]) ;
       %     end
       % end
       % if size(trueclick_mat,1)>3
       %     for i=1:length(trueclick_mat{end-3})
       %     plot([trueclick_mat{end-3}(i) trueclick_mat{end-3}(i)],[0 2], 'Color', [0.9 0.9 0.9]) ;
       %     end
       % end
       % if size(trueclick_mat,1)>4
       %     for i=1:length(trueclick_mat{end-4})
       %     plot([trueclick_mat{end-4}(i) trueclick_mat{end-4}(i)],[0 2], 'Color', [0.95 0.95 0.95]) ;
       %     end
       % end
            
            
        
        
        
        
        %plot(RMAT(agentchangelist, 3), ones(length(agentchangelist)), 'g*');
        %plot([[18:1/2:179.00] [18:1/2:179.00]], [1.1*ones(length([18:1/2:179.00])) 0.9*ones(length([18:1/2:179.00]))] ,'m.')

        for i=1:length(compare_clicks_cell{1,j,k}) %Standard version is plotted in blue
           plot([compare_clicks_cell{1,j,k}(i) compare_clicks_cell{1,j,k}(i)],[0.9 1],'b');
        end
        
        for i=1:length(compare_clicks_cell{2,j,k}) %create3agents is plotted in green
           plot([compare_clicks_cell{2,j,k}(i) compare_clicks_cell{2,j,k}(i)],[1 1.1],'g');
        end
        
        for i=1:length(compare_clicks_cell{3,j,k}) %Dixon is plotted in red
           plot([compare_clicks_cell{3,j,k}(i) compare_clicks_cell{3,j,k}(i)],[1.1 1.2],'r');
        end

        %for i=1:length(winning_agent2')
        %     plot([winning_agent2(i) winning_agent2(i)],[0.8 0.9],'g');
        
        %end
        
        %for i=1:length(winning_agent3')
        %     plot([winning_agent3(i) winning_agent3(i)],[0.85 0.95],'b');
        
        %end
        if k==1
            tempotrack = 'tempo track 1'
        elseif k==2
            tempotrack = 'tempo track 2'
        elseif k==3
            tempotrack = 'tempo track 3'
        else k==4
            tempotrack = 'tempo track 4'
        end
        %titlestring= strcat(strcat(songs{j}, k)
        title(strcat('Reported vs. True Beats: ', strcat(songs{j}, tempotrack)) )
        set(gca,'ytick',[])
        %set(gca,'xticklabel',[])
        xlabel('seconds')
       
        hold off