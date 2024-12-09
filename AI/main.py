import openai
import json
from openai import OpenAI
import requests
import transformers
from huggingface_hub import login
from PIL import Image
import cv2
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision


def call_huggingface_model(prompt):
    login(token="")
    messages = [
        {"role": "user", "content": "Who are you?"},
    ]
    pipe = transformers.pipeline("text-generation", model="mistralai/Mistral-Nemo-Base-2407")   
    response = pipe(messages)
    return response

def classify_image(image_opencv):
    login(token="")
    pipe = transformers.pipeline("image-classification", model="RavenOnur/Sign-Language")
    #image = Image.open(image_path)
    image = Image.fromarray(cv2.cvtColor(image_opencv, cv2.COLOR_BGR2RGB))
    result = pipe(image)
    return result


#def print_result(result: vision.GestureRecognizerResult, output_image: mp.Image, timestamp_ms: int):
    #print('gesture recognition result: {}'.format(result))

#options = vision.GestureRecognizerOptions(
   # base_options=python.BaseOptions(model_asset_path='gesture_recognizer.task'),
   # running_mode=python.VisionRunningMode.LIVE_STREAM,
   # result_callback=print_result)

base_options = python.BaseOptions(model_asset_path='./AI/gesture_recognizer.task')
options = vision.GestureRecognizerOptions(base_options=base_options)
recognizer = vision.GestureRecognizer.create_from_options(options)
def classify_image(image_opencv):
    mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=image_opencv)
    recognition_result = recognizer.recognize(mp_image)

    print(recognition_result.gestures)
    print(recognition_result.hand_landmarks)
    #top_gesture = recognition_result.gestures[0][0]
    #hand_landmarks = recognition_result.hand_landmarks
    

if __name__ == '__main__':
    cap = cv2.VideoCapture(0)
    w, h = 360, 240
    while True:
        _, img = cap.read()
        img = cv2.resize(img, (w,h))
        cv2.imshow("Camera",img)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        print(classify_image(img))

