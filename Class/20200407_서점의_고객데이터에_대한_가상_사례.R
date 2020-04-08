########################################################
# 서점의 고객 데이터에 대한 가상 사례
# (탐색적인 분석과 고객세분화 응용 사례)
########################################################
# 작업 파일 : cust_seg_smpl_280122.csv
# --------------------------------------------------------
# 작업 내용
#--------------------------------------------------------

# 패키지 로드
library(rmarkdown)
library(knitr)

# 데이터 불러오기
cs0 <- read.csv("../수업DATA/cust_seg_smpl_280122.csv")

# 데이터 확인
head(cs0)
names(cs0)

cs1 <- cs0

# 고객명 / 성별 / 연령 / 지역 / 구매일수 / 최종구매후기간 / 구매서적수
# / 서적구매액 / 기타상품구매액 / 총구매액 / 관심장르 / 구매장르 / 가입기간 / SMS수신여부
names(cs1) <- c("cust_name", "sex", "age", "location", "days_purchase", "recency", "num_books",
                "amt_books", "amt_non_book", "amt_total", "interest_genre", "num_genre", "membership_period", "sms_option")


# 최종 구매 후 기간 recency와 구매한 서적의 수간의 관계 확인
plot(cs1$recency, cs1$num_books)

# 동일 좌표에 다수의 고객 존재 가능성이 있으므로 이를 처리 - jitter() 함수 활용
# jitter() 함수는 데이터 값을 조금씩 움직여서 같은 점에 데이터가 여러번 겹쳐서 표시되는 현상을 막는다.

# Description : 숫자 벡터에 소량의 노이즈를 추가하는 함수
# Usage
# jitter(x, factor=1, amount=NULL)

# Arguments
# x : 지터를 추가할 숫자형 벡터
# factor : numeric(숫자)
# amount : numeric(숫자)
# 양수면 양(+값)으로 사용되며 그렇지 않으면=0
# 기본값은 factor * z / 50

# amount의 기본값은 NULL
# factor * d / 5 여기서 d는 x 값 사이의 가장 작은 차이

# Examples
# z <- max(x)-min(x) 라고 하자 (일반적 경우 가정)

# 추가될 양 a는
# 다음과 같이 양의 인수 양으로 제곱되거나 z에서 계산
# 만약 amount==0이면 a <- factor * z/50을 설정
# rep : 반복 함수
round(jitter(c(rep(1,3), rep(1.2, 4), rep(3, 3))), 3)
# [1] 1.039 0.975 0.962 1.184 1.186 1.175 1.187 2.981 3.028 3.003


# 가설 1
# 보조선인 회귀선을 본다면 최근성이 낮을수록, 
# 즉 구매한지 오래되었을 수록 구매한 서적의 수가 많음
plot(jitter(cs1$recency), jitter(cs1$num_books))
abline(lm(cs1$num_books~cs1$recency), col="blue")

####### 결과 : 구매한지 오래되지 않은 사람일수록 구매한 서적의 수가 많다.

#------------------------------------------------------------------------------
# 가설 2
# 구매한 책의 수가 많을수록 구매금액이 큼
cs1$amt_books <- as.numeric(gsub(",", "", as.character(cs1$amt_books)))
cs1$amt_non_book <- as.numeric(gsub(",", "", as.character(cs1$amt_non_book)))

plot(jitter(cs1$num_books), jitter(cs1$amt_books))
abline(lm(cs1$amt_books~cs1$num_books), col="blue")

####### 결과 : 구매한 책의 수가 많을수록 구매금액이 크다.

# 주로 비싼 책을 샀는지를 파악하기 위해 평균금액을 계산
cs1$unitprice_book <- cs1$amt_books / cs1$num_books

plot(jitter(cs1$num_books),
     jitter(cs1$unitprice_book),
     pch=19,
     col="lightblue",
     cex=0.7,
     ylim=c(0, max(cs1$unitprice_book)*1.05))

abline(lm(cs1$unitprice_book~cs1$num_books), col="blue", lwd=2, lty=2)

abline(h=median(cs1$unitprice_book), col="darkgrey")

####### 결과 : 소비자는 저렴한 책을 더 많이 구매한 것으로 보아, 앞으로 저렴한 책 위주로 판매하는 것이 더 효과적이다.

# 성별을 구분해서 특성 차이 비교 
plot(jitter(cs1$num_books),
     jitter(cs1$unitprice_book),
     pch=19,
     cex=0.7,
     col=ifelse(cs1$sex=="여", "pink", "lightblue"),
     ylim=c(0, max(cs1$unitprice_book)*1.5),
     sub="pink: female  blue: male")

abline(lm(cs1$unitprice_book~cs1$num_books), col="blue", lwd=2, lty2)
abline(h=median(cs1$unitprice_book), col="darkgrey")

