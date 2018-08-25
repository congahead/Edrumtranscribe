function [shuffleornot, subdiv_in_beat] = analyze_histogram(histogramlist, plot)
%parameters:
relevance_threshold = 0.1; %only normalized histogramvalues higher than  relevance_threshold will be considered relevant


%%
h = histcounts(histogramlist, [0,1/24, 3/24, 5/24, 7/24, 9/24, 11/24, 13/24, 15/24, 17/24, 19/24, 21/24, 23/24, 1] );

g = h(2:end)/sum(h(2:end));

normh = h/(sum(h));

active_loc=(find(normh>relevance_threshold)-1)/12 ;  % these quant. loc. have an empirical prob higher than 0.1


if isequal(active_loc,[0 2/3]) | isequal(active_loc,[0 1/3 1/2 2/3]) | isequal(active_loc,[0 1/6 1/4 5/12 1/2 2/3 3/4]) 
    shuffleornot =1 ;
else
    shuffleornot =0;
end


%%
if active_loc(1)==0
    denomlcm =1;
else
    [N,D]=numden(sym(active_loc(1)));
    denomlcm =D;
end
if length(active_loc)>1
    for i=2:length(active_loc)
        [N,D]=numden(sym(active_loc(i)));
        denomlcm = lcm(denomlcm, D);
    end
end

if shuffleornot ==0
    subdiv_in_beat = denomlcm ;
else
    subdiv_in_beat = denomlcm*2/3 ;
end
%%

if plot==1
   
    histogram(histogramlist, [0,1/24, 3/24, 5/24, 7/24, 9/24, 11/24, 13/24, 15/24, 17/24, 19/24, 21/24, 23/24, 1], 'Normalization', 'probability' );
   
end
end



%%