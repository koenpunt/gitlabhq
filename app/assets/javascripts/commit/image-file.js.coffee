class ImageFile
  
  # Width where images must fits in, for 2-up this gets divided by 2
  @availWidth = 900
  @viewModes = ['two-up', 'swipe']
  
  constructor: (@file) ->
    
    this.requestImageInfo $('.two-up.view .frame.deleted img', @file), (deletedWidth, deletedHeight) =>
      this.requestImageInfo $('.two-up.view .frame.added img', @file), (width, height) =>
        if width == deletedWidth && height == deletedHeight
          this.initViewModes() 
        else
          this.initTwoUpView()

  initViewModes: ->
    @viewMode = ImageFile.viewModes[0]
    
    $('.view-modes', @file).removeClass 'hide'
    $('.view-modes-menu li', @file).on 'click', (event) =>
      unless $(event.currentTarget).hasClass('active')
        this.activateViewMode(event.currentTarget.className)
        
    this.activateViewMode(@viewMode)
  
  activateViewMode: (viewMode) ->
    $('.view-modes-menu li.active', @file).removeClass 'active'
    $(".view-modes-menu li.#{viewMode}", @file).addClass 'active'
    $(".view:not(.#{viewMode})", @file).fadeOut 200, =>
      $(".view.#{viewMode}", @file).fadeIn(200)
      this.initView viewMode
  
  initView: (viewMode) ->
    # Camelize viewMode
    callback = viewMode.replace /(?:^|[-_])(\w)/g, (_, c) -> 
      (if c then c.toUpperCase() else "")
    
    this["init#{callback}View"].call(this)
  
  initTwoUpView: ->
    $('.two-up.view .wrap', @file).each (index, wrap) =>
      $('img', wrap).each ->
        currentWidth = $(this).width()
        if currentWidth > ImageFile.availWidth / 2
          $(this).width ImageFile.availWidth / 2
      
      this.requestImageInfo $('img', wrap), (width, height) ->
        $('.image-info .meta-width', wrap).text "#{width}px"
        $('.image-info .meta-height', wrap).text "#{height}px"
        $('.image-info', wrap).removeClass('hide')
  
  initSwipeView: ->
    maxWidth = 0
    maxHeight = 0

    $('.swipe.view', @file).each (index, view) =>
      
      $('.frame', view).each (index, frame) =>
        width = $(frame).width()
        height = $(frame).height()
        maxWidth = if width > maxWidth then width else maxWidth
        maxHeight = if height > maxHeight then height else maxHeight
      .css
        width: maxWidth
        height: maxHeight
    
      $('.swipe-frame', view).css
        width: maxWidth + 16
        height: maxHeight + 28
      
      $('.swipe-wrap', view).css
        width: maxWidth + 1
        height: maxHeight + 2
        
      $('.swipe-bar', view).css
        left: 0
      .draggable
        axis: 'x'
        containment: 'parent'
        drag: (event) ->
          $('.swipe-wrap', view).width (maxWidth + 1) - $(this).position().left
        stop: (event) ->
          $('.swipe-wrap', view).width (maxWidth + 1) - $(this).position().left
  
  requestImageInfo: (img, callback) ->
    domImg = img.get(0)
    if domImg.complete
      callback.call(this, domImg.naturalWidth, domImg.naturalHeight)
    else
      img.on 'load', =>
        callback.call(this, domImg.naturalWidth, domImg.naturalHeight)

this.ImageFile = ImageFile

