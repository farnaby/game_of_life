# Represents the game logic independent of DOM representation

class @PositionSnapshot

    constructor: (@n_columns, @string_repr) ->
        if string_repr.length % n_columns != 0
            throw "inconsistent position"

    @buildEmpty: (n_rows, n_columns) ->
        string_repr = Array(n_rows * n_columns + 1).join "0"
        new @ n_columns, string_repr

    @buildFromArray: (array) ->
        rows = (row.join "" for row in array)
        string_repr = rows.join ""
        n_columns = rows[0].length
        new @ n_columns, string_repr

    get: (row, column) ->
        @string_repr[column + @n_columns*row]

    getAssumingPeriodic: (row, column) ->
        row = (row + @n_rows()) % @n_rows()
        column = (column + @n_columns) % @n_columns
        @get(row, column)

    n_rows: ->
        @string_repr.length / @n_columns

    asArray: ->
        @get(row, column) for column in [0..@n_columns-1] for row in [0..@n_rows()-1] 


class @GameHistory

    constructor: ->
        @history = []
        @pointer = -1
        @present = -1

    append: (snapshot) ->
        @pointer += 1
        @present = @pointer
        @history[@pointer] = snapshot

    back: ->
        if @pointer <= 0
            throw "already at beginning"
        @pointer -= 1
        @history[@pointer]

    forward: ->
        if @pointer is @present
            throw "already at present"
        @pointer += 1
        @history[@pointer]

    isAtBeginning: ->
        @pointer <= 0

    isAtPresent: ->
        @pointer is @present


class @ConwayEngine

    neighbours: (positionSnapshot, row, column) ->
        count = 0
        for r in [row-1..row+1]
            for c in [column-1..column+1]
                count += parseInt(positionSnapshot.getAssumingPeriodic(r, c)) unless r is row and c is column
        count

    evaluateNextGeneration: (positionSnapshot, row, column) ->
        next_generation = '0'
        if positionSnapshot.get(row, column) is '1'
            if @neighbours(positionSnapshot, row, column) in [2, 3]
                next_generation = '1'
        else
            if @neighbours(positionSnapshot, row, column) is 3
                next_generation = '1'
        next_generation

    advance: (positionSnapshot) ->
        n_rows = positionSnapshot.n_rows()
        n_columns = positionSnapshot.n_columns
        next_position = PositionSnapshot.buildEmpty(n_rows, n_columns).asArray()
        for row in [0..n_rows-1]
            for column in [0..n_columns-1]
                next_position[row][column] = @evaluateNextGeneration(positionSnapshot, row, column)
        PositionSnapshot.buildFromArray next_position


class @Game

    constructor: (@n_rows, @n_columns) ->
        @positionSnapshot = PositionSnapshot.buildEmpty(n_rows, n_columns)
        @updateListeners = []
        @gameHistory = new GameHistory()
        @conwayEngine = new ConwayEngine()
        @gameHistory.append @positionSnapshot

    asArray: ->
        @positionSnapshot.asArray()

    get: (row, column) ->
        @positionSnapshot.get(row, column)

    toggle: (row, column) ->
        pos = @positionSnapshot.asArray()
        old_val = pos[row][column]
        pos[row][column] = (if old_val is '0' then '1' else '0')
        @positionSnapshot = PositionSnapshot.buildFromArray(pos)
        @gameHistory.append @positionSnapshot
        @positionChanged()

    back: =>
        @positionSnapshot = @gameHistory.back()
        @positionChanged()

    forward: =>
        @positionSnapshot = @gameHistory.forward()
        @positionChanged()

    isAtBeginning: =>
        @gameHistory.isAtBeginning()

    isAtLatestPosition: =>
        @gameHistory.isAtPresent()

    advance: =>
        @positionSnapshot = @conwayEngine.advance @positionSnapshot
        @gameHistory.append @positionSnapshot
        @positionChanged()

    clear: =>
        @positionSnapshot = PositionSnapshot.buildEmpty(@n_rows, @n_columns)
        @gameHistory.append @positionSnapshot
        @positionChanged()

    positionChanged: ->
        for update in @updateListeners
            update()

    keepMeUpdated: (updateListener) =>
        updateListener()
        @updateListeners.push updateListener

