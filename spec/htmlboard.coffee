describe "HtmlBoard", ->

    it "builds a board inside a jquery div object", ->
        $div = $("<div/>")
        game = new Game(5, 4)
        spyOn($div, 'width').andReturn(45)
        spyOn($div, 'height').andReturn(56)
        spyOn($div, 'append')
        board = new HtmlBoard($div, game)
        board.buildDOM()
        expect($div.append.calls.length).toEqual(20)


describe "HtmlBoard helper function for board size calculation", ->

    calculateSquareLength = htmlboard.calculateSquareLength

    it "calculates length without borders", ->
        net_len = 100
        borders = 0
        n_fields = 10
        square_len = calculateSquareLength(net_len, borders, n_fields)
        expect(square_len).toBe 10

    it "calculates length with borders", ->
        net_len = 301
        borders = 1
        n_fields = 10
        square_len = calculateSquareLength(net_len, borders, n_fields)
        expect(square_len * n_fields + borders * (n_fields + 1)).toBe net_len


describe "ButtonPanel", ->

    $next_generation = null
    $clear = null
    $back = null
    $forward = null

    beforeEach ->
        $next_generation = $("<button/>")
        $clear = $("<button/>")
        $back = $("<button/>")
        $forward = $("<button/>")

    it "binds the buttons to their corresponding game functions", ->
        spyGame = jasmine.createSpyObj "Game", ["advance", "clear", "back", "forward", "keepMeUpdated"]
        buttonPanel = new ButtonPanel $next_generation, $clear, $back, $forward, spyGame

        $next_generation.click()
        expect(spyGame.advance).toHaveBeenCalled()

        $clear.click()
        expect(spyGame.clear).toHaveBeenCalled()

        $back.click()
        expect(spyGame.back).toHaveBeenCalled()

        $forward.click()
        expect(spyGame.forward).toHaveBeenCalled()

    it "disables the back button when game is at beginning", ->
        fakeGame = {
            isAtBeginning: -> true,
            isAtLatestPosition: -> true,
            keepMeUpdated: (@cb) -> cb()
        }
        
        buttonPanel = new ButtonPanel $next_generation, $clear, $back, $forward, fakeGame
        expect($back.prop("disabled")).toBe(true)

        fakeGame.isAtBeginning = -> false
        fakeGame.cb()

        expect($back.prop("disabled")).toBe(false)

    it "disables the forward button when game is at latest known position", ->
        fakeGame = {
            isAtBeginning: -> true,
            isAtLatestPosition: -> true,
            keepMeUpdated: (@cb) -> cb()
        }
        
        buttonPanel = new ButtonPanel $next_generation, $clear, $back, $forward, fakeGame
        expect($forward.prop("disabled")).toBe(true)

        fakeGame.isAtLatestPosition = -> false
        fakeGame.cb()

        expect($forward.prop("disabled")).toBe(false)
