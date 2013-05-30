// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function nearBottomOfPage() {
  return $(window).scrollTop() > $(document).height() - $(window).height() - 100;
}

function passedPage1() {
  return $(window).scrollTop() > $('#landing').height() + 1000 ;
}

function backToTop() {
  return $(window).scrollTop() < $('#landing').height() + 1000 ;
}

function redirect_to_best(r){
  window.location = "/ideas/" + r;
}

var currentpage = 1;
var thistag = [];
var searchtext = "";
will_insert = true;
user_search = "";
var previous_search = "";
var last_scroll = 0;
var height = 0;
var dist_to_up = 0;
first_fix_down = false;
first_fix_up = false;

function check_if_exists(tag){
  for(var i = 0; i < thistag.length; i++){
    if(thistag[i]==tag){
      return true;
    }
  }
  return false;
}

function stream_manipulator(page,tag,search,insert,user){
  console.log("da5ell1");
  currentpage = page;
  searchtext = search+"";
  will_insert = (insert == "true");
  user_search = (user == "true");
  reset = "false";
  if (!(searchtext == "" && !user_search && tag == "" && !will_insert)){
    if(searchtext != "" && tag != ""){
      currentpage = 1;
      user_search = false;

      if(will_insert){
        if(!check_if_exists(tag) && (tag[0] != $("#stream_results").data("outsidetags")[0])){
          thistag = tag.concat(thistag);
        }
      }else{
        if (check_if_exists(tag)){
          for (var i = 0; i < thistag.length; i++) {
            if (thistag[i] == tag) {
              thistag.splice(i,1);
              user_search = false;
              currentpage = 1;
              break;
            }
          }
        }else{
          reset = "true";
          searchtext = "";
          user_search = false;
          currentpage = 1;
        }
      }
    }else{
      if (searchtext == "" && !user_search){
        if(will_insert){
          if(!check_if_exists(tag)&& (tag[0] != $("#stream_results").data("outsidetags")[0])){
            thistag = tag.concat(thistag);
          }
          searchtext = "";
          user_search = false;
          currentpage = 1;

        }else{
          if (check_if_exists(tag)){
            for (var i = 0; i < thistag.length; i++) {
              if (thistag[i] == tag) {
                thistag.splice(i,1);
                searchtext = "";
                user_search = false;
                currentpage = 1;
                break;
              }
            }
          }else{
            reset = "true";
            searchtext = "";
            user_search = false;
            currentpage = 1;
          }
        }
      }else{
        if(tag == "" && !will_insert){
          if (user_search){
            currentpage = 1;
            searchtext = search+"";
            user_search = true;
            thistag = [];
          }else{
            currentpage = 1;
            searchtext = search+"";
            user_search = false;
            thistag = [];
          }
        }
      }
    }
  }
  
  $("#stream_results").html("");
  $("#stream_results").data("tags",thistag);
  
  
  if(reset == "true"){
    $.ajax({
      url: '/stream/index?page=' + currentpage,
      type: 'get',
      dataType: 'script',
      data: { mypage: currentpage, tag: thistag, search: searchtext, search_user: user_search, insert: will_insert ,reset_global: reset},
      complete: function() {
        apply_tag_handlers();
        apply_tooltip_handlers();
      }
    });
  }else{
   $.ajax({
    url: '/stream/index?page=' + currentpage,
    type: 'get',
    dataType: 'script',
    data: { mypage: currentpage, tag: thistag, search: searchtext, search_user: user_search, insert: will_insert},
    complete: function() {
      apply_tag_handlers();
      apply_tooltip_handlers();     
    } 
  });
 }
 set_search();
}

$(document).on('ajaxStart', function(){
   var link = $('#spinner-inner').attr("value");
   $('#spinner-inner').css("visibility","visible");
});

$(document).on('ajaxStop', function(){
   $('#spinner-inner').css("visibility","hidden");
});

