// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
  var Page = 1;
$(document).ready(function() {
  var prePopulate = [];

  $("#competition-tags .competition-tag input:checked").each(function(i, checkbox) {
    checkbox = $(checkbox);
    prePopulate.push({id: checkbox.val(), name: checkbox.data("tag-name")});
  });

  $("#competition-tags").html('<input type="text" id="tag_token_input" name="blah2" />')

  $("#tag_token_input").tokenInput('/tags/ajax', {
    theme: "facebook",
    preventDuplicates: true,
    tokenLimit: 5,
    tokenFormatter: function(item){
      return "<li>" + item.name
      + "<input id='competitions_tags_tags_' type='hidden' value='" + item.id + "' name='competition[tag_ids][]' />"
      + "</li>";
    },
    prePopulate: prePopulate
  });
  $('.best_in_place').best_in_place();
  $('.best_in_place').bind("ajax:success", function(){
    $('#edited-check-mark').remove();
    $(this).append("<i class='icon-ok pull-right' id ='edited-check-mark'></i>");
  });
  $.datepicker.setDefaults({ dateFormat: 'dd M (D)' });

  function nearBottomOfPage() {
    return $(window).scrollTop() > $(document).height() - $(window).height() - 100;
  }

  function passedPage1() {
    return $(window).scrollTop() > 600;
  }

  function backToTop() {
    return $(window).scrollTop() < 600;
  }

  apply_script();



  var loading = false;

  $(window).scroll(function () {
    if (loading) {
      return;
    }
    if (passedPage1()) {
      $('.backtotop').show();
    }
    if (backToTop()) {
      $('.backtotop').hide();
    }
    if (nearBottomOfPage() && $("#search").val() === '') {
      loading = true;
      Page += 1;

      var array = ["a"];
      var i = 1;
      if($('.tag').length > 0){
       $('.tag').each(function () {
        array[i] = $(this).text();
        i += 1;
      });
     }

     $.ajax({
      type: 'get',
      url: 'competitions',
      data: {
        myPage: Page,
        tags: array
      },
      beforeSend: function () {
        // this is where we append a loading image
        //$('#ajax-panel').html('<div class="loading"><img src="/images/loading.gif" alt="Loading..." /></div>');
      },
      success: function (array) {
        loading = false;
      },
      error: function () {
          // failed request; give feedback to user
        }

      });
   }
 });

});

function apply_script(){
  $('.aTag').click(function(){
    Page = 1 ;
    var array = ["a"];
    var i = 1;
    if($('.tag').length > 0){
     $('.tag').each(function () {
      array[i] = $(this).text();
      i += 1;
    });
   }
   array[i] = $(this).text();

   $.ajax({
    type: 'get',
    url: 'competitions',
    data: {
      tags: array
    },
    beforeSend: function () {
        // this is where we append a loading image
        //$('#ajax-panel').html('<div class="loading"><img src="/images/loading.gif" alt="Loading..." /></div>');
      },
      success: function (array) {
        loading = false;
      },
      error: function () {
          // failed request; give feedback to user
        }

      });

 });

  $('.delete-token').click(function(){
    Page = 1 ;
    var array = ["a"];
    var i = 1;
    $(this).parent().remove();
    if($('.tag').length > 0){
     $('.tag').each(function () {
      array[i] = $(this).text();
      i += 1;
    });
   }
   $.ajax({
    type: 'get',
    url: 'competitions',
    data: {
      tags: array
    },
    beforeSend: function () {
    },
    success: function (array) {
      loading = false;
    },
    error: function () {
    }

  });

 });

}