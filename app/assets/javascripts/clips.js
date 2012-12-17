$(document).ready(function() {
  // Clip add/remove click events.
  $('.clip .reel').click(function(e) {
    var $clip = $(this);
    $clip.toggleClass('add').toggleClass('remove').addClass('loading');
    if ($clip.hasClass('add')) {
      $.ajax({
        url: $clip.attr('href') + '.json',
        type: 'DELETE',
        success: function(data) {
          $clip.removeClass('loading');
        }
      });
    }
    else if ($clip.hasClass('remove')) {
      $.ajax({
        url: $clip.attr('href') + '.json',
        type: 'POST',
        success: function(data) {
          $clip.removeClass('loading');
        }
      });
    }
    return false;
  });

  var nameToId = {
    'title': '#search_title_contains',
    'director': '#search_director_equals',
    'client': '#search_client_equals',
  };
  $(nameToId[$('#clip_search #where').val()]).addClass('show');
  $('#clip_search #where').change(function(e) {
    $('#clip_search .facet').removeClass('show');
    $(nameToId[$(this).val()]).addClass('show');
  });
  $('#clip_search').submit(function() {
    $('#clip_search .facet').not(nameToId[$('#clip_search #where').val()]).val('');
  });

  if (gm.controller === 'reels' && gm.action === 'edit') {
    // Clip drag events.
    var $dragged = null;
    $('.clip').bind('dragstart', function(e) {
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
