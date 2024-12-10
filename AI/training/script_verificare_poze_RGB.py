import os
from PIL import Image

def find_non_rgb_photos(start_path):

    for root, _, files in os.walk(start_path):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                with Image.open(file_path) as img:
                    if img.mode != "RGB":
                        print(f"Non-RGB: {file_path} | Mode: {img.mode}")
            except Exception as e:
                print(f"Could not process: {file_path}. Error: {e}")

if __name__ == "__main__":
    start_directory = "./asl_dataset"
    if os.path.isdir(start_directory):
        find_non_rgb_photos(start_directory)
    else:
        print("Director invalid.")
