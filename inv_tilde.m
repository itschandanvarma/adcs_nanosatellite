function x = inv_tilde(X)

%inv_tilde(X)
%
%inv_tilde gives the column elements from skew symmetric matrix
%

x = [X(3,2);X(1,3);X(2,1)];