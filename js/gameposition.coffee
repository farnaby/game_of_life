# Represents the game logic independent of DOM representation

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
        @positionChanged?()

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
        @positionChanged?()

    clear: =>
        @positionArray = @getEmptyPositionArray()
        @positionChanged?()

    setPositionChangedCallback: (@positionChanged) ->
