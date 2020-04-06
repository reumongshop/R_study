# 연설문의 단어에 대한 워드 클라우드 만들기
install.packages('rJava')
install.packages('stringr')
install.packages('hash')
install.packages('Sejong')
install.packages('RSQLite')
install.packages('devtools')

install.packages('tau')
install.packages("https://cran.r-project.org/src/contrib/Archive/KoNLP/KoNLP_0.80.2.tar.gz", repos = NULL, type="source")

install.packages("KoNLP")
install.packagees("RColorBrewer")
install.packages("wordcloud")

library(KoNLP)
library(RColorBrewer)
library(wordcloud)

useSejongDic()

pal2 <- brewer.pal(8,"Dark2")

text <- readLines(file.choose())
text

# extractNoun 이 명사를 찾아서 벡터로 저장하는 역할, sapply는 반환하는 역할
noun <- sapply(text, extractNoun, USE.NAMES=F)
noun

# 리스트 형태로 반환하기 힘들기 때문에 unlist 로 반환
# 리스트 형식을 -> 벡터 형식으로 바꿔주는 함수 : unlist
noun2 <- unlist(noun)
noun2

# p,221
word_count <- table(noun2)
word_count

# sort함수 : 정렬
head(sort(word_count, decreasing=TRUE), 10)

wordcloud(names(word_count),
          freq=word_count,
          scale=c(20, 0.3),
          min.freq=3, #최소 빈도수 3 이상인 데이터만 출력
          random.order=F, # 실행할 때마다 위치 변경
          rot.per=.1, # 회전
          colors=pal2)



