#------------------------------------------------------------------
# install.packages("wordcloud2")
# library(wordcloud2)
# wordcloud2(data=wordcount, word="아름", wordsize=1, fontFamily='나눔바른고딕')

# 국정원 트윗 텍스트 마이닝
# * 국정원 계정 트윗 데이터
# - 국정원 대선 개입 사실이 밝혀져 논란이 됐던 2013년 6월, 독립 언론 뉴스타파가 인터넷을 통해
# - 국정원 계정으로 작성된 3744개의 트윗

#패키지 로드
library(rJava)
library(memoise)
library(KoNLP)
##Checking user defined dictionary!
library(dplyr)


#패키지 설치
install.package("rJava")
install.packages("memoise")
install.packages("KoNLP")
install.packages("dplyr")

#패키지 로드 에러 발생할 경우 -java 설치 경로 확인 후 경로 설정
#java 폴더 경로 설정
#Sys.setenv(JAVA_HOME="C:/ProgramFiles/Java/jre)

#사전 설정하기
useNIADic()
#Backup was jsust finished!
##9830122 words dictionary was built

#데이터 로드
twitter <- read.csv("twitter.csv",
                    header=T,
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8")

#변수명 수정
twitter <- rename(twitter,
                  no=번호,
                  id=계정이름,
                  date=작성일,
                  tw=내용)

#특수문자 제거
install.packages("stringr")
library(stringr)

#특수문자 제거
twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")

#단어 빈도표 만들기
#트윗에서 명사추출
nouns <- extractNoun(twitter$tw)

#추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns)) #테이블이란 함수는 리스트 함수를 사용 못함 (unlist : 리스트 풀어놔야 리스트로 활용할 수 있음)

#데이터프레임으로 변환
df_word <- as.data.frame(wordcount, stringAsFactors=F)

#변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 상위 40개, 단어 3글자 이상
#단어 빈도 막대 그래프 만들기
library(ggplot2)

#3글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 3) # df_word 에서 word 컬럼 데이터 중에 글자의 개수가 3개 이상인 것만 filter로 걸러낸다.
# 오류 : Error in nchar(word) : 'nchar()' requires a character vector
# 반환이 문자로 반환되어야 한다
class(df_word$word) # 타입 확인하고
df_word$word <- as.character(df_word$word) # 문자형으로 변환하고
class(df_word$word) #타입 확인해서 위에 3글자 이상 단어 추출 부분 다시 실행

# 빈도수 높은 것을 내림차순 정렬하고 위에서부터 40개만 추출해서 top_40에 저장
top_40 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(40)

order <- arrange(top_40,freq)$word            #빈도 순서 변수 생성

ggplot(data = top_40,aes(x = word, y = freq))+
  ylim(0,2500)+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limit = order)+
  geom_text(aes(label=freq),hjust = -0.3)

library(devtools)
library(htmlwidgets)
library(htmltools)
library(jsonlite)
library(yaml)
library(base64enc)
install.packages("tm")
library(tm)
library(wordcloud2)

#특정 개수 이상 추출되는 글자만 색깔을 변경하여 나타나도록...
#https://html-color-codes.info/Korean/

#워드 클라우드2 그리기 (기본)
wordcloud2(top_40)

#워드클라우드2 크기, 색 변경(size,color)
wordcloud2(top_40, size=0.5, col = "random-dark")

#키워드 회전 정도 조절(rotateRatio)
wordcloud2(top_40, size=0.5, col="random-dark", rotateRatio=0)

#배경색 검정(backgroundColor)
wordcloud2(top_40, size=0.5, col="random-light", backgroundColor = "black")

#사이값 지정시 : (weight > 800 && weight <1000)
# 100개 이상 검색될 시 노랑, 아니면 초록으로 표현
In_out_colors = "function(word, weight){
                    return(weight > 100) ? '#F3EF12':'#1EC612'}"

#wordcloud2 그리기
library(wordcloud2)

#기존모형으로 wordcloud2 생성
#모양선택 : shape = 'circle','cardioid', 'diamond','triangle-forward',
#           'triangle','pentagon','star'

