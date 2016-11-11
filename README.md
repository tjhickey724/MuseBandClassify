# MuseBandClassify

Code for classifying the MuseBand brainwave data (alpha,beta,gamma,delta,theta) from 4 electrodes

## Collecting data using the MuseBand

1. Pair the MuseBand with your computer
   * Turn Bluetooth on (possibly turn it off first to be safe)
   * Open Bluetooth Preferences window on your Mac
2. Turn MuseBand on (hold button until lights blink)
   * The MuseBand should appear on the Bluetooth preference window with a "pair" button, which you should press
3. Start up a terminal window and start reading the data from the MuseBand at 500Hz
by giving the command below to read the data from MB and broadcast it on port 5000 using the osc protocol 
   * `muse-io --osc-timestamp --preset AE`
5. Start up a terminal window and start recording the data and storing it in a file by giving the command
below which stores the data in the file "output.muse"
   * `muse-player -l 5000 -F output.muse`
6. When you are done recording go to the muse-io window and kill the job (^C) and likewise with the muse-player window

## Analyzing the data

1. In the muse-player window, convert the muse file to csv format by giving the command
   * `muse-player -f output.muse -C output.csv`
   * "output.muse" should be the name of your file (likewise with "output.csv")
2. Give the file a clear name and record the metadata in a spreadsheet where you also describe the conditions for generating that data
3. Convert the output.csv file into a matlab table with
   * `javac ProcessCSV.java; java ProcessCSV < output.csv > bands.txt`
4. Startup matlab and cd into this MuseBandClassify folder (which should contain the bands.txt you just created)
5. Give them matlab command which will produce a plot of the band data as well as a classification 
using some number of clusters in a kmeans analysis
   * `analysisDemo`
6. Adjust the k to see which value gives the best classification

   ![MuseBand Classification Data](/bands.jpg "MuseBand k-means Classifcation")
