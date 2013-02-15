class @HtmlBoard

    constructor: (@$div, @gamePosition) ->
        @n_rows = gamePosition.n_rows
        @n_columns = gamePosition.n_columns
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

    buildDOM: ->
        net_width = @$div.width()
        net_height = @$div.height()
        border = 1
        try
            square_width = helpers.calculateSquareLength(net_width, border, @n_columns)
            square_height = helpers.calculateSquareLength(net_width, border, @n_rows)
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
                        border: border + "px solid grey"
                    }
                }).appendTo(@$div)
                @$squares[row][column] = $square
                $square.click(coords, @onSquareClick)
        @gamePosition.setListener(this)
