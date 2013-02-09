# helpers for everything

@helpers = {}  # export everything into helpers object

helpers.calculateSquareLength = (net_len, border, n_squares) ->
    candidate = (net_len - border * (n_squares + 1)) / n_squares
    if helpers.isInteger(candidate)
        candidate
    else
        throw "uneven result"

helpers.isInteger = (number) ->
    number % 1 == 0
