clear;
load input7; %only pre-processing step: remove the first tuple of fs_dirpart_32

%fs_dirpart_32 = fs_dirpart_49731;
%fs_filepart_32 = fs_filepart_49731;

nefolders = unique(fs_dirpart_32(:,2));
efolders = setdiff(1:size(fs_dirpart_32,1), nefolders);

fnum = (histc(fs_filepart_32(:,2),0:84373+0.5));

% for i = 0:size(fs_dirpart_32,1)
%     fnum(i+1) = sum(fs_filepart_32(:,2) == i);
% end; %could be improved with unique function

pthresh = 1/10000;
dcnumtrials = 100;
totalnumtrials = 10000;
pilottrials = 1;
athresh = 100000000;

bpe = [];

for olp = 1:1
    resT = [0,1,pilottrials,0];
    resA = [0];
    res = [];
    ctvec = zeros(size(fs_dirpart_32,1),1);
    dept = zeros(size(fs_dirpart_32,1),1);
    curround = 0;
    while (size(resT,1) > 0)
        tempvec = [];
        tempva = [];
        curround = curround + 1;
        for i = 1:size(resT,1)
            curd = resT(i,1);
            if (curd > 0)
                dept(curd) = curround;
            end;
            curp = resT(i,2);
            curi = floor(resT(i,3));
            curs = 1;
            cure = resT(i,4) + curs/curp;
            if (isempty(find(efolders==curd)))
                clist = fs_dirpart_32(find(fs_dirpart_32(:,2)==curd), 1);
                curp = curp/size(clist,1);
                vlength = size(clist,1);
                tempvec = [tempvec;[clist, ones(vlength,1)*curp, ones(vlength,1), ones(vlength,1)*cure]];
                tempva = [tempva; [ones(vlength,1) * resA(i,:), clist]];
            else
                res = [res; ones(curi,1)*cure];
                vindx = setdiff(resA(i,:),0);
                ctvec(vindx) = ctvec(vindx) + curi*cure;
            end;
        end;
        resT = tempvec;
        resA = tempva;
    end;
    ctvec = ctvec/pilottrials;
    
    %end of weight adjustmeent
    
end;
for dei = 2:10
    qwe(dei-1) = var(ctvec(find(dept==dei)));
end;
plot(qwe)