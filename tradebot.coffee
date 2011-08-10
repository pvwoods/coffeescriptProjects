# A ridiculously rudimentary and uninformed
# bitcoin buy/sell bot.

rest = require 'restler'

priceData = []
historicPrice = []
historicSpread = []

bankRoll = 1000
positions = []
buyConfidence = 1

chartURL = "http://bitcoincharts.com/t/trades.csv?symbol="

delay = (ms, func) -> setTimeout func, ms

sum = (xs) -> xs.reduce (x, y) -> x + y

latestHistoricSpread = () -> historicSpread[historicSpread.length - 1]

historicPriceAverage = () -> ((sum historicPrice) / historicPrice.length) 

getTradeData = (symbol, handler) -> rest.get(chartURL + symbol).on 'complete', handler

findSimpleMean = (xs) ->
    temp = []
    temp.push value.price for value in xs
    return ((sum temp) / temp.length)

findWeightedMean = (xs) ->
    temp = []
    totalWeight = 0
    for value in xs
        temp.push (value.price * value.amount)
        totalWeight += value.amount
    return ((sum temp) / totalWeight)

extractPriceData = (s) ->
    result = []
    values = []
    values.push (line.split ',') for line in (s.split '\n')
    result.push {id:parseInt(value[0]), price:parseFloat(value[1]), amount:parseFloat(value[2])} for value in values
    return result
    
onDataReturned = (s) ->
    priceData = extractPriceData s
    sm = (findSimpleMean priceData)
    wm = (findWeightedMean priceData)
    #console.log ("::TRADER::\n\tSimple Mean:\t" + sm + "\n\tWeighted Mean:\t" + wm + "\n\tSpread:\t\t" + (wm - sm))
    historicPrice.push wm
    historicSpread.push (wm - sm)
    console.log "\nCurrent Spread :: " + latestHistoricSpread()
    console.log "averaged price :: " + historicPriceAverage()
    if (historicPrice.length > 1)
        determineAction()
        console.log "Confidence :: " + buyConfidence

determineAction = () ->
   if (bankRoll >= historicSpread[historicSpread.length - 1])
        spreadDelta = historicSpread[historicSpread.length - 1] - historicSpread[historicSpread.length - 2]
        console.log "Delta :: " + spreadDelta
        buyConfidence += spreadDelta
        if (spreadDelta > 0 && buyConfidence > 0)
            console.log "going to attempt a buy position"
            addBuyPosition historicPrice[historicPrice.length - 1], (Math.ceil buyConfidence)
        else
            if (positions.length ==0)
                console.log "holding tight"
            else
                if (spreadDelta < 0 && buyConfidence < 1)
                    console.log "considering unloading buy positions"
   else
       console.log "no money to invest"
   
   if positions.length >= 1
       positionDelta = 0
       for position in positions
           positionDelta += position.valueDelta + (position.valueDelta - (position.amount * historicPrice[historicPrice.length - 1]))
       console.log 'CURRENT PORTFOLIO VALUE :: ' + (bankRoll + positionDelta)
       

addBuyPosition = (price, amount) ->
    if (price * amount) > bankRoll
        amount = Math.floor (bankRoll / price)
        bankRoll -= price * amount
    if(amount > 0)
       positions.push {type:"buy", amount:amount, price:price, valueDelta: amount * price}

onTick = (d) ->
    getTradeData "mtgoxUSD", onDataReturned
    delay d, -> onTick d

onTick 10000
