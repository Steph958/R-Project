
#�ϥ�ISLR�M�󤤪��H�Υd�H����ơA�ت��O�n�w���Ȥ�O�_�|����d��


install.packages('ISLR')
install.packages('gridExtra')

library(ISLR)
library(tibble)
library(ggplot2)
library(gridExtra)

data = as.data.frame(Default)
str(data)
#
# 'data.frame':	10000 obs. of  4 variables:
# $ default: Factor w/ 2 levels "No","Yes": 1 1 1 1 1 1 1 1 1 1 ...
# $ student: Factor w/ 2 levels "No","Yes": 1 2 1 1 1 2 1 2 1 1 ...
# $ balance: num  730 817 1074 529 786 ...
# $ income : num  44362 12106 31767 35704 38463 ...

#balance �N���H�Υd����l�B�A�q�`�����N�O����ӥI����
data$default #�����ܼƥ�"'Yes" "No"�c���F�G�����O���A�����

# �ˬd��|�ȼƶq
table(is.na(data))


#�N��Ƥ����V�m���H�δ��ն�

set.seed(42)

# �����ưϤ��� train=0.8, test=0.2 
train.index = sample(x=1:nrow(data), size=ceiling(0.8*nrow(data) ))
train = data[train.index, ]
test = data[-train.index, ]

str(train)
str(test)


#�N�����ܼ��ন0�M1 #���ӬOYes�MNo
train$default = as.numeric(train$default) - 1 
test$default = as.numeric(test$default) - 1 



#�b�إ߼ҫ��e��Ƶ�ı��

p1 = ggplot(data = data, aes(x = balance)) +   
    geom_density(aes(fill=default,
                     alpha=0.1)) +
    labs(title="Density plot", 
         subtitle="# Balance Distribution")

p2 = ggplot(data = data, aes(x = income)) +   
    geom_density(aes(fill=default,  
                     alpha=0.1)) +
    labs(title="Density plot", 
         subtitle="# Income Distribution")


grid.arrange(p1, p2, nrow = 1)


#�إ߼ҫ�
model_glm = glm(default ~ balance, data = train, family = "binomial")
summary(model_glm)


#�w�]�����p�Apredict glm()�|�ϥ�type = "link"
#���glog����ഫ��log odd��
head(predict(model_glm))

#�w�����v�ݨϥ�type = "response"
head(predict(model_glm, type='response'))


predict(model_glm,type = "link",
        newdata = data.frame(balance = 2300))
#�o��2.07721

predict(model_glm,type = "response",
        newdata = data.frame(balance = 2300))
#�o�� 1 / (1 + e^-2.07721) = 0.8886683


#�i�����
result = predict(model_glm, type='response')
result = ifelse(result > 0.5,1,0)
head(result)


#�V�c�x�}confusion matrix
trn_tab = table(predicted = result, actual = train$default)
trn_tab


#�ϥ�caret�M����[��V�c�x�}
## Predicting Test Data
result = predict(model_glm,newdata=test,type='response')
result = ifelse(result > 0.5,1,0)

## Confusion matrix and statistics
library(caret)
confusionMatrix(data=as.factor(result), 
                reference=as.factor(test$default))


#ROC Curve
library("pROC")

test_prob = predict(model_glm, newdata = test, type = "response")

par(pty = "s") #���w�e��ø�s������Ϊ��j�p
test_roc = roc(test$default ~ test_prob, 
               plot = TRUE, 
               print.auc = TRUE, 
               legacy.axes=TRUE) #legacy.axes=TRUE �N x�b�令 1 - Specificity


