# Sign Language Translator

## Installation and usage

### Running the backend
In the AI/ directory, create a file called `.env`, copy the contents of `.env.example` here and add your OpenAI key.

From the **root directory** run:
```
./AI/install.sh
./backend/install.sh
```
to install the necesarry dependencies.

Then run the Flask server:
```
python3 ./backend/server.py
```

### Running the frontend

You need to install Flutter (the Flutter SDK + other requirements). See a full guide here: https://docs.flutter.dev/get-started/install

A physical device to run the app on is also required.

In the `sign_language_transaltor/` directory, create a file called `.env`, copy the contents of `.env.example` there and add value to the variable in `.env` following the instructions in `.env.example`.

Then run:
```
cd sign_language_translator
flutter pub get
```
to install the necessary dependancies.

To start the app, run:
```
flutter run
```

## AI Model
A Google AI gesture recognition model was used for American Sign Language (ASL) image recognition. This model was trained on a 2.4GB dataset compiled from various Kaggle repositories.
The model achieves an accuracy of 93.6% and a loss of 0.1563. 
In practice, the lighting of the environment significantly affects the accuracy of classification because the training data primarily consists of images with good to excellent lighting conditions.
Other Hugging Face alternatives tested were slower and less accurate overall, based on our evaluations. Additionally, the training data predominantly features right-handed photos, so ASL letter recognition is expected to perform better for right-handed gestures.

## Validating AI Sign Language Results
To validate results and generate clear text output, an OpenAI API call was used. With a custom prompt, the classification results are combined into a meaningful sentence.
A Mistral alternative was tested but found to be less effective. The OpenAI solution provides clearer messages and better contextual guesses, resulting in sentences closer to the intended user translation.

## Frontend

- the `sign_language_translator/` directory

### Structure
```
lib/
├── main.dart 
├── camera_page.dart
├── components/
│   ├── camera.dart
│   └── instructions_pop_up.dart
└── services/
    └── network.dart   # handles API requests for image upload and translation retrieval.
```

### Components
The app consists of one page with the following components:
- camera, used to capture the signs that will be translated
    - button to change the camera in use (rear/frontal camera)
- button to start/stop the translation
- button that opens a pop-up with the usage instructions for the app
- a text component, where the translation will be displayed

## Backend
- the `backend/` directory
A Flask server for processing and classifying images. The server allows users to upload images from the frontend of the app, after which the server processes them using an AI model.
The server includes the following routes:

### /upload:
- Method: POST
- Allows users to upload images for processing. The Flask application is configured with a folder named “uploads”, where the uploaded images are stored. After retrieving the image from the request, the function check_filename is called to verify if the file name matches the desired extensions (.png, .jpg, .jpeg).
- A counter is appended to the file name, incremented with each upload, ensuring that the images are processed in the order they were sent. The uploaded image is then saved to the folder.
- Responds with a success message or an error message, depending on the file's validity (existence and correct file name).

### /translate:
- Method: GET
- Iterates through all the files saved in the folder using a classification list, leveraging a function from the AI model to classify each image. The highest-probability prediction (usually the first result) is appended to the list.
- The results are concatenated and formatted into a string, which is then passed to the `call_openai_model` function from the AI module to generate a translation.
- Returns the content of the translation in JSON format.

### Translation Workflow
1. Open the app.
2. Tap **Start Translation** to begin.
3. The app captures images periodically and sends them to the backend for processing.
4. Tap **Stop Translation** to end the process.
5. View the translation result displayed on the screen.