wordcloud2(df_word,
           shape='circle',
           size=0.8,
           color=htmlwidgets::JS(In_out_colors),
           backgroundColor="black")

# 키워드 회전 정도 조절(rotateRatio)
wordcloud2(top_40, size=0.5, col="random-dark", rotateRatio=0)

#단계 구분도(Choropleth Map)
# - 지역별 통계치를 색깔의 차이로 표현한 지도
# - 인구나 소득 같은 특성이 지역별로 얼마나 다른지 쉽게 이해할 수 있음

#미국 주별 강력 범죄율 단계 구분도 만들기
#패키지 준비
install.packages("ggiraphExtra")
library(ggiraphExtra)

#내장 데이터셋 구조 확인
str(USArrests)
head(USArrests)
library(tibble)

#행 이름을 state변수로 바꿔 데이터 프레임 생성
crime <- rownames_to_column(USArrests, var="state")

#지도 데이터와 동일하게 맞추기 위해 state의 값을 소문자로 수정
crime$state <- tolower(crime$state)

#tibble(티블)은 행 이름을 가질 수 있지만(예:일반 데이터 프레임에서 변환할 때)
#연산자로 서브 셋팅할 때 제거됩니다
#null이 아닌 행 이름을 티블에 지정하려고 하면 경고가 발생합니다
#일반적으로 행 이름은 기본적으로 다른 모든 열과 의미가 다른 문자 열이므로 행 이름을
#사용하지 않는 것이 가장 좋습니다
#이러한 함수를 사용하면
#데이터프레임에 행이름(has_rownames())이 있는지 감지하거나,
#제거하거나(remove_rownames())
#명시적 열(rownames_to_column()및 column_to_rownames())사이에서 앞뒤로 변환 할 수 있습니다.
#rowid_to_column()도 포함되어 있습니다
#이것은 1부터 시작하여 순차적인 행 id를 오름차순으로 하는 데이터 프레임의 시작 부분에
# 열을 추가합니다. 기존 행 이름이 제거됩니다.

#미국 주 지도 데이터 준비
install.packages("maps")
library(ggplot2)
states_map <- map_data("state")
str(states_map)

install.packages("mapproj")
library(mapproj)

#단계 구분도 만들기
ggChoropleth(data=crime, #지도에 표현할 데이터
             aes(fill=Murder, #색깔로 표현할 변수
                 map_id=state), #지역 기준 변수
             map=states_map) #지도데이터

#인터랙티브 단계 구분도 만들기
ggChoropleth(data=crime,
             aes(fill=Murder,
                 map_id=state),
              map=states_map,
              interactive=T)

#대한민국 시도별, 인구, 결핵 환자 수 단계 구분도 만들기
#대한민국 시도별 인구 단계 구분도 만들기
#패키지 준비하기
install.packages("stringi")
install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)

#대한민국 시도별 인구 데이터 준비
str(changeCode(korpop1))

library(dplyr)
korpop1 <- rename(korpop1,
                  pop = 총인구_명,
                  name = 행정구역별_읍면동)
str(changeCode(kormap1))

ggChoropleth(data=korpop1, #지도에 표현할 데이터
             aes(fill=pop, #색깔로 표현할 변수
                 map_id=code, #지역 기준 변수
                 tooltip=name), #지도 위에 표시할 지역명
             map=kormap1, #지도 데이터
             interactive=T) #인터랙티브

#대한민국 시도별 결핵 환자 수 단계 구분도 만들기
str(changeCode(tbc))

ggChoropleth(data=tbc, #지도에 표현할 데이터
             aes(fill=NewPts, #색깔로 표현할 변수
                 map_id=code, #지역 기준 변수
                 tooltip=name),#지도 위에 표시할 지역명
             map=kormap1, #지도데이터
             interactive=T) #인터랙티브

#인터랙티브 그래프
#plotly패키지로 인터랙티브 그래프 만들기
#패키지 준비
install.packages("plotly")
library(plotly)

