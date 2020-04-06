# 다운로드 사이트 : http://kostat.go.kr

# 작업 순서
# 1. 데이터 파일 읽기 : 6_101_DT_1B26001_A01_M.csv
# 2. '전국' 지역이 아닌 데이터만 추출
# 3. 행정구역 중 '구' 단위에 해당하는 행 번호 추출
# 4. '구' 지역 데이터 제외
# 5. 순이동 인구수가 0보다 큰지역 추출 
# 6. 단어(행정 구역) 할당
# 7. 워드클라우드 출력

# 1. 데이터 파일 읽기 : read.csv(file.choose(), header=T)
# 2. '전국' 지역이 아닌 데이터만 추출('전국' 지역 데이터 제외) :
# data2 <- data[data$행정구역.시군구.별 != "전국", ]
# 3. 행정구역 중 '구' 단위에 해당하는 행 번호 추출 : grep("구$", data2$행정구역.시군구.별)
# 4. '구' 지역 데이터 제외 : data3 <- data2[-c(x), ]
# 5. 순이동 인구수가 0보다 큰지역 추출 : data4 <- [data3$순이동.명>0, ]
# 6. 단어(행정 구역) 할당 : data4$행정구역.시군구.별
# 7. 행정구역별 빈도 : data4$순이동.명
# 8. 워드클라우드 출력 : wordcloud()

# 다운로드 사이트 : http://kostat.go.kr
# 1. 데이터 파일 읽기 : read.csv(file.choose(), header=T)
data <- read.csv(file.choose(), header=T) # 모든 괄호가 .으로 변경된다.
View(data)
head(data)
names(data) # 데이터의 컬럼 확인

# 데이터 정제 : 불필요 지역 제외
# '전국' 지역 제외
# ()가 R에서는 모두 .으로 바뀌어서 들어온다.
# 전체 데이터$컬럼명 중에서 != "전국" 데이터가 아닌 것만 모두 선택
data2 <- data[data$행정구역.시군구.별 != "전국", ]
head(data2)

# '구' 지역 데이터 제외
# grep함수 : 지정 조건에 맞는 행 번호를 벡터로 반환(x: 구 관련 행번호만 저장)
x <- grep("구$", data2$행정구역.시군구.별)
data3 <- data2[-c(x),] 
head(data3)

# 전입자 수가 많은 지역(이동인구수)
# data3중 순이동.명 컬럼 중 0보다 큰애들만 추출
data4 <- data3[data3$순이동.명>0, ]
head(data4)

# 행정구역명
word <- data4$행정구역.시군구.별
View(word)

#행정구역 이동숫자
frequency <- data4$순이동.명.
View(frequency)

library(wordcloud)
library(RColorBrewer)

pal2 <- brewer.pal(8, "Dark2")
wordcloud(word, frequency, colors=pal2)


# 워드클라우드작업을 위한 글자 데이터만 추출
stringvlaue <- data4$행정구역.시군구.별 


# 숫자값으로 작업할 숫자 데이터만 추출
intvlaue <- data4$순이동.명 