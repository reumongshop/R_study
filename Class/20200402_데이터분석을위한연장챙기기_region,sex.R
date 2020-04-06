#지역별 연령대 비율
#노년층이 많은 지역은 어디일까?
#분석절차
#1.변수 검토 및 전처리 : 지역, 연령대
#2.변수 간 관계 분석 : 지역별 연령대 비율표 만들기, 그래프 만들기
#지역(code_region)별 연령대 비율 분석하기
#1.서울 2.수도권(인천/경기) 3. 부산/경남/울산 4. 대구/경북 5. 대전/충남 6.강원/충북 7.광주/전남/전북/제주도

# 스택차트 : 포지션 값 없으면 생성됨

#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
# #패키지 준비
install.packages("foreign") #foreign 패키지 설치
library(foreign) # SPSS 파일 로드
library(dplyr) # 전처리
library(ggplot2) #시각화
library(readxl) # 엑셀 파일 불러오기

#데이터 불러오기
raw_welfare <- read.spss(file="Koweps_hpc10_2015_beta1.sav", to.data.frame=T)
head(raw_welfare)

#복사본 만들기
welfare <- raw_welfare
dim(welfare) #몇행 몇열
summary(welfare)

# 데이터 검토
head(welfare)
tail(welfare)
View(welfare)
str(welfare)
summary(welfare)
dim(welfare)

welfare <- rename(welfare,
                  sex=h10_g3,
                  birth=h10_g4,
                  marriage=h10_g10,
                  religion=h10_g11,
                  income=p1002_8aq1,
                  code_job=h10_eco9,
                  code_region=h10_reg7)
names(welfare)
arrange(welfare)
head(welfare)

#지역별 연령대 비율
#변수 검토 및 전처리 - birth
#1.변수 검토하기
class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)

# 이상치 확인
summary(welfare$birth)
# 결측치 확인
table(is.na(welfare$birth))

#이상치 결측 처리
welfare$birth <- ifelse(welfare$birth == 9999,NA,welfare$birth)
table(is.na(welfare$birth))

#파생변수 만들기 - 나이
welfare$age <- 2015 - welfare$birth +1 #2014년에 조사한 데이터를 2015년에 발견해서 +1
summary(welfare$age)

qplot(welfare$age)

#연령대에 따른 월급 차이
#분석 절차
#1.변수 검토 및 전처리 : 연령대, 월급
#2. 변수 간 관계 분석 : 연령대별 월급 평균표 만들기, 그래프 만들기
welfare <- welfare %>%
  mutate(ageg = ifelse(age<30, "young",
                       ifelse(age <= 59, "middle", "old")))

table(welfare$ageg)
qplot(welfare$ageg)


#변수 검토 및 전처리 - region
class(welfare$code_region)
table(welfare$code_region)

#지역 코드 목록 만들기
list_region <- data.frame(code_region = c(1:7),
                          region = c("서울",
                                     "수도권(인천/경기)",
                                     "부산/경남/울산",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주도"))

list_region

#지역명 변수 추가
welfare <- left_join(welfare, list_region, id="code_region")

welfare %>%
  select(code_region, region) %>%
  head


# 지역별 연령대 비율표 만들기
region_ageg <- welfare %>%
  group_by(region, ageg) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 2))

head(region_ageg)

ggplot(data=region_ageg, aes(x=region,y=pct,fill=ageg))+
  geom_col()+
  coord_flip()

#노년층 비율 높은 순으로 막대 정렬
#노년층 비율 오름차순 정렬
list_order_old <- region_ageg %>% 
  filter(ageg == "old") %>% 
  arrange(pct)

list_order_old

#지역명 순서 변수 만들기
order <- list_order_old$region

#막대가 노년층 비율이 높은 순으로
ggplot(data=region_ageg,aes(x=region,y=pct,fill=ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits=order)

#연령대 순 막대색상 나열
#초년, 중년, 노년 연령대순으로 나열
class(region_ageg$ageg)

levels(region_ageg$ageg)
region_ageg$ageg <- factor(region_ageg$ageg,
                           level=c("old","middle","young"))
class(region_ageg$ageg)
levels(region_ageg$ageg)

ggplot(data=region_ageg, aes(x=region,y=pct,fill=ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits=order)
