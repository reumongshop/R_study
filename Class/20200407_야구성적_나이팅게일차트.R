# 나이팅게일 차트로 표현
# 주요선수별성적-2013년.csv

data <- read.csv("../수업DATA/주요선수별성적-2013년.csv", header=T)
data

#선수명 데이터만 뽑아서 가로 이름으로 추가!
# 컬럼값을 이용해서 컬럼 네임을 추가시키는 방법
row.names(data) <- data$선수명

data2 <- data[,c(7,8,11,12,13,14,17,19)]

stars(data2,
      flip.labels=FALSE,
      draw.segment=TRUE,
      frame.plot=TRUE,
      full=TRUE,
      key.loc=c(1.5, 0),
      main="야구 선수별 주요 성적 분석-2013년")

#====================================================================
require(grDevices)

stars(mtcars[, 1:7], key.loc = c(14, 2),
      main="Motor Trend Cars : stars(*, full=F)", full=FALSE)

stars(mtcars[, 1:7], key.loc = c(14, 1.5),
      main="Motor Trend Cars : full stars()", flip.labels=FALSE)

#====================================================================
## 'Spider' or 'Radar' plot :
stars(mtcars[, 1:7], locations=c(0, 0), radius=FALSE,
      key.loc=c(0, 0), main="Motor Trend Cars", lty=2)

# Segment Diagrams :
palette(rainbow(12, s=0.6, v=0.75))

stars(mtcars[, 1:7], len=0.8, key.loc=c(12, 1.5),
      main="Motor Trend Cars", draw.segments=TRUE)

stars(mtcars[, 1:7], len=0.6, key.loc=c(1.5, 0),
      main="Motor Trend Cars", draw.segments=TRUE,
      frame.plot=TRUE, nrow=4, cex=.7)

#====================================================================
# 한국프로야구선수별 기록분석-2013년
# 주요선수별성적-2013년.csv

data <- read.csv("../수업DATA/주요선수별성적-2013년.csv", header=T)
data # 원래 데이터는 행 값이 숫자

data4 <- data[,c(2,21,22)]
data4

line1 <- data$연봉대비출루율
line2 <- data$연봉대비타점율

# par() : 그래픽 매개 변수를 설정하거나 쿼리하는 데
#         사용할 수 있다.
# 매개변수는 tag = value 형식의 par 인수로 지정하거나 태그 값의 목록으로 전달하여 설정할 수 있다
# 매개변수 mar : 플롯의 네면에 지정된 마진선 수를 나타내는
# c(아래쪽, 왼쪽위, 오른쪽)형태의 숫자 벡터
# 기본값은 c(5, 4, 4, 2)+0.1.

# 매개변수 new :
# 논리적이며 기본값은 FALSE
# TRUE 로 설정하면 다음 높은 레벨의 플로팅 명령(실제로 plot.new)은
# 새 장치에 있는 것처럼 그리지 전에 프레임을 정리해서는 안된다
# 현재 고수준 플롯이 없는 장치에서
# new = TRUE를 사용하려고 하면 오류(경고와 함께 무시됨) 발생

par(mar=c(5, 4, 4, 4) + 0.1) #순수 R에서 사용x

plot(line1,
     type="o",
     axes=F,
     ylab="",
     xlab="",
     ylim=c(0, 50),
     lty=2,
     col="blue",
     main="한국프로야구선수별 기록분석-2013년",
     lwd=2)

axis(1,
     at=1:25,
     lab=data4$선수명,
     las=2)

axis(2, las=1) #las : x축 위치

#타점율그래프 덧그리기(꺾은선)
par(new=T)

#덧그릴 그래프는 타점율을 이용한 선형 점선그래프
plot(line2,
     type="o",
     axes=F,
     ylab="",
     xlab="",
     ylim=c(0, 50),
     lty=2,
     col="red")

axis(4, las=1)

mtext(side=4, line=2.5, "연봉대비 타점율")
mtext(side=2, line=2.5, "연봉대비 출루율")

