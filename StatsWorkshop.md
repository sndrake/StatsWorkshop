# Two-Way ANOVA and Multiple Regression with R

## Table of Contents
1. Getting the environment set up
2. Loading the data and descriptive statistics
3. Multiple Linear Regression
	* Between-subjects analysis
	* Post-hoc comparisons
	* Graphing your results
4. Two-way ANOVA
	* Assumptions of ANOVA
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

For this workshop, we're going to be using a few specific packages. If you don't have them installed already, go ahead and run the following codes:

~~~R
install.packages("ggplot")
install.packages("psych")
install.packages("lsmeans")
install.packages("car")
install.packages("lmSupport")
~~~

## Let's Get Going!
### Loading the data and descriptive analyses

Now that we're in the right place, let's **read in the data file**—which should be in your directory already—and **save it in the variable "mydata"**. After that, let's run a few commands to make sure everything imported correctly and looks the way we expected it to.

~~~R
# read in the CSV that contains your data.
# the 'header' argument should be TRUE if the first row of your CSV file names the columns.
# otherwise, it defaults to FALSE.

mydata <- read.csv("Sample_R.csv", header = TRUE, sep = ",")

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

Let's also run a basic analysis of our data. We'll be using the `psych` package to do that. To use it, we need to **load the package**. You can either go to the "Packages" tab on the right-hand side of the RStudio window and click the checkbox next to `psych`, or you can run one of the following commands:

~~~R
library(psych)

# OR

require(psych)
~~~

Now would also be a good time to load the other packages using the `library()` or `require()` commands.

All of these methods accomplish the same thing, so you can do whatever you find is the most intuitive. If you have a lot of packages installed, you might find it easiest to use the `library` or `require` commands rather than the checkbox.

Use `describe` to see some descriptive statistics (mean, median, standard deviation, standard error, etc.) about your data.

~~~R
describe(mydata)

# OR you can describe individual variables:

describeBy(mydata$Score, mydata$Proficiency)
describeBy(mydata$Score, mydata$Intervention)

~~~

### Variable Types

The key to doing any type of statistical analysis is to make sure you have the correct **independent and dependent variables**. You may have multiple independent variables, as we do in this dataset, or you may just have one independent variable. The independent variable is what you manipulate as the researcher.

The dependent variable "depends on" the independent variable, and it may change as the independent variable changes. For example, if you notice that you can spend less time focusing as you get less sleep, but you're able to focus for longer periods of time when you get more sleep, you have one dependent variable and one independent variable. Your ability to focus depends on how much sleep you were able to get; thus, it is the dependent variable.

In this dataset, we have two independent variables and one dependent variable.

| Type | Factor | Levels |
| :---: | :---: | :---: |
| Independent | Intervention | Before, After |
| Independent | Proficiency | Intermediate, Advanced |
| Dependent | Score | continuous variable |

It should make intuitive sense that a person's score on a language exam will change based on whether they are at an intermediate or an advanced level, and also that the score will change depending on the when they receive the intervention. 

## Multiple Linear Regression

### Assuptions

First and foremost, you can use a two-way ANOVA if and only if you have exactly two independent factors (or variables). If you only have one independent variable, you must instead use a one-way ANOVA.

ANOVAs and linear regressions have two main assumptions. If your data does not follow these assumptions, this is not the test you should be using either; instead, you will need to use a non-parametric test.

1. **Normality:** Your data is normally distributed: you should see a bellcurve or, if your data is linear, the points should not be far off a predictor line.
2. **Homogeneity of variance:** Each group in your sample should show equal amounts of variance. This means that if you have one group with huge differences and another group with smaller differences, you should not use an ANOVA.

ANOVAs also assume that your factors are **orthogonal** to each other; that is, multiple factors are not related to one another. We typically don't need to worry about that very much in our field, but if you were to include factors like "Participant Age" and "Number of Days Since Birth", those factors would be strongly correlated with each other and would affect your model's accuracy.

It's also important to note that both of these statistical models expect that your data is linear, and not shaped like a quadratic curve or anything like that. You can check this by plotting the data, which is below.

---

For the multiple linear regression, we're going to do a between-subjects analysis. The basic code for a linear regression is:

~~~R
model name <- lm (dependent.factor ~ 
					independent.1 * independent.2,
					data = csv.file)
~~~

##### A note about the symbology

The tilda (~) can be read as "as a function of" or "depends on" (e.g., "Score on the exam is a function of the number of hours of sleep" for code reading something like `lm(score ~ amt.sleep)`.

The asterisk (*) between the independent factors is the **interaction term**. This is used when you think your two factors might interact with each other—for example, you might think that a beginning language student would score lower on a listening task than on the reading task, while an advanced student might have more balanced skills. If you don't expect to have an interaction, or if your interaction is not significant, run another model with a plus sign (+) instead to tell the model not to test for an interaction.

Storing the model in a variable allows you to perform other tests and manipulations on the model itself, such as graphing residuals, testing residuals for normality, or comparing two models to each other. It also means that you don't have a lot of stuff taking up your R console, which may or may not be important to you.

---

### Your Turn!
Let's call our model "Reg_model". How would you code it using the sample above? (Don't scroll down yet!)

