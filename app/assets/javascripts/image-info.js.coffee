class ImageInfo
    
  constructor: (file) ->
    $('.wrap:has(.image-info)', file).each (index, frame) =>
      this.setImageInfo($('img', frame), $('.image-info', frame))
    
  setImageInfo: (img, imageInfo) ->
    domImg = img.get(0)
    if domImg.complete
      imageInfo.append(this.formatImageInfo(domImg.naturalWidth, domImg.naturalHeight))
    else
      img.on 'load', =>
        imageInfo.append(this.formatImageInfo(domImg.naturalWidth, domImg.naturalHeight))

  formatImageInfo: (w, h) ->
    " | <b>W:</b> #{w}px | <b>H:</b> #{h}px"
