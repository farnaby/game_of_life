import unittest
from subprocess import call

from selenium import webdriver


PORT = 8111


# TODO: start & stop server automatically

class SeleniumTestPlayer(unittest.TestCase):
    """ Base class for testing Conway's Game of Life webapp, hiding selenium details. """

    def setUp(self):
        _fox.get("http://localhost:{0}".format(PORT))

    def get_board(self):
        return _fox.find_element_by_id("board")

    def get_squares(self):
        board = self.get_board()
        all_squares = board.find_elements_by_class_name("square")
        self.assertEqual(len(all_squares), 30*30)
        return [all_squares[(30*n):30*(n+1)] for n in range(30)]

    def click_next_generation(self):
        _fox.find_element_by_id("next_generation_button").click()

    def assert_populated(self, square):
        self.assertIn("populated", square.get_attribute('class'))

    def assert_not_populated(self, square):
        self.assertNotIn("populated", square.get_attribute('class'))



class TestGameOfLife(SeleniumTestPlayer):

    def test_board(self):
        """ The page should show a board with 30x30 fields. The population of a square can be toggled via mouse click. """
        squares = self.get_squares()

        self.assert_not_populated(squares[2][13])
        self.assert_not_populated(squares[13][6])

        squares[2][13].click()
        self.assert_populated(squares[2][13])
        self.assert_not_populated(squares[13][6])
        
        squares[2][13].click()
        self.assert_not_populated(squares[2][13])
        self.assert_not_populated(squares[13][6])

    def assert_horizontal_blinker(self, squares):
        self.assert_not_populated(squares[14][13])
        self.assert_not_populated(squares[14][14])
        self.assert_not_populated(squares[14][15])
        self.assert_not_populated(squares[15][12])
        self.assert_populated(squares[15][13])
        self.assert_populated(squares[15][14])
        self.assert_populated(squares[15][15])
        self.assert_not_populated(squares[15][16])
        self.assert_not_populated(squares[16][13])
        self.assert_not_populated(squares[16][14])
        self.assert_not_populated(squares[16][15])

    def assert_vertical_blinker(self, squares):
        self.assert_not_populated(squares[14][13])
        self.assert_populated(squares[14][14])
        self.assert_not_populated(squares[14][15])
        self.assert_not_populated(squares[15][12])
        self.assert_not_populated(squares[15][13])
        self.assert_populated(squares[15][14])
        self.assert_not_populated(squares[15][15])
        self.assert_not_populated(squares[15][16])
        self.assert_not_populated(squares[16][13])
        self.assert_populated(squares[16][14])
        self.assert_not_populated(squares[16][15])

    def setup_horizontal_blinker(self, squares):
        squares[15][13].click()
        squares[15][14].click()
        squares[15][15].click()

    def test_blinker(self):
        """ The "blinker" structure should oscillate according to the rules. """
        squares = self.get_squares()

        self.setup_horizontal_blinker(squares)
        self.assert_horizontal_blinker(squares)

        self.click_next_generation()
        self.assert_vertical_blinker(squares)

        self.click_next_generation()
        self.assert_horizontal_blinker(squares)


if __name__ == '__main__':
    call(["coffee", "--compile", "js"])
    global _fox
    _fox = webdriver.Firefox(timeout=3)
    try:
        unittest.main(verbosity=2)
    finally:
        _fox.close()
