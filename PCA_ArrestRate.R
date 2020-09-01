


library(tidyverse)  # data manipulation and visualization
library(gridExtra)  # plot arrangement

data("USArrests")
head(USArrests,10)


#��ƼзǤ�
scaled_df<-apply(USArrests,2,scale) #scale: (x �V mean(x)) / sd(x)
head(scaled_df)

#�p��@�ܲ��x�}
arrest.cov<-cov(scaled_df)
arrest.cov

#�p��S�x��(eigen values)�M�S�x�V�q(eigen vector)
arrest_eigen<-eigen(arrest.cov)
arrest_eigen
# #
# eigen() decomposition
# $values
# [1] 2.4802416 0.9897652 0.3565632 0.1734301
# 
# $vectors
#          [,1]       [,2]       [,3]        [,4]
# [1,] -0.5358995  0.4181809 -0.3412327  0.64922780
# [2,] -0.5831836  0.1879856 -0.2681484 -0.74340748
# [3,] -0.2781909 -0.8728062 -0.3780158  0.13387773
# [4,] -0.5434321 -0.1673186  0.8177779  0.08902432


#�^���̭��n���e��ӥD����
(phi<-arrest_eigen$vectors[,1:2])
# #
#          [,1]       [,2]
# [1,] -0.5358995  0.4181809
# [2,] -0.5831836  0.1879856
# [3,] -0.2781909 -0.8728062
# [4,] -0.5434321 -0.1673186


phi <- -phi
row.names(phi) <- c("Murder", "Assault", "UrbanPop", "Rape")
colnames(phi) <- c("PC1", "PC2")
phi
# #
#             PC1        PC2
# Murder   0.5358995 -0.4181809
# Assault  0.5831836 -0.1879856
# UrbanPop 0.2781909  0.8728062
# Rape     0.5434321  0.1673186



#�N�[���ȧ�v��D�����V�q���W
#�p��D��������
PC1<-as.matrix(scaled_df)%*%phi[,1] #�x�}���k
PC2<-as.matrix(scaled_df)%*%phi[,2] 

PC<-data.frame(State=row.names(USArrests),PC1,PC2)
head(PC)
# #
#       State        PC1        PC2
# 1    Alabama  0.9756604 -1.1220012
# 2     Alaska  1.9305379 -1.0624269
# 3    Arizona  1.7454429  0.7384595
# 4   Arkansas -0.1399989 -1.1085423
# 5 California  2.4986128  1.5274267
# 6   Colorado  1.4993407  0.9776297


#ø��
par(family="����-�c ����")

ggplot(PC, aes(PC1, PC2)) + 
    modelr::geom_ref_line(h = 0) +
    modelr::geom_ref_line(v = 0) +
    geom_text(aes(label = State), size = 3) +
    xlab("PC1: rate of serious crime, ���j�Ǹo�o�Ͳv") + 
    ylab("PC2: urbanization, �����Ƶ{��") + 
    ggtitle("First Two Principal Components of USArrests Data")+
    theme(text=element_text(family="����-�c ����"))


# �Ѩ��D����
# PVE
PVE<-arrest_eigen$values / sum(arrest_eigen$values)
round(PVE,2)
# [1] 0.62 0.25 0.09 0.04


# PVE plot
PVEplot <-
    qplot(c(1:4), PVE) + 
    geom_line() + 
    xlab("Principal Component") + 
    ylab("PVE") +
    ggtitle("Scree Plot") +
    ylim(0, 1)


# Cumulative PVE plot
cumPVE <- 
    qplot(c(1:4), cumsum(PVE)) + 
    geom_line() + 
    xlab("Principal Component") + 
    ylab(NULL) + 
    ggtitle("Cumulative Scree Plot") +
    ylim(0,1)

grid.arrange(PVEplot, cumPVE, ncol = 2)



#PCA�����B��:²��
pca_result<-prcomp(x=USArrests,center=TRUE,scale=TRUE)
pca_result
#
# Standard deviations (1, .., p=4):
#     [1] 1.5748783 0.9948694 0.5971291 0.4164494
# 
# Rotation (n x k) = (4 x 4):
#                 PC1        PC2        PC3         PC4
# Murder   -0.5358995  0.4181809 -0.3412327  0.64922780
# Assault  -0.5831836  0.1879856 -0.2681484 -0.74340748
# UrbanPop -0.2781909 -0.8728062 -0.3780158  0.13387773
# Rape     -0.5434321 -0.1673186  0.8177779  0.08902432

names(pca_result)
#[1] "sdev"     "rotation" "center"   "scale"    "x"  

pca_result$sdev
pca_result$rotation #�t���V�q(loading vector)
pca_result$rotation <- -pca_result$rotation


pca_result$center #������
pca_result$scale #�зǮt


#�����C�@���[���(��a)���D��������
pca_result$x<- -pca_result$x
head(pca_result$x)
# #
#                  PC1        PC2         PC3          PC4
# Alabama     0.9756604 -1.1220012  0.43980366 -0.154696581
# Alaska      1.9305379 -1.0624269 -2.01950027  0.434175454
# Arizona     1.7454429  0.7384595 -0.05423025  0.826264240
# Arkansas   -0.1399989 -1.1085423 -0.11342217  0.180973554
# California  2.4986128  1.5274267 -0.59254100  0.338559240
# Colorado    1.4993407  0.9776297 -1.08400162 -0.001450164


#ø��
biplot(x=pca_result) #�w�]�Ȭ��e����(�D����)











