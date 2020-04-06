#install_github() 사용을 위한 devtools 설치 및 로드
install.packages("devtools")
library(devtools)

#github에서 ggmap 패키지 설치 및 로드
install_github("dkahle/ggmap")

#또는 install.packages("ggmap")
library(ggmap)

#dplyr패키지 설치 및 로드
install.packages("dplyr")
library(dplyr)

#-------------------------------------------------------
#--------------------과 제 -----------------------------
#-------------------------------------------------------
#서울시 범죄율에 대한 지도 시각화

#파일 불러오기
crime_address_data <- read.csv("crime_in_Seoul_address.csv")
head(crime_address_data)

crime_data <- read.csv("crime_in_Seoul.csv")
head(crime_data)

# 속성 확인
names(crime_data)
dim(crime_data)
str(crime_data)

names(crime_address_data)
dim(crime_address_data)
str(crime_address_data)

# 복사본 만들고 테스트
c_data <- crime_data
add_data <- crime_address_data

# 널값 확인하기
sum(is.na(c_data))
sum(is.na(add_data))

#------------------------------------------------
# 관서 좌표 정보 구하기
# as.character() 함수로 문자형으로 변환한 후 crime_code에 할당
add_code <- as.character(add_data$"주소")

# google api key 등록
googleAPIkey <- "AIzaSyBiV7Q9ZswJ9QmsBOE6oZ2ls1iGIavXXSo"
register_google(googleAPIkey)

# geocode() 함수로 crime_code 값을 위도와 경도로 변환
add_code <- geocode(add_code)
head(add_code)

add_code <- as.character(add_data$"주소") %>%  enc2utf8() %>% geocode()
head(add_code) 

#관서명, 주소, 위도, 경도 합친 값
add_code_final <- cbind(add_data, add_code)
head(add_code_final)

c_data$절도.발생 <- gsub(",", "", c_data$절도.발생)
c_data$절도.검거 <- gsub(",", "", c_data$절도.검거)
c_data$폭력.발생 <- gsub(",", "", c_data$폭력.발생)
c_data$폭력.검거 <- gsub(",", "", c_data$폭력.검거)

# 쉼표(,) 찍힌 부분 제거 확인
head(c_data) 
# char로 바뀐 거 확인
str(c_data)

c_data_occur <- c_data %>% 
  mutate(crime_sum = 살인.발생+강도.발생+강간.발생+ as.integer(c_data$절도.발생)+ as.integer(c_data$폭력.발생),
         catch_sum = 살인.검거+강도.검거+강간.검거+ as.integer(c_data$절도.검거)+ as.integer(c_data$폭력.검거),
         catch_ratio = (catch_sum/crime_sum)*100,
         
  )

head(c_data_occur) # 범죄건수, 검거건수, 검거율 확인

c_data_final <- cbind(as.data.frame(c_data_occur$관서명),
                      c_data_occur$crime_sum,
                      c_data_occur$catch_sum,
                      round(c_data_occur$catch_ratio,1))

head(c_data_final)

c_data_final <- rename(c_data_final, "관서명"="c_data_occur$관서명",
                       
                       "발생건수"= "c_data_occur$crime_sum",
                       
                       "검거건수"="c_data_occur$catch_sum",
                       
                       "검거율"="round(c_data_occur$catch_ratio, 1)")
