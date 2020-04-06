# [R] 파싱하여 데이터 가져오기
# 웹에서 문자열 가져오기
# REVEST 패키지의 READ_HTML("url");

# html 파싱
# 특정 노드의 데이터 가져오기
# 문자열에서 html_nodes(태그 / 클래스 / 아이디)를 이용하면
# 매개변수에 해당하는 모든 데이터를 가져온다
# 마지막 데이터까지 가져온 경우
# html_text() 메소드나 html_attr(속성명)을 이용

# 네이버 실제 기사 읽어오기
# read_html("") 쓸 때 프로토콜부터 써야함

# 테이블 내용은 html_table() 메소드로
# 테이블 데이터를 프레임으로 바로 변환해준다

# %>% 은 메소드의 연산결과를 가지고 다음 메소드를 호출 할 때 사용하는
# chain operation 연산자이다.
install.packages("rvest")
library("rvest")

naver <- read_html("http://www.naver.com")
naver


#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 네이버 팟 캐스트 클로링
# 크롤링을 할 때 가장 중요한 것은
# 원하는 부분을 구분할 수 있는 태그, 클래스, 아이디를 찾아내는 일
# 고려해야할 또 하나의 부분은
# 현재 페이지에 원하는 데이터가 있는지 아니면
# 링크만 존재하는지 확인하는 것

# 크롤링 코드는 매번 변경될 수 있음(확인해야함)

# 1. 웹에서 데이터를 가져오기 위한 패키지 설치
install.packages("rvest")

# 2. 패키지 메모리 로드
library("rvest")

# 3. 문자열을 가지고 올 주소를 생성
url <- "http://tv.naver.com/r/category/drama"

# 4. 문자열 다운로드
cast <- read_html(url)

# 5. 문자열 확인
cast

# 6. span 안에 내용들이 출력
# 실제 웹사이트에서 데이터 확인시 .tit 검색!
craw <- cast %>% html_nodes(".tit") %>% html_nodes('span')
craw

# 7. tit 클래스 안에 있는 span 안에 내용 가져오기
craw <- cast %>% html_nodes(".tit") %>% html_nodes('span') %>% html_test()
craw

# 8. tooltip 태그 안의 내용 가져오기
craw <- cast %>% html_nodes("tooltip") %>% html_text()
craw

#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 한겨레 신문에서 데이터를 검색한 후
# 검색 결과를 가지고 워드 클라우드 만들기

# 한겨레 신문사에서 지진으로 뉴스 검색하는 경우
# url
# http://search.hani.co.kr/Search?command=query&keyword=%EC%A7%80%EC%A7%84%sort=d&period=all%media=news

# http://search.hani.co.kr/Search? => Search? : url 패턴명
# command=query&
# keyword=%EC%A7%80%EC%A7%84& => keyword : 검색어부분
# sort=d&
# period=all&
# media=news

# 기사 검색이나 SNS 검색을 하는 경우
# 검색어를 가지고 검색하면 그 결과는 검색어를 가진 URL의 모임이다
# 기사나 SNS 글이 아니다

# 검색결과에서 URL을 추출해서 그 URL의 기사 내용을 다시 가져와야 함
# dt 태그 안에 있는 a 태그의 href 속성 값이 실제 기사의 링크이다
# 실제 기사에서 클래스가 text 안에 있는 내용이 기사 내용이다

# 1. 기존의 변수를 모두 제거 - remove함수 : rm()
rm(list=ls()) 

# 2. 필요한 패키지 설치
install.packages("stringr")
install.packages("wordcloud")
install.packages("wordcloud2") # 워드클라우드2 중 선택해서 사용
install.packages("KoNLP")
install.packages("dplyr")
install.packages("RColorBrewer")
install.packages("rvest") # 실제 크롤링할 때 필요한 패키지

# 3. 필요한 패키지 로드
library(stringr) # 문자열 조작하는 전문 패키지
library(wordcloud) # 시각화 작업시 필요한 패키지
library(wordcloud2) # 시각화 작업시 필요한 패키지
library(KoNLP) # 명사 추출, 사전을 포함한 패키지 
library(dplyr) # 데이터프레임 조작(수정, 합하기)하기 위한 전용 패키지
library(RColorBrewer) # 컬러팔레트, 색상에 관련된 패키지 (시각화)
library(memoise) 

