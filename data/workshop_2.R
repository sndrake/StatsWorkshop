
# Install the following packages by highlighting the following codes and click Run:
# install.packages("psych")
# install.packages("lsmeans")
# install.packages("car")
# install.packages("lmSupport")


# set the working directory (this is where your data files are stored):

# 1. Right click on your data file (i.e.,the .csv file)
# 2. Choose  "get info" from the drop-down list
# 3. From the popped up box, go to "General" and from "Where:" copy the title after the colon (Where: ~ ~ ~)
# 4. Paste this title between the quotation marks "" in the code below 


setwd("/Users/essa/Dropbox/U of A/Talks and conferences/SLAT Workshop R/SLAT Roundtable 19/2-way Anova + Multiple Regression") 
# click Run  ++++++++++++++


# Uplaod the data file
Mydata<-read.csv("Sample_R.csv", header= T, sep =",")


# Check the data file
summary(Mydata) # basic summary of the data  
str(Mydata)   # ++++++++++++++
Mydata$Participants= as.factor(Mydata$Participants)

# install.packages("psych")
# you only need to install packages once (and maybe run updates every so often), so you can delete
# or comment out this line once you have psych installed

require(psych)      # this is equivalent to library(psych)
describe(Mydata) #  ++++++++++++++

# Your turn: How would you use describe with Score only?



# ----------------------------------------------------------------------------------------------------------------------
# Independent variables:
    # 1. Intervention (Before + After) => Within-Subject factor => Every participant is doing both tests.
    # 2. Proficiency (Intermediate + Advanced) => Between-Subject factor => A participant can be only in one level.

# Dependent variable:
    # Score
# -----------------------------------------------------------------------------------------------------------------------




          # ---------------------------------------------------------------------------
                          # Two-Way Mixed ANOVA (only TWO variables/factors) 
                                 # Between-Subject Analysis
          # ---------------------------------------------------------------------------


# model name <- lm (Dept. ~ Indep.1 * Indep.2 , data frame = data file name)
# let's call our model Model_ANOVA.

                            # Two-Way Mixed ANOVA model    ++++++++++++++
Model_ANOVA <- lm (Score ~ Proficiency * Intervention , data=Mydata) # use the * sign between the two factors 
# to indicate the interaction term. Use + sign instead if you do not want the interaction.

require(car)
Anova(Model_ANOVA) # the results
# options(scipen = 999)  to get rid of the scientific notion

                                 #  p > 0.05*  |   p > 0.01**   |    p > 0.001***




# 1. The is a statistically significant difference of the mean Score between Intermediate and Advanced levels 
#  (look at the mean of Intermediate and the mean of Advanced to see which has higher score than the other).
aggregate(Score ~ Proficiency, data=Mydata, mean)  # the means of proficiency

# 2. The is a statistically significant difference of the mean Score between Before and After the Intervention 
# (look at the mean of Before and the Mean of After to see which has higher score than the other).
aggregate(Score ~ Intervention, data=Mydata, mean) # the means of Intervention

# 3. There is a statistically significant interaction between Proficiency and Intervention.


# You can also see this using a line graph. If you can use a straight edge to continue the lines and they intersect,
# you have an interaction.

# install.packages("lsmeans")
require(lsmeans)
lsmip(Model_ANOVA, Proficiency ~ Intervention, main="2-Way Mixed ANOVA", ylab="Score",xlab="Effect of Intervention", 
      col = c("blue","red"), par.settings = list(fontsize = list(text = 16, points = 10)))


# The significant p-value of the interaction tells us that there is a significant difference 
# somewhere between the levels of our variables, but we do not know which level is (or is not) 
# statistically different from another.
# To find this out, we perform a multiple post-hoc comparisons test. 


                                  #  Post-hoc comparisons

# we will use "lsmeans" fucntion 
# require(lsmeans)
# you can choose which comparsion you want more based on your research question:

# Levels of Skill on each Proficiency
lsmeans(Model_ANOVA, pairwise ~ Intervention | Proficiency, adjust="tukey") 

# Levels of Proficiency on each Skill
lsmeans(Model_ANOVA, pairwise ~ Proficiency | Intervention, adjust="tukey") 

# All possible comparsions (Just in case you need that!)
# lsmeans(Model_ANOVA, pairwise ~ Intervention * Proficiency, adjust="tukey") 


                                      # Assumptions test

# Assumption 1: Normality = The residuals are (relatively) normally distributed along a bell curve.
hist(residuals(Model_ANOVA))    # We hope for a normal bell-shaped curve.
shapiro.test(residuals(Model_ANOVA)) # Shapiro-Wilke normality test. If NOT significant ==> GOOD

