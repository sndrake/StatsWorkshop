# Two-Way ANOVA and Multiple Regression in R

#### Essa Batel, University of Arizona: <essabatel@email.arizona.edu>
#### [Shiloh Drake][], University of Arizona: <sndrake@email.arizona.edu>
[Shiloh Drake]: http://www.shilohdrake.com

---

##Getting the environment set up


~~~R
rm(list = ls(all = TRUE))
~~~

This command clears everything that you had in the environment, from variables you had saved to datasets you had saved. It's useful if you want to start fresh!

Next, you'll need to make sure your working directory is set correctly. This is the place where your data files are stored so that you can read them into R, and is also where your R scripts, graphs, and anything else you generate will be saved for this project.

~~~R
getwd()

setwd("/Users/Shiloh/Desktop/Experiment Data/")
~~~

You can also use the shortened version with a tilda: "~Desktop/Experiment Data/".

If you're on a PC, it might look something more like this:

~~~R
setwd("C:\Users\Shiloh\Desktop\Experiment Data\")
~~~

##Let's Get Going!

Now that we're in the right place, let's read in the data file—which should be in your directory already—and save it in the variable "mydata". After that, let's run a few commands to make sure everything imported correctly and looks the way we expected it to.

~~~R
mydata <- read.csv("Exam_Scores.csv", header = TRUE, sep = ",")
mydata$Participants <- as.factor(mydata$Participants)
str(mydata)
summary(mydata)
head(mydata)
tail(mydata)
~~~

