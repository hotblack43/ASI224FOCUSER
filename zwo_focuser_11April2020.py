## Usage (typical)
# sudo python zwo_focuser_11April2020.py left 500
#
## Focus motor software using a geared bipolar stepper motor
## Uses an FT232H to generate GPIO values as input for 
## a Polou A4988 that drives the motor and is fed 8 VDC.

# Wiring:
# Connect C0 on FT232H to DIR on A4988 - i.e. pin DIR
# Connect C1 on FT232H to STP on A4988 - i.e. pin STEP
# Connect C2 on FT232H to SLP on A4988 - i.e. pin SLP
# Connect C3 on FT232H to RST on A4988 - i.e. pin RST
# Connect C4 on FT232H to ENA on A4988 - i.e. pin ENABLE
# Import standard Python sys and time library.
import sys
import time

# Import GPIO and FT232H modules.
import Adafruit_GPIO as GPIO
import Adafruit_GPIO.FT232H as FT232H
print('Done importing libs ...')

# Read arguments https://www.youtube.com/watch?v=kQFKtI6gn9Y
#------------------------------------------------------------------------
print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: " , str(sys.argv))
#------------------------------------------------------------------------
#read the direction and number of steps; if steps are 0 exit
try:
    direction = sys.argv[1]
    steps = int(float(sys.argv[2]))
except:
    steps = 0

print("You told me to turn",steps," steps.", steps) 
print("In the direction : ",direction) 
#------------------------------------------------------------------------
#------------------------------------------------------------------------

# Temporarily disable the built-in FTDI serial driver on Mac & Linux platforms.
FT232H.use_FT232H()
# Create an FT232H object that grabs the first available FT232H device found.
ft232h = FT232H.FT232H()

# Configure digital outputs using the setup function.
# Note that pin numbers 0 to 15 map to pins D0 to D7 then C0 to C7 on the board.
ft232h.setup(8, GPIO.OUT) # Make pin C0 a digital output.
ft232h.setup(9, GPIO.OUT) # Make pin C1 a digital output.
ft232h.setup(10, GPIO.OUT) # Make pin C2 a digital output.
ft232h.setup(11, GPIO.OUT) # Make pin C3 a digital output.
ft232h.setup(12, GPIO.OUT) # Make pin C4 a digital output.

# Set pin C0 to a LOW level 
ft232h.output(8, GPIO.LOW)
# Set pin C1 to a LOW level 
ft232h.output(9, GPIO.LOW)

#------------------------------------------------------------------------
#------------------------------------------------------------------------
#set 8 to LOW for left and HIGH for right
if direction == 'left':
    ft232h.output(8, GPIO.LOW)
elif direction == 'right':
    ft232h.output(8, GPIO.HIGH)
#------------------------------------------------------------------------
#------------------------------------------------------------------------

# Turn ON the juice to motor
print("ENABLING device, now") 
# Set pin C4 to a LOW level thus ENABLING the device
ft232h.output(12, GPIO.LOW)

ft232h.output(10, GPIO.HIGH)
ft232h.output(11, GPIO.HIGH)

#------------------------------------------------------------------------
#------------------------------------------------------------------------
StepCounter = 0
WaitTime = 0.001    ## This value may be motor-specific. If set wrong 
                    ## motor whines or grumbles and may not follow DIR commands
# Start main loop
while StepCounter < steps:

    #turning the gpio on and off tells the easy driver to take one step
    ft232h.output(9, GPIO.HIGH)
    ft232h.output(9, GPIO.LOW)
    StepCounter += 1

    #Wait before taking the next step...this controls rotation speed
    time.sleep(WaitTime)
#------------------------------------------------------------------------
#------------------------------------------------------------------------


# Turn OFF the juice to motor

ft232h.output(10, GPIO.LOW)
ft232h.output(11, GPIO.LOW)
print("POWER TO MOTOR IS OFF, now") 
# Set pin C4 to a HIGH thus DISABLING the device
ft232h.output(12, GPIO.HIGH)
print("DEVICE DISABLED, now") 
