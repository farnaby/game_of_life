onSquareClick = (event) ->
    $(event.target).toggleClass("populated")

buildBoard = ($div) ->
    for i in [0..29]
        for j in [0..29]
            left = 5 * i
            top = 5 * j
            coords = {'i': i, 'j': j}
            $square = $("<div/>", {
                class: "square"
                css: {
                    left: left + "px"
                    top: top + "px"
                    width: 3 + "px"
                    height: 3 + "px"
                    border: 1 + "px"
                }
            }).appendTo($div)
            $square.click(coords, onSquareClick)

$(document).ready ->
    $board = $('#board')
    buildBoard(board)
