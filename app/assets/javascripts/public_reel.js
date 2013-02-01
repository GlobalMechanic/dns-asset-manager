//= require jquery
//= require jquery_ujs
//= require underscore
//= require zero-clipboard

$(document).ready(function() {
  var tray = _.template(
    ['<div id="tray-<%= asset.id %>" class="video tray">',
      '<div class="inside">',
        '<video class="video-js vjs-default-skin" controls="controls" autoplay="autoplay" width="960" height="540">',
          '<source src="http://globalmechanic.com/asset/movies/<%= asset.video %>" type="video/mp4">',
        '</video>',
        '<div class="meta">',
          '<div class="info">',
            '<ul>',
              '<li><strong>Director</strong> <%= asset.director %></li>',
              '<li><strong>Title</strong> <%= asset.title %></li>',
              '<li><strong>Client</strong> <%= asset.client %></li>',
            '</ul>',
          '</div>',
          '<div class="actions">',
            '<ul>',
              '<li><a href="mailto:tina@globalmechanic.com?subject=Montage%203D"><div class="icon email"></div><div>Contact Us</div></a></li>',
              //'<li><a id="share-button" href="#"><div class="icon"></div><div>Share asset</div></a></li>',
            '</ul>',
          '</div>',
          '<div id="share" class="clearfix">',
            '<div class="column">',
              '<label for="share-url">URL for this asset:</label>',
              '<input id="share-url" type="text" value="<%= root_url %>reels/<%= reel.slug %>" /><span class="assetpy"></span>',
            '</div>',
            '<div class="column">',
              '<label>Share it with:</label>',
              '<a class="twitter" target="_blank" href="http://twitter.com/share?url=<%= root_url %>reels/<%= reel.slug %>&amp;text=Reel%20from%20Global%20Mechanic%3A%20<%= reel.title %>">Twitter</a>',
              '<a class="email" href="mailto:?subject=Asset%20from%20Global%20Mechanic%3A%20Montage%203D&amp;body=http%3A%2F%2Fglobalmechanic.com%2Freel%2F1204%2F613">Email</a>',
              '<a class="facebook" target="_blank" href="http://www.facebook.com/sharer.php?u=http%3A%2F%2Fglobalmechanic.com%2Freel%2F1204%2F613&amp;t=Asset%20from%20Global%20Mechanic%3A%20Montage%203D">Facebook</a>',
            '</div>',
          '</div>',
          '<div class="description"><%= asset.description %></div>',
        '</div>',
      '</div>',
    '</div>'].join('')
  );

  if (navigator.userAgent.match(/msie/i)) {
    _V_.options.techOrder = ["flash","html5"];
  }
  $('body.public-reel .assets .asset').click(function() {
    var active = $(this).hasClass('active');
    $('body.public-reel .assets .asset.active').removeClass('active');
    $('body.public-reel .video.tray').remove();
    if (!active) {
      $(this).addClass('active');
      var assetID = parseInt($(this).attr('id').replace('asset-', ''));
      var $newAsset = $(tray({ root_url: gm.root_url, asset: gm.assets[assetID], reel: gm.reel }));
      _V_($newAsset.find('video').get(0));
      $(this).parent('.assets').after($newAsset);
      //window.setTimeout(function() {
        //_V_('asset-' + assetID + '-video', {}, function() { console.log('hahaha'); });
      //}, 2000);
      //$(this).parent('.assets').after(tray({ root_url: gm.root_url, asset: gm.assets[assetID], reel: gm.reel }));
      if ($('.tray').length > 0) {
        var currentTray = $('.tray .inside, .tray video').last();
        var paddingTop = ($(window).height() - currentTray.height()) / 2;
        if (paddingTop < 0) {
          paddingTop = 0;
        }
        window.scrollTo(0, currentTray.parent().position().top - paddingTop);
      }
    }
    return false;
  });

});
