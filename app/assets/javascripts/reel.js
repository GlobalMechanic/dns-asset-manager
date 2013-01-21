$(document).ready(function() {
  
  $('#open-reel, #create-reel').click(function() {
    $(this).parent().toggleClass('open');
    return false;
  });

  $('#create-reel').click(function () {
    $('#reel_title').focus();
  });

  // Drag and drop for reels.
  if (gm.controller === 'reels' && gm.action === 'edit') {
    // Clip drag events.
    var $dragged = null;
    $('.clip').bind('dragstart', function(e) {
      e.originalEvent.dataTransfer.effectAllowed = 'move';
      e.originalEvent.dataTransfer.setData('text/clip', this);
      // Firefox needs this.
      if (typeof $.browser.mozilla !== 'undefined') {
        e.originalEvent.dataTransfer.setDragImage($(this).find('img').get(0), 80, 60);
      }
      $('.clips').addClass('dragging');
      $dragged = $(this).addClass('dragged');
      return true;
    }).bind('dragend', function(e) {
      $('.clips').removeClass('dragging');
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

      // Move clip into new slot
      $dragged.insertAfter($this);
      $bringMeAlong.insertAfter($dragged);

      // Remove active from slot.
      $this.removeClass('active');

      // Save new order to server.
      var clips = [];
      $('.clip .reel').each(function(index, clip) {
        clips.push($(clip).attr('id').replace(/clip-/, ''));
      });
      $.post('/reels/' + gm.current_reel_slug + '/sort.json', { order: clips }, function(data) {
        // We cool.
      });
    });
  }

});
