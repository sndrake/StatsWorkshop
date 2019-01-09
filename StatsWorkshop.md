# Two-Way ANOVA and Multiple Regression in R

#### Essa Batel, University of Arizona: <essabatel@email.arizona.edu>
#### [Shiloh Drake][], University of Arizona: <sndrake@email.arizona.edu>
[Shiloh Drake]: http://www.shilohdrake.com

---

## Table of Contents
1. Getting the environment set up
2. Loading the data and descriptive statistics
3. Two-way ANOVA
	* Assumptions of ANOVA
	* Between-subjects analysis
	* Post-hoc comparisons
4. Multiple Linear Regression
	* Assumptions of multiple regression
	* Between-subjects analysis
	* Post-hoc comparisons
	* Graphing your results

---

## Getting the environment set up

~~~R
rm(list = ls(all = TRUE))
~~~

This command clears everything that you had in the environment, from variables you had saved to datasets you had saved. It's useful if you want to start fresh!

Next, you'll need to make sure your **working directory** is set correctly. This is the place where your data files are stored so that you can read them into R, and is also where your R scripts, graphs, and anything else you generate will be saved for this project.

To get your working directory, right click on your CSV file (ctrl-click or two-finger click on Mac) and select "Get Info" (Mac) or "Properties" (Windows). From the opened window, copy the "where" information, then paste it between quotes in the `setwd("")` command.

~~~R
# find out what your working directory is right now
getwd()

# change your working directory to the right place
setwd("/Users/Shiloh/Desktop/Experiment Data/")
~~~

You can also use the shortened version with a tilda: "~Desktop/Experiment Data/".

If you're on a PC, it might look something more like this:

~~~R
# if you're on a PC
setwd("C:\Users\Shiloh\Desktop\Experiment Data\")
~~~

## Let's Get Going!
### Loading the data and descriptive analyses

Now that we're in the right place, let's **read in the data file**—which should be in your directory already—and **save it in the variable "mydata"**. After that, let's run a few commands to make sure everything imported correctly and looks the way we expected it to.

~~~R
# read in the CSV that contains your data.
# the 'header' argument should be TRUE if the first row of your CSV file names the columns.
# otherwise, it defaults to FALSE.

mydata <- read.csv("Exam_Scores.csv", header = TRUE, sep = ",")

# make sure R treats the way you name associate subject data as a factor!
mydata$Participants <- as.factor(mydata$Participants)

# look at the structure of the data
str(mydata)

# get a summary of the data
summary(mydata)

# look at the first five rows of data
head(mydata)

# look at the last five rows
tail(mydata)
~~~

Let's also run a basic analysis of our data. We'll be using the `psych` package to do that. If you have never used this package before, you'll need to install it:

~~~R
install.packages("psych")
~~~

Then we need to **load the package**. You can either go to the "Packages" tab on the right-hand side of the RStudio window and click the checkbox next to `psych`, or you can run one of the following commands:

~~~R
library(psych)

# OR

require(psych)
~~~

All of these methods accomplish the same thing, so you can do whatever you find is the most intuitive. If you have a lot of packages installed, you might find it easiest to use the `library` or `require` commands rather than the checkbox.

Use `describe` to see some descriptive statistics (mean, median, standard deviation, standard error, etc.) about your data.

~~~R
describe(mydata)

# OR you can describe individual variables:

describeBy(mydata$Score, mydata$Proficiency)
describeBy(mydata$Score, mydata$Skill)

~~~

### Variable Types

The key to doing any type of statistical analysis is to make sure you have the correct **independent and dependent variables**. You may have multiple independent variables, as we do in this dataset, or you may just have one independent variable. The independent variable is what you manipulate as the researcher.

The dependent variable "depends on" the independent variable, and it may change as the independent variable changes. For example, if you notice that you can spend less time focusing as you get less sleep, but you're able to focus for longer periods of time when you get more sleep, you have one dependent variable and one independent variable. Your ability to focus depends on how much sleep you were able to get; thus, it is the dependent variable.

In this dataset, we have two independent variables and one dependent variable.

| Type | Factor | Levels |
| :---: | :---: | :---: |
| Independent | Skill | Listening, Reading |
| Independent | Proficiency | Intermediate, Advanced |
| Dependent | Score | continuous variable |

It should make intuitive sense that a person's score on a language exam will change based on whether they are at an intermediate or an advanced level, and also that the score will change depending on the skill they are being tested on. 

## Two-Way Analysis with ANOVA
### Assuptions

First and foremost, you can use a two-way ANOVA if and only if you have exactly two independent factors (or variables). If you only have one independent variable, you must instead use a one-way ANOVA.

ANOVAs have two main assumptions. If your data does not follow these assumptions, this is not the test you should be using either; instead, you will need to use a [WORD] test.

1. **Normality:** Your data is normally distributed: you should see a bellcurve or, if your data is linear, the points should not be far off a predictor line.
2. **Homogeneity of variance:** Each group in your sample should show equal amounts of variance. This means that if you have one group with huge differences and another group with smaller differences, you should not use an ANOVA.

ANOVAs also assume that your factors are **orthagonal** to each other; that is, multiple factors are not related to one another. We typically don't need to worry about that very much in our field, but if you were to include factors like "Participant Age" and "Number of Days Since Birth", those factors would be strongly correlated to each other and would affect your model's accuracy.

### How to code it

The basic code for an ANOVA is

~~~R
model.name <- aov(dependent.factor ~ 
					independent.1 * independent.2, 
					data = csv.file)

summary(model.name)
~~~

##### A note about the symbology

The tilda (~) can be read as "as a factor of" or "depends on" (e.g., "Score on the exam depends on number of hours of sleep" for code reading something like `aov(score ~ amt.sleep)`

The asterisk (*) between the independent factors is the **interaction term**. This is used when you think your two factors might interact with each other—for example, you might think that a beginning language student would score lower on the listening task than on the reading task, while an advanced student might have more balanced skills. If you don't expect to have an interaction, or if your interaction is not significant, run another model with a plus sign (+) instead to tell the model not to test for an interaction.

Storing the model in a variable allows you to perform other tests and manipulations on the model itself, such as graphing residuals, testing residuals for normality, or comparing two models to each other. 

### Your turn!

For our ANOVA, try creating a model named ANOVA_2, using the factor names from our sample dataset that you loaded in earlier, and the name of the data file.

---