abline(h=seq(0, 50, 5),
       v=seq(1, 25, 1),
       col="gray",
       lty=2)

#범례 추가
legend(18,50,
       names(data[21:22]),
       cex=0.8,
       col=c("red","blue"),
       lty=1,
       lwd=2,
       bg="white")


dev.new()
savePlot("baseball_4.png", type="png")

#===================================================
# 프로야구 KBO 타자 성적과 나이의 관게(hit20180927.csv)
# 루타(TB) / 추정득점(XR) / 타석(PA) 값을 이용하여
# 추정득점(XR) / 타석(PA) 값이 .18보다 큰 선수들만
# 별도로 시각화하여 성적과 기여도의 관계를 시각화

# 추정득점(XR) : 팀 득점에서 얼마나 기여했는지 정도
hit5 <- read.csv("../수업DATA/hit20180927.csv")
hit5

hit5$age <- c(30, 20, 28, 31, 30, 32, 37, 32,
              37, 34, 36, 30,
              30, 30, 28, 25, 28, 32, 28,
              25, 28, 33, 32, 28,
              29, 29, 28, 33, 34, 31, 39,
              30, 29, 35, 29, 28,
              26, 34,  31, 33, 28, 31, 22,
              29, 29, 28, 29, 19,
              31, 33, 33, 28, 19, 31, 34,
              28, 28, 31, 27, 24,
              31)

# 루타(TB)값 이용한 기본차트
plot(hit5$age,
     hit5$TB,
     pch=19,
     col="steelblue",
     cex=1.5,
     main="나이와 타자 성적",
     xlab="AGE",
     ylab="TB")


# 추정득점(XR)/타석(PA) 값이 .18보다 큰 데이터만 추출
hit51 <- hit5[hit5$XR/hit5$PA>0.18,]

points(hit51$age,
      hit51$TB,
      pch=19,
      col="red",
      cex=1.5)

# 글씨 새기기
text(hit51$age,
     hit51$TB,
     pos=3,
     labels=hit51$name)

# lowess()
# 이 함수는 국소 가중 다항 회귀를 사용하는 LOWESS smmther에 대한 계산을 수행한다(References 참조)
# lowess는 복잡한 알고리즘에 의해 정의되며, Ratfor 오리지널(W.S. Cleveland)은
# R 소스에서 파일 'src / appl / lowess.doc' 로 찾을 수 있다.
# 일반적으로 로컬 선형 다항식 피팅이 사용되지만
# 경우에 따라 (파일참조) 로컬 상수 피팅을 사용할 수 있다
# '로컬'은 가장 가까운 이웃 (f*n)까지의 거리로 정의되며, 이웃에 속하는 x에 대해 삼중 가중이 사용된다

# Arguments
# x,y : 산점도에서 점 좌표를 제공하는 벡터
# 또는 단일 플로팅 구조 지정 가능(xy.coords 참조)
# f : 부드러운 스팬
# 이는 각 값에서 평활도에 영향을 주는 플롯의 점 비율 제공
# 값이 클수록 더 부드러워진다

# iter
# 수행해야 할 '강화' 반복 횟수가
# 더 작은 iter값을 사용하면 lowess 실행 속도가 빨라진다

# delta : 기본값은 x 범위의 1/100

lines(lowess(hit5$TB~hit5$age),
      lwd=2,
      lty=3)

# 선수명단 한번에 가져오기
plot(hit5$age,
     hit5$TB,
     pch=19,
     col="steelblue",
     cex=1.5,
     main="프로야구 타자 - 나이와 성적",
     sub="red: XR/PA>0.18",
     xlab="AGE",
     ylab="TB")

hit51 <- hit5[hit5$XR/hit5$PA>0.18,]

points(hit51$age, hit51$TB, pch=19, col="red", cex=1.5)

text(hit5$age, hit5$TB, pos=3, labels=hit5$name)

lines(lowess(hit5$TB~hit5$age), lwd=2, lty=3)

