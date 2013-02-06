import unittest

from selenium import webdriver


PORT = 8111

# TODO: start & stop server automatically

class GOLPlayer(object):

    def __init__(self):
        self.fox = webdriver.Firefox(timeout=3)
        self.fox.get("http://localhost:{0}".format(PORT))

    def stop(self):
        self.fox.close()

    def get_board(self):
        return self.fox.find_element_by_id("board")

    def get_squares(self):
        board = self.get_board()
        return board.find_elements_by_class_name("square")

    def get_square(self, num):
        squares = self.get_squares()
        return squares[num]

    def is_square_populated(self, num):
        chosen_square = self.get_square(num)
        return "populated" in chosen_square.get_attribute('class')

    def click_square(self, num):
        chosen_square = self.get_square(num)
        chosen_square.click()



class TestGameOfLife(unittest.TestCase):

    def setUp(self):
        self.player = GOLPlayer()

    def tearDown(self):
        self.player.stop()

    def test_board(self):
        """ The page should show a board with 30x30 fields. The colour can be changed via mouse click. """
        self.player.get_board()
        squares = self.player.get_squares()
        self.assertEqual(len(squares), 30*30)

        self.assertFalse(self.player.is_square_populated(55))
        self.assertFalse(self.player.is_square_populated(121))

        self.player.click_square(55)
        self.assertTrue(self.player.is_square_populated(55))
        self.assertFalse(self.player.is_square_populated(121))

        self.player.click_square(55)
        self.assertFalse(self.player.is_square_populated(55))
        self.assertFalse(self.player.is_square_populated(121))


if __name__ == '__main__':
    unittest.main(verbosity=2)
