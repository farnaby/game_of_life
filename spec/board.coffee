describe "game position", ->

    it "toggles fields when asked to", ->
        pos = new GamePosition(5, 5)
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
        pos = new GamePosition(5, 5)
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
        pos = new GamePosition(5, 5)
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

