


# R �V Recency : ���O�̳̫�@���ʶR�Z���ѼơC
# F �V Frequency: ���O���ʶR�W�v�C
# M �V Monetary: ���O�̥�����O���B�]�C�@���ʪ�/�q�浲�b�^�C

setwd('C:/Users/USER/Desktop/Github/R Project')
getwd()

#�ɮ׬�txt
df<-read.table(file="cdnow_master.txt", header=FALSE)
df
str(df)

#�ƥ����:
df_backup<-df
#df<-df_backup


#�D�X���n�ܼ�:
df<-df[,c(1,2,4)]
names(df)<-c("ID","Date","Amount")

str(df)
#�o�{�ثe����Oint����
df$Date<-as.Date(as.character(df$Date), format="%Y%m%d")
str(df)

dim(df)
#69659��������

UserID<-df[!duplicated(df$ID),]
dim(UserID)
#23570�ӥΤ�

# �ϥ�Independent(�W�ߪk)�i��Bining(���c)
#����������ƫe�B�z:

startDate<-as.Date("19970101","%Y%m%d")
endDate<-as.Date("19980101","%Y%m%d")

# group by�p��R,F,M��:

library(dplyr)
library(magrittr)

new_df <- 
    df %>% 
    filter(Date >= startDate & Date <= endDate) %>% 
    group_by(ID) %>% 
    summarise(
        MaxTransDate = max(Date),
        Amount = sum(Amount),
        Recency = as.numeric(endDate - MaxTransDate),
        Frequency = n(),
        Monetary = Amount/Frequency
    ) %>% 
    ungroup() %>% 
    as.data.frame()

head(new_df,10)
tail(new_df,10)

UserID<-df[!duplicated(df$ID),]
dim(UserID)
#23570�ӥΤ�



# EDA

# 1.Recency
#ø��:
quantile(new_df$Recency,probs=c(0.2,0.4,0.6,0.8,1)) # probs = seq(0,1,by = 0.2)
hist(new_df$Recency)
plot(density(new_df$Recency))

#���c:
R_labels=c(1,2,3,4,5)
new_df$R_score<-cut(
    new_df$Recency,
    breaks=c(quantile(new_df$Recency,probs=seq(0,1,by=0.2))), #�ʤ���Ƥ���
    labels=R_labels,
    include.lowest=TRUE
)

str(new_df$R_score)
new_df$R_score<-as.numeric(new_df$R_score)

head(new_df,10)


    
# 2.Frequency
#ø��:
quantile(new_df$Frequency,probs=seq(0,1,by=0.2))
summary(new_df$Frequency)
hist(new_df$Frequency, breaks=500)
plot(density(new_df$Frequency))


#���c:
F_labels=c(1,2,3,4,5)
new_df$F_score<-cut(
    new_df$Frequency,
    breaks=c(0,1,2,3,4,60), #�ۭq���ΡA�]����Ƥ��������װ��A
    labels=F_labels,
    include.lowest=TRUE
)

table(new_df$F_score)

str(new_df)
new_df$F_score<-as.numeric(new_df$R_score)

head(new_df,10)


# 3.Monetary
#ø��:
quantile(new_df$Monetary,probs=seq(0,1,by=0.2))
summary(new_df$Monetary)
hist(new_df$Monetary,breaks=200)
plot(density(new_df$Monetary))

#���c:
M_labels=c(1,2,3,4,5)
new_df$M_score<-cut(
    new_df$Monetary,
    breaks=c(quantile(new_df$Monetary, probs = seq(0,1,0.2))), #�ʤ���Ƥ���
    labels=M_labels,
    include.lowest=TRUE
)

new_df$M_score<-as.numeric(new_df$M_score)
str(new_df)

table(new_df$M_score)

# new_df$M_score<-NULL

head(new_df,10)




# �p��Total Score:
new_df$Total_Score <- as.numeric(paste(new_df$R_score,new_df$F_score,new_df$M_score, sep = ""))

head(new_df,10)
str(new_df)
summary(new_df$R_score)
summary(new_df$F_score)
summary(new_df$M_score)
summary(new_df$Monetary)

# 
# > summary(new_df$R_score)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   2.000   3.000   2.984   4.000   5.000 

# > summary(new_df$R_score)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   2.000   3.000   2.984   4.000   5.000 

# > summary(new_df$F_score)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   2.000   3.000   2.984   4.000   5.000 

# > summary(new_df$M_score)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   2.000   3.000   2.976   4.000   5.000 

# > summary(new_df$Monetary)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.00   14.96   24.85   32.63   39.83 1119.68 












