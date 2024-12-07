import openai
import json
from openai import OpenAI
import requests
import transformers
from huggingface_hub import login


def call_huggingface_model(prompt):
    login(token="")
    messages = [
        {"role": "user", "content": "Who are you?"},
    ]
    pipe = transformers.pipeline("text-generation", model="mistralai/Mistral-7B-Instruct-v0.3")
    response = pipe(messages)
    return response


if __name__ == '__main__':
    print(call_huggingface_model("Hi, my name is"))

