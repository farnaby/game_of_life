describe "game position", ->

    pos = undefined

    beforeEach ->
        pos = new GamePosition(5, 5)

    it "toggles fields when asked to", ->
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
        ]}"
        pos.toggle(3, 1)
        pos.toggle(3, 2)
        pos.toggle(3, 3)
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 1, 1, 1, 0]
            [0, 0, 0, 0, 0]
        ]}"
        pos.toggle(3, 2)
        pos.toggle(2, 2)
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 1, 0, 0]
            [0, 1, 0, 1, 0]
            [0, 0, 0, 0, 0]
        ]}"

    it "counts the number of neighbours properly", ->
        pos.toggle(3, 1)
        pos.toggle(3, 2)
        pos.toggle(3, 3)
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 1, 1, 1, 0]
            [0, 0, 0, 0, 0]
        ]}"
        expect(pos.neighbours(3, 2)).toBe 2
        expect(pos.neighbours(2, 2)).toBe 3
        expect(pos.neighbours(3, 1)).toBe 1
        expect(pos.neighbours(0, 0)).toBe 0

    it "advances game position according to Conway's rules", ->
        pos.toggle(1, 2)
        pos.toggle(2, 2)
        pos.toggle(2, 3)
        pos.toggle(3, 3)
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 1, 0, 0]
            [0, 0, 1, 1, 0]
            [0, 0, 0, 1, 0]
            [0, 0, 0, 0, 0]
        ]}"
        pos.advance()
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 1, 1, 0]
            [0, 0, 1, 1, 0]
            [0, 0, 1, 1, 0]
            [0, 0, 0, 0, 0]
        ]}"
        pos.advance()
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 1, 1, 0]
            [0, 1, 0, 0, 1]
            [0, 0, 1, 1, 0]
            [0, 0, 0, 0, 0]
        ]}"
        pos.advance()
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 1, 1, 0]
            [0, 1, 0, 0, 1]
            [0, 0, 1, 1, 0]
            [0, 0, 0, 0, 0]
        ]}"

    it "informs its listeners when toggled", ->
        positionChanged = jasmine.createSpy "positionChanged"
        pos.setPositionChangedCallback positionChanged

        pos.toggle(2, 2)

        expect(positionChanged).toHaveBeenCalled()

    it "informs its listeners when position advanced", ->
        positionChanged = jasmine.createSpy "positionChanged"

        pos.setPositionChangedCallback positionChanged        
        pos.toggle(1, 2)
        pos.toggle(2, 2)
        pos.toggle(2, 3)

        pos.advance()
        expect(positionChanged.calls.length).toEqual(4)

    it "informs its listeners when cleared", ->
        positionChanged = jasmine.createSpy "positionChanged"
        pos.setPositionChangedCallback positionChanged

        pos.toggle(1, 2)
        pos.toggle(2, 2)
        pos.toggle(2, 3)

        pos.clear()
        expect("#{pos.asArray()}").toBe "#{[
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
            [0, 0, 0, 0, 0]
        ]}"
        expect(positionChanged.calls.length).toEqual(4)


