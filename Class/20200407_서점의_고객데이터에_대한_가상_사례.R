########################################################
# 서점의 고객 데이터에 대한 가상 사례
# (탐색적인 분석과 고객세분화 응용 사례)
########################################################
# 작업 파일 : cust_seg_smpl_280122.csv
# --------------------------------------------------------
# 작업 내용
#--------------------------------------------------------
# 최종구매후기간 recency와 구매한 서적의 수간의 관계 확인
# 동일 좌표에 다수의 고객 존재 가능성이 있으므로 이를 처리

# 가설 1
# 보조선인 회귀선을 본다면 최근성이 낮을수록, 
# 즉 구매한지 오래되었을 수록 구매한 서적의 수가 많음

# 패키지 로드
library(rmarkdown)
library(knitr)

# 데이터 불러오기
book_data <- read.csv("../수업DATA/cust_seg_smpl_280122.csv")

# 데이터 확인
head(book_data)
names(book_data)

# 고객명 / 성별 / 연령 / 지역 / 구매일수 / 최종구매후기간 / 구매서적수 / 서적구매액 / 기타상품구매액 / 총구매액 / 관심장르 / 구매장르 / 가입기간 / SMS수신여부

# 컬럼명 변경
names(book_data) <- c("name", "sex", "age", "region", "recency", "buybooks", "money", "other_money", "total_money", "fav_type", "buy_type", "join_period", "sms_option")

# 최종 구매 후 기간 recency와 구매한 서적의 수간의 관계 확인
plot(book_data$recency, book_data$buybooks)

# 동일 좌표에 다수의 고객 존재 가능성이 있으므로 이를 처리
plot(jitter(book_data$recency), jitter(book_data$buybooks))

library(ggplot2)

ggplot(data=book_data,
       aes(x=recency, y=buybooks)) +
  geom_point()

# 가설 1
# 보조선인 회귀선을 본다면 최근성이 낮을수록, 
# 즉 구매한지 오래되었을 수록 구매한 서적의 수가 많음

# gsub함수로 쉼표 제거
book_data$recency <- as.numeric(gsub(",", "", as.character(book_data$recency)))
book_data$buybooks <- as.numeric(gsub(",", "", as.character(book_data$buybooks)))

# qplot(book_data)
# ml <- qplot(data=book_data, x=book_data$recency, y=book_data$buybooks)

plot(jitter(book_data$buybooks), jitter(book_data$recency))

# 파란 직선
abline(lm(book_data$buybooks~book_data$recency), col="blue", lwd=2, lty=1)


#------------------------------------------------------------------------------


