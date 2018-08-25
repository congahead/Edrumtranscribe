

%with this function you can create squeezedmat and trueclick_mat. 
%Once you have s

function [squeezedmat, trueclick_mat] = Josefins_function(midimat, subdiv, name)
% name is the name of the output midifile. It should be a string and end
% with  .mid

    [squeezedmat, squeezedclicks]  = apply_tempo_trajectory(midimat, subdiv);
    
    writemidi(squeezedmat, name)
%%
    [trueclick_mat] = create_trueclick_mat(squeezedclicks, subdiv)
end
    
% once having done this , you check the Fscore with this piece of code 
%you throw in the output of Dixons Beatroot as clicks

  %run Fscore 

    Fscore_mat = zeros(size(trueclick_mat,1),2)

    for i =1:size(trueclick_mat,1)
         Fscore_mat(i,:) =Fscore(trueclick_mat{i} , clicks, 0.07)
    end

    [Score, Index] = max(Fscore_mat, [], 1);

    Score
    Index

