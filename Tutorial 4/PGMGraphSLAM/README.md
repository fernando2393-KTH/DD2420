# PGMCourse
Probabilistic Graphical Models Project


## Description of datasets
### map files
Each line contains one landmark.

For each line:

| Index | Meaning        |
|:-----:|:---------------|
| 1     | The ID of the landmark |
| 2     | The x-position of the landmark |
| 3     | The y-position of the landmark |
    
### so files
Each line contains one time step.

For each line:

| Indices | Meaning        |
|:-------:|:---------------|
| 1       | Contains the current time |
| 2-4     | Contains odometry |
| 5-6     | Contains encoder |
| 7-9     | Contains the true pose |
| 10      | Says how many landmarks are in the remainder of the line |
| 11:3:end     | Contains the ID of the landmarks |
| 12:3:end     | Contains the bearings to the landmarks |
| 13:3:end     | Contains the ranges to the landmarks |
