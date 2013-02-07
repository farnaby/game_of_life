@helpers = {}  # export some helper functions. required for testing.

helpers.calculateSquareLength = (net_len, border, n_squares) ->
    candidate = (net_len - border * (n_squares + 1)) / n_squares
    if helpers.isInteger(candidate)
        candidate
    else
        throw "uneven result"

helpers.isInteger = (number) ->
    number % 1 == 0


onSquareClick = (event) ->
    $(event.target).toggleClass("populated")
 
buildBoard = ($board) ->
    net_width = $board.width()
    net_height = $board.height()
    border = 1
    try
        square_width = helpers.calculateSquareLength(net_width, border, 30)
        square_height = helpers.calculateSquareLength(net_width, border, 30)
    catch error
        alert "Board dimensions don't fit. Please use a fitting width/height for the board div."
    for i in [0..29]
        for j in [0..29]
            left = (square_width + border) * i
            top = (square_height + border) * j
            coords = {'i': i, 'j': j}
            $square = $("<div/>", {
                class: "square"
                css: {
                    left: left + "px"
                    top: top + "px"
                    width: square_width + "px"
                    height: square_height + "px"
                    border: border + "px solid grey"
                }
            }).appendTo($board)
            $square.click(coords, onSquareClick)


$(document).ready ->
    $board = $('#board')
    buildBoard($board)
