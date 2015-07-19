
#Reproducible Research - Peer Assessment 1

##Introduction

library(ggplot2)
library(scales)
library(Hmisc)
library(knitr)
library(lattice)
require(knitr)
require(markdown)

The aim of this assignment is to get practical experiences especially utilising R markdown to write a report. 
The single R markdown document will be rendered by knitr to an HTML output format file.

Fork/clone the GitHub repository created for this assignment. Submit this assignment by
pushing the completed files into the forked repository on GitHub. The assignment submission will
consist of the URL to the GitHub repository and the SHA1 commit ID for the repository state.

### Data

This project makes used of data from a personal activity monitoring device. 
The data was captured every 5 minutes through out the day by the device.

### Loading and preprocessing data

#####Set Working Directory
```r
setwd("D:/Assignment/05_Reproductive/Assignment1/")
getwd()

```
#####unzip downloaded file 
```r
if(!file.exists('activity.csv')){
    unzip('repdata_data_activity.zip')
}
activityData <- read.csv('activity.csv')
```
**The data consists of:**

##### 'data.frame': 17568 obs. of 3 variables:
##### $ steps : int NA NA NA NA NA NA NA NA NA NA ...
##### $ date : chr "2012-10-01" "2012-10-01" "2012-10-01" "2012-10-01" ...
##### $ interval: int 0 5 10 15 20 25 30 35 40 45 ...

#####reformat date to date data type

###What is mean total number of steps taken per day?

#####1. Calculate the total number of steps taken per day

```r
stepsByDay <- tapply(activityData$steps, activityData$date, sum, na.rm=TRUE)

```

#####2. Make a histogram of the total number of steps taken each day
```r
qplot(stepsByDay, xlab='Total steps per day', ylab='Frequency using binwith 500', binwidth=500)

```
#####3. Calculate and report the mean and median total number of steps taken per day
```r
stepsByDayMean <- mean(stepsByDay)
stepsByDayMedian <- median(stepsByDay)

Mean   : [1] 9354.23

Median : [1] 10395
```

###What is the average daily activity pattern?
```r
averageStepsPerTimeBlock <- aggregate(x=list(meanSteps=activityData$steps), by=list(interval=activityData$interval), FUN=mean, na.rm=TRUE)
```
####1. Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
ggplot(data=averageStepsPerTimeBlock, aes(x=interval, y=meanSteps)) +
    geom_line() +
    xlab("5-minute interval") +
    ylab("average number of steps taken") 
```
####2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```r
mostSteps <- which.max(averageStepsPerTimeBlock$meanSteps)
timeMostSteps <-  gsub("([0-9]{1,2})([0-9]{2})", "\\1:\\2", averageStepsPerTimeBlock[mostSteps,'interval'])

Most Steps at: [1] 8:35

```

####Imputing missing values

#####1. Calculate and report the total number of missing values in the dataset
```r
numMissingValues <- length(which(is.na(activityData$steps)))

Number of missing values: [1] 2304
```

#####2. Devise a strategy for filling in all of the missing values in the dataset.

#####3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
```r
activityDataImputed <- activityData
activityDataImputed$steps <- impute(activityData$steps, fun=mean)
```
#####4. Make a histogram of the total number of steps taken each day
```r
stepsByDayImputed <- tapply(activityDataImputed$steps, activityDataImputed$date, sum)
qplot(stepsByDayImputed, xlab='Total steps per day (Imputed)', ylab='Frequency using binwith 500', binwidth=500)
```
####Calculate and report the mean and median total number of steps taken per day.
```r
stepsByDayMeanImputed <- mean(stepsByDayImputed)
stepsByDayMedianImputed <- median(stepsByDayImputed)

Mean (Imputed): [1] 10766.19

Median (Imputed): [1] 10766.19
```

####Are there differences in activity patterns between weekdays and weekends?

#####1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
```r
activityDataImputed$dateType <-  ifelse(as.POSIXlt(activityDataImputed$date)$wday %in% c(0,6), 'weekend', 'weekday')
```
#####2. Make a panel plot containing a time series plot
```r
averagedActivityDataImputed <- aggregate(steps ~ interval + dateType, data=activityDataImputed, mean)
ggplot(averagedActivityDataImputed, aes(interval, steps)) + 
    geom_line() + 
    facet_grid(dateType ~ .) +
    xlab("5-minute interval") + 
    ylab("avarage number of steps")
```

#### Observations:
Are there differences in activity patterns between weekdays and weekends? Yes.
The plot indicated that the person carying activities mostly during the
weekend days.

#### Conclusion
The overall works provided details steps for analyzing data. The data analysis started from set up working directory,loading data, transform data, missing data, and reporting statistical data and plots.