####### 결과 : 남자가 여자보다 책을 더 많이 구매했다.


# 서적과 서적이외 구매액 비교

# 동그라미 크기 비율 조정
plot(jitter(cs1$num_books),
     jitter(cs1$unitprice_book),
     pch=19,
     cex=4*cs1$amt_non_book/max(cs1$amt_non_book),
     col=ifelse(cs1$sex=="여", "pink", "lightblue"),
     ylim=c(0, max(cs1$unitprice_book)*1.05),
     sub="size: 서적이외 상품 구매액")

####### 결과 : 여자가 남자보다 서적이외 상품 구매금액이 더 크다.

plot(jitter(cs1$amt_books),
     jitter(cs1$amt_non_book),
     pch=19,
     col="khaki",
     cex=1.5,
     ylim=c(0, max(cs1$amt_non_book)*1.05))

abline(h=median(cs1$amt_non_book)*1.5, col="darkgrey")
abline(v=median(cs1$amt_books)*1.5, col="darkgrey")

text(median(cs1$amt_books)*1.5 *2,
     median(cs1$amt_non_book)*1.5 *0.7, "cross-sell targer")

####### 결과 : 구매서적금액이 10만원 이하, 기타상품금액이 5만원 정도 하는 고객들 위주로 집중 타겟 (구매서적 보다 기타상품 구매율이 낮은 고객층)

# 서적 구매는 많으나 기타 상품 구매가 약한 집단을 선정해
# 집중적 cross-selling 노력 기울이는 것이 필요해보인다.

# 대상 집단 조건 - 시각적으로 설정했던 기준선 영역에 해당하는 고객 리스트 추출
target <- cs1[cs1$amt_books > median(cs1$amt_books)*1.5 &
                cs1$amt_non_book < median(cs1$amt_non_book)*1.5 ,]

nrow(target)

paste("size of target = ",
      as.character(100* nrow(target)/ nrow(cs1)),
      " % of customer base")

# => 타겟층 10%

# 선정된 집단의 프로파일 시각적으로 확인
# 서적 구매수량과 성별 분포 확인 (여성은 pink)
barplot(target$num_books,
        names.arg=target$cust_name,
        col=ifelse(target$sex=="여", "pink", "lightblue"),
        ylab="서적 구매수량")

# 한지민, 민지화

# 전체고객의 평균/중위수 서적구매수량과 비교 
abline(h=mean(cs1$num_books), lty=2)
abline(h=median(cs1$num_books), lty=2)

####### 결과 : 중위수와 평균에 비해서 서적구매수량이 많은 고객 성별은 여성 고객.
#######        집중 타겟 고객 : 한지민, 민지화
#######        기타 상품 중 여성 선호 상품을 찾아 제안하는 방식으로 cross-sell 캠페인 진행 필요해보임

#군집분석을 활용한 고객세분화
cs2 <- cs1[, names(cs1) %in% c("days_purchase", "recency",
                               "num_books", "amt_books",
                               "unitprice_book", "amt_non_book",
                               "num_genre", "membership_period")]


kmm1 <- kmeans(cs2, 3)

table(kmm1$cluster)


# 고객집단을 표시할 색상을 임의로 지정
# 번호순의 색상 이름 벡터 생성
# 각 고객의 소속 집단이 어디인가에 따라 색상 표시
cols <- c("red", "green", "blue")
barplot(table(kmm1$cluster),
        names.arg=names(table(kmm1$cluster)),
        col=cols,
        main="군집별 고객수 분포")


# 구매빈도와 서적구매 장르 다양성 분포
plot(jitter(cs2$days_purchase),
     jitter(cs2$num_genre),
     col=cols[kmm1$cluster],
     pch=19,
     main="고객세분집단 프로파일 : 구매빈도와 서적구매 장르 다양성 분포",
     sub="Cl#1: red, Cl#2: green, Cl#3: blue")

####### 결과 : 서적구매 장르가 많으면 구매빈도수가 낮다. 장르를 간소화 시켜 빈도수를 높이는 방법이 효과적일 것이다.


#구매 빈도와 서적구매량대비 장르 다양성 분포
plot(jitter(cs2$days_purchase),
     jitter(cs2$num_genre/cs2$num_books),
     col=cols[kmm1$cluster],
     pch=19,
     main="고객세분집단 프로파일 : 구매빈도와 서적구매 장르 다양성 분포",
     sub="Cl#1: red, Cl#2: green, Cl#3: blue",
     ylab="서적구매량대비 구매장르수 비율")

####### 결과 : 구매빈도가 낮을수록 서적구매량대비 구매장르수 비율이 높다.
####### 따라서 구매빈도가 낮은 고객층에겐 다양한 장르의 서적을 추천하는 것이 매출을 올리는데 효과적일 것이다.
