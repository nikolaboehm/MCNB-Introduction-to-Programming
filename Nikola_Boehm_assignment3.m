%%% Nikola Böhm - Introduction to Programming - Assignment 3

n_subjects = 60;
n_blocks = 6;

familiarity = ["familiar" "unfamiliar"]; 
emotion = ["positive" "neutral" "negative"]; 

%% Familiarity
% 2 possible orders for familiarity
% either starting with familiar or unfamiliar
% afterwards: alternating
familiarity_orders = [familiarity([1 2 1 2 1 2]);
                      familiarity([2 1 2 1 2 1])];

% assigning the first half of the sample to the first familiarity order
% and the second half of the sample to the second familiarity order
sampled_familiarity = strings(n_subjects, n_blocks);
sampled_familiarity(1:(n_subjects/2), :) = repmat(familiarity_orders(1, :), n_subjects/2, 1);
sampled_familiarity(((n_subjects/2)+1):n_subjects, :) = repmat(familiarity_orders(2, :), n_subjects/2, 1);

% shuffle rows to randomly assign which participant gets which order
% create a random index
row_indices = randperm(n_subjects);

% reorder sampled_familiarity according to random index
sampled_familiarity = sampled_familiarity(row_indices, :);

%% Emotions

% six possible orders for the emotions
% each emotion shown twice (once familiar and once unfamiliar)
emotion_orders = [emotion([1 1 2 2 3 3])
                  emotion([1 1 3 3 2 2])
                  emotion([2 2 1 1 3 3])
                  emotion([2 2 3 3 1 1])
                  emotion([3 3 2 2 1 1])
                  emotion([3 3 1 1 2 2])];

% assigning each sixth of the sample to each possible order
sampled_emotions = strings(n_subjects, n_blocks);
sampled_emotions(1:n_subjects/6, :) = repmat(emotion_orders(1, :), n_subjects/6, 1);
sampled_emotions((n_subjects/6)+1 :(n_subjects/6)*2, :) = repmat(emotion_orders(2, :), n_subjects/6, 1);
sampled_emotions(((n_subjects/6)*2)+1 :(n_subjects/6)*3, :) = repmat(emotion_orders(3, :), n_subjects/6, 1);
sampled_emotions(((n_subjects/6)*3)+1 :(n_subjects/6)*4, :) = repmat(emotion_orders(4, :), n_subjects/6, 1);
sampled_emotions(((n_subjects/6)*4)+1 :(n_subjects/6)*5, :) = repmat(emotion_orders(5, :), n_subjects/6, 1);
sampled_emotions(((n_subjects/6)*5)+1 :n_subjects, :) = repmat(emotion_orders(6, :), n_subjects/6, 1);

% shuffle rows to randomly assign which participant gets which order
% reorder sampled_familiarity according to random index (created above)
sampled_emotions = sampled_emotions(row_indices, :);


% saving the orders of emotions and orders of familiarity in one structure
con_list = struct('Emotion', {sampled_emotions}, ...
                  'Familiarity', {sampled_familiarity});