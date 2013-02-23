
@init = () ->
    game = new Game(30, 30)
    board = new HtmlBoard($('#board'), game)
    board.buildDOM()
    buttonPanel = new ButtonPanel(
        $('#next_generation_button'),
        $('#clear_board_button'),
        $('#back_button'),
        $('#forward_button'),
        game
    )