# 웹에서 문자열 가져와서 html 파싱하기 위한 패키지 로드
library(rvest)

# 4. 기사 검색 url 생성
url <- 'http://search.hani.co.kr/Search?command=query&keyword=%EC%A7%80%EC%A7%84&sort=d&period=all&media=news'

# 5. url에 해당되는 데이터 가져오기
k <- read_html(url, encoding="utf-8")

# 6. dt 태그 안에 있는 a 태그 들의 href 속성의 값 가져오기
k <- k %>% html_nodes("dt") %>% html_nodes("a") %>% html_attr("href")
k

# 7. k에 저장된 모든 URL에 해당하는 데이터의 클래스가 text인 데이터를 읽어서 파일에 저장
# for(임시변수 in 컬렉션이름){} ★★★★★

for(addr in k){
  temp <- read_html(addr) %>% html_nodes(".text") %>% html_text()
  cat(temp, file="temp.txt", append=TRUE)
}

# 8. 파일의 모든 내용 가져오기
txt <- readLines("temp.txt")
head(txt)

# 9. 명사만 추출
useNIADic()
nouns <-extractNoun(txt)
nouns # 세종 사전보다 훨씬 많은? nouns 딕셔너리 사용

# 10. 빈도수 만들기 - 각 단어가 몇번씩 나왔는지
wordcount <- table(unlist(nouns))
wordcount

# 11. 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word
class(df_word) # data.frame

# 12. 필터링
df_word <- filter(df_word, nchar(Var1) >= 2)

# 13. 워드클라우드 색상 판 생성
pal <- brewer.pal(8, "Dark2")

# 14. 시드 설정
set.seed(1234)

# 15. 워드 클라우드 생성
wordcloud(words = df_word$Var1,
          freq = df_word$Freq,
          min.freq = 2, max.word=200,
          random.order = F,
          rot.pet = .1, scale = c(4, 0.3), colors = pal)


#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 코로나 기사 읽어오기

# http://search.hani.co.Kr/Search?command=query&keyword=코로나19&sort=d&period=all&media=magazine
# http://search.hani.co.Kr/Search?
# command=query&
# keyword=코로나19&
# sort=d&
# period=all&
# media=magazine

# &media=news
# &media=magazine
# &media=common

# 1. 기사 검색 url 생성
url <- 'http://search.hani.co.kr/Search?command=query&keyword=%EC%BD%94%EB%A1%9C%EB%82%98&media=news&submedia=&sort=d&period=all&datefrom=2000.01.01&dateto=2020.04.06&pageseq=4'

# 2. url에 해당되는 데이터 가져오기
a <- read_html(url, encoding="utf-8")

# 3. dt 태그 안에 있는 a 태그 들의 href 속성의 값 가져오기
a <- a %>% html_nodes("dt") %>% html_nodes("a") %>% html_attr("href")
a

# 4. k에 저장된 모든 URL에 해당하는 데이터의 클래스가 text인 데이터를 읽어서 파일에 저장
# for(임시변수 in 컬렉션이름){} ★★★★★
for(addr in a){
  temp <- read_html(addr) %>% html_nodes(".text") %>% html_text()
  cat(temp, file="temp2.txt", append=TRUE)
}

# 5. 파일의 모든 내용 가져오기
txt <- readLines("temp2.txt")
head(txt)

# 6. 명사만 추출
useNIADic()
nouns <-extractNoun(txt)
nouns # 세종 사전보다 훨씬 많은? nouns 딕셔너리 사용

# 7. 빈도수 만들기 - 각 단어가 몇번씩 나왔는지
wordcount <- table(unlist(nouns))
wordcount

# 8. 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word
class(df_word) # data.frame

# 9. 필터링
df_word <- filter(df_word, nchar(Var1) >= 2)

# 10. 워드클라우드 색상 판 생성
pal <- brewer.pal(8, "Dark2")

# 11. 시드 설정
set.seed(1234)

# 12. 워드 클라우드 생성
wordcloud(words = df_word$Var1,
          freq = df_word$Freq,
          min.freq = 2, max.word=200,
          random.order = F,
          rot.pet = .1, scale = c(4, 0.3), colors = pal)

#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 코로나 기사 읽어오기
#########################################
library("rvest")

