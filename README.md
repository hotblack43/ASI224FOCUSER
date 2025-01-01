# ASI224FOCUSER

1) The ASI224 camera from ZWO can be focused by twisting the lens in its thread-mount. In case your camera is mounted in an unacessible place you may wish to be able to focus it remotely. This is my project to enable that.

2) In this project, the camera is connected by USB to an online Raspberry Pi (3B+ in my case) and by logging on to that Raspberry over the internet I can go to a terminal and there issue commands to take images as well as run a python code which I am distributing in this Github, which allows turning of the lens in its thread by use of a geared stepper-motor and a cog-wheel mounted around the lens.

3) The project files consist of OPENSCAD files (in .scad format so you can edit and make them better) and one python3 code which, when installed with the right libraries, as well as various enabling electronics, allows turning the lens left or right by so many steps. There is also a hardware list covering the camera and the lens, the dome, and various cables and electronics. And a photo showing the thing in its glory!


April 12 2020.

PS from January 2025: The systems survived well for several years on a roof in a city. The dome I used turned yellow from the Sunlight and needs to be exchanged. But there are ideas for what to do. The basic system - cogwheel and remote control and stepper motors never let me down, so I can recommend it as far as that goes.
