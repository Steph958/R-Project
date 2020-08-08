# R Code for Shrinkage Regression

install.packages("glmnet")

require(glmnet)


data(Prostate, package="lasso2")
str(Prostate)


# ���ưϤ��� train=0.8, test=0.2 
set.seed(22)
train.index = sample(x=1:nrow(Prostate),
                     size=ceiling(0.8*nrow(Prostate)))


train = Prostate[train.index, ]
test = Prostate[-train.index, ]

str(train)
str(test)




ridge = glmnet(x = as.matrix(train[, -9]), 
               y = train[, 9], 
               alpha = 0,  #0(Ridge) �� 1(Lasso)
               family = "gaussian")
#�Yy�O�s��ȡA�]"gaussian"�F
#�Yy�O�G�������A�]"binomial"�F
#�Yy�O�h�������A�]"multinomial"�C
ridge



lasso = glmnet(x = as.matrix(train[, -9]), 
               y = train[, 9], 
               alpha = 1,
               family = "gaussian")
lasso




#���ϡAX �b�� lambda(�g�@��) �A Y �b���U�ܼƪ��Y�ƭȡC
par(mfcol = c(1, 2))
plot(lasso, xvar='lambda', main="Lasso")
plot(ridge, xvar='lambda', main="Ridge")






######################################################################################################################################################################

# ��X�̨�lambda

#�Q�� Cross Validation ����k�A���Ҧb���P lambda �ȤU�ҫ������{

# �M����ݮt�̤p��(���{�̦n)�ҫ�



cv.lasso = cv.glmnet(x = as.matrix(train[, -9]), 
                     y = train[, 9], 
                     alpha = 1,  # lasso
                     family = "gaussian")

cv.lasso


# �����C�Ӽҫ��� cvm(mean cross-validated error)��
# ���̤p cvm �ҫ��ҹ����� lambda
best.lambda = cv.lasso$lambda.min
best.lambda
#  0.005795017


# �Ŧ⫫����u�N�O�̨� lambda ���Ҧb��m
# ���L�u�ۥ檺��m�N�O���ܼƦ��Y�᪺�Y��
plot(lasso, xvar='lambda', main="Lasso")
abline(v=log(best.lambda), col="blue", lty=5.5 )



# Lasso���ܼƬD��
# �[������ܼƳQ�D��X�ӡA��Y�Ƥ��� 0������
coef(cv.lasso, s = "lambda.min")

#���X�o�ǭ��n�ܼƪ��W�١G
select.ind = which(coef(cv.lasso, s = "lambda.min") != 0)


select.ind = select.ind[-1]-1 # remove `Intercept` and �����ѤU��ind
select.ind # �ĴX���ܼƬO���n�� 


select.varialbes = colnames(train)[select.ind]
select.varialbes


lm(lpsa ~ ., train[, c(select.varialbes, "lpsa")])


#�w��:

#���� glmnet() �إ߰򥻪� Ridge / Lasso �ҫ�
ridge = glmnet(x = as.matrix(train[, -9]), 
               y = train[, 9], 
               alpha = 0, # ridge
               family = "gaussian")

# �� cv.glmnet() ��X�̨Ϊ��g�@�� best.lambda
cv.ridge = cv.glmnet(x = as.matrix(train[, -9]), 
                     y = train[, 9], 
                     alpha = 0,  # ridge
                     family = "gaussian")

best.ridge.lambda = cv.ridge$lambda.min


# �ϥ� predict()�i��w��
ridge.test = predict(ridge,                 #�ϥΪ��ҫ�
                     s = best.ridge.lambda,  #�̨Ϊ�Lambda��
                     newx = as.matrix(test[, -9]))  #��test����9��(Ipsa)����

# �����ҫ�
R_squared(test$lpsa, ridge.test)