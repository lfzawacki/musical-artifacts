class @DonationMiner

  constructor: ->

    if typeof CoinHive != 'undefined'
      console.log " [coinhive] Initializing coinhive donation miner ... "
      @ch = new CoinHive.Anonymous($('a.coinhive-activate').data('key'))

      # show the miner
      $('.coinhive-disabled').hide()
      $('.coinhive-cpu, .coinhive-stopped').show()

    else
      console.log " [coinhive] Miner has not loaded, consider unblocking it"

  # Check if the user opted out in the last 4 hours
  didOptOut: ->
    return if !@ch

    @ch.didOptOut(4 * 60 * 60)

  handleClick: (e) ->
    return if !@ch

    e.preventDefault()

    $('.coinhive-activate').toggleClass('not-active')

    if @ch.isRunning()
      console.log " [coinhive] Stopping coinhive miner."
      @ch.stop()
    else
      console.log " [coinhive] Starting coinhive miner."
      @ch.start()

  donateMore: (e) ->
    return if !@ch

    e.preventDefault()

    val = parseInt($('.coinhive-cpu .value').text())
    val = Math.min(val + 25, 100);
    $('.coinhive-cpu .value').text(val)

    @ch.setThrottle(1 - (val / 100))

    localStorage.minerPercentage = val

  donateLess: (e) ->
    return if !@ch

    e.preventDefault()

    val = parseInt($('.coinhive-cpu .value').text())
    val = Math.max(val - 25, 25);
    $('.coinhive-cpu .value').text(val)

    @ch.setThrottle(1 - (val / 100))

    localStorage.minerPercentage = val

  setStarted: (e) ->
    return if !@ch

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
    return if !@ch

    ah = @ch.getAcceptedHashes()
    th = @ch.getTotalHashes()
    hps = @ch.getHashesPerSecond()
    console.info ' [coinhive] Hash accepted (' + ah + '/' + th + ') at ' + hps

  startIfWasRunning: ->
    return if !@ch

    if !this.didOptOut() && !@ch.isRunning() && localStorage.minerStarted == 'true'
      @ch.start()

  bind: ->
    return if !@ch

    @ch.on 'open', this.setStarted.bind(this)

    @ch.on 'close', this.setStopped.bind(this)

    @ch.on 'error', this.setStarted.bind(this)

    @ch.on 'accepted', this.printStatus.bind(this)

    $('.coinhive-activate').click this.handleClick.bind(this)

    $('.coinhive-cpu .donate-more').click this.donateMore.bind(this)
    $('.coinhive-cpu .donate-less').click this.donateLess.bind(this)

    $('.coinhive-cpu .value').text(localStorage.minerPercentage || 100)
