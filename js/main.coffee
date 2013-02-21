
@init = () ->
    gamePosition = new GamePosition(30, 30)
    board = new HtmlBoard($('#board'), gamePosition)
    board.buildDOM()
    buttonPanel = new ButtonPanel(
        $('#next_generation_button'),
        $('#clear_board_button'),
        $('#back_button'),
        gamePosition
    )
    $('#next_generation_button').click(gamePosition.advance)
    $('#clear_board_button').click(gamePosition.clear)
    $('#back_button').click(gamePosition.back)
