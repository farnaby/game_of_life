isInteger = (number) ->
    number % 1 == 0

calculateSquareLength = (net_len, border, n_squares) ->
    candidate = (net_len - border * (n_squares + 1)) / n_squares
    if isInteger(candidate)
        candidate
    else
        throw "uneven result"

@htmlboard = {
    calculateSquareLength: calculateSquareLength
}

class @HtmlBoard

    constructor: (@$div, @game) ->
        @n_rows = game.n_rows
        @n_columns = game.n_columns
        @$squares = (null for j in [1..@n_columns] for k in [1..@n_rows])

    onSquareClick: (event) =>
        @game.toggle(event.data.row, event.data.column)

    positionChanged: =>
        for i in [0..(@n_rows-1)]
            for j in [0..(@n_columns-1)]
                $square = @$squares[i][j]
                is_populated = @game.get(i, j)
                if is_populated is '1'
                    $square.addClass "populated"
                else
                    $square.removeClass "populated"

    buildDOM: ->
        net_width = @$div.width()
        net_height = @$div.height()
        border = 1
        try
            square_width = calculateSquareLength(net_width, border, @n_columns)
            square_height = calculateSquareLength(net_height, border, @n_rows)
        catch error
            alert "Board dimensions don't fit. Please use a fitting width/height for the board div."
        for row in [0..(@n_rows-1)]
            for column in [0..(@n_columns-1)]
                left = (square_width + border) * row
                top = (square_height + border) * column
                coords = {'row': row, 'column': column}
                $square = $("<div/>", {
                    class: "square"
                    css: {
                        left: left + "px"
                        top: top + "px"
                        width: square_width + "px"
                        height: square_height + "px"
                        'border-width': border + "px"
                    }
                })
                @$div.append($square)
                @$squares[row][column] = $square
                $square.click(coords, @onSquareClick)
        @game.keepMeUpdated @positionChanged


class @ButtonPanel

    constructor: (@$nextGeneration, @$clearBoard, @$back, @$forward, @game) ->
        @game.keepMeUpdated @checkButtons

        @$nextGeneration.click(@game.advance)
        @$clearBoard.click(@game.clear)
        @$back.click(@game.back)
        @$forward.click(@game.forward)

    checkButtons: =>
        @$back.prop "disabled", @game.isAtBeginning()
        @$forward.prop "disabled", @game.isAtLatestPosition()
