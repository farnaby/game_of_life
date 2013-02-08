import unittest

from selenium import webdriver


PORT = 8111

# TODO: start & stop server automatically

class SeleniumTestPlayer(unittest.TestCase):
    """ Base class for testing Conway's Game of Life webapp, hiding selenium details. """

    def setUp(self):
        self._fox = webdriver.Firefox(timeout=3)
        self._fox.get("http://localhost:{0}".format(PORT))

    def tearDown(self):
        self._fox.close()

    def get_board(self):
        return self._fox.find_element_by_id("board")

    def get_squares(self):
        board = self.get_board()
        all_squares = board.find_elements_by_class_name("square")
        self.assertEqual(len(all_squares), 30*30)
        return [all_squares[(30*n):30*(n+1)] for n in range(30)]

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


if __name__ == '__main__':
    unittest.main(verbosity=2)
