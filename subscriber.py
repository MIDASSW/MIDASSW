import paho.mqtt.client as mqtt
import PIL.Image as pilimg
import json
import base64

def on_connect(client, userdata, flags, rc):
    print("연결 중...")
    if rc == 0:
        client.subscribe("packet/test")
    else:
        print("연결 실패")

def on_message(client, userdata, msg):
    jsonData = json.loads(msg.payload)

    location = jsonData["location"]
    print(f"Location: {location}")

    image_base64 = jsonData["image"]
    image_bytes = base64.b64decode(image_base64)

    with open("received_image2.jpg", "wb") as image_file:
        image_file.write(image_bytes)

mqttClient = mqtt.Client()
mqttClient.on_connect = on_connect
mqttClient.on_message = on_message
mqttClient.connect("192.168.0.10", 1883, 60)
mqttClient.loop_forever()