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
          if (data > 0) {
            $('#create-reel').addClass('show');
          }
          else {
           $('#create-reel').removeClass('show'); 
          }
          $clip.removeClass('loading');
        }
      });
    }
    else if ($clip.hasClass('remove')) {
      $.ajax({
        url: $clip.attr('href') + '.json',
        type: 'POST',
        success: function(data) {
          if (data > 0) {
            $('#create-reel').addClass('show');
          }
          else {
           $('#create-reel').removeClass('show'); 
          }
          $clip.removeClass('loading');
        }
      });
    }
    return false;
  });

  // Handle video player.
  $('.clip .default, .clip .title').click(function(e) {
    if ($(this).parents('.clip').hasClass('open')) {
      $(this).parents('.clip').removeClass('open');
      $(this).parent().find('video').each(function() {
        this.pause();
        if (this.currentTime > 0) {
          this.currentTime = 0;
        }
      });
    }
    else {
      $('.clip.open video').each(function () {
          this.pause();
          if (this.currentTime > 0) {
            this.currentTime = 0;
          }
      });
      $('.clip.open').removeClass('open');
      $(this).parents('.clip').addClass('open');
      $(this).parent().find('video').get(0).play();
    }
  });

  gm.uploads = [];
  $('#new_clip').fileupload({
    dataType: 'json',
    add: function(e, data) {
      $('body').addClass('drop');
      //$('.batch-form').show();
      data.context = $(tmpl("template-upload", data.files[0]));
      $('#upload-form .clip-uploads').append(data.context);
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
      var clip = {};
      $('#batch-form input, #batch-form textarea').each(function (j, input) {
        var attribute = upload.context.find('input[name=' + $(input).attr('name') + '], textarea[name=' + $(input).attr('name') + ']').val();
        if (attribute !== '' || $(input).val() !== '') {
          clip[$(input).attr('name')] = attribute == '' ? $(input).val() : attribute;
        }
      });
      $.ajax('/clips/' + upload.result.id + '.json', {
        type: 'PUT',
        data: { clip: clip },
        success: function() {
          $('body').removeClass('drop');
        }
      });
    });
    return false;
  };
  $('#batch-form').submit(submitBatch);
  $('#update-uploads').click(submitBatch);


  $('.row').live('click', function() {
    $(this).addClass('show');
  });

});
