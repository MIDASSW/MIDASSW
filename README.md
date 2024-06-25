## yolo 딥러닝

# 학습하여 test 하는 방법

1. 터미널에서 cd yolov5 명령어를 입력한다.

2. 딥러닝 학습

   
   * GPU 사용하지 않을 시

     python train.py --img 640 --batch 16 --epochs 30 --data data/data.yaml --cfg models/yolov5s.yaml --weights weights/yolov5s.pt

   * GPU 사용할 시
  
     python train.py --img 640 --batch 16 --epochs 30 --data data/data.yaml --cfg models/yolov5s.yaml --weights weights/yolov5s.pt  --device 1,2

3. 돌린 후 결과는 디렉토리 runs/train/exp마지막번호 에 존재한다.
  
4. 학습된 모델 사용하기

   python detect.py 명령어 입력

   python detect.py --source ./inference/images/test.jpg --weights runs/train/exp22/weights/best.pt --conf 0.4

   사진의 저장 디렉토리는 runs/detect/exp숫자 폴더에 저장
