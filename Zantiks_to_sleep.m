%% Transforms Zantiks speed data spreadsheets into sleep data variables RS_2023

%% Import table
% Copies your data from the Zantiks .csv output from cell H5

[file,path] = uigetfile('*.csv');
T = readtable(fullfile(path,file),'Range','H5');
T = rmmissing(T); % Delete all NaNs

clear file path

%% Calculates sleep with time-bin granularity

Time_bins=10; % Length in seconds of the time bins recorded with Zantiks
Sleep_definition=300; % Duration of locomotor inactivity, in seconds, that defines sleep
Min_in_hour_Zantiks=58; %How many real minutes (excluding autoref) are recorded per hour in Zantiks
headings_tab = ["A1"; "A2"; "A3"; "A4"; "A5"; "A6"; "A7"; "A8"; "A9"; "A10"; "A11"; "A12"; "B1"; "B2"; "B3"; "B4"; "B5"; "B6"; "B7"; "B8"; "B9"; "B10"; "B11"; "B12"; "C1"; "C2"; "C3"; "C4"; "C5"; "C6"; "C7"; "C8"; "C9"; "C10"; "C11"; "C12"; "D1"; "D2"; "D3"; "D4"; "D5"; "D6"; "D7"; "D8"; "D9"; "D10"; "D11"; "D12"; "E1"; "E2"; "E3"; "E4"; "E5"; "E6"; "E7"; "E8"; "E9"; "E10"; "E11"; "E12"; "F1"; "F2"; "F3"; "F4"; "F5"; "F6"; "F7"; "F8"; "F9"; "F10"; "F11"; "F12"; "G1"; "G2"; "G3"; "G4"; "G5"; "G6"; "G7"; "G8"; "G9"; "G10"; "G11"; "G12"; "H1"; "H2"; "H3"; "H4"; "H5"; "H6"; "H7"; "H8"; "H9"; "H10"; "H11"; "H12"];

Bins_sleep=Sleep_definition/Time_bins; % Number of immobility bins to define sleep

S = zeros(height(T),width(T));

for b=1:width(T)
    for a=Bins_sleep+1:height(T)
        if T{a-Bins_sleep:a,b}==0
           S(a-Bins_sleep,b)=1;
        else
            S(a-Bins_sleep,b)=0;
        end
    end
end



%% Re-binning (in minutes and percentage)

Re_bin=60;  % in Minutes
Re_bin_num= Re_bin*Min_in_hour_Zantiks/Time_bins; % How many old bins in a new bin
S_rebinned= zeros((length(S)/Re_bin_num),width(T));

for b=1:size(S,2)
    for c=1:(length(S)/Re_bin_num) 
        S_rebinned(c,b)=Re_bin*mean(S(1+Re_bin_num*(c-1):Re_bin_num*(c),b));
    end
end

S_rebinned_perc=S_rebinned./Re_bin;

T = array2table(T, 'VariableNames', headings_tab);
S = array2table(S, 'VariableNames', headings_tab);
S_rebinned = array2table(S_rebinned, 'VariableNames', headings_tab);
S_rebinned_perc = array2table(S_rebinned_perc, 'VariableNames', headings_tab);

clear a b c Bins_sleep N_bins_per_h Re_bin_num Re_bin Sleep_definition Time_bins Min_in_hour_Zantiks headings_tab
