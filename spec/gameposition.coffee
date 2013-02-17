describe "GamePosition", ->

    pos = undefined

    beforeEach ->
        pos = new GamePosition(5, 5)

    it "toggles fields when asked to", ->
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
        ]
        pos.toggle(3, 1)
        pos.toggle(3, 2)
        pos.toggle(3, 3)
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '1', '1', '1', '0']
            ['0', '0', '0', '0', '0']
        ]
        pos.toggle(3, 2)
        pos.toggle(2, 2)
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '1', '0', '0']
            ['0', '1', '0', '1', '0']
            ['0', '0', '0', '0', '0']
        ]

    it "counts the number of neighbours properly", ->
        pos.toggle(3, 1)
        pos.toggle(3, 2)
        pos.toggle(3, 3)
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '1', '1', '1', '0']
            ['0', '0', '0', '0', '0']
        ]
        expect(pos.neighbours(3, 2)).toBe 2
        expect(pos.neighbours(2, 2)).toBe 3
        expect(pos.neighbours(3, 1)).toBe 1
        expect(pos.neighbours(0, 0)).toBe 0

    it "advances game position according to Conway's rules", ->
        pos.toggle(1, 2)
        pos.toggle(2, 2)
        pos.toggle(2, 3)
        pos.toggle(3, 3)
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '1', '0', '0']
            ['0', '0', '1', '1', '0']
            ['0', '0', '0', '1', '0']
            ['0', '0', '0', '0', '0']
        ]
        pos.advance()
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '1', '1', '0']
            ['0', '0', '1', '1', '0']
            ['0', '0', '1', '1', '0']
            ['0', '0', '0', '0', '0']
        ]
        pos.advance()
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '1', '1', '0']
            ['0', '1', '0', '0', '1']
            ['0', '0', '1', '1', '0']
            ['0', '0', '0', '0', '0']
        ]
        pos.advance()
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '1', '1', '0']
            ['0', '1', '0', '0', '1']
            ['0', '0', '1', '1', '0']
            ['0', '0', '0', '0', '0']
        ]

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
        expect(pos.asArray()).toEqual [
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
            ['0', '0', '0', '0', '0']
        ]
        expect(positionChanged.calls.length).toEqual(4)


describe "PositionSnapshot", ->

    it "allows to access squares by (row, column) coordinates", ->
        positionSnapshot = new PositionSnapshot(3,
            "100"+
            "011")
        expect(positionSnapshot.get(0, 0)).toBe("1")
        expect(positionSnapshot.get(0, 1)).toBe("0")
        expect(positionSnapshot.get(0, 2)).toBe("0")
        expect(positionSnapshot.get(1, 0)).toBe("0")
        expect(positionSnapshot.get(1, 1)).toBe("1")
        expect(positionSnapshot.get(1, 2)).toBe("1")

    it "can create an empty position for a given board size", ->
        snap1 = PositionSnapshot.buildEmpty(2, 3)
        snap2 = new PositionSnapshot(3, "000000")

        expect(snap1).toEqual snap2

    it "can convert itself into a mutable array representation", ->
        snap = new PositionSnapshot(3,
            "100"+
            "011")
        expect(snap.asArray()).toEqual [
            ['1', '0', '0']
            ['0', '1', '1']
        ]

    it "can be constructed from an array", ->
        snap1 = PositionSnapshot.buildFromArray([
            [0, 1, 0, 1]
            [1, 1, 0, 1]
        ])
        snap2 = new PositionSnapshot(4,
            "0101"+
            "1101")
        expect(snap1).toEqual snap2

    it "can be accessed like a bigger position, assuming periodicity", ->
        snap = new PositionSnapshot(3,
            "100"+
            "011")

        expect(snap.getAssumingPeriodic(1, -1)).toBe("1")

        expect(snap.getAssumingPeriodic(1, 0)).toBe("0")
        expect(snap.getAssumingPeriodic(1, 1)).toBe("1")
        expect(snap.getAssumingPeriodic(1, 2)).toBe("1")

        expect(snap.getAssumingPeriodic(1, 3)).toBe("0")

    it "throws an exception when trying to be constructed with inconsistent arguments", ->
        expect(-> new PositionSnapshot(2, "111")).toThrow()

