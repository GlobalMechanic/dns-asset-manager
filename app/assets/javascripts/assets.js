$(document).ready(function() {
  var currentMBps = null;

  // Modified from: http://stackoverflow.com/a/5529841
  var imageAddr = "/assets/ui/loading.gif" + "?n=" + Math.random();
  var startTime, endTime;
  var downloadSize = 43976;
  var download = new Image();
  download.onload = function () {
    endTime = (new Date()).getTime();
    showResults();
  }
  startTime = (new Date()).getTime();
  download.src = imageAddr;

  function showResults() {
    // var bitsLoaded = downloadSize * 8;
    // var speedBps = (bitsLoaded / duration).toFixed(2);
    // var speedKbps = (speedBps / 1024).toFixed(2);
    // var speedMbps = (speedKbps / 1024).toFixed(2);
    var duration = (endTime - startTime) / 1000;
    var bytesLoaded = downloadSize;
    var speedBytesps = (bytesLoaded / duration).toFixed(2);
    var speedKBps = (speedBytesps / 1024).toFixed(2);
    var speedMBps = (speedKBps / 1024).toFixed(2);
    currentMBps = (1/speedMBps).toFixed(2);
  }

  var layout = $('.assets.list-view').length > 0 ? 'list' : 'tile';
  var dimensions = {
    'tile': {
      width: 734,
      height: 330
    },
    'list': {
      width: 860,
      height: 433
    }
  }
  gm.playerReady = function(playerId) {
    $player = $('#object-player');
    window.setTimeout(function() {
      if ($player.attr('width') == dimensions[layout]['width']) {
        $player.attr('width', dimensions[layout]['width'] - 1);  
      }
      else {
        $player.attr('width', dimensions[layout]['width']);
      }
    }, 500);
  }
  var setupFlash = function(i, element) {
    console.log(element);
    window.tylor = element;
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
    var video = ['<object id="object-player" width="' + dimensions[layout]['width'] + ' " height="' + dimensions[layout]['height'] + '">',
      '<param name="movie" value="http://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf"></param>',
      '<param name="flashvars" value="src=' + flashURL + '&controlBarMode=none&playButtonOverlay=false&loop=true&autoPlay=true&backgroundColor=#ffffff&javascriptCallbackFunction=gm.playerReady"></param>',
      '<param name="allowFullScreen" value="true"></param>',
      '<param name="allowscriptaccess" value="always"></param>',
      '<param name="javascriptCallbackFunction" value="gm.playerReady"></param>',
      '<embed src="http://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="' + dimensions[layout]['width'] + '" height="' + dimensions[layout]['height'] + '" flashvars="src=' + flashURL + '&controlBarMode=none&playButtonOverlay=false&loop=true&autoPlay=true&backgroundColor=#ffffff&javascriptCallbackFunction=gm.playerReady"></embed>',
      '</object>'];

    $(element).append(video.join("\n"));
  }
  $('body.controller-assets.action-edit [data-flash-url]:empty').each(setupFlash);

  // Asset add/remove click events.
  $('body').on('click', '.asset .reel', function(e) {
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

  // Handle image preview
  $('body').on('click', '.media .detail img', function() {
    $(this).toggleClass('fullsize');
  });

  var toggleTile = function($asset) {
    $('[data-flash-url]').empty();
    if ($asset.hasClass('open')) {
      $asset.removeClass('open');
      $asset.find('.video-js.full-size').each(function(i, item) {
        var video = _V_($(item).attr('id'));
        video.pause();
        if (video.currentTime() > 0) {
          video.currentTime(0);
        }
      });
    }
    else {
      $('.asset.open .video-js.full-size').each(function (i, item) {
        var video = _V_($(item).attr('id'));
        video.pause();
        if (video.currentTime() > 0) {
          video.currentTime(0);
        }
      });
      $asset.find('[data-image-url]:empty').each(function() {
        $(this).append($('<img>', { 'src': $(this).data('image-url') }));
      });
      $asset.find('.video-js').each(function(i, item) {
        _V_($(item).attr('id'), { "preload": "none", "controls": "true" }, function(){
        });
        // _V_($(item).attr('id')).play();
      });
      $asset.find('[data-flash-url]:empty').each(setupFlash);
      $('.asset.open').removeClass('open');
      $('.tile.open').removeClass('open');
      $('.fullsize').removeClass('fullsize');
      $('.tab-tile .tile.edit').addClass('open');
      $('.asset-utilities a').removeClass('active');
      $('.asset-utilities .edit a').addClass('active');
      $asset.addClass('open');
      $asset.find('.video-js.full-size').each(function(i, item) {
        _V_($(item).attr('id')).play();
      });
    }   
  }

  var setupExtended = function($asset, callback) {
    var $extended = $asset.find('.extended');
    if ($extended.html() === '') {
      var id = $asset.attr('id').replace('asset-', '');
      $.ajax({
        url: '/plum-landing/assets/' + id + '/extended.json',
        type: 'GET',
        success: function(data) {
          $extended.html(data.html);
          if (currentMBps) {
            $extended.find('.internet-speed').html(currentMBps);
          }
          $extended.find('#asset_swatch').addClass(function() {
            return $(this).find('#asset_status').val();
          });
          $extended.find('#asset_status').change(function() {
            var that = this;
            $(this).parents('#asset_swatch').attr('class', function() {
              return $(that).val();
            });
          });
          $extended.find('#asset_asset').change(function() {
            var size = ($(this).get(0).files[0].size / (1024*1024)).toFixed(1);
            $extended.find('label[for="asset[asset]"]').html('Upload File (' + size + 'MB, ~' + (size / currentMBps).toFixed(1) + 's)');
          });
          $extended.find('#asset_preview').change(function() {
            var size = ($(this).get(0).files[0].size / (1024*1024)).toFixed(1);
            $extended.find('label[for="asset[preview]"]').html('Upload SWF Preview (' + size + 'MB, ~' + (size / currentMBps).toFixed(1) + 's)');
          });

          $('.status input[type="checkbox"]:checked').parent().addClass('checked');
          $extended.find('.status .status-button').click(function() {
            $this = $(this);
            if (!$this.hasClass('checked')) {
              $('.status .status-button').removeClass('checked');
              $('.status .status-button input[type="checkbox"]').prop('checked', false);
              $this.addClass('checked');
              $this.find('input[type="checkbox"]').prop('checked', true);
            }
            else {
              $this.removeClass('checked');
              $this.find('input[type="checkbox"]').prop('checked', false);
            }
          });
          // $('.extended .asset-form input#asset_asset').get(0).files[0].size /(1024 * 1024);
          callback();
        }
      });
    }
    else {
      callback();
    }
  };

  // Handle video player.
  $('body').on('click', '.asset .default, .asset .title', function(e) {
    var $this = $(this);
    $this.parents('.asset').addClass('loading');
    setupExtended($this.parents('.asset'), function() {
      $this.parents('.asset').removeClass('loading');
      toggleTile($this.parents('.asset'));
    });
  });
  // $('.asset').hover(function() {
  //   var $this = $(this);
  //   setupExtended($this, function() {
  //     console.log('setup!', $this)
  //   });
  // });

  $('.controller-assets.action-show .asset').each(function(i, asset) {
    toggleTile($(asset));
  });

  $('body').on('click', '.extended .title', function() {
      $(this).parents('.asset').removeClass('open');
  });

  $('body').on('submit', '.extended .edit .asset-form', function() {
    var $this = $(this);
    var $asset = $this.parents('.asset');
    $asset.addClass('loading');
    if ($asset.find('input[type="file"]').val() === '') {
      $.ajax($this.attr('action') + '.json', {
        type: 'PUT',
        data: $this.serialize(),
        success: function(data) {
          $asset.removeClass('loading');
          toggleTile($this.parents('.asset'));
          $asset.find('.extended').html(''); // Next time opened, reload from server.
          var classes = [
            'asset',
            data.asset.status
          ];
          if (data.asset.submitted) {
            classes.push('submitted');
          } 
          if (data.asset.approved) {
            classes.push('approved-denny');
          } 
          if (data.asset.revision) {
            classes.push('revision');
          } 
          $asset.attr('class', classes.join(' '));

          var $workflow = $asset.find('.asset-workflow');
          $workflow.html('');

          if (data.asset.checked_out) {
            $workflow.append('<div class="checkout asset-state" title="Checked Out">out</div>');
          }
          else {
            $workflow.append([
              '<div class="checkin asset-state">',
                '<a href="#download-asset" title="Download Asset">Download Asset</a>',
              '</div>',
            ].join(''));
            //.. link up to download.
          }
          if (data.assigned_to) {
            $workflow.append([
              '<p class="assigned-to" title="Assigned To">',
                data.assigned_to,
              '</p>',
            ].join(''));
          }
        },
        error: function(data) {
          $asset.removeClass('loading');
          $asset.addClass('error');
          $asset.find('.title').html('There was a problem updating your asset, try editing directly.');
        }
      });
      return false;
    }
    else {
      return true;
    }
  });

  $('body').on('submit', '.extended .inline-autocomplete .edit_asset', function() {
    var $this = $(this);
    $this.addClass('active');
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

  $('.asset-form #asset_swatch').addClass(function() { return $('.asset-form #asset_status').val(); });
  $('.asset-form #asset_status').change(function() {
    $('.asset-form #asset_swatch').attr('class', function() {
      return $('.asset-form #asset_status').val();
    });
  });

  // Asset download
  $('body').on('click', '.asset-state a[href*="#download-asset"]', function(event) {
    var $this = $(this);
    setupExtended($this.parents('.asset'), function() {
      $('.asset-utilities').find('.active').removeClass('active');
      $('.tab-tile .tile').removeClass('open');
      $('.asset').removeClass('open');
      toggleTile($this.parents('.asset'));
      $this.parents('.asset').find('.asset-utilities li a.active').removeClass('active');
      $this.parents('.asset').find('.asset-utilities li:first-child a').addClass('active');
      $this.parents('.asset').find('.tile.open').removeClass('open');
      $this.parents('.asset').find('.tile:first-child').addClass('open');
    });
    return false;
  });  

  // Reveal relevant tile
  $('body').on('click', '.asset-utilities a', function (event) {
    event.preventDefault();
    var currentTile = $(this).parent('li').index() + 1;

    $(this).parents('.asset-utilities').find('.active').removeClass('active');
    $('.tab-tile .tile').removeClass('open');
    $(this).addClass('active');
    $(".tab-tile .tile:nth-child("+ currentTile +")").addClass('open');
    $(this).parents('.asset').find('.video-js.full-size').each(function (i, item) {
      var video = _V_($(item).attr('id'));
      video.pause();
      if (video.currentTime() > 0) {
        video.currentTime(0);
      }
    });
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
