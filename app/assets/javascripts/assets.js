$(document).ready(function() {

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
  $('.asset .default').click(function(e) {
    if ($(this).parents('.asset').hasClass('open')) {
      $(this).parents('.asset').removeClass('open')
      $(this).parent().find('video').each(function() {
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
      $('.asset.open').removeClass('open');
      $('.tile.open').removeClass('open');
      $('.tab-tile .tile:last-child').addClass('open');
      $('.asset-utilities li:last-child a').addClass('active');
      $(this).parents('.asset').addClass('open');
      $(this).parent().find('video').get(0).play();
    }
  });

  $('.extended .title').click(function() {
      $(this).parents('.asset').removeClass('open');
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
      console.log('two');
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
    }
  });

  var submitBatch = function() {
    $.each(gm.uploads, function(i, upload) {
      var asset = {};
      $('#batch-form input, #batch-form textarea').each(function (j, input) {
        var attribute = upload.context.find('input[name=' + $(input).attr('name') + '], textarea[name=' + $(input).attr('name') + ']').val();
        if (attribute !== '' || $(input).val() !== '') {
          asset[$(input).attr('name')] = attribute == '' || !upload.context.hasClass('show') ? $(input).val() : attribute;
        }
      });
      $.ajax('/assets/' + upload.result.id + '.json', {
        type: 'PUT',
        data: { asset: asset },
        success: function() {
          upload.context.addClass('success');
          if ($('.asset-uploads .row:not(.success)').length === 0) {
            $('body').removeClass('drop');
          }
        }
      });
    });
    return false;
  };
  $('#batch-form').submit(submitBatch);
  $('#update-uploads').click(submitBatch);

  $('.row header').on('click', function() {
    var $row = $(this).parent();
    if (!$row.hasClass('show')) {
      $row.find('input, textarea').each(function(i, input) {
        $(input).val($('#batch-form').find('input[name=' + $(input).attr('name') + '], textarea[name=' + $(input).attr('name') + ']').val());
      });
    }
    $row.toggleClass('show');
  });

});
