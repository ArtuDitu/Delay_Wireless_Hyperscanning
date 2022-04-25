from psychopy import visual
import psychopy
import time
import csv
import pandas as pd

list_of_timestamps = []

def waitForconfirm():
    pressed = False
    while not pressed:
        event = psychopy.event.getKeys(keyList = [ 'space', 'escape'])
        if event == ['space']:
            pressed = True
        if event == ['escape']:
            psychopy.core.quit()

def box():
    triggerBox.draw()
    list_of_timestamps.append(time.clock())
    SCREEN.flip()
    SCREEN.flip()
    time.sleep(0.965)


SCREEN = visual.Window(size  = (1920, 1080), fullscr = True, screen = 0)
startMessage = visual.TextStim(SCREEN, text = 'press spacebar to start')
startMessage.draw()
SCREEN.flip()
waitForconfirm()
triggerBox = visual.Rect(SCREEN, width = 0.5, height = 0.5, fillColor = 'white', pos = (0.7,-0.9))
start = time.clock()

while  time.clock() - start < 10:
    box()


endMessage = visual.TextStim(SCREEN, text = 'press spacebar to end')
endMessage.draw()
SCREEN.flip()
waitForconfirm()

df = pd.DataFrame(list_of_timestamps)

df.to_csv('results.csv')