---

You should have something like this for the code:

~~~R
Reg_model<- lm (Score ~ Proficiency * Intervention, data=Mydata)    
summary(Reg_model)
~~~

Take a look at the summary of the model. You should be able to see all of the factors, the interactions, whether anything is significant, and so on. Check for these things in your summary to interpret your model:

* Adjusted R-squared: the amount of variance explained by the variable. In this case, 67.33% of the variance in the Score variable is explained by when the intervention occurred. Because this is such a high percentage, you can interpret this as an important factor in your research!
* Intercept: the baseline of the model, which the numbers in the "Estimate" column are added to or subtracted from. The mean score that Advanced participants with the interventioning happening After received was 86.13.
* ProficiencyIntermediate: the Intermediate/After group is expected to decrease the mean of Score by 11.26 points (or being at the Advanced level is expected to increase the mean of Score by 11.26 points), and that is statistically significant.
* The Score is expected to increase by 7 points after the intervention (since InterventionBefore = -7), and that is statistically significant.
* The mean Score is expected to increase by 6 points as a result of the interaction between Intervention and Proficiency level, and that is also statistically significant.

You can get a nice table of score means for each level by using the `aggregate()` function. Doing this will give you concrete numbers for the model estimates if you don't want to do math. :)

~~~R
aggregate(Score ~ Proficiency * Intervention, data = mydata, mean)
~~~

### Post-hoc tests
The p value of the interaction tells us that there is a significant difference somewhere between the levels of our variables, but we don't know which level is significantly different from the other. Therefore, we have to perform a post-hoc comparison test.

You can choose which comparison to test based on your research question. Checking every possible combination for a significant p value is frowned upon and can potentially lead to a Type I error (incorrectly rejecting the null hypothesis). 

To compare the levels of Proficiency to each level of Intervention:  
`lsmeans(Reg_model, pairwise ~ Proficiency | Intervention, adjust="bon")`

To compare the levels of Intervention to each level of Proficiency:  
`lsmeans(Reg_model, pairwise ~ Intervention | Proficiency, adjust="bon")`

To check all possible comparisons:  
`lsmeans(Reg_model, pairwise ~ Intervention | Proficiency, adjust="bon")`

The argument `adjust = "bon"` tells the model what kind of alpha criterion adjustment it needs to do. Alpha is (essentially) the same level to which the p value is set; since we're making a lot of comparisons, we need to adjust alpha to avoid a Type I error. This command is for a Bonferroni correction.

You can also use a Tukey test (also called *Tukey's test*, *Tukey's Honest Standard Difference*, and several other variations) to compare every level of one factor to every level of the other. To conceptualize this, a Tukey test is a t-test that corrects for all of the comparisons you're making—essentially the third possibility for the `lsmeans()` command above.
  
`TukeyHSD(Reg_model)`


### Testing Assumptions

##### Assumption 1: Normality = The residuals are (relatively) normally distributed along a bell curve.

First, we can plot the residuals themselves:

`hist(residuals(Reg_Model))`

We're hoping for a normal histogram curve roughly in the shape of a bell.

We can also use the Shapiro-Wilk test for normality using this code:

`shapiro.test(residuals(Reg_Model))`

This is where we do NOT want a significant result—the null hypothesis of the Shapiro-Wilk test is that the residuals are normally distributed.

Finally, we can plot the actual values that were observed against values that are predicted by a model using a or QQ (quantile-quantile) plot. We're looking for the observed values to fall relatively close to the line of predicted values.

`plot(Reg_Model,2)`


##### Assumption 2: Homogeneity of Variance = The variance of the residuals is relatively even.

To test this, we're going to use the `car` package to do the Levene's test. Note that you can only do this test for the between-subject variable(s)—in this dataset, that's proficiency.

~~~R
leveneTest(residuals(Reg_Model) ~ Proficiency, data = Mydata) 
~~~

This is another case where ideally, the test comes out non-significant. If Levene's Test is significant, that means the variance in the residuals is NOT relatively uniform.


##### Outliers

We can also visually inspect our data for outliers. It's normal to have a couple outliers, or data points that fall outside the bulk of your data, but it's a problem if you have more than a few.

~~~R
boxplot(residuals(Reg_Model)) # no/few outliers ==> GOOD
~~~

**Your turn:** Perform at least one of the tests of the assumptions on your data. What do you see?

A lot of the time, you'll also want to have a visual representation of your results. In this case, we will use a line graph to show how scores improve as a function of proficiency and intervention.

