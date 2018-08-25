




function [resultvec] = quantize_microbeats(beg_int, end_int, onsetvec)
% I will make a function out of it later

% here is a synthetic onsetvector (and begin and endpoint) we wish to quantize:
%onsetvec = [1.2 1.45 1.7 ]' ;
%beg_int = 1 ;
%end_int = 1.9;

%here we go
%first step: normalization

k = length(onsetvec);
l = end_int-beg_int; %interval length

onsetvec = onsetvec-ones(k,1)*beg_int;
onsetvec = onsetvec/l;
%%

%Here we create the matrix codevec_mat. Each row of the matrix will contain a codevector
% with the same number of onsets that we have in onsetvec
% Josefin: the perms function did not give the unique permutations,
% therefore I had to do it this way

A = [ones(1,k) zeros(1, (11-k))];
n = numel(A); % for our grid:  11
c = nchoosek(1:n,k);
m = size(c,1); % number of codevectors
codevec_mat = zeros(m,n);
codevec_mat(sub2ind([m,n],(1:m)'*[ones(1, k)],c)) = 1;

%in this for loop, I find for each codevector maximum depth he expands on ,
%i.e. which subdivision does he operate on

d = [12 6 4 3 12 2 12 3 4 6 12]'; %depth function

depth_vec = zeros(m,1);
for i=1:m
    depth_vec(i,1) = lcm(sym(d(codevec_mat(i,:)==1)));
end
   
%computing the prior probabilities
lambda = 0.9; %for now just an arbitrary value, can be optimized later

prior_vec = zeros(m,1) ;% this vector will contain the prior probability of each codevector
prior_vec(:,1) = exp((-1)*lambda*depth_vec);
prior_vec = prior_vec/sum(prior_vec); % normalize 



%just to look at codevectors and their prior probabilities: 
%D =codevec_mat((prior_vec>0.01),:);
%D(:, end+1)=prior_vec(prior_vec>0.01)
%


%%

%computing the likelihood function
%first get deviances from the codevector :

likelihood_var = 1/200; %for now just an arbitrary value, can be optimized later

[col, row] = find(codevec_mat'); %just look at the nonzero indices of codevec_mat

 M = 1/12 * reshape(col-1, k, m)' ;%HERE WE CHANGED FROM col TO col-1 !!!this matrix contains the exact locations of the codevector
 
 deviance_mat = abs(M-(repmat(onsetvec, 1, m)')); % each row of this matrix contains the pointwise deviance from onsetvec to exact codevector location
 
likelihood_mat = normpdf(deviance_mat, 0, likelihood_var); %likelihood of each onset in the onsetvector given a specific codevector was meant to be played

%now, we take the pointwise product of the columns of likelihood_mat:

likelihood_product = likelihood_mat(:,1) ;
for i=2:k
    likelihood_product = likelihood_product.* likelihood_mat(:,i) ;
end
 

posterior_vec=likelihood_product.*prior_vec; %this vector will give us the posteroir probabilities

 [Y,I] = max(posterior_vec);

 resultvec=codevec_mat(I,:);
end



%%

