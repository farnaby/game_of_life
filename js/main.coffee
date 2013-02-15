
@init = () ->
    gamePosition = new GamePosition(30, 30)
    board = new HtmlBoard($('#board'), gamePosition)
    board.buildDOM()
    $('#next_generation_button').click(gamePosition.advance)
    $('#clear_board_button').click(gamePosition.clear)