# QQ-plot: Normal distribution (the line of the observed values against the line of the predicted values) 
plot(Model_ANOVA,2) 


# Assumption 2: Homogeneity of Variance = The variance of the residuals is relatively even.
# install.packages("car")
# require(car)
leveneTest(residuals(Model_ANOVA) ~ Proficiency, data= Mydata) # ONLY for the between-subject variable(s)
# (Proficiency in this dataset). If NOT significant ==> GOOD


#  Outliers
boxplot(residuals(Model_ANOVA)) # no/few outliers ==> GOOD





         # ----------------------------------------------------------------------------------
                    # Multiple Linear Regression (More than ONE variables/factors)
                                 # Between-Subject Analysis
         # ----------------------------------------------------------------------------------

                    # To make things easier, we will use the same dataset 


                             
# model name <- lm (Dept. ~ Indep.1 * Indep.2 , data frame = data file name)
# let's call our model Reg_model.



                            # Multiple Regression model
Reg_model<- lm (Score ~ Proficiency * Intervention, data=Mydata)    
summary(Reg_model) # Expected changes in Score relative to the reference groups == Advanced + After

                           #  p > 0.05*  |   p > 0.01**   |    p > 0.001***


#  Adjusted R-squared: 0.6733 ==> 67.3 % the variance in the predicted Score is explained 
# by the effect of both Intervention and Proficiency above and beyond all other factors.
# (which is a high percentage)

levels(Mydata$Proficiency) 
levels(Mydata$Intervention) 
#  Intercept = Adavnced/After 

# 1. The mean score of our baseline (Advanced/After) is 86.13 (look at the intercept value) 
# above and beyond all other predictors. 


# 2. The difference between the mean score of Intermediate/After and Advanced/After = 11.26 points apart), 
# and that is statistically significant.(Intermediate/After = 86.13 - 11.27= 74.86667)

# 2. The difference between the mean of Advanced/Before and Advanced/After = 7.06 points apart), 
# and that is statistically significant.(Advanced/Before  = 86.13 - 7.06= 79.06)

# 2. The difference between the mean of Intermediate/Before and Advanced/After = 86.1333 -11.26 -7.0667 + 6.00 = 73.80) 
# and that is statistically significant.(Intermediate/Before  = 73.80)

# 5. Because of the significant interaction, we will perform a post-hoc multiple comparsion:

# we will use "lsmeans" fucntion 
require(lsmeans)
# you can choose which comparsion you want more based on your research question:

# Levels of Skill on each Proficiency
lsmeans(Reg_model, pairwise ~ Intervention | Proficiency, adjust="tukey") 

# Levels of Proficiency on each Skill
lsmeans(Reg_model, pairwise ~ Proficiency | Intervention, adjust="tukey") 

# All possible comparsions (Just in case you need that!)
# lsmeans(Reg_model, pairwise ~ Intervention * Proficiency, adjust="tukey") 


             
                                           # Tests of assumptions

# Assumption 1: Normality
hist(residuals(Reg_model)) # We hope for a normal histogram curve (Bell shape)
shapiro.test(residuals(Reg_model)) # If NOT significant ==> GOOD

# QQ-plot 
plot(Reg_model,2)  


# Assumption 2: Homogeneity of Variance
# require(car)
leveneTest(residuals(Reg_model) ~ Proficiency, data= Mydata) # only for the bewteen-subjects variable.
# If NOT significant ==> GOOD

# Outliers
boxplot(residuals(Reg_model)) # no/few outliers ==> GOOD



# For a line graph
require(lsmeans)
lsmip(Reg_model, Proficiency ~ Intervention, main="Multiple Regression", ylab="Score",xlab="Effect of Intervention", 
      col = c("blue","red"), par.settings = list(fontsize = list(text = 16, points = 10)))



# Effect size of each predictor separately
# install.packages("lmSupport")
require(lmSupport)
modelEffectSizes(Reg_model) # Look at dR-sqr column 

# The effect of proficiency is 0.466, meaning that 46.6% of the variance in the Score is explained 
# by Proficiency. 

# The effect of Intervention is 0.183, meaning that 18.3% of the variance in the Score is explained 
# by Intervention. 

# The effect of the Proficiency-Intervention interaction is 0.066, meaning that 6.6% of the variance 
# in the Score is explained by interaction between Proficiency & Intervention.

# When talking about effect size:
# 80% or above is considered a high effect size
# 50% is considered a moderate effect size
# below 20% is considered a low effect size