#ggplot으로 그래프 만들기
library(ggplot2)
p <- ggplot(data=mpg, aes(x=displ, y=hwy, col=drv)) + geom_point()
ggplotly(p)

#인터랙티브 막대 그래프 만들기
p <- ggplot(data=diamonds, aes(x=cut, fill=clarity)) + geom_bar(position = "dodge")
ggplotly(p)

#dygraphs 패키지로 인터랙티브 시계열 그래프 만들기
# 패키지 준비
install.packages("dygraphs")
library(dygraphs)

# 데이터 준비
economics <- ggplot2::economics
head(economics)

#시간 순서 속성을 지니는 xts 데이터 타입으로 변경
library(xts)
eco <- xts(economics$unemploy, order.by=economics$date)
head(eco)

#그래프생성
dygraph(eco)

#날짜 범위 선택 가능
dygraph(eco) %>% dyRangeSelector()

#여러값 표현
#저축률
eco_a <- xts(economics$psavert, order.by = economics$date)

#실업자수
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)

#합치기
eco2 <-cbind(eco_a, eco_b) #데이터 결합
colnames(eco2) <- c("psavert", "unemploy") #변수명 바꾸기
head(eco2)

#그래프 만들기
dygraph(eco2) %>%  dyRangeSelector()

#통계적 가설 검정
#기술통계와 추론 통계
#기술통계(Descriptive statistics)
#-데이터를 요약해 설명하는 통계 기법
#-ex) 사람들이 받는 월급을 집계해 전체 월급 평균 구하기
#추론 통계(Inferential statistics)
#- 단순히 숫자를 요약하는 것을 넘어 어떤 값이 발생할 확률을 계산하는 통계 기법
#- ex) 수집된 데이터에서 성별에 따라 월급 차이가 있는 것으로 나타났을 때,
#이런 차이가 우연히 발생할 확률 계산

#이런 차이가 우연히 나타날 확률이 작다
# -> 성별에 따른 월급차이가 통계적으로 유의하다(statistically significant)고 결론
#이런 차이가 우연히 나타날 확률이 크다
# -> 성별에 따른 월급차이가 통계적으로 유의하지 않다(not statistically significant)고 결론
# - 기술 통계 분석에서 집단 간 차이가 있는 것으로 나타났더라도 이는 우연에 의한 차이일 수 잇음
# -- 데이터를 이용해 신뢰할 수 있는 결론을 내리려면 유의확률을 계산하는 통계적 가설 검정 절차를 거쳐야 함

# 통계적 가설 검정
# 1) 통계적 가설 검정(Statistical hypothesis test)
# - 유의 확률을 이용해 가설을 검정하는 방법
# 2) 유의 확률(Significance probability, p-value)
# - 실제로는 집단 간 차이가 없는데 우연히 차이가 있는 데이터가 추출될 확률
# - 분석 결과 유의확률이 크게 나타났다면
# --> 집단 간 차이가 통계적으로 유의하지 않다고 해석
# --> 실제로 차이가 없더라도 우연에 의해 이 정도의 차이가 관찰될 가능성이 크다는 의미
# - 분석 결과 유의확률이 작게 나타났다면
# --> 집단 간 차이가 통계적으로 유의하다고 해석
# --> 실제로 차이가 없는데 우연히 이 정도의 차이가 관찰될 가능성이 작다, 우연이라고 보기 힘들다는 의미

# t검정-  두 집단의 평균 비교
# t 검정(t-test)
# - 두 집단의 평균에 통계적으로 유의한 차이가 있는지 알아볼 때 사용하는 통계 분석 기법

# compact 자동차와 suv 자동차의 도시 연비 t 검정
# 데이터 준비
mpg <- as.data.frame(ggplot2::mpg)
str(mpg)

library(dplyr)

mpg_diff <- mpg %>%
  select(class, cty) %>% #전체 데이터를 갖고 있는 mpg를 이용하여 두가지 컬럼 값을 선택
  filter(class %in% c("compact","suv")) #filter : 행 선택 // %in% : 값 매칭 추출해주는 연산

head(mpg_diff)

