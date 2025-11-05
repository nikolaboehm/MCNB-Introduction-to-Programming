%%% Nikola Böhm - Introduction to Programming - Assignment 2

%% Task 1
% Loading eeg_data_assignment_2.mat in workspace
load eeg_data_assignment_2.mat;

%% Task 2
% finding out which channels are occipital channels
ch_names
% channels "O1", "O2", "Oz", "PO7", "PO3","POz", "PO4", "PO8" are occipital

%find indices for occipital channels
index_occ = [find(ch_names == "O1") 
             find(ch_names == "Oz") 
             find(ch_names == "O2")
             find(ch_names == "PO7")
             find(ch_names == "PO3")
             find(ch_names == "POz")
             find(ch_names == "PO4")
             find(ch_names == "PO8")];

% alternative solution:
% o_chans = find(contains(ch_names, "O")); 

% find index for timepoint at 0.1s
index_time = find(times == 0.1);
% the 41st timepoint is 0.1s

% averaging across all conditions, for the 15th to 17th channel at 41st
% timepoint
occ_t41 = eeg(:, index_occ, 41);
mean_occ_t41 = mean(mean(occ_t41))
% the mean EEG voltage at 0.1 seconds for occipital channels is 0.4213

% finding out which channels are frontal channels
ch_names;
frontal_channels = regexp(ch_names, 'F.+', 'match');
index_frontal = find(~cellfun(@isempty, frontal_channels)); %used claude ai (sonnet 4.5) to find this command

%timepoint at 0.1 s is still the same: 41

% averaging across all conditions, for the frontal channels at 41st
% timepoint
frontal_t41 = eeg(:, index_frontal, 41);
mean_frontal_t41 = mean(mean(frontal_t41))
% the mean EEG voltage at 0.1 seconds for frontal channels is -0.0536

%% Task 3
% average across all conditions
all_cond = mean(eeg, 1);
all_cond = squeeze(all_cond);


%create timecourse figure for all 63 channels
figure();
hold on
for a = 1:63
    plot(times, all_cond(a, :))
end
hold off
xlabel("Time in s");
ylabel("Voltage in microV");
legend(ch_names);

% similarities between timecourses: 
% 1. relatively rhythmic activity

% reasons
% 1. repeitive patterns in EEG activity (e.g. alpha waves)

% differences between timecourses
% 1. different amplitudes for different channels 

% reasons
% 1. if the data is not preprocessed, high amplitudes in frontal
% areas could be attributed to eye blink artifacts (but they would
% not appear so rapidly)
% by looking at the data I rather assume that they are preprocessed,
% so different amplitudes could indeed indicate differences
% in brain activity (e.g. higher amplitudes in occipital channels
% due to visua processing of stimuli


%% Task 4
%(i) mean EEG voltage across all image conditions and occipital channels
%(ii) mean EEG voltage across all image conditions and frontal channels
mean_occ = mean(eeg(:, index_occ, :), [1 2]);
mean_occ = squeeze(mean_occ);

mean_frontal = mean(eeg(:, index_frontal, :), [1 2]);
mean_frontal = squeeze(mean_frontal);

% figure
figure();
hold on
plot(times, mean_occ)
plot(times, mean_frontal)
hold off
xlabel("Time in s");
ylabel("Voltage in microV");
legend("Occipital Channels", "Frontal Channels");

% similarities between timecourses: 
% 1. relatively rhythmic activity

% reasons
% 1. repeitive patterns in EEG activity (e.g. alpha waves)

% differences between timecourses
% 1. amplitudes for occipital channels are higher compared to 
% frontal channels

% reasons
% 1. One reason could be that due to the presentation of visual
% stimuli, visual processing took place, which is associated with
% brain activity in occipital regions. In contrast, frontal
% regions are not really involved in those processes, hence showing
% less activity.

%% Task 5
%(i)mean EEG voltage across all occipital channels for the
% first image condition
%(ii) mean EEG voltage across all occipital channels for the second
% image condition
mean_occ_cond1 = mean(eeg(1, index_occ, :), [2]);
mean_occ_cond1 = squeeze(mean_occ_cond1);

mean_occ_cond2 = mean(eeg(2, index_occ, :), [2]);
mean_occ_cond2 = squeeze(mean_occ_cond2);

% figure
figure();
hold on
plot(times, mean_occ_cond1)
plot(times, mean_occ_cond2)
hold off
xlabel("Time in s");
ylabel("Voltage in microV");
legend("Occipital Channels Condition 1", "Occipital Channels Condition 2");

% similarities between timecourses
% 1. both timecourses look similar
% 2. e.g. both timecourses show a peak at approximately 0.9 seconds

% reasons
% 1. the timecourses could look similar due to very similar processes,
% i.e. processing of a visual stimulus in occipital brain regions
% 2. the peak could be interpreted as the vision-specific P100 ERP component

% differences between timecourses
% 1. at around 0.125s: timecourse for condition 1 shows a more extreme
% negative spike
% 2. at around 0.190s: positive peak for condition 1, but not condition 2
% reasons
% 1. this could be a component specific to condition 1
% (e.g. specific to processing of inanimate objects
% compared to living animals)
% 2. this could be a component specific to condition 1
% (e.g. specific to processing of inanimate objects
% compared to living animals)
