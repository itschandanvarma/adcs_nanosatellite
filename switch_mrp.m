function [sigma] = switch_mrp(sigma)

%switch_mrp(sigma)
%
%switch mrp switches from original set to shadow set.
%

norm = sigma'* sigma;

if(norm > 1)
    sigma = -(1/norm)*sigma;
end

end