#테이블 함수로 compact, suv 몇 대 있는지 확인
table(mpg_diff$class)

# t-test
t.test(data=mpg_diff, cty~class, var.equal=T)
#p-value : 유의확률값
#mean in group compact : compact 에 대한 평균값
#mean in group suv : suv에 대한 평균값
#alternative hypothesis: true difference in means is not equal to 0
# : 대립가설이 0과 같지 않다면 평균값 신뢰 불가
#95 percent confidence interval : 유의한 값 / 신뢰기간이 5.525180~7.730139

# 일반 휘발유와 고급 휘발유의 도시 연시 t 검정
# 데이터 준비
mpg_diff2 <- mpg %>% 
  select(fl, cty) %>%  #휘발유 컬럼과 도시연비를 뽑아냄
  filter(fl %in% c("r","p")) #r:regular(일반휘발유), p:premium(고급휘발유)

table(mpg_diff2$fl) # 일반휘발유 : 168, 고급휘발유 : 52

t.test(data=mpg_diff2, cty~fl, var.equal = T)
# 연비 차이가 별로 나지 않아, 굳이 고급 휘발유를 넣을 필요x

#상관분석 - 두 변수의 관계성 분석 (변수 : R에서는 컬럼명)
#상관분석(Correlation Analysis)
#- 두 연속 변수가 서로 관련이 있는지 검정하는 통계 분석 기법
#- 상관계수(Correlation Coefficient)
#   --> 두 변수가 얼마나 관련되어 있는지, 관련성의 정도를 나타내는 값
#   --> 0~1 사이의 값을 지니고 1에 가까울수록 관련성이 크다는 의미
#   --> 상관계수가 양수면 정비례, 음수면 반비례 관계

# 상관관계 예시
# cctv와 범죄발생율 상관관계
# 복지 패널 데이터를 이용해 급여와 우리 삶에 관한 상관관계
# 종교와 이혼율에 상관관계

#실업자 수와 개인 소비 지출의 상관관계
#데이터 준비
economics <- as.data.frame(ggplot2::economics)

#상관분석
cor.test(economics$unemploy, economics$pce) #실업자수와 개인소비지출의 상관관계

#상관행렬 히트맵 만들기
#상관행렬(Correlation Matrix)
# - 여러 변수 간 상관계수를 행렬로 나타낸 표
# - 어떤 변수끼리 관련이 크고 적은지 파악할 수 있음

#데이터준비
head(mtcars) #내장데이터 mtcars 이용

#상관행렬 만들기 ★★★ 이 내용을 잘 알고 있어야 파이썬 딥러닝에서 image 분석이 들어감 - 텐서플로우
car_cor <- cor(mtcars) #상관행렬 생성
head(car_cor) #먼저 데이터 확인 후 round 작업 해주기

round(car_cor, 2) #소수점 셋째 자리에서 반올림해서 출력

#상관행렬 히트맵 만들기
#히트맵(heat map):값의 크기를 색깔로 표현한 그래프
# // 전달된 값에 따라 색깔의 농도를 정해주는 게 특징
install.packages("corrplot")
library(corrplot)

corrplot(car_cor)

#원 대신 상관계수 표시 / 원이 아닌 숫자값으로 출력하고 싶을시
corrplot(car_cor, method="number")

#다양한 파라미터 지정하기 / 원도 상관계수도 아닌, 색상으로 네모칸 채우고 싶을 때
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
#색상 팔레트로 색상 직접 지정 / 색상 팔레트 만들시 색상 하나는 있어야함
#얘네가 만들어낸 다섯가지 색상을 지정해주고 그 사이사이는 200가지 색상이 들어감

corrplot(car_cor,
         method="color",      #색깔로 표현
         col = col(200),      #색상 200개 선정
         type="lower",        #왼쪽 아래 행렬만 표시
         order = "hclust",    #유사한 상관계수끼리 군집화
         addCoef.col="black", #상관계수 색깔
         tl.col="black",      #변수명 색깔
         tl.srt=45,           #변수명 45도 기울임
         diag=F)              #대각 행렬 제외


