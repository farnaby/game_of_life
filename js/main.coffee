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


class @GamePosition

    constructor: (@n_rows, @n_columns) ->
        @positionArray = @getEmptyPositionArray()

    getEmptyPositionArray: ->
        0 for j in [1..@n_rows] for k in [1..@n_columns]

    getSquareAssumingPeriodicBoundaryConditions: (row, column) ->
        row = (row + @n_rows) % @n_rows
        column = (column + @n_columns) % @n_columns
        @positionArray[row][column]

    asArray: ->
        @positionArray

    toggle: (row, column) ->
        old_val = @positionArray[row][column]
        @positionArray[row][column] = (if old_val is 0 then 1 else 0)

    neighbours: (row, column) ->
        count = 0
        for r in [row-1..row+1]
            for c in [column-1..column+1]
                count += @getSquareAssumingPeriodicBoundaryConditions(r, c) unless r is row and c is column
        count

    evaluateNextGeneration: (row, column) ->
        next_generation = 0
        if @positionArray[row][column] is 1
            if @neighbours(row, column) in [2, 3]
                next_generation = 1
        else
            if @neighbours(row, column) is 3
                next_generation = 1
        next_generation

    advance: ->
        next_position = @getEmptyPositionArray()
        for row in [0..@n_rows-1]
            for column in [0..@n_columns-1]
                next_position[row][column] = @evaluateNextGeneration(row, column)
        @positionArray = next_position



@init = () ->
    $board = $('#board')
    buildBoard($board)
