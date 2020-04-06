#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# TEST
# ["제주도 여행코스 추천" 검색어 결과를 그래프로 표시]
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 단어추가(제주도여행지.txt) 를 읽어들인 후, dataframe 으로 변경하여 기존 사전에 추가
# 데이터 읽어오기(jeju.txt)
# 한글 외 삭제, 영어
# 읽어들인 데이터로부터 제거할 단어 리스트 읽어오기(제주도여행코스gsub.txt)
# 두 글자 이상인 단어만 추출
# 현재까지의 작업을 파일로 저장 후, 저장된 파일 읽기
# 단어 빈도 수 구한 후, 워드 클라우드 작업
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 가장 추천 수가 많은 상위 10개를 골라서
# 1. pie 그래프로 출력
# 2. bar 형태의 그래프로 표시하기
# 3. 옆으로 누운 바 그래프 그리기
# 4. 3D Pie Chart 로 표현 (plotrix라는 패키지가 추가로 필요)
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 필요 패키지 설치
install.packages("KoNLP")
install.packages("wordcloud")
install.packages("stringr")

useSejongDic()

# 단어추가(제주도여행지.txt) 를 읽어들인 후, dataframe 으로 변경하여 기존 사전에 추가
mergeUserDic(data.frame(readLines("./제주도여행지.txt"),"ncn"))

# 데이터 읽어오기(jeju.txt)
txt <- readLines("./jeju.txt")

place <- sapply(txt, extractNoun, USE.NAMES=F)
head(place, 10) #상위 10개 읽어오기
head(unlist(place), 30) #unlist 형태로 30개 읽어오기

# 한글 외 삭제, 영어
c <- unlist(place)
res <- str_replace_all(c, "[^[:alpha:]]", "") #알파벳으로 된 것들을 공백없는것으로 바꿔치기
res <- gsub(" ", "", res)
#[[:digit:]]  숫자 패턴 0,1,2,3,4,5,6,7,8,9 ( [0-9] 와 \d 동일 )
# [[^0-9]]   숫자가 아닌 패턴   (\D 와 동일)
# [[:lower:]] 영문 소문자 패턴
# [[:upper:]] 영문 대문자 패턴
# [[:alpha:]]  영문 패턴 (소 대 문자 구분X)
# [^[:alpha:]] 영문이 아닌 패턴
# [[:alnum:]] 영문&숫자 패턴  (* [[:alpha:][:digit:]]  대괄호로 감싸서 두 패턴 함께 이용 가능)
# [[:blank:]] 간격 문자열 패턴(space & tab)
# [[:space:]] 공백 문자열 패턴
# [[:punct:]] 구두점 문자열 패턴  ! " # $ % & ’ ( ) * + , - . / : ; < = > ? @ [  ] ^ _ ` { | } ~.
# [[:cntrl:]] \n \r 등의 제어 문자열 패턴
# [가-핳] 한글 문자열 패턴


# 읽어들인 데이터로부터 제거할 단어 리스트 읽어오기(제주도여행코스gsub.txt)
txt <- readLines("./제주도여행코스gsub.txt")
txt

cnt_txt <- length(txt)
cnt_txt

for(i in 1:cnt_txt){
  res <- gsub((txt[i]), "", res)
}

# 두 글자 이상인 단어만 추출
res2 <- Filter(function(x) {nchar(x) >=2}, res)
nrow(res2)

# 현재까지의 작업을 파일로 저장 후, 저장된 파일 읽기
write(res2, "./jeju2.txt")
res3 <- read.table("./jeju2.txt")

# 단어 빈도 수 구한 후, 워드 클라우드 작업
wordcount <- table(res3)
head(sort(wordcount, decreasing=T), 30)

library(RColorBrewer)
palete <- brewer.pal(8, "Set2")

