function gwdraw(Q, Episode)
% GWDRAW Draw Gridworld and robot.
% If Q is provided, the policy will be drawn as well. For this to work,
% gwgetpolicy has to be implemented.
% If Episode is provided, the episode number will be shown in the title.

global GWWORLD;
global GWXSIZE;
global GWYSIZE;
global GWPOS;
global GWFEED;
global GWTERM;

% Draw background and set format
cla;
h = imagesc(GWFEED, 'AlphaData', ~isnan(GWFEED));
xlabel('X');
ylabel('Y');
axis image;

% Set title
if nargin >= 2
    title(sprintf('Feedback Map, World %i, Episode %i', GWWORLD, Episode));
else
    title(sprintf('Feedback Map, World %i', GWWORLD));
end

% Create a gray rectangle for the robot
rectangle('Position',[GWPOS(2)-0.5, GWPOS(1)-0.5, 1, 1], 'FaceColor', [0.5,0.5,0.5]);

% If you want to see the color scale of the world you can uncomment this
% line. This will slow down the drawing significantly.
%colorbar;

% Green circle for the goal
for x = 1:GWXSIZE
  for y = 1:GWYSIZE
    if GWTERM(y,x)
      radius = 0.5;
      rectangle('Position',[x-0.5, y-0.5, radius*2, radius*2],...
                'Curvature',[1,1],...
                'FaceColor','g');
    end
  end
end

% Policy
if nargin > 0
    P = gwgetpolicy(Q);
    for x = 1:GWXSIZE
      for y = 1:GWYSIZE
        if ~GWTERM(y,x) && ~isnan(GWFEED(y,x))
            gwplotarrow([y x], P(y, x));
        end
      end
    end
end

% If you want to make the robot move slower (to make it easier to
% understand what it does) you can uncomment this line.
%pause(0.1);

drawnow;
end