# 1. 기사 검색하기
# 2. 기사 링크 가져오기
# 3. 링크를 출력하기
# 4. addr의 모든 내용을 순회하면서 기사 내용을 article.txt에 저장
# 5. 파일의 모든 내용 가져오기
# 6. 명사만 추출
# 7. 빈도수 만들기 - 각 단어가 몇번씩 나왔는지
# 8. 데이터 프레임으로 변환
# 9. 필터링
# 10. 워드클라우드 색상 판 생성
# 11. 시드 설정
# 12. 워드 클라우드 생성 

# 기사 검색 URL 
# 
# http://news.donga.com/search?
#   p=1&
#   query=코로나19&
#   check_news=1&
#   more=1&
#   sorting=1&
#   search_date=1&
#   v1=&
#   v2=&
#   range=1

library("rvest")

# 1. 기사 검색하기
url <- "http://news.donga.com/search?p=1&query=코로나19&check_news=1&more=1&sorting=1&search_date=1&v1=&v2=&range=1"
url

link <- read_html(url)
link

# 2. 기사 링크 가져오기
addr <- link %>% html_nodes(".t") %>% html_nodes(".tit") %>% html_nodes("a") %>% html_attr("href")
addr

# 3. 링크를 출력하기
for(url in addr){
  print(url)  #url에 있는 기사들을 모아서 파일에 저장
}


# 4. addr의 모든 내용을 순회하면서
# 기사 내용을 article.txt에 저장
for(url in addr){
  # url에 있는 기사들을 모아서 파일에 저장
  # article_txt 클래스에 있는 내용만 저장하기
  content = read_html(url) %>% html_nodes(".article_txt") %>% html_text()
  # print(content)
  
  # 저장하기
  cat(content,file="article.txt", append = T)
}

content

# 5. 파일의 모든 내용 가져오기
txt <- readLines("article.txt")
head(txt)

# 6. 명사만 추출
useNIADic()
nouns <- extractNoun(txt)
nouns

# 7. 빈도수 만들기 - 각 단어가 몇번씩 나왔는지
wordcount <- table(unlist(nouns))
wordcount

# 8. 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word 
class(df_word)

# 9. 필터링
df_word <- filter(df_word, nchar(Var1) >= 2)

# 10. 워드클라우드 색상 판 생성
pal <- brewer.pal(8, "Dark2")

# 11. 시드 설정
set.seed(1234)

# 12. 워드 클라우드 생성 
wordcloud(words = df_word$Var1,
          freq=df_word$Freq,
          min.freq = 2, max.words=200, 
          random.order=F,
          rot.per=.1, scale=c(4, 0.3), colors=pal)

#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# R 키보드 이용한 데이터 입력
# c() 함수를 이용한 데이터 입력
x <- c(10.4, 5, 6, 3.1, 6.4, 21.7)
x

# scan() 함수는 외부의 텍스트파일을 불러올 때 외에도
# 키보드 입력에도 이용할 수 있는 함수이며,
# 일반적으로 R Console 에서 프롬프트가 [1]과 같이 보여지나
# scan() 함수를 실행할 경우는 '1:'과 같은 형태로 출력된다.

# scan() 함수 이용
x <- scan()

# console에서 입력
# 1: 24
# 2: 75
# 3: 36
# 4: 
#   Read 3 items
x

# 문자열 입력받고 싶을 때
x <- scan(what=" ")
# 1: Actor
# 2: Actress
# 3: Hero
# 4: Heroine
# 5: 
#   Read 4 items
x

# edit() 함수는 데이터 편집기 창을 직접 띄워 데이터를 직접 입력하는 방식으로
# 편집기는 셀의 형식을 띠고 있으며, 각 셀에 데이터를 입력한 후 수정할 경우는
# 메뉴에서 <편집> - <데이터 편집기> 를 선택하여 수정할 수 있다.

# edit() 함수를 이용하여 데이터 입력기 호출한 후 데이터를 입력한다.

age = data.frame()
age = edit(age)
age

library(KoNLP)
library(wordcloud)
library(stringr)

useSejongDic()

# 정규표현식 예
text <- c("phone: 010-1234-5678",
          "home: 02-123-1234",
          "이름: 아벨이")

grep("[[:digit:]]", text, value=T) # digit : 숫자
