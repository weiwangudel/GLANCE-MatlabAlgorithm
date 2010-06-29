clear;
load 1515dt; %only pre-processing step: remove the first tuple of fs_dirpart_32

fs_dirpart_32 = dir_data;
fs_filepart_32 = file_data;

nefolders = unique(fs_dirpart_32(:,2));
efolders = setdiff(1:size(fs_dirpart_32,1), nefolders);
fnum = (histc(fs_filepart_32(:,2),[-1:size(fs_dirpart_32,1)-1]+0.5));

pilottrials = 300;

'ok'


square_of_sum = zeros(1, 20);
sum_of_square = zeros(1, 20);
level_est_times = zeros(1, 20);
level_variance = zeros(1, 20);
sum1 = 0;
for drilldown = 1:pilottrials
    curd = 0;
	level = 0;
    curp = 1; %current probability
    while (isempty(find(efolders==curd)))
		% files that are under root is called level 1 
		level = level + 1;
		curfnum = fnum(curd+1); % file number under current dir	
		level_est_times(level) = level_est_times(level) + 1;
		square_of_sum(level) = (square_of_sum(level) + curfnum / curp);
		sum1 = sum1 + curfnum/curp;
        clist = fs_dirpart_32(find(fs_dirpart_32(:,2)==curd), 1);
        vlength = size(clist,1);
		curp = curp / vlength;
        vindx = randperm(vlength);
        curd = clist(vindx(1,end),:);       
    end;

    level = level + 1;
    curfnum = fnum(curd+1); % file number under current dir	
    level_est_times(level) = level_est_times(level) + 1;
	square_of_sum(level) = (square_of_sum(level) + curfnum / curp);
	sum_of_square(level) = sum_of_square(level) + (curfnum/curp).^2;
    sum1 = sum1 + curfnum/curp;
    
	% compute variance --sum up all the level variances
%	sum_of_square
%	square_of_sum
    variance=sum_of_square/pilottrials - (square_of_sum/pilottrials).^2;
	variance=sum(variance)
	
end;
%square_of_sum / pilottrials
%sum1/pilottrials
' drill down ok'


