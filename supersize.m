clear;
load 1515dt; %only pre-processing step: remove the first tuple of fs_dirpart_32

fs_dirpart_32 = x1515_dir_mtime_ctime;
fs_filepart_32 = x1515_file_size_mtime_ctime;

nefolders = unique(fs_dirpart_32(:,2));
efolders = setdiff(1:size(fs_dirpart_32,1), nefolders);

pilottrials = 1000;
estratio = 10;
levelcut = 8;

datem = 0;
bpe = [];

for i = 0:size(fs_dirpart_32,1)
    indx = find(fs_filepart_32(:,2)==i);
    if (~isempty(indx))
        dtarr(i+1) = max(fs_filepart_32(indx,3));
    else
        dtarr(i+1) = 0;
    end;
end;

'ok'


resT = [0,1,pilottrials];
resA = [0];
ctvec = dtarr;
while (size(resT,1) > 0)
    tempvec = [];
    tempva = [];
    for i = 1:size(resT,1)
        datem = datem + 1;
        curd = resT(i,1);
        curp = resT(i,2);
        curi = floor(resT(i,3));
        curs = 1;
        if (isempty(find(efolders==curd)))
            clist = fs_dirpart_32(find(fs_dirpart_32(:,2)==curd), 1);
            curp = curp/size(clist,1);
            vlength = size(clist,1);
            tempvec = [tempvec;[clist, ones(vlength,1)*curp, binornd(curi,1/vlength,vlength,1)]];
            tempva = [tempva; [ones(vlength,1) * resA(i,:), clist]];
        else
            ctvec(resA+1) = max(ctvec(resA+1), dtarr(curd+1));
        end;
    end;
    if (~isempty(tempvec))
        resT = tempvec(find(tempvec(:,3)>0),:);
    else
        resT = [];
    end;
    resA = tempva;
end;

ctvec = ctvec*estratio;
resT = [0];
res = [];
thresh = 3575184;

ddep = 0;
while (size(resT,1) > 0)
    tempvec = [];
    tempva = [];
    ddep = ddep + 1;
    for i = 1:size(resT,1)
        datem = datem + 1;
        curd = resT(i,1);
        if (dtarr(curd+1) > thresh)
            indx = find(fs_filepart_32(:,2) == curd);
            res = [res; indx(find(fs_filepart_32(indx,3) > thresh))];
        end;
        if ((ctvec(curd+1) > thresh) || (ddep > levelcut))
            if (isempty(find(efolders==curd)))
                clist = fs_dirpart_32(fs_dirpart_32(:,2)==curd, 1);
                vlength = size(clist,1);
                tempvec = [tempvec;clist];
            end;
        end;
    end;
    resT = tempvec;
end;

datem
res
num_res = size(res)
realres = sum(fs_filepart_32(:,3) > thresh)