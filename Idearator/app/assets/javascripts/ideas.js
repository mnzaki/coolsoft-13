$(document).ready(function() {

  $(".view_tags").click(function(){
    $(".available-tags").slideDown("slow");
    $(".view_tags").hide();
    $(".hide_tags").fadeIn("slow");
  });

  $(".hide_tags").click(function(){
    $(".available-tags").slideUp("slow");
    $(".hide_tags").hide();
    $(".view_tags").fadeIn("slow");
  });

$(".similar_idea").click(function(){
  var idea_id_redirect = $(this).attr("value");
  window.location.href = '/ideas/' + idea_id_redirect;
});

$('.btn-success.add-rating').click(function(){
    $('.add-ratings').show();
  });
  // When The user clicks on facebook share or twitter share button, this method
  // gets the current URL of the current page and apends it to the default facebook
  // and twitter sharing URLs.
  // This page's URl is then shared on The user's facebook or twitter account.
  // Author: Mohamed Sameh

  var prePopulate = [];

  $("#idea-tags .idea-tag input:checked").each(function(i, checkbox) {
    checkbox = $(checkbox);
    prePopulate.push({id: checkbox.val(), name: checkbox.data("tag-name")});
  });

  $("#idea-tags").html('<input type="text" id="tag_token_input" name="blah2" />')

  $("#tag_token_input").tokenInput('/tags/ajax', {
    theme: "facebook",
    preventDuplicates: true,
    tokenLimit: 5,
    tokenFormatter: function(item){
      return "<li>" + item.name
           + "<input id='ideas_tags_tags_' type='hidden' value='" + item.id + "' name='idea[tag_ids][]' />"
           + "</li>";
    },
    prePopulate: prePopulate
  });

  $('.best_in_place').best_in_place();
  $('.best_in_place').tooltip({animation: true, title:'Click to edit' , trigger: 'hover', html: true });
  $('.best_in_place').bind("ajax:success", function(){
    $('#edited-check-mark').remove();
    $(this).append("<i class='icon-ok pull-right' id ='edited-check-mark'></i>");
  });

  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=446451938769749";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  function sendAjax(idea_id){
    var list = "";
    var i=0;
    $('.token-input-list-facebook li p').each(function(){
      list += "rating[]="+$(this).text()+"&";
      i=i+1;

    });

    $.ajax("/ideas/" + idea_id + "/add_rating?"+list);
  }

  $('.new-idea-form-title .hint').text($('.new-idea-form-title .hint-val').attr("placeholder"));
  $('.new-idea-form-description .hint').text($('.new-idea-form-description .hint-val').attr("placeholder"));
  $('.new-idea-form-problem .hint').text($('.new-idea-form-problem .hint-val').attr("placeholder"));

  $("input, select, textarea").on("focus", function(){
    $(this).on("keyup", function(){
      if($(this).val().length == 0){
        $(this).siblings("span").css("display", "none");
      }else{
        $(this).siblings("span").css("display", "inline");
      }
    });
    }).on("blur", function(){
      if($(this).val().length == 0){
        $(this).siblings("span").css("display", "none");
      }else{
        $(this).siblings("span").css("display", "inline");
      }
  });
});

