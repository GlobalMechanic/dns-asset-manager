$(document).ready(function() {

  var setupFlash = function(i, element) {
    var entityMap = {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': '&quot;',
      "'": '&#39;',
      "/": '&#x2F;'
    };
    function escapeHtml(string) {
      return String(string).replace(/[&<>"'\/]/g, function (s) {
        return entityMap[s];
      });
    }
    // var flashURL = 'http://osmf.org/videos/cathy2.flv';
    var flashURL = escapeHtml($(element).data('flash-url'));
    var video = ['<object id="object-player" width="359" height="181">',
      '<param name="movie" value="http://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf"></param>',
      '<param name="flashvars" value="src=' + flashURL + '&controlBarMode=none&playButtonOverlay=false&loop=true&autoPlay=true&backgroundColor=#ffffff&javascriptCallbackFunction=gm.playerReady"></param>',
      '<param name="allowFullScreen" value="true"></param>',
      '<param name="allowscriptaccess" value="always"></param>',
      '<param name="javascriptCallbackFunction" value="gm.playerReady"></param>',
      '<embed src="http://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="359" height="181" flashvars="src=' + flashURL + '&controlBarMode=none&playButtonOverlay=false&loop=true&autoPlay=true&backgroundColor=#ffffff&javascriptCallbackFunction=gm.playerReady"></embed>',
      '</object>'];

    $(element).append(video.join("\n"));
    gm.playerReady = function(playerId) {
      $player = $('#object-player');
      window.setTimeout(function() {
        if ($player.attr('width') == 359) {
          $player.attr('width', 358);  
        }
        else {
          $player.attr('width', 359);
        }
      }, 200);
    }
  }
  $('[data-flash-url]:empty').each(setupFlash);

  // Asset add/remove click events.
  $('.asset .reel').click(function(e) {
    var $asset = $(this);
    $asset.toggleClass('add').toggleClass('remove').addClass('loading');
    if ($asset.hasClass('add')) {
      $.ajax({
        url: $asset.attr('href') + '.json',
        type: 'DELETE',
        success: function(data) {
          if (data > 0) {
            $('#create-reel').addClass('show');
          }
          else {
           $('#create-reel').removeClass('show'); 
          }
          $asset.removeClass('loading');
        }
      });
    }
    else if ($asset.hasClass('remove')) {
      $.ajax({
        url: $asset.attr('href') + '.json',
        type: 'POST',
        success: function(data) {
          if (data > 0) {
            $('#create-reel').addClass('show');
          }
          else {
           $('#create-reel').removeClass('show'); 
          }
          $asset.removeClass('loading');
        }
      });
    }
    return false;
  });

  // Handle video player.
  $('.asset .default, .asset .title').click(function(e) {
    if ($(this).parents('.asset').hasClass('open')) {
      $(this).parents('.asset').removeClass('open');
      $(this).parent().find('video, audio').each(function() {
        this.pause();
        if (this.currentTime > 0) {
          this.currentTime = 0;
        }
      });
    }
    else {
      $('.asset.open video').each(function () {
        this.pause();
        if (this.currentTime > 0) {
          this.currentTime = 0;
        }
      });
      $(this).parent().find('[data-image-url]:empty').each(function() {
        $(this).append($('<img>', { 'src': $(this).data('image-url') }));
      });
      $(this).parent().find('[data-flash-url]:empty').each(setupFlash);
      $('.asset.open').removeClass('open');
      $('.tile.open').removeClass('open');
      $('.tab-tile .tile:last-child').addClass('open');
      $('.asset-utilities a').removeClass('active');
      $('.asset-utilities li:last-child a').addClass('active');
      $(this).parents('.asset').addClass('open');
      $(this).parent().find('video:not(.default), audio').each(function() {
        this.play();
      });
    }
  });

  $('.extended .title').click(function() {
      $(this).parents('.asset').removeClass('open');
  });

  $('.extended .edit_asset').submit(function() {
    var $this = $(this);
    $this.addClass('active');
    window.tylor = $this;
    $.ajax(gm.root_url + 'assets/' + $this.attr('id').replace('edit_asset_', '') + '.json', {
      type: 'PUT',
      data: $this.serialize(),
      success: function() {
        $this.removeClass('active');
      },
      error: function() {
        $this.addClass('error');
      }
    });
    return false;
  });

  // Reveal relevant tile
  $('.asset-utilities a').click(function (event) {
    event.preventDefault();
    var currentTile = $(this).parent('li').index() + 1;

    $(this).parents('.asset-utilities').find('.active').removeClass('active');
    $('.tab-tile .tile').removeClass('open');
    $(this).addClass('active');
    $(".tab-tile .tile:nth-child("+ currentTile +")").addClass('open');
  });

  gm.uploads = [];
  $('#new_asset').fileupload({
    dataType: 'json',
    add: function(e, data) {
      $('body').addClass('drop');

      data.context = $($($.parseHTML(tmpl("template-upload", data.files[0]))));
      $('#upload-form .asset-uploads').append(data.context);
      var reader = new FileReader();
      reader.onload = function (event) {
        var image = $('<img width="80">').attr('src', event.target.result);
        data.context.find('.image').append(image);
      };
      reader.readAsDataURL(data.files[0]);
      data.submit();
    },
    progress: function(e, data) {
      var progress;
      if (data.context) {
        progress = parseInt(data.loaded / data.total * 100, 10);
        data.context.find('.bar').css('width', progress + '%');
      }
    },
    done: function (e, data) {
      data.context.find('.progress').removeClass('active').addClass('progress-success');
      gm.uploads.push(data);
    },
    fail: function(e, data, three) {
      data.context.find('.progress').remove()
      data.context.append('<div class="alert">' + JSON.parse(data.jqXHR.responseText).asset[0] + '</div>');
    }
  });

  var submitBatch = function() {
    $.each(gm.uploads, function(i, upload) {
      var formContext = upload.context.hasClass('show') ? upload.context : $('#batch-form');
      var asset = {
        'description': $('#description', formContext).val(),
        'keyword_list': $('#keyword_list', formContext).val(),
        'asset_type': $('#asset_asset_type', formContext).val(),
        'scene_ids': $('#asset_scene_ids', formContext).val(),
      };
      $.ajax(gm.root_url + 'assets/' + upload.result.id + '.json', {
        type: 'PUT',
        data: { asset: asset },
        success: function() {
          upload.context.addClass('success');
          if ($('.asset-uploads > .row:not(.success)').length === 0) {
            $('body').removeClass('drop');
          }
        }
      });
    });
    return false;
  };
  $('#batch-form').submit(submitBatch);
  $('#update-uploads').click(submitBatch);
  $('#close-uploads').click(function() {
    $('body').removeClass('drop');
    window.location.reload();
  });

  $(document).on('click', '.row header', function() {
    var $row = $(this).parent();
    if (!$row.hasClass('show')) {
      $row.find('input, select, textarea').each(function(i, input) {
        $(input).val($('#batch-form').find('input[name="' + $(input).attr('name') + '"], select[name="' + $(input).attr('name') + '"], textarea[name="' + $(input).attr('name') + '"]').val());
      });
    }
    $row.toggleClass('show');
  });

});
