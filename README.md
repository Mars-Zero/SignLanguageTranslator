### Real-Time Sign Language Translator


#AI Model
A Google AI gesture recognition model was used for ASL image recognition. This model was trained on a 2GB curated dataset compiled from various Kaggle repositories.
The model achieves an accuracy of 93.6% and a loss of 0.1563.
In practice, the lighting of the environment significantly affects the accuracy of classification because the training data primarily consists of images with good to excellent lighting conditions.
Other Hugging Face alternatives tested were slower and less accurate overall, based on our evaluations.

#Validating AI Sign Language Results
To validate results and generate clear text output, an OpenAI API call was used. With a custom prompt, the classification results are combined into a meaningful sentence.
A Mistral alternative was tested but found to be less effective. The OpenAI solution provides clearer messages and better contextual guesses, resulting in sentences closer to the intended user translation.
