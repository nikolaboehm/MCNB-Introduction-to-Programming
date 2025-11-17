%%% Nikola Böhm - Introduction to Programming - Assignment 5
%%% Encoding Models

% Load the data
load("data_assignment_5.mat")

% Get the data dimension sizes
numFeatures = size(dnn_train, 2);
[~, Nchannels, Ntime] = size(eeg_test);

% initialize variables 
% weights and intercepts
W = zeros(numFeatures, numChannels, numTime); % regression weights
b = zeros(numChannels, numTime);              % intercepts
% predictions 
eeg_test_pred = zeros(numTest, numChannels, numTime);
% correlation matrix
R = zeros(Nchannels, Ntime);

%% Effect of training data amount on encoding accuracy
% Training 4 EEG encoding models using different amounts of 
% training image conditions [250, 1000, 10000, 16540]

% different numbers of training image conditions
im_cond = [250, 1000, 10000, 16540];

% Progressbar parameters
totalModels = numChannels * numTime * length(im_cond);
modelCount = 0;

% results from all models
R_all = zeros(length(im_cond), Nchannels, Ntime);

% Train a linear regression independently for each EEG channel and time
% point
for i = 1:length(im_cond)
    eeg_train_mod = eeg_train(1:im_cond(i), :, :);
    dnn_train_mod = dnn_train(1:im_cond(i), :);

      for ch = 1:numChannels
        for t = 1:numTime
            
            % Extract EEG responses for this channel/time over all trials
            y = eeg_train_mod(:, ch, t);   % [N x 1]
            
            % Fit linear regression: y = DNN*w + b
            mdl = fitlm(dnn_train_mod, y);
            
            % Save parameters
            W(:, ch, t) = mdl.Coefficients.Estimate(2:end); % weights
            b(ch, t)    = mdl.Coefficients.Estimate(1);     % intercept
    
            % Update progress bar
            modelCount = modelCount + 1;
            fprintf('\rTraining models: %d / %d (%.1f%%)', ...
                modelCount, totalModels, 100*modelCount/totalModels);
    
            %% Use the trained models to predict the EEG responses for the test images
    
            eeg_test_pred(:, ch, t) = dnn_test * W(:, ch, t) + b(ch, t);
    
            %% Compute the prediction accuracy using Pearson's correlation
            % Get test responses across images
            real_vec = squeeze(eeg_test(:, ch, t));
            pred_vec = squeeze(eeg_test_pred(:, ch, t));
    
            % Compute Pearson correlation
            R(ch, t) = corr(real_vec, pred_vec, 'Type', 'Pearson');
    
        end
      end
    R_all(i, :, : ) = R;
end


%% Plot the prediction accuracy over time, averaged across channels

% Average the correlation across channels
meanR = zeros(length(im_cond),numTime);
for i = 1:length(im_cond)
    meanR(i, :) = mean(R_all(i, :, :), 2);
end

% Plot the mean correlation over time
figure;
hold on;
for i = 1:length(im_cond)
    plot(meanR(i, :, :));
end
hold off;
legend('250 images', '1000 images', '10000 images', '16540 images','' );
xlabel('Time (seconds)');
xticks(1:Ntime);
xticklabels(times);
ylabel('Mean Pearson Correlation');
title('Prediction Accuracy Over Time With Different Numbers of Training Images');
grid on;
set(gca, 'FontSize', 20);
xline(find(times == 0), 'HandleVisibility','off');

%% Effect of DNN feature amount on encoding accuracy
% Training 4 EEG encoding models using different amounts of 
% DNN features [25, 50, 75,100]

% Get the data dimension sizes
numFeatures = size(dnn_train, 2);
[~, Nchannels, Ntime] = size(eeg_test);

% initialize variables 
% weights and intercepts
W = zeros(numFeatures, numChannels, numTime); % regression weights
b = zeros(numChannels, numTime);              % intercepts
% predictions 
eeg_test_pred = zeros(numTest, numChannels, numTime);
% correlation matrix
R = zeros(Nchannels, Ntime);


% different numbers of DNN features [25, 50, 75,100]
dnn_feat = [25, 50, 75, 100];

% Progressbar parameters
totalModels = numChannels * numTime * length(dnn_feat);
modelCount = 0;

% results from all models
R_all = zeros(length(dnn_feat), Nchannels, Ntime);

% Train a linear regression independently for each EEG channel and time
% point
for i = 1:length(dnn_feat)
    dnn_train_mod = dnn_train(:,1:dnn_feat(i));
    dnn_test_mod = dnn_test(:,1:dnn_feat(i));
    numFeatures = dnn_feat(i);

    W = zeros(numFeatures,ch, t);
      for ch = 1:numChannels
        for t = 1:numTime
            
            % Extract EEG responses for this channel/time over all trials
            y = eeg_train(:, ch, t);   % [N x 1]
            
            % Fit linear regression: y = DNN*w + b
            mdl = fitlm(dnn_train_mod, y);
            
            % Save parameters
            W(:, ch, t) = mdl.Coefficients.Estimate(2:end); % weights
            b(ch, t)    = mdl.Coefficients.Estimate(1);     % intercept
    
            % Update progress bar
            modelCount = modelCount + 1;
            fprintf('\rTraining models: %d / %d (%.1f%%)', ...
                modelCount, totalModels, 100*modelCount/totalModels);
    
            %% Use the trained models to predict the EEG responses for the test images
    
            eeg_test_pred(:, ch, t) = dnn_test_mod * W(:, ch, t) + b(ch, t);
    
            %% Compute the prediction accuracy using Pearson's correlation
            % Get test responses across images
            real_vec = squeeze(eeg_test(:, ch, t));
            pred_vec = squeeze(eeg_test_pred(:, ch, t));
    
            % Compute Pearson correlation
            R(ch, t) = corr(real_vec, pred_vec, 'Type', 'Pearson');
    
        end
      end
    R_all(i, :, : ) = R;
end


% Plot the prediction accuracy over time, averaged across channels

% Average the correlation across channels
meanR = zeros(length(dnn_feat),numTime);
for i = 1:length(dnn_feat)
    meanR(i, :) = mean(R_all(i, :, :), 2);
end

% Plot the mean correlation over time
figure;
hold on;
for i = 1:length(dnn_feat)
    plot(meanR(i, :, :));
end
hold off;
legend('25 features', '50 features', '75 features', '100 features','' );
xlabel('Time (seconds)');
xticks(1:Ntime);
xticklabels(times);
ylabel('Mean Pearson Correlation');
title('Prediction Accuracy Over Time with Different Numbers of DNN Features');
grid on;
set(gca, 'FontSize', 20);
xline(find(times == 0), 'HandleVisibility','off');