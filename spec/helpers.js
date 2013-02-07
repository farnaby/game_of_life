(function() {

  describe("calculate square lengths", function() {
    var calculateSquareLength;
    calculateSquareLength = helpers.calculateSquareLength;
    it("calculates length without borders", function() {
      var borders, n_fields, net_len, square_len;
      net_len = 100;
      borders = 0;
      n_fields = 10;
      square_len = calculateSquareLength(net_len, borders, n_fields);
      return expect(square_len).toBe(10);
    });
    it("calculates length with borders", function() {
      var borders, n_fields, net_len, square_len;
      net_len = 301;
      borders = 1;
      n_fields = 10;
      square_len = calculateSquareLength(net_len, borders, n_fields);
      return expect(square_len * n_fields + borders * (n_fields + 1)).toBe(net_len);
    });
    return it("warns you when your sizes don't work out even", function() {
      var borders, call, n_fields, net_len;
      net_len = 300;
      borders = 1;
      n_fields = 10;
      call = function() {
        return calculateSquareLength(net_len, borders, n_fields);
      };
      return expect(call).toThrow("uneven result");
    });
  });

}).call(this);
