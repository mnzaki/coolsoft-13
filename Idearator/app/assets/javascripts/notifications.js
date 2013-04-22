function add_notification_event_handlers() {
  $('div.invite-committee').click(function () {
    var notification = $(this).data('notification');
    $.getScript("/redirect_expertise.js?&notification=" + notification);
  });

  $('div.idea').click(function () {
    //var idea = this.getAttribute('data-idea');
    var notification = $(this).data('notification');
    $.getScript("/redirect_idea.js?&notification=" + notification);
  });

  $('div.approve-committee').click(function () {
    //var user = this.getAttribute('data-user');
    var notification = $(this).data('notification');
    $.getScript("/redirect_review.js?&notification=" + notification);
  });

  $('div.delete').click(function () {
    var notification = $(this).data('notification');
    $.getScript("/set_read.js?&notification=" + notification);
  });
}

$(document).ready(add_notification_event_handlers);