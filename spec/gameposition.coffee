describe "ConwayEngine", ->

    eng = null

    beforeEach ->
        eng = new ConwayEngine()

    it "counts the number of neighbours properly", ->
        snap = new PositionSnapshot(5,
            "00000" +
            "00000" +
            "00000" +
            "01110" +
            "00000")
        expect(eng.neighbours(snap, 3, 2)).toBe 2
        expect(eng.neighbours(snap, 2, 2)).toBe 3
        expect(eng.neighbours(snap, 3, 1)).toBe 1
        expect(eng.neighbours(snap, 0, 0)).toBe 0

    it "advances the game position according to Conway's rules", ->
        snap = new PositionSnapshot 5,
            "00000" +
            "00100" +
            "00110" +
            "00010" +
            "00000"
        snap = eng.advance snap
        expect(snap).toEqual new PositionSnapshot 5,
            "00000" +
            "00110" +
            "00110" +
            "00110" +
            "00000"
        snap = eng.advance snap
        expect(snap).toEqual new PositionSnapshot 5,
            "00000" +
            "00110" +
            "01001" +
            "00110" +
            "00000"
        snap = eng.advance snap
        expect(snap).toEqual new PositionSnapshot 5,
            "00000" +
            "00110" +
            "01001" +
            "00110" +
            "00000"


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

    it "informs a listener when toggled", ->
        positionChanged = jasmine.createSpy "positionChanged"
        pos.keepMeUpdated positionChanged

        pos.toggle(2, 2)

        expect(positionChanged).toHaveBeenCalled()

    it "informs a listener when position advanced", ->
        positionChanged = jasmine.createSpy "positionChanged"

        pos.keepMeUpdated positionChanged        
        pos.toggle(1, 2)
        pos.toggle(2, 2)
        pos.toggle(2, 3)

        pos.advance()
        expect(positionChanged.calls.length).toBeGreaterThan(3)

    it "informs a listener when cleared", ->
        positionChanged = jasmine.createSpy "positionChanged"
        pos.keepMeUpdated positionChanged

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
        expect(positionChanged.calls.length).toBeGreaterThan(3)

    it "informs more than one listener when toggled", ->
        positionChanged = jasmine.createSpy "firstListener"
        positionChanged2 = jasmine.createSpy "secondListener"
        pos.keepMeUpdated positionChanged
        pos.keepMeUpdated positionChanged2

        pos.toggle(2, 2)

        expect(positionChanged).toHaveBeenCalled()
        expect(positionChanged2).toHaveBeenCalled()

    it "updates their listeners immediately when they register", ->
        positionChanged = jasmine.createSpy "firstListener"
        pos.keepMeUpdated positionChanged
        expect(positionChanged).toHaveBeenCalled()


describe "PositionSnapshot", ->

    it "allows to access squares by (row, column) coordinates", ->
        snap = new PositionSnapshot(3,
            "100"+
            "011")
        expect(snap.get(0, 0)).toBe("1")
        expect(snap.get(0, 1)).toBe("0")
        expect(snap.get(0, 2)).toBe("0")
        expect(snap.get(1, 0)).toBe("0")
        expect(snap.get(1, 1)).toBe("1")
        expect(snap.get(1, 2)).toBe("1")

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


describe "GameHistory", ->

    history = null
    snap1 = new PositionSnapshot(3, "000" + "000")

    beforeEach ->
        history = new GameHistory()
        history.append snap1

    it "remembers some PositionSnapshots", ->
        snap2 = new PositionSnapshot(3, "111" + "111")
        history.append snap2
        snap3 = new PositionSnapshot(3, "101" + "001")
        history.append snap3

        expect(history.back()).toEqual snap2
        expect(history.back()).toEqual snap1

    it "continues working after taking back and making other moves again", ->
        snap2 = new PositionSnapshot(3, "111" + "111")
        history.append snap2

        expect(history.back()).toEqual snap1

        snap2a = new PositionSnapshot(3, "001" + "111")
        history.append snap2a
        snap3 = new PositionSnapshot(3, "000" + "111")
        history.append snap3

        expect(history.back()).toEqual snap2a

    it "throws an exception when trying to go back beyond big bang", ->
        expect(-> history.back()).toThrow()

    it "can tell whether we are at its beginning", ->
        expect(history.isAtBeginning()).toBe true

        snap2 = new PositionSnapshot(3, "111" + "111")
        history.append snap2

        expect(history.isAtBeginning()).toBe false

        history.back()

        expect(history.isAtBeginning()).toBe true

