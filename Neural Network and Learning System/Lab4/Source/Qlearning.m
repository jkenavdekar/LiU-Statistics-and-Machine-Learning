%% Initialization
%  Initialize the world, Q-table, and hyperparameters
k = 4;
gwinit(k);
Q = zeros(10, 15, 4);
Q(1,:,2) = -Inf;
Q(10,:,1) = -Inf;
Q(:,1,4) = -Inf;
Q(:,15,3) = -Inf;
eta = 0.1;
gamma = 0.1;
eps = 0.5;


%% Training loop
%  Train the agent using the Q-learning algorithm.

number_of_episodes = 5000;
maxiter = 200;
for Episode=1:number_of_episodes
    gwinit(k);
    s = gwstate();
    old_pos = s.pos;
    
    for i=1:maxiter
        valid = 0;
        while valid == 0
            [action, opt_action] = chooseaction(Q, old_pos(1), old_pos(2), ...
                                                 [1,2,3,4], [1 1 1 1], eps);
            s = gwaction(action);
            valid = s.isvalid;
        end
        r = s.feedback;
        new_pos = s.pos;
        Q(old_pos(1),old_pos(2),action) = (1-eta)*Q(old_pos(1),old_pos(2),action) + ...
            eta*(r + gamma*max(Q(new_pos(1),new_pos(2),:)));
        if s.isterminal == 1
            break;
        end
        old_pos = new_pos;  
        
    end   
end

%% Test loop
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0, always pick
%  the optimal action.

number_of_episodes = 1;
maxiter = 200;
for Episode=1:number_of_episodes
    gwinit(k);
    s = gwstate();
    gwdraw();
    hold on
    old_pos = s.pos;    
    for i=1:maxiter
        valid = 0;
        while valid == 0
            [action, opt_action] = chooseaction(Q, old_pos(1), old_pos(2), ...
                                                 [1,2,3,4], [1 1 1 1], 0);
            s = gwaction(action);
            valid = s.isvalid;
        end
        gwplotarrow(old_pos,action);
        V(i) = Q(old_pos(1),old_pos(2),action);
        new_pos = s.pos;      
        if s.isterminal == 1
            V(i+1) = 0;
            break;
        end
        old_pos = new_pos;          
    end   
end
V = max(Q,[],3);

figure(2) 
imagesc(V)

figure(3)
gwdraw(Q)