$(document).ready(function(){

  if(!($("#landing").is(":visible"))){
    $("#sidebar").css("position","fixed");
    $("#sidebar").css("top",71);
    $("#sidebar").css("left",940);
  }

  $("#sidebar").hover(function(){
    $("#sidebar").css("overflow-y","auto");
  },function(){
    $("#sidebar").css("overflow-y","hidden");
  });

  $(".show").click(function(){
    if($("#topten-content").is(':hidden')){
      $('#topten-content').slideDown(1000, function() {
        $(".show-sign").removeClass("icon-plus-sign");
        $(".show-sign").addClass("icon-minus-sign");
      });
    }else{
      $('#topten-content').slideUp(1000, function() {
        $(".show-sign").addClass("icon-plus-sign");
        $(".show-sign").removeClass("icon-minus-sign");
      });
    }
  });

   $(".show-trend").click(function(){
    if($("#trend-content").is(':hidden')){
      $('#trend-content').slideDown('slow', function() {
        $(".show-trend-sign").removeClass("icon-plus-sign");
        $(".show-trend-sign").addClass("icon-minus-sign");
      });
    }else{
      $('#trend-content').slideUp('slow', function() {
        $(".show-trend-sign").addClass("icon-plus-sign");
        $(".show-trend-sign").removeClass("icon-minus-sign");
      });
    }
  });

  if($("#landing").is(':visible')){
    $("#in-stream-component").hide();
  }
  if($("#stream_results").data("outsidetags").length > 0){
    $("#landing-stream").show();
    $("#landing").hide();
  }

  if($('#search').val() != ""){
    $("#landing-stream").show();
    $("#landing").hide();
  }

  $('.backtotop').hide();

  $('.backtotop').click(function(){
    $('html, body').animate({scrollTop:0}, 'slow');
  });

  $('.signup-landing-button').hide();
  $('.landing-sign-in-form').hide();

  $('.signin-landing-button').click(function (e) {
    e.preventDefault();
    $('.landing-sign-up').hide();
    $('.landing-login').hide();
    $('.landing-sign-in-form').slideDown("slow");
    $('.signin-landing-button').hide();
    $('.signup-landing-button').show();
  });

  $('.signup-landing-button').click(function (e) {
    e.preventDefault();
    $('.landing-login').show();
    $('.landing-sign-in-form').hide();
    $('.landing-sign-up').slideDown("slow");
    $('.signup-landing-button').hide();
    $('.signin-landing-button').show();
  });

  apply_tag_handlers();

  $('.post-an-idea').click(function (e) {
    e.preventDefault();
    $('#signedout').modal('show');
  });

  $('#myCarousel').carousel();

  $(".show-stream").click(function show_stream(e){
    e.preventDefault();
    $('#landing').slideUp(1000);
    $("#in-stream-component").slideDown(3000);
    setTimeout(fix_side_bar, 900);
    $('#sidebar .carousel').carousel();
    apply_tag_handlers();
  });

  $(".hide-stream").click(function show_stream(e){
    e.preventDefault();
    $("#sidebar").css("position","static");
    $("#in-stream-component").slideUp(1000);
    $('#landing').slideDown(1000);
    $(".nav-login").addClass("scrollshow");
    $(".scrollshow").slideUp("fast");
  });

  function fix_side_bar(){
    $("#sidebar").css("position","fixed");
    $("#sidebar").css("top",85);
    $("#sidebar").css("left",940);
    $(".scrollshow").slideDown("fast");
    $(".scrollshow").removeClass("scrollshow");
  }

  $(".best-wrapper").click(function() {
  redirect_to_best($(this).data("idea-id"));
  });
});

   function apply_tag_handlers(){
    var stream_height = $("#stream_results").height()/currentpage;

    $("#stream_results .btn-link").click(function tag_caller(e){
      e.preventDefault();
      $("#landing").hide();
      var tag = $(this);
      $("#searchtype").val("false");
      stream_manipulator(1,[tag.val()],$("#search").val(),"true", "false");
      $('html, body').animate({scrollTop:0}, 'slow');
    });

     $(".tagsPopover .btn-link").click(function tag_caller(e){
      e.preventDefault();
      $("#landing").hide();
      var tag = $(this);
      $("#searchtype").val("false");
      stream_manipulator(1,[tag.val()],$("#search").val(),"true", "false");
      $('html, body').animate({scrollTop:0}, 'slow');
    });

    $("#stream_results .close").click(function tag_remover(e){
      e.preventDefault();
      var curr = $(this);
      $("#searchtype").val("false");
      search_isempty = ($("#search").val()=="");
      tags_outside_exist = (($("#stream_results").data("tags").length==0)&&($("#stream_results").data("outsidetags").length==1));
      tags_inside_exist = (($("#stream_results").data("tags").length==1)&&($("#stream_results").data("outsidetags").length==0));
      tags_all = ($("#stream_results").data("tags").length + $("#stream_results").data("outsidetags").length);
      if (curr.val() == $("#stream_results").data("outsidetags")[0]){
        $("#stream_results").data("outsidetags",[]);
      }


      if ((tags_all == 1) && search_isempty){
      }
      stream_manipulator(1,[curr.val()],$("#search").val(),"false", "false");
    });
  }


$(window).scroll (function(){
  if (passedPage1()) {
      $('.backtotop').show();
    }
    if (backToTop()) {
      $('.backtotop').hide();
    }
    
    if($("#landing").is(":visible")){
      
      if($(window).scrollTop()>$('#landing').height()+20){
        $("#sidebar").css("position","fixed");
        $("#sidebar").css("top",65);
        $("#sidebar").css("left",940);
      }else{
        $("#sidebar").css('position','');
        $("#sidebar").css('top','');
      }
    }

  if($(window).scrollTop()!=0 && !($(".stream-generate-button").is(":visible"))){
    if ($(window).scrollTop() > $(document).height() - $(window).height() - 50){
      currentpage = call_infinite_scrolling("stream","index",currentpage,"",[thistag,$("#search").val(),$("#searchtype").val(),false]);
    }
  }
});

 function call_infinite_scrolling(controller,action,page,id,params){
  if(id == ""){
    var url_to_go = '/'+controller+'/'+action+'?page='+page;
  }else{
    var url_to_go = '/'+controller+'/'+id+'?page='+page;
  }
    page++;
    $.ajax({
      url: url_to_go ,
      type: 'get',
      dataType: 'script',
      data: { mypage: page, tag: params[0], search: params[1], search_user: params[2], insert: params[3] },
      success: function() {
        apply_tag_handlers();
      }
    });
    return page;
  }

$(document).ready(function() {      
 $('#sidebar .carousel').carousel('pause');
});

$(document).ready(function() {      
 $('.best-ideas-div').hide();
 $('.show-best').click(function(){
  $('.best-ideas-div').slideDown(1000);
  $('html, body').animate({scrollTop:$('#landing').height()+20}, 'slow');
 });
});