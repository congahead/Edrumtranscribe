
%%
function [trueclick_mat] = create_trueclick_mat(squeezedclicks, subdiv)


    possible_subdiv = divisors(subdiv);

    trueclick_mat = cell(length(possible_subdiv), 1) ;

    for i = 1:length(divisors(subdiv))
        indexvec = [1:possible_subdiv(i):length(squeezedclicks)];
        trueclick_mat{i}= squeezedclicks(indexvec)    ;
    end
 
end