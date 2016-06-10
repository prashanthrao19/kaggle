rm(list=ls())
library(xlsx)

#read the data
Titanic<- read.xlsx("C:/Users/rao/Desktop/imarticus/capstone/Titanic.xls",sheetIndex = 1,stringsAsFactors = FALSE)
str(Titanic)

# check for missing values and their proporion of total values
logic_dataframe<-  is.na(Titanic)
Missing_values<- data.frame(proportion_of_missing_values = colSums(logic_dataframe)/nrow(logic_dataframe))
Missing_values

#variables age and cabin have missing values of 20% and 77% of the data. cabin variable has more missing values than threshold of 40% and can be dropped.
# missing values in age have to imputed. Though variable EMbarked has some missing values it doesn't add much information to the model so it is dropped.
#clean the data by removing unwanted variables

Data<- Titanic[,-c(1,9:12)]
library(stringr)
Data$Title<- str_split_fixed(Data$Name,", ",2)[,2]
Data$Title<- str_split_fixed(Data$Title,"\\.",2)[,1]
sort(table(Data$Title))

# most occuring titles are Mr, Miss,Mrs,Master,Dr and Rev with frequencies 6-517
mean_mr_age<- round(mean(Data$Age[Data$Title == "Mr"], na.rm = TRUE),digits = 2)
mean_miss_age<-round(mean(Data$Age[Data$Title == "Miss"], na.rm = TRUE),digits = 2)
mean_mrs_age<-round(mean(Data$Age[Data$Title == "Mrs"], na.rm = TRUE),digits = 2)
mean_master_age<- round(mean(Data$Age[Data$Title == "Master"], na.rm = TRUE),digits = 2)
mean_dr_age<- round(mean(Data$Age[Data$Title == "Dr"], na.rm = TRUE),digits = 2)
mean_rev_age<- round(mean(Data$Age[Data$Title == "Rev"], na.rm = TRUE),digits = 2)

# conditional imputation of missing values for Age variable
for(i in 1:nrow(Data)){
        if(is.na(Data$Age[i])){
                if(Data$Title[i] == "Mr"){
                        Data$Age[i] = mean_mr_age
                }else if(Data$Title[i] == "Miss"){
                        Data$Age[i] = mean_miss_age
                }else if(Data$Title[i] == "Mrs"){
                        Data$Age[i] = mean_mrs_age
                }else if(Data$Title[i] == "Master"){
                        Data$Age[i] = mean_master_age
                }else if(Data$Title[i] == "Dr"){
                        Data$Age[i] = mean_dr_age
                }else if (Data$Title[i] == "Rev"){
                        Data$Age[i] = mean_rev_age
                }
                        
                        
                        
        }
}

# making variable Sex as a factor with levels 1 and 2
Data$Sex<- gsub("female","1",Data$Sex)
Data$Sex<-gsub("male","2",Data$Sex)
Data$Sex<- as.numeric(Data$Sex)
Data1<- Data[,-c(3,8)]

# checking for correlation of numercial variables
library(corrgram)
corrgram(Data1)
cor(Data1)

#good correlation is visible between survived, Pclass and Survived and Sex.
#divide the data in to train and test datasets with 70:30 ratio
sample_size<- floor(0.7*nrow(Data1))
set.seed(123)
train_index<- sample(seq_len(nrow(Data1)),size = sample_size)
train<- Data1[train_index,]
test<- Data1[-train_index,]

#confirm that split has worked
str(train)

#check if the deceased to survided ratio is uniform in each dataset
table(Titanic$Survived)
table(train$Survived)
table(test$Survived)


# modelling logistic model on the train data set with "Survived" as response variable and Pclass,Sex, Age, Sibsp,Prach and interaction between Pclass and sex as independedent variables 
model<- glm(Survived~as.factor(Pclass)*Sex+Age+SibSp:Parch,family = binomial(link = logit),data = train)

summary(model)

# checking for VIF of the independent variables
library(car)

vif(model)

# checking the model accuracy
train$probs = predict(model, type="response")
train$Predict <- NA
for(i in 1:length(train$probs)) {
        if(train$probs[i] > .5) {
                train$Predict[i] <- 1
        } else{
                train$Predict[i] <- 0
        }
                
        
}
table(train$Survived,train$Predict)

# predicting Survival of passengers in the test dataset
test$probs<- predict(model,newdata = test,type = "response")
test$Predict <- NA
for(i in 1:length(test$probs)) {
        if(test$probs[i] > .5) {
                test$Predict[i] <- 1
        } else{
                test$Predict[i] <- 0
        }
        
        
}

table<-table(test$Survived,test$Predict)
table

#accuracy of the model
overall_accuracy <- ((table[1,1]+table[2,2])/(table[1,1]+table[2,2]+table[1,2]+table[2,1]))*100
print(overall_accuracy)