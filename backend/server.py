import os
import sys
from flask import Flask, request, jsonify
import uuid
import cv2

import importlib.util
import sys
from pathlib import Path

module_path = Path(__file__).resolve().parent.parent / 'AI' / 'main.py'

spec = importlib.util.spec_from_file_location("ai", module_path)
ai = importlib.util.module_from_spec(spec)
sys.modules["ai"] = ai
spec.loader.exec_module(ai)

current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
if parent_dir not in sys.path:
    sys.path.insert(0, parent_dir)
from AI.main import classify_image
app = Flask(__name__)

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['ALLOWED_EXTENSIONS'] = ['jpg', 'png', 'jpeg']

def check_filename(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']


@app.route('/upload', methods=['POST'])
def upload_file():
    # verific daca in cerere exista un fisier.
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']

    if file.filename == '': 
        # in caz ca am un fisier gol:
        return jsonify({'error': 'No selected file'}), 400

    if file and check_filename(file.filename):
        cod_unic = uuid.uuid4().hex
        # am creat un hash unic pe care sa il apenduiesc in fata numelui fisierului, pentru
        # ca daca il lasam fara, fisierele nu mai aveau denumiri distincte, si folderul
        # ramanea mereu doar cu o poza, la fiecare incarcare a camerei din flutter.
        filename = f"{cod_unic}{file.filename}"
        # concatenez cu un contor pentru ca altfel, imi punea pozele
        # distincte ca acelasi obiect file in folder.
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return jsonify({'message': 'File uploaded successfully!'}), 200
    else:
        return jsonify({'error': 'File type not allowed'}), 400

# Ruta de procesare a imaginii, se asteapta sa primeasca o cerere de genul:
# {
#   "filename": "image_name.jpg"
# }

# si rapsunsul corect ar fi fe genul:
# {
#     "filename": "image_name.jpg",
#     "result_llm": [],
#     "message": "Image processed successfully"
# }
@app.route('/translate', methods=['GET'])
def translate():
    all_translations = []
    for filename in os.listdir(UPLOAD_FOLDER):
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        image_opencv = cv2.imread(file_path)
        if image_opencv is None:
            return jsonify({'error': f'Could not read image: {filename}'}), 400
        
        # translation_result = ai.classify_image_huggingface(image_opencv)
        # print(translation_result)
        
        translation_result = ai.classify_image(image_opencv)
        if translation_result:
            all_translations.append(translation_result[0][0].category_name)
        if translation_result:
            print(translation_result[0][0].category_name)

        os.remove(file_path)
        
    translation_string = ''.join(all_translations)
    final_translation = ai.call_openai_model(translation_string)
    print(final_translation.content)

    return jsonify({
        'translation': final_translation.content
    }), 200

if __name__ == '__main__':
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    app.run(debug=True, host='0.0.0.0', port=5000)