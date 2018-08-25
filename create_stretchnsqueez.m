 


function [stretchnsqueez_vec] = create_stretchnsqueez(grid_vec, subdiv , tempotrack) 

%beatnr = length(grid_vec)/subdiv ;% nr of beats


%lets keep tempo steady for 25 beats, then go to half tempo over 250 beats
%, then remain at steady tempo
if tempotrack ==1
    n1= ones(subdiv*25,1);
    n2 = linspace(1, 2, subdiv*250)';
    if length(grid_vec)<length(n1)+length(n2)
        n3=[];
    else
        n3 = 2*ones((length(grid_vec)-length(n1)-length(n2)),1);
    end
    stretchnsqueez_vec= [n1; n2; n3];
    stretchnsqueez_vec = stretchnsqueez_vec(1:length(grid_vec)); %chunk off if too long
end

%%
% this vector goes from tempo 60 to tempo 120
if tempotrack==2
    n1= 2*ones(subdiv*25,1);
    n2 = linspace(2, 1, subdiv*250)';
    if length(grid_vec)<length(n1)+length(n2)
        n3=[];
    else
        n3 = ones((length(grid_vec)-length(n1)-length(n2)),1);
    end
    stretchnsqueez_vec= [n1; n2; n3];
    stretchnsqueez_vec = stretchnsqueez_vec(1:length(grid_vec)); %chunk off if too long

end


%%
%this one goes from tempo 160 to tempo 40
if tempotrack ==3
    n1= 0.75*ones(subdiv*25,1);
    n2 = linspace(0.75, 3, subdiv*250)';
    if length(grid_vec)<length(n1)+length(n2)
        n3=[];
    else
        n3 = 3*ones((length(grid_vec)-length(n1)-length(n2)),1);
    end
    stretchnsqueez_vec= [n1; n2; n3];
    stretchnsqueez_vec = stretchnsqueez_vec(1:length(grid_vec)); %chunk off if too long
end

%%
% this vector goes from tempo 40 to tempo 160
if tempotrack==4
    n1= 3*ones(subdiv*25,1);
    n2 = linspace(3, 0.75, subdiv*250)';
    if length(grid_vec)<length(n1)+length(n2)
        n3=[];
    else
        n3 = 0.75*ones((length(grid_vec)-length(n1)-length(n2)),1);
    end
    stretchnsqueez_vec= [n1; n2; n3];
    stretchnsqueez_vec = stretchnsqueez_vec(1:length(grid_vec)); %chunk off if too long

end

%%

%in this section we create our stretchnsqueez_vec, the vector containing the factors to manipulates the onset times at the gridpoints 
%for now , we shape it with a sinusoid, but we can try other functions, like
%for example exponentially growing functions etc


%n=500 ;% number of samples until one sinusoid period is completed , i.e. after how many subdivision are we back in initial tempo (actually back in tempo for 2nd time) 
%amplitude=1/2; % some value s.t. 0 < amplitude < 1
%our_sinusoid= 1-amplitude*sin(linspace(0,2*pi, n)); 

%m = floor((length(grid_vec)-1)/n);

%a=our_sinusoid;
%for i=1:m
%    a = horzcat(a, our_sinusoid);
%end

%stretchnsqueez_vec= a(1:length(grid_vec)-1); 

end
