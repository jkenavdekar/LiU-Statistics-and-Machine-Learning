function gwinit(k)
% GWINIT Initialize Gridworld and robot

global GWWORLD;
global GWXSIZE;
global GWYSIZE;
global GWPOS;
global GWFEED;
global GWTERM;
global GWISVALID;
global GWLASTFEED;

GWLASTFEED = 0;
GWWORLD = k;

% Same size for all world except 7
GWXSIZE = 15;
GWYSIZE = 10;

% World-specific
switch k
    case 1 % Annoying blob
        GWFEED = -0.1 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0; 
        GWTERM(4,end-2) = 1;
        GWFEED(1:8,5:8) = -(0.1+0.1+0.1+0.2+11)/5;
    case 2 % Stochastic annoying blob
        GWFEED = -0.1 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(4,end) = 1;
        if rand < 0.2
            GWFEED(1:8,5:8) = -11;
        end
    case 3 % The road to HG
        GWFEED = -0.5 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(10,14) = 1;
        GWFEED(1:3,:) = -0.01;
        GWFEED(8:8,:) = -0.01;
        GWFEED(:,1:3) = -0.01;
        GWFEED(:,13:15) = -0.01;
    case 4 % The road home from HG
        GWFEED = -0.5 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(end-2,2) = 1;
        GWFEED(1:3,:) = -0.01;
        GWFEED(8:8,:) = -0.01;
        GWFEED(:,1:3) = -0.01;
        GWFEED(:,13:15) = -0.01;
    case 5 % One goal only
        GWFEED = -0.1 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(4,end-2) = 1;
    case 6 % Two goals
        GWFEED = -0.1 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(3,end-2) = 1;
        GWTERM(end-2,3) = 1;
    case 7 % Fast lane
        GWXSIZE = 30;
        GWYSIZE = 25;
        GWFEED = -0.5 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(3,end-2) = 1;
        GWFEED(:,7:9) = -0.01;
        GWFEED(:,20:20) = -0.01;
        GWFEED(1:3,:) = -0.01;
        GWFEED(16:18,:) = -0.01;
     case 8 % Warpspace
        GWFEED = -0.1 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(4,end-2) = 1;
        GWFEED(3,3) = 0.1234; % special warp space code
    case 9 % Choices
        GWFEED = -0.5 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(end-2,2) = 1;
        GWFEED(1:3,:) = -0.01;
        GWFEED(5:5,:) = -0.01;
        GWFEED(7:7,:) = -0.01;
        GWFEED(9:9,:) = -0.01;
        GWFEED(5,7) = -0.5;
        GWFEED(7,7) = -0.5;
        GWFEED(9,7) = -0.1;
        GWFEED(:,1:3) = -0.01;  
        GWFEED(:,13:15) = -0.01;
    case 10 % Pillars
        GWFEED = -0.1 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(end-2,end-2) = 1;
        GWFEED(5:8, 3:4) = NaN;
        GWFEED(3:4, 10:13) = NaN;
        GWFEED(7:10, 9:10) = NaN;
    case 11 % It's a trap!
        GWFEED = -0.01 * ones(GWYSIZE,GWXSIZE);
        GWFEED(2:4, 2:4) = 1;
        GWTERM = GWFEED * 0;
        GWTERM(end-2,end-2) = 1;
    case 12 % The final boss
        GWFEED = -0.01 * ones(GWYSIZE,GWXSIZE);
        GWTERM = GWFEED * 0;
        GWTERM(end-2,end-2) = 1;
        GWFEED(5:8, 3:4) = NaN;
        GWFEED(3:4, 10:13) = -0.5;
        GWFEED(7:10, 9:10) = -0.1;
        if (rand < 0.2)
            GWFEED(1:4, 3:4) = -0.5;
        end
end

% Start position
while 1
    GWPOS = ceil([rand*GWYSIZE,rand*GWXSIZE])';
    if k == 4
        GWPOS(1) = 10;
        GWPOS(2) = 14;
    end
    if k == 3
        GWPOS(1) = 8;
        GWPOS(2) = 2;
    end
    if GWTERM(GWPOS(1),GWPOS(2)) || isnan(GWFEED(GWPOS(1),GWPOS(2)))
        continue;
    end
    break;
end

GWISVALID = 1;
end

