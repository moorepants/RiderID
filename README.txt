=====================================
Bicycle Rider Identification Software
=====================================

This is the accompanying software to derive the results found in the paper:

Rider control identification in bicycling using lateral force pertubation
tests. A.L. Schwab, P.D.L Lange, R.Happee, and Jason K. Moore. Multibody System
Dynamics, 2013

Software Requirements
=====================

- Matlab recommended version 2011a or higher
- Matlab Optimization toolbox
- Matlab Control System toolbox
- Matlab DSP System toolbox

Installation and Usage
======================

This source code can be obtained from Figshare
(http://dx.doi.org/10.6084/m9.figshare.659465) or Github
(https://github.com/moorepants/RiderID). Use one of the following three sets of
commands.

$ wget https://github.com/moorepants/RiderID/archive/master.zip
$ unzip master.zip
$ cd RiderID-master

or

$ git clone git://github.com/moorepants/RiderID.git
$ cd RiderID

or

$ mkdir RiderID
$ cd RiderID
$ wget http://files.figshare.com/1018052/rider_id_source.tar.gz
$ tar -zxf rider-id-source.tar.gz

The data can be obtained from Figshare
(http://dx.doi.org/10.6084/m9.figshare.659465). Decompress the data file while
in the source directory.

$ wget http://files.figshare.com/1017793/rider_id_measurements.tar.gz
$ tar -zxf rider-id-measurements.tar.gz

Now open Matlab, set the current working directory as the project folder, and
run the main program to generate the results for the controller identification:

$ matlab
>> main.m

To generate the optimal control results run:

>> optimalQRv2.m

which reads data from data/ResultsvKFromPeter19dec2012.txt and produces the
results in Tables.mat.

Data
====

Only a small subset of the collected data was used in this study. The entire
dataset which contains more runs with a variety of riders, manuevers, speeds
and environments is stored in an HDF5 formatted file can be obtained with the
following commands:

$ wget http://mae.ucdavis.edu/~biosport/InstrumentedBicycleData/InstrumentedBicycleData.h5.bz2

Uncompress the file and it is ready for use.:

$ bzip2 -d InstrumentedBicycleData.h5.bz2

The BicycleDataProcessor (https://github.com/moorepants/BicycleDataProcessor)
software can be used to export .mat files for use with the software herein.

License
=======

The software and data are licensed under CC-BY 3.0
(http://creativecommons.org/licenses/by/3.0/).
