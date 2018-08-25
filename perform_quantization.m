function result_vec = perform_quantization(beg_int, end_int, onsetvec)
%%
load('onsetvec_cell.mat')
%%

%little test example:
%onsetvec = [0.1; 0.15; 0.34; 0.38; 0.4; 0.44] ;
%onsetvec=[0.2]
%onsetvec=[0.2 ; 0.26]
%beg_int = 0
%end_int = 1

almost_identical_onset = 0.07;

%first step : check whether there are onsets that are so close together
%that they could be quantized to the same location
% this looks complicated and it is, because it is made very computationally inexpensive. but the goal is easy , if onsetvec(i)
% and onsetvec(j) are less than almost_identical_onset apart,
% close_onset_mat(i, j) is set to one. check for the test vector above that
% it works. 


k = length(onsetvec);

close_onset_mat= eye(k);

if k == 0
    result_vec=[];

else

    if k == 1
        close_onset_mat= 1 ;
    else
        for i = 0:k-2     
                for j=1:k-i-1
                    if close_onset_mat(k-i,k-i-j)==1
                        j=j+1;
                    else 
                        if onsetvec(k-i)-onsetvec(k-i-j)> almost_identical_onset % here maybe: min( almost_identical_onset, some relative threshold)    
                            break
                        else    
                            close_onset_mat((k-i-(j-1)):(k-i),k-i-j)=1 ;
                        end
                    end
                end        
        end
    end

    %%
    %next step: normalization of onsetvec

    l = end_int-beg_int; %interval length
    onsetvec = onsetvec'-ones(1,k)*beg_int;
    onsetvec = onsetvec/l;

   
    
    %%

    %now we extract the codevectors we have to consider from onsetvec_cell,
    %using the information from close_onset_mat

    CodevecMat = onsetvec_cell{k} ;

    for i = 1:k-1
        index_vec = find(diag(close_onset_mat,-i)==0);
        for j = 1:length(index_vec) 
            CodevecMat = CodevecMat(CodevecMat(:,index_vec(j))<CodevecMat(:,index_vec(j)+i),:) ;
        end
        if length(index_vec)==length(diag(close_onset_mat,-i))
            break
        end
    end

    %%
    %Now we create the matrix DevianceMat, the has for each codevector from
    %CodevecMat the deviances from the onsetvec. 


    onsetsMat = repmat(onsetvec, size(CodevecMat,1), 1);


    DevianceMat = CodevecMat(:,1:end-1)-onsetsMat;


    %%
    %now we compute the likelihood values of each codevector given onsetvec

    likelihood_var = 1/100*eye(k);  %MAYBE WE SHOULD USE THE COVARIANCE FUNCTION HERE  for now just an arbitrary value, can be optimized later

    likelihood_vec = mvnpdf(DevianceMat, zeros(1,k) , likelihood_var); %likelihood of each onset in the onsetvector given a specific codevector was meant to be played


    %%


    posterior_vec=likelihood_vec.*CodevecMat(:,end); %this vector will give us the posteroir probabilities

     [Y,I] = max(posterior_vec);

     result_vec=CodevecMat(I,1:end-1);

end
end

 
 