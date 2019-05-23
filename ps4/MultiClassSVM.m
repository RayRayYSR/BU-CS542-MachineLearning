%% SHIRUI YE
%% Nonlinear Kernel Function with ONE-ONE & ONE-REST & DAG multiclass SVM classifier implementation for MNIST dataset
clear; clc;
load('MNIST_data.mat')
polynomial_deg = 4;

%% Train Classifier with one-versus-one: design a SVM between any two samples, so k classes has k(k-1)/2 SVM. There are 10 classes, so the number of SVM is 45n The goal is to train 45 different classifier
disp('1-1')
round = 0;
votes = zeros(size(test_samples_labels,1),10); 
for m = 0 : 8
    for n = m + 1 : 9
        round = round + 1;
        [data_matrix, label_vector] = cluster(train_samples,train_samples_labels,m,n);
        % Langrangian optimization dual form 
        a_vector = findAlpha(data_matrix, label_vector, polynomial_deg);
        pred_vec = predict_class(a_vector,data_matrix,label_vector,test_samples, polynomial_deg);
        m_class = pred_vec > 0;
        pred_vec(m_class) = m;
        pred_vec(~m_class) = n;
        for i = 1:size(pred_vec,1)
            votes(i, pred_vec(i) + 1) = votes(i, pred_vec(i) + 1) + 1; 
        end
    end
end
[confusion_matrix_1_1,accuracy] = computeConfusionMatrix(votes, test_samples_labels);
disp(confusion_matrix_1_1)
disp(accuracy)

disp('1-rest')
round = 0;
votes = zeros(size(test_samples,1),10); 
for m = 0 : 9
    round = round + 1;
    data_matrix = train_samples;
    label_vector = train_samples_labels;
    m_class = label_vector == m;
    label_vector(m_class) = 1;
    label_vector(~m_class) = -1/9;
    % Langrangian optimization dual form 
    a_vector = findAlpha(data_matrix, label_vector, polynomial_deg);
    votes(:, m + 1) = predict_class(a_vector,data_matrix,label_vector,test_samples, polynomial_deg);
end
[confusion_matrix_1_rest,accuracy] = computeConfusionMatrix(votes ,test_samples_labels);
disp(confusion_matrix_1_rest)
disp(accuracy)

votes = ones(size(test_samples_labels,1),10); 
disp('DAGSVM')
for times = 1 : 9 
    for m = 0 : times - 1
        n = m + (10 - times); 
        [data_matrix, label_vector] = cluster(train_samples,train_samples_labels,m,n);
        a_vector = findAlpha(data_matrix, label_vector, polynomial_deg);
        pred_vec = predict_class(a_vector,data_matrix,label_vector,test_samples,polynomial_deg);
        m_class = pred_vec > 0; 
        votes(m_class, n + 1) = 0;
        votes(~m_class, m + 1) = 0;
    end
end
[confusion_matrix_DAG,accuracy] = computeConfusionMatrix(votes, test_samples_labels);
disp(confusion_matrix_DAG)
disp(accuracy)









function [data_matrix, label_vector] = cluster(data, label, m, n)
data_matrix = [];
label_vector = [];
for i = 1:size(data,1)
    if label(i) == m
        label_vector = [label_vector; 1]; %Extend the vector
    elseif label(i) == n
        label_vector = [label_vector; -1];%Extend the vector
    else
        continue
    end
    data_matrix = [data_matrix; data(i,:)];%Extend the matrix
end
end

%According to the different constraints, the quadratic programming can be divided into the equality constrained quadratic programming problem and the inequality constrained quadratic programming problem. The equality-constrained quadratic programming problem only contains equality constraints. The common solutions are direct elimination method, generalized elimination method and Lagrange method. For the inequality constrained quadratic programming problem, the basic idea is to impose inequality constraints. It is transformed into an equality constraint and solved. The common solution has an active set method. The effective set method takes the effective constraint as an equality constraint in each iteration, and then can be solved by the Lagrangian method and repeated until the most Excellent solution.
function a_vector = findAlpha(data_matrix, label_vector, polynomial_deg)
% MATLAB Function: x = quadprog(H,f,A,b,Aeq,beq):
% minimize 0.5 * x'Hx - f'x where x is variable, A*x <= b, Aeq * x = beq
    N = size(label_vector,1); % N data points
    H = ((data_matrix * data_matrix').^polynomial_deg) .* (label_vector * label_vector');
    f = -ones(N,1);  %- f
    A = -eye(N);
    b = zeros(N,1);
    Aeq = [label_vector'; zeros(N-1,N)]; % A zero matrix where 1st row contains y
    beq = zeros(N,1); % such that effectively label_vector' * a_vector = 0
%Display is set to 'off', indicating that the optimization process does not display information about the optimization process (in contrast to 'iter', 'iter-detailed', 'notify', 'notify-detailed', 'final', 'final -detailed' and other options, please refer to the documentation for the specific meaning; Algorithm is set to 'sqp', which means to select the Sequential Quadratic Programming algorithm. If you want to know more about the algorithm, some basic introductions are provided in the documentation. You can know the basic principles and general characteristics of various algorithms, and if you want to go deeper, you need to refer to other specialized documents.
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
    a_vector = quadprog(H, f, A, b, Aeq, beq, [],[],[], options);
end

%%Nonlinear

function prediction_vector = predict_class(a_vector, data_matrix, label_vector, test_data, polynomial_deg)
        support_index = a_vector > 0.0001; 
        support_matrix_x = data_matrix(support_index,:);
        support_vector_y = label_vector(support_index);
        support_alpha = a_vector(support_index);
        
        M = size(support_vector_y,1); % size of support vectors
        b = 1/M * sum(support_vector_y - ((support_matrix_x * support_matrix_x').^polynomial_deg * (support_vector_y .* support_alpha)));
        prediction_vector = (test_data * support_matrix_x').^polynomial_deg * (support_vector_y .* support_alpha) + b;
        
end

%% Compute confusion matrix and post-processing
%% test sample labels are 1000*1 vectors,votes is a 1000*10 matrix
function [confusion_matrix,accuracy] = computeConfusionMatrix(votes, test_samples_labels) 

confusion_matrix = zeros(10,10); 
[max_counts, max_index] = max(votes,[],2);
for i = 1:size(max_index, 1)
    confusion_matrix(test_samples_labels(i) + 1, max_index(i))= confusion_matrix(test_samples_labels(i) + 1, max_index(i)) + 1;
end
accuracy = trace(confusion_matrix) / size(test_samples_labels,1);
end













