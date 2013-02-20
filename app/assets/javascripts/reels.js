$(document).ready(function() {
  
  $('#open-reel, #create-reel').click(function() {
    $(this).parent().toggleClass('open');
    return false;
  });

  $('#create-reel').click(function () {
    $('#reel_title').focus();
  });

  $('#asset-filters li:first-child a').on("click", function() {
    $(this).parents('#asset-filters').toggleClass('open');
    return false;
  });

  $('#episode-filters li:first-child a').on("click", function() {
    $(this).parents('#episode-filters').toggleClass('open');
    return false;
  });

  // Drag and drop for reels.
  if (gm.controller === 'reels' && gm.action === 'edit') {
    // Asset drag events.
    var $dragged = null;
    $('.asset').bind('dragstart', function(e) {
      e.originalEvent.dataTransfer.effectAllowed = 'move';
      e.originalEvent.dataTransfer.setData('text/asset', this);
      // Firefox needs this.
      if (typeof $.browser.mozilla !== 'undefined') {
        e.originalEvent.dataTransfer.setDragImage($(this).find('img').get(0), 80, 60);
      }
      $('.assets').addClass('dragging');
      $dragged = $(this).addClass('dragged');
      return true;
    }).bind('dragend', function(e) {
      $('.assets').removeClass('dragging');
      $dragged.removeClass('dragged');
      return true;
    });

    // Slot dragover events.
    $('.slot').bind('dragover', function(e) {
      $(this).addClass('active');
      // Drag into a neighbouring slot (no change).
      if ($dragged.next().get(0) === this || $dragged.prev().get(0) === this) {
        return true;
      }
      else {
        return false;
      }
    }).bind('dragleave', function(e) {
      $(this).removeClass('active');
      return false;
    }).bind('drop', function(e) {
      var $this = $(this);
      var $bringMeAlong = $dragged.prev();

      // Move asset into new slot
      $dragged.insertAfter($this);
      $bringMeAlong.insertAfter($dragged);

      // Remove active from slot.
      $this.removeClass('active');

      // Save new order to server.
      var assets = [];
      $('.asset .reel').each(function(index, asset) {
        assets.push($(asset).attr('id').replace(/asset-/, ''));
      });
      $.post('/reels/' + gm.current_reel_slug + '/sort.json', { order: assets }, function(data) {
        // We cool.
      });
    });
  }

});