wordcloud(names(wordcount),
          freq=wordcount,
          scale=c(3,1),
          rot.per=0.25,
          min.freq=5,
          random.order=F,
          random.color=F,
          colors=palete)
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 가장 추천 수가 많은 상위 10개를 골라서
# 1. pie 그래프로 출력
# 2. bar 형태의 그래프로 표시하기
# 3. 옆으로 누운 바 그래프 그리기
# 4. 3D Pie Chart 로 표현 (plotrix라는 패키지가 추가로 필요)
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# 차트그리기
# head(상위 10개 추출) 여행지 탑텐 저장(df)
top10 <- head(sort(wordcount, decreasing=T), 10)

pie(top10, init.angle=90, labels=label, main="제주도 추천 여행 코스 TOP 10")

# 색상 변경하여 출력
pie(top10, col=rainbow(10), radicus=1, main="제주도 추천 여행 코스 TOP 10")

# 수치값을 함께 출력
# 출력값 계산
pct <- round(top10/sum(top10) * 100, 1)
names(top10)

# 지명과 계산 결과를 합치기
lab <- paste(names(top10),"\n", pct, "%")

pie(top10,
    main="제주도 추천 여행 코스 TOP 10",
    col=rainbow(10),
    cex=0.8,
    labels=lab)

# bar 형태의 그래프 표시
bchart <- head(sort(wordcount, decreasing=T),10)
bchart

bp <- barplot(bchart,
              main="제주도 추천 여행 코스 TOP 10",
              col=rainbow(10),
              cex.names=0.7,
              las=2,
              ylim=c(0,25))

# 출력값 계산
pct <- round(bchart/sum(bchart) * 100, 1)

# 수치값 출력하기(%)
text(x=bp,
     y=bchart * 1.05,
     labels = paste("(", pct, "%", ")"),
     col="black",
     cex=0.7)

# 수치값 출력하기 (전)
text(x = bp,
     y = bchart * 9.5,
     labels = paste(bchart, "건"),
     col = "black",
     cex = 0.7)

# 옆으로 누운 바 그래프 그리기
barplot(bchart,
        main="제주도 추천 여행 코스 TOP 10",
        col=rainbow(10),
        xlim=c(0,25),
        cex.name=0.7,
        las=1,
        horiz=T)

# 수치값 출력(%)
text(y=bp,
     x=bchart * 1.15,
     labels=paste("(", pct, "%", ")"),
     col="black",
     cex=0.7)

# 수치값 출력(전)
text(y=bp,
     x=bchart * 0.9,
     labels=paste(bchart, "건"),
     col="black",
     cex=0.7)


# 3D Pie Chart 로 표현(plotrix 라는 패키지가 추가 필요)
install.packages("plotrix")
library(plotrix)

# 수치값 함께 출력
# 출력값 계산
th_pct <- round(bchart/sum(bchart) * 100, 1)

# 지명과 계산 결과 합하기
th_names <- names(bchart)
th_labels <- paste(th_names, "\n", "(", th_pct, ")")

pie3D(bchart,
      main="제주도 추천 여행 코스 TOP 10",
      col=rainbow(10),
      cex=0.3,
      labels=th_labels,
      explode=0.05)


#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# # 1. pie 그래프로 출력
# label <- names(top10)
# pie(top10, init.angle=90, labels=label, main="여행추천지 top10")
# 
# # 2. bar 형태의 그래프로 표시하기
# barplot(top10, names.arg=label, xlab="여행지", ylab="추천수", ylim=c(0,20), main="여행 추천지 top10")
# 
# # 3. 옆으로 누운 바 그래프 그리기
# barplot(top10, names.arg=label, main="여행 추천지 top10", col=rainbow(length(top10)),
#         xlab="추천수", ylab="여행지", horiz=TRUE, xlim=c(0,20), width=50)
# 
# # 4. 3D Pie Chart 로 표현 (plotrix라는 패키지가 추가로 필요)
# iinstall.packages("plotrix")
# library(plotrix)
# 
# pie3D(top10, labels=label, explode=0.1, labelcex=0.8, main="여행 추천지 top10")
