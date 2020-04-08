# flexdashboard 애플리케이션처럼 만들기

# flexdashboard
# R로 유연, 매력, 쌍방향의 대시보드를 쉽게 만들 수 있음
# 대시보드 작성 및 커스터마이제이션은
# Rmarkdown에 기반하여 이루어지며,
# Shiny(애플리케이션처럼 만들어줌) 컴포넌트들도 덧붙일 수 있다

# 이외 htmlwidgets, base/lattice/grid 그래픽,
# tabula(표) 데이터, 주석 같은 다양한 컴포넌트들까지 지원하며,
# 열과 행 기반 레이아웃, 스토리보드 등 제공된다는 장점도 가지고 있음


# flexdashboard 시작하기

# 패키지 설치
# packages -> install -> 검색해서 설치
# 여러개 동시 설치하고 싶을 경우
# 쉼표로 나열해서 설치하면 됨!
install.packages("flexdashboard")

# New File -> R Markdown -> From Template -> Flex Dashboard

# 차트 이미지 결과는 확인 후 닫아도 됨!

# Knit 실행 후
# 가로 크기를 더 줄이면 아예 설정되어 있는 행과 열 구분이 무시되고 아래로 그래프들이 나열되기도 한다
# => 이건 모두 YAML 헤더의 설정 내용 때문
# 반응형 웹 페이지로 많이 쓰임


#===========================================================================================
#===========================================================================================
# flexdashboard의 레이아웃

# ---
#   title: "Dashboard Example"
# output:
#   flexdashboard::flex_dashboard:
#   orientation: columns
#   vertical_layout: fill
# ---

# flex_dashboard가 flexdashboard로 내보내질 건데
# 기준은 columns 기준!
# 들여쓰기 필수!
# vertical_layout : fill -> 가득 채운다

# r 코드 넣기
# ```{r setup, include=FALSE}
# library(flexdashboard)
# library(ggplot2)
# ```

# 이름은 setup 으로 잡고 include는 시키지 않겠다
# setup 부분에는 전체 코드 말고, 라이브러리를 많이 씀



# Column {data-width=650} # 첫번째 컬럼은 가로 650 사이즈로 만들겠다!
# -----------------------------------------------------------------------
#   
### Chart A    # 타이틀 지정
# 
# ```{r}
# ggplot(data=mtcars, aes(x=hp, y=mpg, color=as.factor(cyl))) +
#   geom_point()

# Column {data-width=350} # 두번째 컬럼은 가로 350 사이즈로 만들겠다!
# -----------------------------------------------------------------------
#   
### Chart B    # 타이틀 지정
# ```{r}
# ggplot(data=mtcars) +
#   geom_bar(mapping = aes(x=cyl, fill=as.factor(am)))
# 
# ```
# 
### Chart C    # 타이틀 지정
# 
# ```{r}
# ggplot(data=mtcars) +
#   geom_bar(mapping = aes(x=cyl, fill=as.factor(cyl)), position="dodge") +
#   coord_p
# 
# ```
# 
# 하나의 컬럼으로 쓰이고 싶을 경우 # Column {data-width=숫자} 로 써주면 되고,
# 여러개의 컬럼으로 쓰이고 싶을 경우 한 컬럼 내에 여러 제목을 지정해주면 된다 !
  
#===========================================================================================
#===========================================================================================

# 행 -> 열 순서로 설정 변경시
# YAML 헤더의 orientation: 부분만 columns 를 row 로 변경하면 된다

# 열과 행의 구분은 --- 와 ### 을 이용



# fill -> scroll 변경시
# 오른쪽에 스크롤바 생성!

# ---
#   title: "Dashboard Example"
# output: 
#   flexdashboard::flex_dashboard:
#   orientation: columns
# vertical_layout: scroll
# ---


#===========================================================================================
# tabset 적용을 위해서는 {.tabset} 속성을 열 또는 행 구분할 때 기재하면 된다
# {.tabset .tabset-fade} 기재하면 탭 전환시 부드럽게 처리되는 효과가 있다


#===========================================================================================
# dygraphs 패키지
# : 시계열 자료에 대한 시각화 그래프 구현 할 때 하이라이트, 줌 등 기능 제공
# flexdashboard에서 예시로 든 코드인데, library() 함수를 쓰는 것을 보아 dygraphs가 R의 패키지임을 확인할 수 있음

# plotly
# R의 ggplot2 그래픽을 인터렉티브한 웹 버전으로 쉽게 변환해준다
# 정말 보기 좋고 인터렉티브한 그래프를 간단히 그릴 수 있는 기능들이 ~
# 홈페이지가 별도로 있고 설명도 잘 되어 있다.


#===========================================================================================
# Flexdashboard Figure Sizes
# 그래프 크기를 fig.width 와 fig.height 를 이용하여 조정 (비율)
# ex) 1열 : fig.width=12, fig.height=7

#===========================================================================================
# valueBox()
# 대시보드를 구성할 때 한 개 또는 두 개의 값을 강조해서
# 그림 또는 아이콘과 같이 보여주고 싶을 때가 있는데
# 이 경우 flexdashboard에서는 valueBox() 함수를 이용해서
# 제목, 아이콘(옵션)과 함께 보여주고 싶은 값을 아래와 같이 표시해 줄 수 있다.



  
  

