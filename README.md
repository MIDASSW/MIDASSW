# [MIDAS종합설계(1)] Prototype
## 인공지능 기반의 도로 크랙 감지 임베디드 시스템

**1. 주요 기능**
* 주변 크랙을 눈으로 볼 수있는 지도화면 (홈 화면)
* 실시간으로 내 주변, 최근 크랙 확인 가능 (내 주변)
* 제보하기 기능을 통해 주변 크랙 사진을 찍고 날짜와 현재위치 웹서버 전송 (전송 하기)
* 내 주변에 크랙이 감지될때, 알림 전송 (설정)
* 라즈베리파이와 웹서버, DB 기능은 추후 업데이트 예정

**2. 개발 환경**
* vscode
* 플러터
* 안드로이드 스튜디오

**3. 앱 설치 및 에뮬레이터 설정 방법**
* 플러터 설치방법 : https://joverything.tistory.com/1
* 파일 생성 후 vscode터미널창에 git init
* git remote https://github.com/MIDASSW/MIDASSW.git
* git remote update
* git switch main
* git pull
* flutter pub get 하여 필요한 플러그인 다운로드
* ctrl + shift + p 한후, Lauch Emulator
* ctrl + F5를 사용하여 디버깅

**4. 로컬 웹 설치 및 실행방법(window 기준)**
* Node.js 공식 웹사이트에서 Windows용 인스톨러를 다운로드(https://nodejs.org/en)
* vscode에 ApptoWeb으로 이동한후, pull 받기
* npm install express multer 패키지 설치
* node app.js를 실행하여 로컬 웹 실행

**5. 애플리케이션 실행 가이드**
* 아이디 : 휴대폰 번호 사용 (숫자만 가능)
* 비밀번호 : 8자리 이상 특수기호 1개이상 꼭 포함
* 카카오로 시작하기 (사실상 불가능) : 실 디바이스 혹은 Android 11 이하 에뮬레이터를 사용하거나 다른 브라우저를 설치한 뒤 디바이스 기본 브라우저로 설정해서 사용해야 가능. 추후에 수정 예정
* google로 시작하기 : 클릭하여 구글 소셜 로그인 진행
* '홈' 화면 왼쪽에 버튼을 눌러서 현재 위치 확인 가능
* '내 주변' 화면 클릭 시, 최근 크랙 및 내 주변 크랙 확인 가능
* '제보 하기' 화면 클릭 시, 사진 촬영 또는 이미지 선택을 하여 원하는 사진을 선택 후 위치 정보와 날짜정보를 받아옴.
  
  전송하기 버튼 클릭 후, uploads파일에 저장된 이미지 확인.

  WebtoApp에서 받아온 코드 실행 후, cmd창 혹은 vscode에서 node app.js 실행.

  실행 후, cmd창에서 위치, 이미지, 날짜 정보 확인 가능.

  http://포트번호:3000/ 실행하여 uploads파일에서 이미지 선택, 날짜 및 위치 저장

* '설정' 화면에서 직접 알림(50~200m내에 크랙이 감지될때, 알림 소리)

   푸시 알림(1km내에 크랙이 감지 될 때, 푸시알림)

   비밀번호 변경, 로그아웃 가능

**6. 어플리케이션 UI**
  1. 첫 화면

    * 어플의 이름과 로고

    * 짧은 시간 지속 후 로그인 화면으로 넘어감.

  2. 로그인 화면

    * 휴대폰 번호, 비밀번호 입력창

    * 비밀번호 찾기, 회원가입 버튼

    * 소셜로그인 기능 (카카오, apple, google)

  3. 회원가입 화면

    * 이름 입력창 (영어 또는 한글로 구성)

    * 이메일 입력창 

    * 휴대폰 번호 입력창 (숫자만 포함)

    * 비밀번호 입력창 (8자리 이상, 특수기호 1개 이상 포함)

    * 가입하기 버튼 (조건에 맞지 않을 경우, 재입력 요청)

  4. 내 위치 화면

    * 앱 위치 권한 안내

    * 왼쪽 아래 버튼 클릭시 현재의 위치로 이동

    * 빨간 핀 : 현재의 위치 표시

  5. 크랙 리스트 화면

    * 최근 크랙 : 최근에 발생한 크랙이미지, 날짜, 위치

    * 내 주변 크랙 : 현재 위치 주변의 크랙에 대한 이미지, 날짜, 위치

  6. 제보하기 화면

    * 카메라 아이콘 클릭시 "사진 촬영 또는 앨범에서 선택" 통해 사진 업로드

    * 일시 클릭시 날짜 선택 가능

    * 위치 클릭시 현재 위치 도출

  7. 설정 화면

    * 직접 알림 토글 설정

      50 ~ 200m 이내에 크랙 감지시 알림

    * 알림 크기 설정

      드래그를 통해 크기 설정 가능

    * 푸시 알림 토글 설정

      1km 이내에 크랙 감지시, 푸시 알림

    * 비밀번호 변경 가능

  8. 비밀번호 변경 화면

    * 기존 비밀번호 입력

    * 기존 비밀번호 일치시 새로운 비밀번호 입력

    * 새로운 비밀번호 다시 입력 후 변경 가능

  9. 하단 네비게이션 바

    * 홈 - 내 위치 화면으로 이동

    * 내 주변 - 최근 크랙, 내 주변 크랙 리스트 화면으로 이동

    * 제보하기 - 제보하기 화면으로 이동

    * 설정 - 설정 화면으로 이동

**7. 웹서버 UI**

  1. 실시간 크랙 피드

    * 라즈베리파이 카메라에서 보낸 크랙 이미지 날짜, 위치 업로드 

  2. 제보

    * 어플리케이션에서 보낸 이미지, 날짜, 위치 업로드

  3. 크랙 업로드 내역

    * 어플리케이션에 업로드한 크랙 내역

  4. 알림 전송 내역

    * 어플리케이션에 보낸 알림 내역

  5. Google Cloud Storage

    * 크랙 이미지, 날짜, 위치 저장

**8. 라즈베리파이(publisher)**

1. 필요 라이브러리 설치(mqtt, cv2, picamera2)

    pip install paho-mqtt

    pip install opencv-python

    sudo apt install -y python3 -picamera2

2. 라즈베리파이 카메라 포트 활성화

    sudo raspi-config

    camera 선택

    yes 선택

3. pc에 mosquitto 설치

    * 모스키토 홈페이지(https://mosquitto.org/download/)에서 설치 파일 다운로드
  
    * 고급 시스템 설정-환경변수-path 편집-mosquitto 설치 경로 등록
  
    * 실행방법

        1. 명령 프롬프트 실행 후 mosquitto-v 명령어 입력을 통해 mosquitto 실행
     
        2. 다른 명령 프롬프트에서 python subscriber.py 명령어 입력을 통해 subscriber 실행
     
        3. 라즈베리파이 터미널에서 python publisher.py 명령어 입력을 통해 publisher 실행
     
           * publisher.py 파일은 라즈베리파이에서 동작합니다.

           * 현재 로컬 통신만 가능한 상태입니다.
          
           * gps 모듈을 연결하였으나 gps값이 출력되지 않는 오류가 있어 코드 상에서 임의의 gps값으로 대체된 상태입니다.
          
           * 추후 학습모델 적용하여 스마트폰과 웹서버를 subscriber로 두고 크랙 감지 시 상응하는 동작을 수행하도록 할 예정입니다.






   
