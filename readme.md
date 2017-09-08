# GUI Tutorial

### Prerequisites

- Matlab installation
http://it.wvu.edu/files/d/293391de-df69-4324-a9fa-f74f3ecf6030/matlab-student-installation-instructions-1.pdf

## GUI Installation
```
1- Download the file gui_Ubuntu_Win.zip
```
```
2- Unzip by extracting to gui_Ubuntu_Win\ folder
```
```
3- Make sure that gui_Ubuntu_Win folder includes poses and stages folders, flowerIdentifierGUI.fig and flowerIdentifierGUI.m files
```

## Getting Started
#### Configure your MATLAB saving configuration as below before processing; (You can still do it if you already start, but it should be done before saving your database - e.g. Step 16 - Finish Folder)

```
MATLAB -> Preferences -> General -> MAT-Files - > check MATLAB Version 7.3 or later (save -7.3)
```

## How to use the GUI

1- Open gui_Ubuntu_Win folder and open flowerIdentifierGUI.m file - it will start the Matlab also. Alternatively, you may open MATLAB and navigate your workspace to gui_Ubuntu_Win folder and write flowerIdentifierGUI and press enter.

2- Run the file (click green arrow or press F5)

3- Click Step:1 Select Folder - and select a folder that contains flower images to process.

4- Click the first image name (e.g 0U5A8440.jpg) at the area below 'Step1:Select Folder' (Do not click Select Folder again.)

5- Click Step:2 Draw Free, you will notice that arrow shaped mouse pointer will change to a cross.

6- Trace a flower or cluster.

7- After you see the drawn figure in the area below Step:3 Select Type, simply click one of the buttons to select a type of flower, single or cluster (if it is one flower, it is single).

8- If it is a cluster, count how many flowers you see and write when asked.

9- Click Next button at the Step:4 Select Stage Section. Select the flower stage (or bud/fruit) by navigating back and next buttons.

10- Click Next button at the Step:5 Select Pose Section. Select the pose by using the buttons.

11- Click Step:6 Save Database. You will notice blue selection line becomes red. It means you successfully saved the drawing.

12- Back to Step:2 Draw Free and draw for another flower or cluster.

13- Repeat steps from 6 to 12.

14- When you finish all drawings in the current image, select the second image (e.g 0U5A8680.jpg) at the area below 'Step1:Select Folder' (Do not click Select Folder again.)

15- Repeat Steps 5-12 for this image.

16- When you are done (processed all the images) click FINISH FOLDER. It saves the drawings in a .mat file up to this point.

17- It is important to click FINISH FOLDER, otherwise you don't save the database in a proper mat file.

18- The GUI is tested on Linux and Windows, however, if you encounter any fatal error, try Reset button. (warning: It resets the database and you will lose all your data.)

Important notes
- Blue line means that you haven't saved the drawn flower. If it is not a red line you can re-draw it again. Blue=Unsaved, Red=Saved
- Cluster means more than 1 flowers. So do not write 1 flower for the cluster option.
- You should select a stage for the cluster and single.
- There is no need to select a pose for Cluster type - it will be NaN. However you should select a pose for the Single type
- It is better to select images from the top to the bottom.
- When you click Draw Free button - it will reset the axes
- You can Zoom-in, Zoom-out and Pan the image by using shortcuts at the upper left(to you) of the GUI.
- You can Reset to Original View by - Right click to image and Select 'Reset to Original View'

Feel free to ask questions - cakilic@mix.wvu.edu
