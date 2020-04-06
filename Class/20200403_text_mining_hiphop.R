# 텍스트마이닝(Text mining)
# 문자로 된 데이터에서 가치 있는 정보를 얻어내는 분석 기법
# sns 나 웹 사이트에 올라온 글을 분석해 사람들이 어떤 이야기를 나누고 있는지 파악할 때 활용
# 형태소 분석(Morphology Analysis) : 문장을 구성하는 어절들이 어떤 품사로 되어있는지 분석
# 분석 절차
# - 형태소 분석
# - 명사, 동사 형용사 등 의미를 지닌 품사 단어 추출
# - 빈도표 만들기
# - 시각화

#10-1. 힙합 기사 텍스트 마이닝
#텍스트마이닝 준비하기
#자바 다운로드 및 설치

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

#데이터 준비
txt <- readLines("hiphop.txt")
## Warning in readLines("hiphop.txt"):incomplete final line found on
## 'hiphop.txt'

head(txt)

#특수문자 제거
install.packages("stringr")
library(stringr)

#특수문자 제거
txt <- str_replace_all(txt, "\\W", " ") # 모든 특수기호를 찾아서 공백 처리
head(txt)
class(txt)
dim(txt)
View(txt)

#가장 많이 사용된 단어 알아보기
#명사 추출
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

#가사에서 명사 추출
nouns <- extractNoun(txt) #명사 형태를 추출하면 데이터타입 -> 리스트
head(nouns)
class(nouns)

#추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns)) #테이블이란 함수는 리스트 함수를 사용 못함 (unlist : 리스트 풀어놔야 리스트로 활용할 수 있음)
head(wordcount)
class(wordcount)

# 자주 사용된 단어 빈도표 만들기
df_word <- as.data.frame(wordcount, stringsAsFactors = F) # wordcount(스트링)의 팩터값을 없앤다, 데이터프레임으로 변환한다.
class(df_word) # data.frame
dim(df_word) # 3008 , 2
summary(df_word)
head(df_word)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2) # df_word 에서 word 컬럼 데이터 중에 글자의 개수가 2개 이상인 것만 filter로 걸러낸다.
class(df_word) # data.frame
dim(df_word) # 2508, 2
summary(df_word)

# 빈도수 높은 것을 내림차순 정렬하고 위에서부터 20개만 추출해서 top_20에 저장
top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

# 패키지 준비하기
# 패키지 설치
install.packages("wordcloud")

# 패키지 로드 (패키지 로드를 먼저 한 후 잘 로드되는지 확인 후 안되면 설치)
library(wordcloud)
library(RColorBrewer) #색상 팔레트

# 단어 색상 목록 만들기
pal <- brewer.pal(8,"Dark2") #Dark2 색상 목록에서 8개 색상 추출출

#워드 클라우드 생성
set.seed(1234) #난수 고정
wordcloud(words = top_20$word,    #단어
          freq = df_word$freq,    #빈도
          min.freq = 2,           #최소 단어 빈도
          max.words = 200,        #표현 단어 수
          random.order = F,       #고빈도 단어 중앙 배치
          rot.per = .1,           #회전 단어 비율
          scale = c(4, 0.3),      #단어 크기 범위
          colors = pal)           #색깔 목록


#---------------------------------------------------------
# 여고생 고민거리

text <- readLines("remake.txt")
head(text)
class(text)
dim(text)
View(text)

#특수문자 제거
text <- str_replace_all(txt, "\\W", " ") # 모든 특수기호를 찾아서 공백 처리
head(text)
class(text)
dim(text)
View(text)

# 텍스트 내용에서 명사 추출★
nouns <- extractNoun(text) #명사 형태를 추출하면 데이터타입 -> 리스트
head(nouns)
class(nouns)

#추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns)) #테이블이란 함수는 리스트 함수를 사용 못함 (unlist : 리스트 풀어놔야 리스트로 활용할 수 있음)
head(wordcount)
class(wordcount)

# 자주 사용된 단어 빈도표 만들기
df_word <- as.data.frame(wordcount, stringsAsFactors = F) # wordcount(스트링)의 팩터값을 없앤다, 데이터프레임으로 변환한다.
class(df_word) # data.frame
dim(df_word) # 3008 , 2
summary(df_word)
head(df_word)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2) # df_word 에서 word 컬럼 데이터 중에 글자의 개수가 2개 이상인 것만 filter로 걸러낸다.
class(df_word) # data.frame
dim(df_word) # 2508, 2
summary(df_word)

# 빈도수 높은 것을 내림차순 정렬하고 위에서부터 20개만 추출해서 top_20에 저장
top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

# 패키지 준비하기
# 패키지 설치
install.packages("wordcloud")

# 패키지 로드 (패키지 로드를 먼저 한 후 잘 로드되는지 확인 후 안되면 설치)
library(wordcloud)
library(RColorBrewer) #색상 팔레트

# 단어 색상 목록 만들기
pal <- brewer.pal(8,"Dark2") #Dark2 색상 목록에서 8개 색상 추출출

#워드 클라우드 생성
set.seed(1234) #난수 고정
wordcloud(words = top_20$word,    #단어
          freq = df_word$freq,    #빈도
          min.freq = 2,           #최소 단어 빈도
          max.words = 200,        #표현 단어 수
          random.order = F,       #고빈도 단어 중앙 배치
          rot.per = .1,           #회전 단어 비율
          scale = c(4, 0.3),      #단어 크기 범위
          colors = pal)           #색깔 목록


