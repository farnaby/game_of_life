@helpers = {}  # export some helper functions. required for testing.

helpers.calculateSquareLength = (net_len, border, n_squares) ->
    candidate = (net_len - border * (n_squares + 1)) / n_squares
    if helpers.isInteger(candidate)
        candidate
    else
        throw "uneven result"

helpers.isInteger = (number) ->
    number % 1 == 0


class HtmlBoard

    constructor: (@$div, @n_rows, @n_columns) ->
        @gamePosition = new GamePosition(@n_rows, @n_columns)
        @gamePosition.setListener(this)
        @$squares = (null for j in [1..@n_rows] for k in [1..@n_columns])

    onSquareClick: (event) =>
        @gamePosition.toggle(event.data.row, event.data.column)

    positionChanged: ->
        arr = @gamePosition.asArray()
        for i in [0..(@n_rows-1)]
            for j in [0..(@n_columns-1)]
                $square = @$squares[i][j]
                is_populated = arr[i][j]
                if is_populated is 1
                    $square.addClass "populated"
                else
                    $square.removeClass "populated"

    buildDOM: ($board) ->
        net_width = @$div.width()
        net_height = @$div.height()
        border = 1
        try
            square_width = helpers.calculateSquareLength(net_width, border, @n_columns)
            square_height = helpers.calculateSquareLength(net_width, border, @n_rows)
        catch error
            alert "Board dimensions don't fit. Please use a fitting width/height for the board div."
        for i in [0..(@n_rows-1)]
            for j in [0..(@n_columns-1)]
                left = (square_width + border) * i
                top = (square_height + border) * j
                coords = {'row': i, 'column': j}
                $square = $("<div/>", {
                    class: "square"
                    css: {
                        left: left + "px"
                        top: top + "px"
                        width: square_width + "px"
                        height: square_height + "px"
                        border: border + "px solid grey"
                    }
                }).appendTo(@$div)
                @$squares[i][j] = $square
                $square.click(coords, @onSquareClick)


class @GamePosition

    constructor: (@n_rows, @n_columns) ->
        @positionArray = @getEmptyPositionArray()
        @listener = null

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
        @listener?.positionChanged()

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

    advance: =>
        next_position = @getEmptyPositionArray()
        for row in [0..@n_rows-1]
            for column in [0..@n_columns-1]
                next_position[row][column] = @evaluateNextGeneration(row, column)
        @positionArray = next_position
        @listener?.positionChanged()

    setListener: (@listener) ->



@init = () ->
    board = new HtmlBoard $('#board'), 30, 30
    board.buildDOM()
    $('#next_generation_button').click(board.gamePosition.advance)
