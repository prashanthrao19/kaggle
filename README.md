# kaggle
Titanic_kaggle
Project description: On April 15 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. We have the data of 891 passengers. For each passenger our model should predict whether or not they survived the sinking.
Methodology:
Dataset “Titanic” has 891 observations with 12 variables 
Variable	Description
PassengerID	Numeric Id for each passenger
Survived	Survival (0 = No, 1 = Yes)
Pclass	Passenger class (1 = 1st, 2 = 2nd, 3 = 3rd)
Name	Name of the Passenger
Sex	Sex(Male, Female)
Age	Age
SibSp	Number of Siblings/Spouses Aboard
Parch	Number of Parents/Children Aboard
Ticket	Ticket Number
Fare	Passenger Fare
Cabin	Cabin
Embarked	Port of Embarkment
(C = Cherbourg, Q= Queenstown,
 S = Southampton)

After checking the structure of the data, I checked proportion of missing values in the data.
Variable	Proportion of missing values
Age	0.198653199
Cabin	0.771043771                                                   
Embarked	0.002244669

Variables ‘passengerID’,‘Ticket’, ’Fare’, ’Cabin’ and ‘Embarked’ are dropped. Age variable is of interest and imputation of missing values has to be done. The variable “Name” has middle name as titles “Mr”,”Miss” so on. So these titles have to be extracted. With library “Stringr” I, extracted these titles and stored them in column “Title”. Most occurring titles are “Mr”, ”Miss”, ”Mrs”, ”Master”, ”Dr”, “Rev”. For these titles, I calculated the mean age and did conditional imputation of missing values. 
Variable “Sex” has values “male” and “female”  which are characters, so I converted them to categorical variable with levels “1-Female”, and “2=Male”.
At these stage variables “Name” and “Title” can be dropped.
When I checked for correlation between variables, I found high correlation between “Survived-Pclass” and “Survived-Sex”.
Then I split the data into ‘train’ and ‘test’ datasets in 70:30 ratio of observations. I checked the split has worked and if the observations of deceased and survived are proportional in each dataset.
I modeled a logistic regression on dataset “train” with “Survived” as response and “Sex”,”Pclass”,”Age”, interaction terms “Pclass:Sex” and “SibSP:Parch” as independent variables. Pclass was modelled as factor as it has three levels and sex being only two levels it doesn’t add anything if it is factor or not. As sex and Pclass were correlated to survived I added the interaction term. Other interaction term SibSp:Parch was added after modelling  them individually and finding that Parch variable is insignificant individually. 
VIF values of all the independent variables are less than five.
I used the model to predict Survival of passengers in “test” dataset and accuracy was found to be 82.08995.
	0	1
0	154	13
1	35	66
