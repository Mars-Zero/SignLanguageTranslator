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
import torch
from dotenv import load_dotenv
import os

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
HUGGINGFACE_API_TOKEN = os.getenv("HUGGINGFACE_API_TOKEN")

client = OpenAI(
    api_key=OPENAI_API_KEY)
def call_openai_model(prompt):
    messages = []
    messages.append(
        {"role": "system", "content": "You are an AI content writer helper. Your role is to act as an assistant and correct errors. Do not add further explanation, only return the corrected text."}
    )
    messages.append(
        {"role": "user", "content": prompt}

    )
    response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=messages,
    )
    return response.choices[0].message

def call_huggingface_model(prompt):
    login(token=HUGGINGFACE_API_TOKEN)
    messages = [
        {"role": "user", "content": "You are an AI model that corrects errors in writing. Do not add any other details, just correct the input. Please correct the following input "+prompt},
    ]
    pipe = transformers.pipeline("text-generation", model="mistralai/Mistral-7B-Instruct-v0.3")   
    response = pipe(messages)
    return response

def classify_image_huggingface(image_opencv):
    login(token=HUGGINGFACE_API_TOKEN)
    pipe = transformers.pipeline("image-classification", model="RavenOnur/Sign-Language")
    image = Image.fromarray(cv2.cvtColor(image_opencv, cv2.COLOR_BGR2RGB))
    result = pipe(image)
    return result


base_options = python.BaseOptions(model_asset_path='../AI/training/gesture_recognizer_trained_large_dataset.task')
options = vision.GestureRecognizerOptions(base_options=base_options)
recognizer = vision.GestureRecognizer.create_from_options(options)
def classify_image(image_opencv):
    mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=image_opencv)
    recognition_result = recognizer.recognize(mp_image)
    return recognition_result.gestures
    

if __name__ == '__main__':
    print(call_openai_model("HHhhhhheeeelllllloooooo"))
    # cap = cv2.VideoCapture(0)
    # w, h = 360, 240
    # while True:
    #     _, img = cap.read()
    #     img = cv2.resize(img, (w,h))
    #     cv2.imshow("Camera",img)
    #     if cv2.waitKey(1) & 0xFF == ord('q'):
    #         break
    #     print(classify_image(img))

