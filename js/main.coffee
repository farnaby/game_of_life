
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
