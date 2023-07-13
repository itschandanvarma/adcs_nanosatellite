function x = tilde(X)

%tilde(X)
%
%tilde operator gives a skew symmetric matrix which is used for
%cross multiplication with equivalent tilde matrix.
%

x = [0 -X(3) X(2);X(3) 0 -X(1);-X(2) X(1) 0];
