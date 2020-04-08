#=============================================================================================
#=============================================================================================
# CRM을 이용한 은행마케팅 - 20대 고객 탐색적 데이터 분석
#=============================================================================================
#=============================================================================================
# 은행 마케팅 데이터를 불러온 후 20대와 30대까지의연령대에 해당하는 고객들의 일부 변수들만을 추출한다.
# 이 데이터 부분집합을 활용하여 데이터 처리와 탐색적 시각적 분석을 실시한다.
# 이 중 20대에 해당하는 고객들만을 다시 구분하여 부분집합을 만든다.
#=============================================================================================
#=============================================================================================
bnk01 <- read.csv("../수업DATA/bnk05.csv")

dim(bnk01)
str(bnk01)

bnk_20s_30s <- bnk01[bnk01$age>=20 & bnk01$age<40, c("age", #나이
                                               "marital", #결혼
                                               "job", #직업
                                               "balance", #잔고
                                               "duration", #이자율
                                               "loan")] #대출

bnk_20s <- bnk02[bnk02$age>=20 & bnk02$age<30, c("age", #나이
                                               "marital", #결혼
                                               "job", #직업
                                               "balance", #잔고
                                               "duration", #이자율
                                               "loan")] #대출

#=============================================================================================
#=============================================================================================
# 20대 고객들은 어떤 특성을 가지고 있는가? 데이터만을 활용하여 이 집단의 특성을 파악하라.
# 집계와 챠트를 생성하여 특성을 보여주는 다음의 요구사항에 해당하는 스크립트를 작성하라.
#=============================================================================================
#=============================================================================================
# - 연령의 분포를 보여주는 플롯을 작성하라.
bnk_20s <- bnk_20s[bnk_20s$age<30,]
plot(bnk_20s$age) #나이

# - duratiion의 분포를 보여주는 플롯을 작성하라.
plot(bnk_20s$duration) #이자율

# - 연령과 잔고의 scatterplot을 작성하라.
plot(bnk_20s$age, bnk_20s$balance)

# - 동일한 연령이 많이 존재하므로 jitter를 활용한 플롯을 작성하고 플롯의 point를 반투명한 blue 색상으로 변경하라.
plot(jitter(bnk_20s$age), jitter(bnk_20s$balance), pch=19, col=rgb(0,0,1,0.2))

# - 결혼상태별 고객수를 막대챠트로 작성하고 <20대의 결혼상태 분포>라는 제목을 추가하라.
barplot(table(bnk_20s$marital), col=rgb(0,0,1,0.75),
        main="<20대의 결혼상태 분포>")

# - 잔고와 duration간의 분포를 보여주는 scatterplot을 작성하고, 선형회귀선을 추가하라.
# - 결혼상태가 single인 경우는 blue, 아니라면 red인 반투명 point로 색상을 변경하라.
plot(jitter(bnk_20s$balance), jitter(bnk_20s$duration), pch=19, 
     col=ifelse(bnk_20s$marital=="single", rgb(0,0,1,0.2), rgb(1,0,0,0.2)),
     sub="blue: single")

abline(lm(duration~balance, data=bnk_20s), col="darkgrey", lwd=2, lty=2)

# - duration과 balance 각각에 대한 중위수를 기준으로 수직,수평의 보조 구분선을 추가하라.
abline(h=median(bnk_20s$duration), lty=2)
abline(v=median(bnk_20s$balance), lty=2)

# - 개인대출여부 (loan) 별 잔고 분포를 box plot을 사용하여 나타내라.
plot(jitter(bnk_20s$balance), jitter(bnk_20s$duration), pch=19, 
     col=ifelse(bnk_20s$loan=="yes", rgb(1,0,0,0.2), rgb(0,0,1,0.2)),
     sub="blue: loan")

boxplot(balance~loan,data=bnk_20s, main="개인대출여부별 잔고", 
        ylab="잔고", ylim=c(-1000,4000))
grid()


# - 직업별 잔고의 중위수를 집계 산출하고, 막대 플롯을 작성하라.
jobBalance <- aggregate(bnk_20s$balance,
                        by=list(bnk_20s$job),
                        FUN=median)

names(jobBalance) <- c("job","medianBalance")

# job medianBalance
# 1        admin.           230
# 2   blue-collar           431
# 3  entrepreneur           345
# 4    management           448
# 5 self-employed          1179
# 6      services            33
# 7       student           755
# 8    technician            59

barplot(table(bnk_20s$job), col=rgb(0,0,1,0.75),
        main="직업별 잔고의 중위수 집계 산출")

# - 직업이 학생이면 blue로 아니면 grey로 색상을 지정하라.
plot(jitter(bnk_20s$age), jitter(bnk_20s$marital), pch=19, 
     col=ifelse(bnk_20s$job=="student", rgb(0,0,1,0.2), rgb(1,0,0,0.2)),
     sub="blue: student")


# - 20대 전체의 잔고 중위수 값을 기준으로 수평 보조선을 추가하라.

# - 20대의 직업별 고객수 비율을 table 명령을 활용하여 구하고

# 20대 뿐 아닌 전체 고객의 직업별 비율을 역시 같은 방식으로 구한후
# 두 가지를 하나의 데이터프레임으로 결합해서 생성하라

# -20대와 전체의 각 직업별 구성비 차이를 비교해 함께 보여주는 막대플롯을 작성하라
# -30대 고객의 연령과 잔고간 scatterplot과 

# 20대에 대한 그 것을 각각이 플롯으로 비교해 보여주는 한 장의 그림을 작성하라 (par mfrow 활용)




# 직업별 잔고의 중위수 산출

barplot(jobBalance$medianBalance, names.arg=jobBalance$job,
        col=ifelse(jobBalance$job=="student","blue","grey"))

abline(h=median(bnk02a$balance), lty=2)

agg2 <-aggregate(bnk02a$age, by=list(bnk02a$job), 
                 FUN=mean)

names(agg2) <- c("job","avg_age")

rloan01 <- table(bnk02a$job, bnk02a$loan)[,3]/table(bnk02a$job, bnk02a$loan)[,1]
rloan02 <- rloan01[!is.nan(rloan01)]

barplot(agg2$avg_age, names.arg=agg2$job,
        col=rgb(rloan02,0,rloan02,0.8), 
        ylab="age", xlab="job")

abline(h=median(bnk02a$age), col="grey", lty=2)


# compare to the entire customer base

tb01 <- table(bnk02a$job)/nrow(bnk02a)

jobnames <- names(tb01)

tb01 <- as.numeric(tb01)

tb02 <- as.numeric(table(bnk01$job)/nrow(bnk01))

dfjobcnt <- data.frame(tb01, tb02)

row.names(dfjobcnt) <- jobnames

names(dfjobcnt) <- c("20_sth", "all")

tbjobcnt <- as.table(as.matrix(dfjobcnt))



barplot(t(tbjobcnt), beside=TRUE,  legend = colnames(tbjobcnt))





# 30 sth only -------



bnk02b <- bnk02[bnk02$age>=30,]

plot(jitter(bnk02b$age), jitter(bnk02b$balance), pch=19, 
     
     col=ifelse(bnk02b$job=="student", rgb(0,0,1,0.2), rgb(1,0,0,0.2)),
     
     sub="blue: student")