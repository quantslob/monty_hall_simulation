using StatsBase;

n = 3; # number of doors
r = 1; # number of losing doors revealed by host, must be > 0 AND < n - 1
nn = 10000; # total number of simulations

os_wins = falses(1, nn);
sw_wins = falses(1, nn);

d_space = [1:1:3;];

kk = 0;

while kk < nn
    global kk += 1;
    door_prize = sample(d_space);
    door_select = sample(d_space);
    doors_can_reveal = setdiff(d_space, [door_prize, door_select]);
    doors_revealed = doors_can_reveal[sample([1:1:length(doors_can_reveal);], r)];

    doors_can_switch = setdiff(d_space, [door_select, first(doors_revealed)]);
    door_switch = doors_can_switch[sample([1:1:length(doors_can_switch);])];

    os_wins[kk] = door_prize == door_select;
    sw_wins[kk] = door_prize == door_switch;
end

print("proportion original selection wins: ", sum(os_wins) / nn, "\n")

print("proportion switching wins: ", sum(sw_wins) / nn, "\n")
