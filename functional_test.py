import unittest
import random
import time
from subprocess import call, Popen, PIPE

from selenium import webdriver


PORT = 8111


class SeleniumTestPlayer(unittest.TestCase):
    """ Base class for testing Conway's Game of Life webapp, hiding selenium details. """

    def setUp(self):
        _fox.get("http://localhost:{0}".format(PORT))

    def get_board(self):
        return _fox.find_element_by_id("board")

    def get_square_matrix(self):
        board = self.get_board()
        all_squares = board.find_elements_by_class_name("square")
        self.assertEqual(len(all_squares), 30*30)
        return [all_squares[(30*n):30*(n+1)] for n in range(30)]

    def click_next_generation(self):
        _fox.find_element_by_id("next_generation_button").click()

    def click_clear_board(self):
        _fox.find_element_by_id("clear_board_button").click()

    def click_back_button(self):
        _fox.find_element_by_id("back_button").click()

    def assert_populated(self, square):
        self.assertIn("populated", square.get_attribute('class'))

    def assert_not_populated(self, square):
        self.assertNotIn("populated", square.get_attribute('class'))

    def assert_back_button_disabled(self):
        back_button = _fox.find_element_by_id("back_button")
        self.assertTrue(back_button.get_attribute('disabled'))



class TestGameOfLife(SeleniumTestPlayer):

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

    def assert_no_blinker(self, squares):
        self.assert_not_populated(squares[14][13])
        self.assert_not_populated(squares[14][14])
        self.assert_not_populated(squares[14][15])
        self.assert_not_populated(squares[15][12])
        self.assert_not_populated(squares[15][13])
        self.assert_not_populated(squares[15][14])
        self.assert_not_populated(squares[15][15])
        self.assert_not_populated(squares[15][16])
        self.assert_not_populated(squares[16][13])
        self.assert_not_populated(squares[16][14])
        self.assert_not_populated(squares[16][15])

    def assert_all_not_populated(self, squares):
        for square in squares:
            self.assert_not_populated(square)

    def select_random(self, square_matrix, number=9):
        selected = []
        for i in range(9):
            selected.append(random.choice(random.choice(square_matrix)))
        return selected

    def click_all(self, squares):
        for square in squares:
            square.click()

    def setup_horizontal_blinker(self, square_matrix):
        self.click_all([square_matrix[15][13],
                        square_matrix[15][14],
                        square_matrix[15][15]])

    def test_board(self):
        """ The page should show a board with 30x30 fields. The population of a square can be toggled via mouse click. """
        squares = self.get_square_matrix()

        self.assert_not_populated(squares[2][13])
        self.assert_not_populated(squares[13][6])

        squares[2][13].click()
        self.assert_populated(squares[2][13])
        self.assert_not_populated(squares[13][6])
        
        squares[2][13].click()
        self.assert_not_populated(squares[2][13])
        self.assert_not_populated(squares[13][6])

    def test_blinker(self):
        """ The "blinker" structure should oscillate according to the rules. """
        square_matrix = self.get_square_matrix()

        self.setup_horizontal_blinker(square_matrix)
        self.assert_horizontal_blinker(square_matrix)

        self.click_next_generation()
        self.assert_vertical_blinker(square_matrix)

        self.click_next_generation()
        self.assert_horizontal_blinker(square_matrix)

    def test_clear_button(self):
        """ The "clear" button should clean the board. """
        square_matrix = self.get_square_matrix()
        selected = self.select_random(square_matrix)

        self.click_all(selected)

        self.click_clear_board()
        self.assert_all_not_populated(selected)

    def test_back_buttons(self):
        """ The "back" button allows to go back in history. """
        self.assert_back_button_disabled()

        square_matrix = self.get_square_matrix()
        self.setup_horizontal_blinker(square_matrix)  # takes three steps
        self.click_next_generation()
        self.click_next_generation()
        self.assert_horizontal_blinker(square_matrix)

        self.click_back_button()
        self.assert_vertical_blinker(square_matrix)

        self.click_back_button()
        self.assert_horizontal_blinker(square_matrix)

        self.click_back_button()
        self.click_back_button()
        self.click_back_button()
        self.assert_no_blinker(square_matrix)



if __name__ == '__main__':
    call(["coffee", "--compile", "js"])
    global _fox
    server = Popen(["python", "-m", "SimpleHTTPServer", str(PORT)],
                   cwd='/home/om3/Projekte/game_of_life',
                   stdout=PIPE, stderr=PIPE)
    _fox = webdriver.Firefox(timeout=3)
    
    try:
        unittest.main(verbosity=2)
    finally:
        _fox.close()
        server.terminate()
