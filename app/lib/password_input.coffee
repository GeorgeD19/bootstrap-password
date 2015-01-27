class PasswordInput

  constructor: (element, @options) ->
    @element = $(element)
    @id = @element.attr('id')
    @isShown = false
    @i18n = @options[@options.lang]
    @formGroupElement = @element.parents('.form-group')
    $.error("Form input ##{@id} must have a surrounding form-group.") unless @formGroupElement.length > 0
    @formGroupElement.addClass('bootstrap-password')

    # layout based on the feature options
    @layoutInputGroup()
    @layoutMeter()
    @layoutToggleVisibilityLink()

    # trigger initial strength update and background-meter underlay placement
    @onKeyup()
    @setBackgroundMeterPosition()

    # hookup listeners
    $(window).resize @setBackgroundMeterPosition
    @element.keyup(@onKeyup)

    # attach if there is something (this will find inside the form-group allowing for additional triggers)
    @attachToToggleVisibilityIcon()
    @attachToToggleVisibilityText()

    # see if we belong to a modal
    @modal = @element.closest('.modal')
    @modal = null if @modal.length is 0 # for easy comparison

    # hookup modal listeners to properly position the underlay
    if @modal
      @hideBackgroundMeter() # initial hide
      @modal.on('shown.bs.modal', @setBackgroundMeterPosition)
      @modal.on('hidden.bs.modal', @hideBackgroundMeter)


  layoutToggleVisibilityLink: =>
    return unless 'toggle-visibility-link' in @options.features

    @toggleVisibilityTextElement = $("<a href='#' class='toggle-visibility'>#{@i18n.show}</a>")
    @formGroupElement.append @toggleVisibilityTextElement


  layoutInputGroup: =>
    return unless 'input-group' in @options.features

    # find existing input-group
    @inputGroupElement = @element.parents('.input-group')

    # create input-group
    if @inputGroupElement.length <= 0
      @inputGroupElement = $('<div class="input-group"></div>')
      @element.wrap @inputGroupElement

    reachedInput = false
    for addonKey in @options['input-group'].layout
      if addonKey is 'input'
        reachedInput = true
        continue

      addon = @options['input-group'].addons[addonKey]
      addonElement =
        $("""
              <div class="input-group-addon">
                  #{addon.html}
              </div>
              """)
      if reachedInput
        @element.after addonElement
      else
        @element.before addonElement

  attachToToggleVisibilityText: =>
    @toggleVisibilityTextElement = @formGroupElement.find('a.toggle-visibility') # have to use the finder because the @inputGroupElement is a wrapper and find doesn't appear to work. jquery bug?
    @toggleVisibilityTextElement = null if @toggleVisibilityTextElement.length <= 0
    # events to trigger show/hide for password field
    @toggleVisibilityTextElement?.click(@onToggleVisibility)


  attachToToggleVisibilityIcon: =>
    @toggleVisibilityIconElement = @formGroupElement.find('.input-group').find('span.toggle-visibility') # have to use the finder because the @inputGroupElement is a wrapper and find doesn't appear to work. jquery bug?
    @toggleVisibilityIconElement = null if @toggleVisibilityIconElement.length <= 0
    # events to trigger show/hide for password field
    @toggleVisibilityIconElement?.click(@onToggleVisibility)

  layoutMeter: =>

    if 'background-meter' in @options.features
      @formGroupElement.addClass('background-metered')
      @backgroundMeterElement = $("<div class='background-meter' />")
      @formGroupElement.append @backgroundMeterElement
      #@formGroupElement.find('.input-group').append @backgroundMeterElement # doesn't change modal issue

      meterGroupElement = @backgroundMeterElement


    # create strength meter outer div and inner label.  Looks like:
    #    <div class="meter">
    #      <div class="none">Strength</div>
    #    </div>
    unless meterGroupElement
      meterGroupElement = $("<div class='meter-group'/>")
      @element.after meterGroupElement

    @meterElement = $("<div class='meter'>")
    @meterLabelElement = $("<div>#{@i18n.meter.none}</div>")
    @meterLabelElement.appendTo @meterElement
    meterGroupElement.append @meterElement

  hideBackgroundMeter: =>
    # make sure there is no visual artifacting when a modal is hidden then shown again
    return unless @backgroundMeterElement?
    @meterElement.addClass('hidden')

  setBackgroundMeterPosition: =>
    # resetBackgroundMeterCss - now that position and everything is calculated, grab the css from the input and add it to our backgroundMeterElement
    return unless @backgroundMeterElement?

#    console.debug "background-meter z-index: #{@baseZindex + 1}"
#    console.debug "background-meter location set to: ", @element.offset()
    backgroundMeterCss =
      position: 'absolute'
      verticalAlign: @element.css('verticalAlign')
      width: @element.css('width')
      height: @element.css('height')
      borderRadius: @element.css('borderRadius')

    @backgroundMeterElement.css(backgroundMeterCss)
    @backgroundMeterElement.offset(@element.offset())
    @meterElement.removeClass('hidden')

  onToggleVisibility: (ev) =>
    ev.preventDefault()

    if @isShown
      @element.attr('type', 'password')
      @toggleVisibilityIconElement.removeClass('hide-toggle-visibility').addClass('toggle-visibility') if @toggleVisibilityIconElement
      @toggleVisibilityTextElement.removeClass('hide-toggle-visibility').addClass('toggle-visibility').html @i18n.show if @toggleVisibilityTextElement
      @isShown = false
    else
      @element.attr('type', 'text')
      @toggleVisibilityIconElement.removeClass('toggle-visibility').addClass('hide-toggle-visibility') if @toggleVisibilityIconElement
      @toggleVisibilityTextElement.removeClass('toggle-visibility').addClass('hide-toggle-visibility').html @i18n.hide if @toggleVisibilityTextElement
      @isShown = true

  onKeyup: (ev) =>
    # events to trigger strength meter and update the hidden field
    strength = @calculateStrength(@element.val())
    @updateUI strength

  updateUI: (strength) =>
    for cssClass in ['strong', 'medium', 'weak', 'veryWeak', 'none']
      @formGroupElement.removeClass(cssClass)

    @formGroupElement.addClass(strength)

    switch strength
      when 'strong', 'medium', 'weak', 'none'
        @meterLabelElement.text(@i18n.meter[strength])
      else
        @meterLabelElement.text @i18n.meter.veryWeak

  calculateStrength: (newValue) =>
    #
    # Check the password against the calculation. Allow someone to pass in a different `calculation` fn via options.
    #   Any given function should return strength string values of strength|veryweak|weak|strong
    #
    if typeof @options.calculation is 'function'
      calculation = @options.calculation
    else
      calculation = @defaultCalculation

    calculation(newValue, @options)

  defaultCalculation: (newValue, options) =>
    # check the password against the regexes given in the options (defaulted as well)
    if newValue.length is 0
      'none'
    else if newValue.search(options.calculation.strongTest) >= 0
      'strong'
    else if newValue.search(options.calculation.mediumTest) >= 0
      'medium'
    else if newValue.search(options.calculation.weakTest) >= 0
      'weak'
    else
      'veryWeak'

module.exports = PasswordInput