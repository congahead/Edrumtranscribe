


function [F1,F2, n , false_negatives, false_positives] = Fscore(TRUECLICKS, CLICKS, Fscore_tol) 

%%
    %some tryout data 
    % for now , we look only at 
    %TRUECLICKS = trueclicks(and(trueclicks>= clicks(1),trueclicks<=clicks(end)));
    %TRUECLICKS=trueclick_mat{2}
    
    %CLICKS = clicks;
    
    %Fscore_tol= 0.07%inner_tol

%%
 %in this loop , we count the false negative
 false_negatives = 0;
 n=0;


for i=1:length(TRUECLICKS)
    [c,I]=min(abs(TRUECLICKS(i)-CLICKS));
    if c >  Fscore_tol
        false_negatives=false_negatives+1;
    else 
        n=n+1;
    end 
end


%%
%in this loop , we count the false positives.

false_positives =0 ;

for i=1:length(CLICKS)
    [c,I]=min(abs(CLICKS(i)-TRUECLICKS));
    if c >  Fscore_tol
        false_positives=false_positives+1;
    end 
end

n;
false_negatives;
false_positives;

F1= n/(n+false_negatives+false_positives);

F2= n/(n+0.5*false_negatives+0.5*false_positives);


end
