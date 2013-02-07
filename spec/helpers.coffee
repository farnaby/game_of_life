describe "calculate square lengths", ->

  calculateSquareLength = helpers.calculateSquareLength

  it "calculates length without borders", ->
    net_len = 100
    borders = 0
    n_fields = 10
    square_len = calculateSquareLength(
      net_len, borders, n_fields)
    expect(square_len).toBe 10
    
  it "calculates length with borders", ->
    net_len = 301
    borders = 1
    n_fields = 10
    square_len = calculateSquareLength(
      net_len, borders, n_fields)
    expect(square_len * n_fields + borders * (n_fields + 1)).toBe net_len
   
  it "warns you when your sizes don't work out even", ->
    net_len = 300
    borders = 1
    n_fields = 10
    call = () -> calculateSquareLength(net_len, borders, n_fields)
    expect(call).toThrow "uneven result"
