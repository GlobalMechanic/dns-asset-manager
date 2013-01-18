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

  $('#new_clip').fileupload({
    dataType: 'json',
    add: function(e, data) {
      $('body').addClass('drop');
      data.context = $(tmpl("template-upload", data.files[0]));
      $('#new_clip').append(data.context);
      var reader = new FileReader();
      reader.onload = function (event) {
        var image = new Image();
        image.src = event.target.result;
        image.width = 80;
        $('#new_clip').get(0).appendChild(image);
      };
      reader.readAsDataURL(data.files[0]);
      return data.submit();
    },
    progress: function(e, data) {
      var progress;
      if (data.context) {
        progress = parseInt(data.loaded / data.total * 100, 10);
        return data.context.find('.bar').css('width', progress + '%');
      }
    }
  });

  // Do it without jQuery.
  // document.addEventListener('dragover', function(e) {
  //   console.log('drag');
  //   gmDrag = e;
  //   e.preventDefault();
  //   console.log(e.target.files);
  //   console.log(e.dataTransfer.files); // There we are.
  // });

  // document.addEventListener('drop', function(e) {
  //   console.log('drop');
  //   gmDrop = e;
  //   e.preventDefault();
  //   e.stopPropagation();
  //   //console.log(e.target.files);
  //   console.log(e.dataTransfer.files); // There we are.
  // });

  // This was working quite well, but we can't dump these files into the field.
  // $('body').bind('dragover', function(e) {
  //   $('body').addClass('drop');
  //   return false; // preventDefault() please.
  // });
  // $('body').bind('dragend', function(e) {
  //   $('body').removeClass('drop');
  //   return false; // preventDefault() please.
  // });

  // $('body').bind('drop', function(e) {
  //   $('body').addClass('drop');
  //   $.each(e.originalEvent.dataTransfer.files, function(index, file) {
  //     // Write out title.
  //     $('#clip_title').val(file.name.replace(/.(png|jpg)$/, ''));
  //     //$('<p>').html(file.name + ' ' + file.size + ' ' + file.type).appendTo($('#filez'));

  //     // Append a preview maybe.
  //     var reader = new FileReader();
  //     reader.onload = function (event) {
  //       var image = new Image();
  //       image.src = event.target.result;
  //       image.width = 80;
  //       $('#filez').get(0).appendChild(image);
  //     };
  //     reader.readAsDataURL(file);

  //     // Set upload field.
  //     $('<input id="clip_thumbnail" name="clip[thumbnail]" type="file" value="' + file.name + '">').appendTo($('#filez'));
  //   });
  //   //$('#clip_thumbnail').get(0).files[0] = e.originalEvent.dataTransfer.files[0];
  //   $('#clip_title').focus();
  //   return false;
  // });

});
