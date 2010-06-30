clear;
load 1515dt; %only pre-processing step: remove the first tuple of fs_dirpart_32

fs_dirpart_32 = dir_data;
fs_filepart_32 = file_data;

nefolders = unique(fs_dirpart_32(:,2));
efolders = setdiff(1:size(fs_dirpart_32,1), nefolders);
fnum = (histc(fs_filepart_32(:,2),[-1:size(fs_dirpart_32,1)-1]+0.5));
real_count = size(fs_filepart_32, 1);
pilottrials = 3000;

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
	sum_of_square(level) = 0 + (curfnum/curp).^2;
    sum1 = sum1 + curfnum/curp;
	    
	% compute variance --sum up all the level variances
%	sum_of_square
%	square_of_sum
    third_variance=sum_of_square - (square_of_sum/drilldown).^2;
	third_std_variance(drilldown)=sqrt(sum(third_variance))
	
	% compute real variance
	individual_count_res(drilldown) = sum1;
	sum1 = 0;
	first_variance = (individual_count_res - real_count).^2;
	first_std_variance(drilldown) = sqrt(sum(first_variance))
	
	%compute accumulating variance
	count_res(drilldown) = sum(individual_count_res)/drilldown;
	accu_first_variance = (count_res - real_count).^2;
	accu_first_std_variance(drilldown) = sqrt(sum(accu_first_variance))

	%compute second variance
	our_count = count_res(drilldown);
	second_variance = (individual_count_res - our_count).^2;
	second_std_variance(drilldown) = sqrt(sum(second_variance))	
	
end;
' drill down ok'
count_res(pilottrials)
mean(individual_count_res)

