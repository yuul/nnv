load ACASXU_run2a_1_9_batch_2000.mat;
Layers = [];
n = length(b);
for i=1:n - 1
    bi = cell2mat(b(i));
    Wi = cell2mat(W(i));
    Li = Layer(Wi, bi, 'ReLU');
    Layers = [Layers Li];
end
bn = cell2mat(b(n));
Wn = cell2mat(W(n));
Ln = Layer(Wn, bn, 'Linear');

Layers = [Layers Ln];
F = FFNN(Layers);

% Input Constraints
% 55947.69 <= i1(\rho) <= 60760,
% -3.14 <= i2 (\theta) <= 3.14,
%-3.14 <= i3 (\shi) <= -3.14
% 1145 <= i4 (\v_own) <= 1200, 
% 0 <= i5 (\v_in) <= 60

lb = [58000; -.5; -.5; 1170; 25];
ub = [58050; .5; .5; 1175; 35];

% normalize input
for i=1:5
    lb(i) = (lb(i) - means_for_scaling(i))/range_for_scaling(i);
    ub(i) = (ub(i) - means_for_scaling(i))/range_for_scaling(i);   
end

B = Box(lb, ub);

I = B.toStar;

[R, t] = F.reach(I, 'exact', 1, []); % exact reach set
save result.mat;