#--------------------------------------------------------------
# KBO 프로야구 가을야구 예상 분석
# 플레이오프와 코리아 시리즈
# hit20180919.csv

# 미리보는 KBO 2018 가을 야구
# 플레이오프 : 환하-sk
# 코리아시리즈 : sk-두산
# 순서대로 진행된다 했을 때 벌어질 타격전의 예상시나리오?
# 9.19일까지의 KBO 타격 통계를 바탕으로 예상해본다면?

#--------------------------------------------------------------
# [EDA] KBO 가을야구 미리보기 연습
# 1. scatter plot을 통한 타자들 구성 분포 탐색
# 2. barplot 을 활용한 팀별 성향 비교

# 데이터 불러오기
# KBO 데이터 타자순위로 60명. 2018.09.19 까지 통계 반영

hit0 <-  read.csv("../수업DATA/hit20180919.csv")

# 타석당 타점 중요하다 보고 비율변수 추가
hit0$pparbi <- hit0$RBI/hit0$PA
hit1 <- hit0[order(hit0$pparbi, decreasing=T),]
head(hit1, 5)

# 전반적인 상관관계 확인
pairs(hit1[, 4:7])

# 타석이 많다고 타율이 자동적으로 높지 x

# 주요 관심 특정 변수를 활용한 scatterplot으로 대세 파악하기
plot(hit1$AVG, hit1$ISOP,
     cex=0.9, pch=19,
     col=ifelse(hit1$team=="두산","navy",
                ifelse(hit1$team=="SK", "red",
                       ifelse(hit1$team=="한화", "orange", "lightblue")
                )
     ),
     main="가을야구 Preview - stat a.o. 20180919",
     xlab="AVG",
     ylab="ISOP",
     sub="only high XR/PA hitters labeled")

# 선수 이름 표시
# 타석대비 득점생산력이 높은 소수의 선수만 이름 표시

text(hit1$AVG,
     hit1$ISOP,
     labels=ifelse((hit1$XR/hit1$PA)>.17 & hit1$team %in% c("두산","SK","한화"), as.character(hit1$name), ""),
     pos=3,
     cex=0.7)

abline(h=.28, lty=3)
abline(v=.32, lty=3)











# hit5$age <- c(30, 20, 28, 31, 30, 32, 37, 32,
#               37, 34, 36, 30,
#               30, 30, 28, 25, 28, 32, 28,
#               25, 28, 33, 32, 28,
#               29, 29, 28, 33, 34, 31, 39,
#               30, 29, 35, 29, 28,
#               26, 34,  31, 33, 28, 31, 22,
#               29, 29, 28, 29, 19,
#               31, 33, 33, 28, 19, 31, 34,
#               28, 28, 31, 27, 24,
#               31)
# 
# plot(hit5$age, hit5$TB,
#      pch=19, col="steelblue", cex=1.5,
#      main="나이와 타자 성적",
#      xlab="AGE", ylab="TB")
# hit51 <- hit5[hit5$XR/hit5$PA>0.18,]
# points(hit51$age, hit51$TB,
#        pch=19, col="red", cex=1.5)
# text(hit51$age, hit51$TB,
#      pos=3, labels=hit51$name)
# lines(lowess(hit5$TB~hit5$age), lwd=2, lty=3)
# 
# 
# 
# boxplot(hit5$TB~hit5$age)
# 
# 
# 
# plot(hit5$age, hit5$TB,
#      pch=19, col="steelblue", cex=1.5,
#      main="프로야구 타자 - 나이와 성적",
#      sub="red: XR/PA>0.18",
#      xlab="AGE", ylab="TB")
# hit51 <- hit5[hit5$XR/hit5$PA>0.18,]
# points(hit51$age, hit51$TB,
#        pch=19, col="red", cex=1.5)
# text(hit5$age, hit5$TB,
#      pos=3, labels=hit5$name)
# lines(lowess(hit5$TB~hit5$age), lwd=2, lty=3)
