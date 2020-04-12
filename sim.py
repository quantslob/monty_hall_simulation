
############ Run the following code in Python3 session.  ~Quantslob

import datetime
import random

n = 3 ### number of doors
r = 1 ### number of losing doors revealed by host, must be > 0 AND < n - 1
nn = 50000 #### total number of simulations

#############

os_wins = [0] * nn
sw_wins = [0] * nn
d_space = list( range(1, n+1) )


xxnow = datetime.datetime.now()

kk = 0
while kk < nn:
    
    door_prize = random.sample(d_space, 1)
    door_select = random.sample(d_space, 1)
   
    doors_can_reveal = set(d_space) - set( (door_prize + door_select) )
    doors_revealed = random.sample(doors_can_reveal, r)
    
    doors_can_switch = set(d_space) - set( (doors_revealed + door_select) )
    door_switch = random.sample(doors_can_switch, 1)
     
    os_wins[kk] = door_prize == door_select
    sw_wins[kk] = door_prize == door_switch
    
    kk += 1


print("proportion original selection wins: ", sum(os_wins) / nn)

print("proportion switching wins: ", sum(sw_wins) / nn)

yynow = datetime.datetime.now()

print("run time: ", (yynow - xxnow).total_seconds(), "secs")