~~~R
# For a line graph
require(lsmeans)
lsmip(Reg_model, Proficiency ~ Intervension, main="Multiple Regression",
		ylab="Score", xlab="Effect of Intervension", 
		col = c("blue","red"),
		par.settings = list(fontsize = list(text = 16, points = 10)))
~~~

---

You might also need to report how much of the variance each variable explains. To do that, you can run the code below.

~~~R
# Strength of correlation of each predictor separately
require(lmSupport)
modelEffectSizes(Reg_model) # Look at dR-sqr column 
~~~

The effect of Proficiency is 0.466: 46.6% of the variance in the Score is explained by Proficiency. 

The effect of Intervention is 0.183: 18.3 % of the variance in the Score is explained by Intervention. 

The effect of the Proficiency-Intervention interaction is 0.066: 6.6% of the variance in the Score is explained by the interaction between  Proficiency & Intervention.

Notice that the percentages don't sum to 100%. 28.5% of the variance isn't explained by any of the factors. This is fairly ordinary—it would be incredible to explain all of the variation in your data! However, in the fuzzy world of social sciences, a model that explains 71.5% of the variance in scores is still very rare to see.


## Two-Way Analysis with ANOVA
### How to code it

The basic code for an ANOVA is

~~~R
require(car)
model.name <- lm(dependent.factor ~ 
	independent.1 * independent.2,
	data = csv.file)

Anova(model.name)
~~~


### Your turn!

For our ANOVA, try creating a model named Model_ANOVA, using the factor names from our sample dataset that you loaded in earlier, and the name of the data file. Once you have that, run the `Anova()` command too. What do you see?

**Don't scroll past here yet!**

---

You should have something that looks like this for the model:

~~~R
Model_ANOVA <- lm(Score ~ Proficiency * Intervention, data = mydata)

Anova(Model_ANOVA)
~~~

You might have also not used the interaction term, so it looks something like this:

~~~R
ANOVA_3 <- lm(Score ~ Proficiency + Intervention, data = mydata)

Anova(ANOVA_3)
~~~

For now, let's use the function that uses the interaction term (Model_ANOVA).

You should see that there is a significant interaction between Intervention and Proficiency, and there are also significant differences between the two levels of Intervention (before/after) and Proficiency (intermediate/advanced).

Let's also look at the mean scores for each level that we're interested in. To do that, use the command `model.tables(Model_ANOVA,"means")`. The first argument in parentheses is the model you want to look at, and the second argument is the descriptive statistic that you want to see.

Hypothetically, let's say you wanted to present this data for a conference, write it up, or maybe show it to your lab members. Humans are visual creatures, so let's put these results in a graph.

~~~R
# for a bar graph, looking at scores as a function of proficiency
boxplot(Score ~ Proficiency, data = mydata)

# same thing, looking at scores as a function of Intervention
boxplot(Score ~ Intervention, data = mydata)

# or you can see all of the factors in one graph
boxplot(Score ~ Intervention * Proficiency, data = mydata)
~~~

If a line graph is more your speed, we can do that too using the package `lsmeans`.

~~~R
install.packages(lsmeans)
require(lsmeans)
lsmip(Model_ANOVA, Proficiency ~ Intervention, main="2-Way ANOVA",
	ylab="Score", xlab="Language Intervention",
	col = c("blue","red"), 
	par.settings = list(fontsize = list(text = 16, points = 10)))
~~~

**Your turn:** Describe what your graph looks like!

---

### Post-hoc tests
Just like in the multiple regression, we have to perform post-hoc tests due to our significant interaction between Intervention and Proficiency. We can use the `lsmeans()` function just like we did before, but substituting the name of our regression model.

~~~R
# Levels of Proficiency on each level of Intervention
lsmeans(Model_ANOVA, pairwise ~ Proficiency | Intervention, adjust="tukey") 

# Levels of Intervention on each level of Proficiency
lsmeans(Model_ANOVA, pairwise ~ Intervention | Proficiency, adjust="tukey") 

# All possible comparsions 
lsmeans(Model_ANOVA, pairwise ~ Intervention * Proficiency, adjust="tukey")
~~~



---

#### Assumptions

ANOVA has the same assumptions that linear regression does. Fortunately, we can still use the same functions as before.

~~~R
# Assumption 1: Normality
hist(residuals(Model_ANOVA)) # We're hoping for a normal bell curve

shapiro.test(residuals(Model_ANOVA)) # If NOT significant ==> GOOD

# QQ-plot 
plot(Model_ANOVA,2)  


# Assumption 2: Homogeneity of Variance
require(car)
leveneTest(residuals(Model_ANOVA) ~ Proficiency, data= Mydata)
# only for the bewteen-subjects variable (here, Proficiency).
# If NOT significant ==> GOOD

# Outliers
boxplot(residuals(Model_ANOVA)) # no/few outliers ==> GOOD
~~~
