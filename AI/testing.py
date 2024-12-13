import unittest
from main import call_openai_model
class TestOpenAI(unittest.TestCase):

    def test_hello(self):
        response = call_openai_model("HHhhhhheeeelllllloooooo")
        self.assertEqual( "Hello!",response.content,
                         f'Response is {response} rather than Hello')

    def test_sentence(self):
        response = call_openai_model("Hi ttthhhheeerrree, mmmmyyy ffffrrrriiieeenddd!")
        self.assertEqual("Hi there, my friend!",response.content,
                         f'Response is {response} rather than Hi there, my friend!')
    def test_using_multiple_words(self):
        response = call_openai_model("appppppllllee baaaannnaaannaaa oooorrraaaanngggeee")
        self.assertEqual("apple banana orange",response.content,
                         f'Response is {response} rather than apple banana orange')


if __name__ == '__main__':
    unittest.main()