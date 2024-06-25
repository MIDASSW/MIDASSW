from time import sleep
import paho.mqtt.publish as publish
import json
import base64
import cv2
import time
from picamera2 import Picamera2, Preview
import threading
from collections import deque

def initialize_camera():
   camera = Picamera2()
   camera.configure(camera.create_still_configuration(main={"size": (649, 480)}))
   camera.start()
   time.sleep(0.1)
   return camera

def buffer_frames(camera, buffer):
   while True:
      frame = camera.capture_array()
      buffer.append(frame)

      if cv2.waitKey(1) & 0xFF == 27:
         break
   cv2.destroyAllWindows()


def serialization(buffer, location):
   frame = buffer[-1]
   _, jpeg = cv2.imencode('.jpg', frame)
   image = base64.b64encode(jpeg).decode('utf-8')
   data = {
      "location": location,
      "image": image,
   }
   return json.dumps(data)

def capture_input(buffer):
   while True:
      command = input("Enter 'capture' to send frame: ")
      if command.strip().lower() == 'capture':
         if buffer:
            return buffer[-1]
         else:
            print("buffer is empty")


if __name__ == "__main__":
   buffer = deque(maxlen = 10)

   camera = initialize_camera()

   buffering_thread = threading.Thread(target = buffer_frames, args = (camera, buffer))
   buffering_thread.start()

   image = capture_input(buffer)
   location = '052709.00,3550.44056,N,12708.32592,E,1,04,5,92,70,0,M,19,8,M,,*68'
   s_data = serialization(buffer, location)

   publish.single("packet/test", s_data, hostname = "192.168.0.10")