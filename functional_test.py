import unittest

from selenium import webdriver


PORT = 8111

# TODO: start & stop server automatically

class TestGameOfLife(unittest.TestCase):

    def setUp(self):
        self.fox = webdriver.Firefox(timeout=3)
        self.fox.get("http://localhost:{0}".format(PORT))

    def tearDown(self):
        self.fox.close()

    def test_board(self):
        """ The page should show a board with 30x30 fields. The colour can be changed via mouse click. """
        self.fail("TODO: finish")


if __name__ == '__main__':
    unittest.main(verbosity=2)
