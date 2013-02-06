onSquareClick = (event) ->
    $(event.target).toggleClass("populated")

buildBoard = ($div) ->
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
            }).appendTo($div)
            $square.click(coords, onSquareClick)

$(document).ready ->
    $board = $('#board')
    buildBoard(board)
