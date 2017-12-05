class @DonationMiner

  constructor: ->
    console.log " [coinhive] Initializing coinhive donation miner ... "
    @ch = new CoinHive.Anonymous($('a.coinhive-activate').data('key'))

  # Check if the user opted out in the last 4 hours
  didOptOut: ->
    @ch.didOptOut(4 * 60 * 60)

  handleClick: (e) ->
    e.preventDefault()

    $('.coinhive-activate').toggleClass('not-active')

    if @ch.isRunning()
      console.log " [coinhive] Stopping coinhive miner."
      @ch.stop()
    else
      console.log " [coinhive] Starting coinhive miner."
      @ch.start()

  donateMore: (e) ->
    e.preventDefault()

    val = parseInt($('.coinhive-cpu .value').text())
    val = Math.min(val + 25, 100);
    $('.coinhive-cpu .value').text(val)

    @ch.setThrottle(1 - (val / 100))

    localStorage.minerPercentage = val

  donateLess: (e) ->
    e.preventDefault()

    val = parseInt($('.coinhive-cpu .value').text())
    val = Math.max(val - 25, 25);
    $('.coinhive-cpu .value').text(val)

    @ch.setThrottle(1 - (val / 100))

    localStorage.minerPercentage = val

  setStarted: (e) ->
    return if this.didOptOut()

    $('.coinhive-activate').toggleClass('not-active')

    $('.coinhive-stopped').hide()
    $('.coinhive-started').show()
    localStorage.minerStarted = 'true'

  setStopped: ->
    $('.coinhive-activate').toggleClass('not-active')

    $('.coinhive-stopped').show()
    $('.coinhive-started').hide()
    localStorage.minerStarted = 'false'

  printStatus: ->
    ah = @ch.getAcceptedHashes()
    th = @ch.getTotalHashes()
    hps = @ch.getHashesPerSecond()
    console.info ' [coinhive] Hash accepted (' + ah + '/' + th + ') at ' + hps

  startIfWasRunning: ->
    if !this.didOptOut() && !@ch.isRunning() && localStorage.minerStarted == 'true'
      @ch.start()

  bind: ->

    @ch.on 'open', this.setStarted.bind(this)

    @ch.on 'close', this.setStopped.bind(this)

    @ch.on 'error', this.setStarted.bind(this)

    @ch.on 'accepted', this.printStatus.bind(this)

    $('.coinhive-activate').click this.handleClick.bind(this)

    $('.coinhive-cpu .donate-more').click this.donateMore.bind(this)
    $('.coinhive-cpu .donate-less').click this.donateLess.bind(this)

    $('.coinhive-cpu .value').text(localStorage.minerPercentage || 100)
