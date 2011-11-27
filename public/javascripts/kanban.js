var drop_handler = function() {

  var item_ordering = "";
  jQuery.each(this.parent().children(),function(){
    item_ordering += "&item_ordering[]=" + this.id.substr(1);
  });

  var item_id = this.attr("id").substr(1);
  var lane_id = this.parent().attr("id").substr(1);

  Hobo.ajaxRequest( window.location.href + "?lane_id=" + lane_id + "&item_id=" + item_id + item_ordering,
                    [],
                    { params: { lane_id: lane_id, item_id: item_id },
                      action: 'show',
                      controller: 'projects',
                      method: 'get',
                      message: "Please wait"
                    } );
}

jQuery("#cl-toggle").click( function() {
  this.value = jQuery("#change-log").is(':visible') ? "Change Log" : "Hide Change Log";
  jQuery("#change-log").toggle();
});

jQuery(".lane",".board").dragsort({ dragBetween: true, dragEnd: drop_handler});
