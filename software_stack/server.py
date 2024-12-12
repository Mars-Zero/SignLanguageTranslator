import os
import sys
from flask import Flask, request, jsonify
import uuid
import cv2

# adaug directorul parinte in calea de cautare a modulului, pentru a putea importa
# PARTEA COMENTATA MOMENTAN NU FUNCTIONEAZA
# current_dir = os.path.dirname(os.path.abspath(__file__))
# parent_dir = os.path.dirname(current_dir)
# if parent_dir not in sys.path:
#     sys.path.insert(0, parent_dir)
# from AI.main import classify_image_huggingface, classify_image_mediapipe
app = Flask(__name__)
# setez directorul in care voi incarca pozele primite de camera din aplicatia flutter.
UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['ALLOWED_EXTENSIONS'] = ['jpg', 'png', 'jpeg']

# functie pentru a verifica extensia fisierului
def check_filename(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

@app.route('/')
def home():
    return "Serverul Flask good, good!"

# adaug si o ruta de reset, cu rol de a sterge toate fisierele din folderul uploads
# va fi folosita de fiecare data cand apas din aplicatia flutter pe butonul Start Translation, pentru
# a incepe o noua sesiune de translare a imaginilor de catre modelul AI.
@app.route('/reset', methods=['POST'])
def reset_uploads():
    for filename in os.listdir(UPLOAD_FOLDER):
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        os.remove(file_path)
    return "Uploads folder had been reseted!", 200

# aceasta ruta merge, e testata cu PostMan, si uploadeaza si file-ul in folder.
@app.route('/upload', methods=['POST'])
def upload_file():
    # verific daca in cerere exista un fisier.
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    # preiau FISIERUL din request.
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


# testata si ea cu postman.
# Ruta de procesare a imaginii, se asteapta sa primeasca o cerere de genul:
# {
#   "filename": "e28aaff68a034674b73bf9e945e2b5381.jpg"
# }

# si rapsunsul corect ar fi fe genul:
# {
#     "filename": "e28aaff68a034674b73bf9e945e2b5381.jpg",
#     "message": "Image processed successfully"
# }
@app.route('/processing_translate', methods=['POST'])
def procesing_translate():
    data = request.json
    if not data or 'filename' not in data:
        return jsonify({'error': 'No filename provided'}), 400

    filename = data['filename']
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)

    if not os.path.exists(file_path):
        return jsonify({'error': 'File not found'}), 404

    # incarc imaginea si o citesc
    image_opencv = cv2.imread(file_path)
    if image_opencv is None:
        return jsonify({'error': 'Could not read the image'}), 400

    # NU MERGE SA LE IMPORT.
    # result_huggingface = classify_image_huggingface(image_opencv)
    # result_mediapipe = classify_image_mediapipe(image_opencv)

    # Poți returna un rezultat procesat
    return jsonify({
        'message': 'Image processed successfully',
        'filename': filename,
        # 'huggingface_result': result_huggingface,
        # 'mediapipe_result': result_mediapipe
    }), 200

if __name__ == '__main__':
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    app.run(debug=True, host='0.0.0.0', port=5000)