# G44_CV2021Challenge

## Starting the Graphical User Interface
To start the program, simply run the main.m file in MATLAB. The program requires the Computer Vision and Image Processing Toolbox to be installed.

## Graphical User Interface
The Graphical User Interface (GUI) allows the user to interact with the application with the aim of visualizing the change in multi-year satellite images of the same point on the earth. Here, the design of the application and the features presented are kept intuitive for all target audience and not only Computer Vision experts. Figure xx highlights this design. In the following, a detailed breakdown of the features and their use cases is presented:

## Dataset Selection:
Here the user will browse the data set folder that consists of a sequence of images  by pressing the “Select Dataset” button. The folder path chosen will be displayed on the “Current path” box. Once a dataset has been selected, the Load and Prepare Dataset button will turn green. Once the desired settings (see below) have been selected, push this button to prepare the images for visualization.

## Mode of change: 
The app will enable the user to switch between 4 different mode of changes in two tab groups:
                
1. Image quality: If the dataset to be analyzed is good quality (all the images are oriented almost the same way, exposure is very similar, no perspective skew etc.) use the 'Faster' option. If the default 'Faster' option does not provide satisfactory results, switching to 'Robust' adds an extra preprocessing step and uses a different, more robust algorithm at the expense of processing time. The names of the algorithms used are shown in parentheses so that the Computer Vision audience gets a better understanding of what’s happening behind the scenes.
                
2. Timespan: If you wish to examine short term changes (ones that will be apparent between 2 consecutive images, select the default option 'short term.' Then, you will be able to pic any of the dataset images and compare it with the image directly after it. If you wish to examine longer term, more gradual change, select long term. This will automatically select the first and last image in the dataset to compare.
3. Image Content: @sherif

## Visualization Type: 
Using this list box, the user will be able to choose one of three visualization modes and the application will update accordingly:
1. Timelapse: this is the default option. The idea behind this visualization mode is to parse the images of the selected location and perceive the slight change that keeps happening over a period of time. When this mode is selected, a parameters box under the output area will appear and it will be possible to end the time-lapse via “End Playback” button and to change the “FPS” (i.e Frame Per Second) of the output. Per default, the value of FPS is set to 1 frame per second.

2. Slider: @Moncef
                
3. Difference Image: this option will display the difference between the first and last image in the sequence to highlight the difference that occurred in the whole time period. Dark areas signify areas with high amounts of change between the images, while lighter areas signify less change. Furthermore, if the color has shifted over time, the shade of color change will also be displayed.

## Output Section:
After selecting a dataset the “Analyze” button will change its color from red to green. This gives the green light for the application to start by clicking this button. Besides, keep an eye on the “Progress bar” beneath the button which will guide the user throughout the whole experience of using the app.
Dialog box: As we all hate reading the documentation of a tool, a Welcome Dialog Box has been added to the app for the convenience of the user. This will pop up when the app opens and will provide a welcome message and instructions to how and where to proceed further. The users will have the choice of either closing this window or keeping it aside as they use the app.
