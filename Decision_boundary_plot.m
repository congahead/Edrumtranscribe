

eta =0.66
lambda2 = 2.57
covmat1=1/300*[1 0 ; 0 1];

twoonsetmat=onsetvec_cell{2};
x1 = [0: 0.001 : 1];
x2 = [0: 0.001 : 1];
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];

matrixarray= zeros(1001,1001,size(twoonsetmat,1));

%%

for i = 1:size(twoonsetmat,1)
    offdig = eta*exp(-lambda2^2/2*(twoonsetmat(i,1)-twoonsetmat(i,2))^2);
    
    covmat2 = 1/300*[0, offdig; offdig, 0];
    covmat=covmat1+covmat2;
    f= mvnpdf(X, [twoonsetmat(i,1), twoonsetmat(i,2)], covmat)* twoonsetmat(i,3);
    f = reshape(f, 1001, 1001);
    matrixarray(:,:,i)=f;
end

[Y,I] = max(matrixarray,[], 3);

%%


Z=tril(I);

s=surf(x1,x2, Z)

s.EdgeColor = 'none';


