load ACASXU_run2a_2_7_batch_2000.mat;
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
% 1500 <= i1(\rho) <= 1800,
% -0.06 <= i2 (\theta) <= 0.06,
% 3.1 <= i3 (\shi) <= 3.14
% 980 <= i4 (\v_own) <= 1200, 
% 960 <= i5 (\v_in) <= 1200

lb = [1500; -0.06; 3.1; 980; 960];
ub = [1800; 0.06; 3.14; 1200; 1200];
%lb = [1650; -.02; 3.1; 1040; 1030];
%ub = [1750; .02; 3.14; 1140; 1130];
% normalize input
for i=1:5
    lb(i) = (lb(i) - means_for_scaling(i))/range_for_scaling(i);
    ub(i) = (ub(i) - means_for_scaling(i))/range_for_scaling(i);   
end

%I = Polyhedron('lb', lb, 'ub', ub);
B = Box(lb, ub);
I = B.toStar;
[R, t] = F.reach(I, 'exact', 4, []); % exact reach set
save result.mat; % save the verified network
F.print('F.info'); % print all information to a file
