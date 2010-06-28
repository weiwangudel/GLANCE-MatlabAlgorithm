clear;
load input7; %only pre-processing step: remove the first tuple of fs_dirpart_32

%fs_dirpart_32 = fs_dirpart_49731;
%fs_filepart_32 = fs_filepart_49731;

para1 = 10000;
para2 = 6;
para3 = 2; %never changed
para4 = 1000; %for backtracking

nefolders = unique(fs_dirpart_32(:,2));
efolders = setdiff(1:size(fs_dirpart_32,1), nefolders);

fnum = (histc(fs_filepart_32(:,2),[-1:size(fs_dirpart_32,1)-1]+0.5));

zfolders = intersect(efolders, find(fnum > para4) - 1);



realres = sum(fnum);

bpe = [];
qcv = [];
for olp = 1:10
    resT = [0,1];
    staticvec = 0;    
    qcost = 0;
    curround = 0;

    while (size(resT,1) > 0)
        tempvec = [];
        curround = curround + 1;
        for i = 1:size(resT,1)
            curd = resT(i,1);
            curf = resT(i,2);
            curs = fnum(curd + 1);
            qcost = qcost+1;

            staticvec = staticvec + curs * curf;
            
            if (isempty(find(efolders==curd)))
                clist = fs_dirpart_32(find(fs_dirpart_32(:,2)==curd), 1);
                if (~isempty(clist))
                    vlength = size(clist,1);
                    if ((qcost > para1) && isempty(intersect(zfolders, clist)))
                        clength = min(vlength, max(para2, floor(vlength/para3)));
                    else
                        clength = vlength;
                    end;
                    vindx = randperm(vlength);
                    clist = clist(vindx(1:clength));
                    tempvec = [tempvec;[clist, ones(clength, 1) * curf * vlength / clength]];
                end;
            end;
        end;    
        resT = tempvec;
    end;
    bpe = [bpe; staticvec]
    qcv = [qcv; qcost]
end;
mean(abs(bpe-realres))/realres
mean(qcv)
