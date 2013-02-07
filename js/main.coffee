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
    for i in [0..29]
        for j in [0..29]
            left = 10 * i
            top = 10 * j
            coords = {'i': i, 'j': j}
            $square = $("<div/>", {
                class: "square"
                css: {
                    left: left + "px"
                    top: top + "px"
                    width: 8 + "px"
                    height: 8 + "px"
                    border: "1px solid black"
                }
            }).appendTo($board)
            $square.click(coords, onSquareClick)


$(document).ready ->
    $board = $('#board')
    buildBoard($board)
