import time
import os


def countdown(t):
	t = t * 60
	while t:
		print(t)
		time.sleep(1)
		t-=1
	print( "Time is up\n")
	os.system('play --no-show-progress --null --channels 1 synth %s sine %f' %(1, 440))


t = 0
print("If you want to quit enter -1 :")
num_of_pomidoros = 0
pom_time =  0
num_of_rest_time = 0
rest_time = 0
while t!=-1 :
	t = input("Enter time in minutes that you plan to work or -1: ")
	if( t == -1):
		break
	countdown(t)
	if t > 0 :
		num_of_pomidoros +=1;
		pom_time +=t
	t = 0
	t = input("Enter time in minutes that you plan to get rest -1: ")
	if( t == -1):
		break
	countdown(t)
	if t > 0:
		num_of_rest_time +=1
		rest_time +=t

print ("---------------------------------------------------------------")
print ("You did %d and got %d times rest:" % (num_of_pomidoros, num_of_rest_time) )
print ("You did %d h %d min work :" %(pom_time/60, pom_time%60))
print ("You got rest for %d h and %d min : " % (rest_time/60, rest_time%60))
print ("---------------------------------------------------------------")
