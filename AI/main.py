import openai
import json
from openai import OpenAI
import requests
import transformers
from huggingface_hub import login
from PIL import Image
import cv2



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

