from flask import Flask, request, jsonify
import os
import uuid

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

if __name__ == '__main__':
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    app.run(debug=True, host='0.0.0.0', port=5000)