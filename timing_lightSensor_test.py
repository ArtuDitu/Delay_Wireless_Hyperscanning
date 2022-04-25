# import packages and required functions
from psychopy import visual
import psychopy
import time
import csv
import pandas as pd

# create an empty list to store all timestamps of events (each almost every second)
list_of_timestamps = []

# function to wait for a press to start and end the experiment
def waitForconfirm():
    pressed = False
    while not pressed:
        event = psychopy.event.getKeys(keyList = [ 'space', 'escape'])
        if event == ['space']:
            pressed = True
        if event == ['escape']:
            psychopy.core.quit()
# function to display white rectangle on the screen
# light sensor detecs the white box and sends triggers to EEG systems (wireless)
def box():
    triggerBox.draw() # draw a box
    list_of_timestamps.append(time.clock()) # append the time since start to a list
    SCREEN.flip() # flip a screen to show the box
    SCREEN.flip() # flip a screen to background
    time.sleep(0.965) # wait time


SCREEN = visual.Window(size  = (1920, 1080), fullscr = True, screen = 0) # initizalize the screen
startMessage = visual.TextStim(SCREEN, text = 'press spacebar to start') # create start message
startMessage.draw() # draw start message
SCREEN.flip() # flip the screen to show start message
waitForconfirm() # wait for key press to continue
triggerBox = visual.Rect(SCREEN, width = 0.5, height = 0.5, fillColor = 'white', pos = (0.7,-0.9)) # create a wite box
start = time.clock() # initialize counter

# main while loop to display white box every second (approximately) for certain time (time specified in seconds)
while  time.clock() - start < 10:
    box()


endMessage = visual.TextStim(SCREEN, text = 'press spacebar to end') # create end message
endMessage.draw() #draw end message
SCREEN.flip() # flip the screen to show end message
waitForconfirm() # wait for key press to end

df = pd.DataFrame(list_of_timestamps) # create data frame with all timestamps

df.to_csv('results.csv') # save data frame as csv - it contains time from the start for each event
