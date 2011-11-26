var drop_handler = function() {
  var children = this.parent().children();
  var item_ordering = "";

  for (var i = 0, len = children.length; i < len; i++) {
    item_ordering += "&item_ordering[]=" + children[i].textContent.replace(/^S([\d]+).*/, "$1");
  }

  var item_id = this.text().replace(/^S([\d]+).*/, "$1");
  var lane_id = this.parent().attr("id").replace(/^L([\d]+).*/, "$1");
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
  var txt = jQuery("#change-log").is(':visible') ? "Change Log" : "Hide Change Log";          
  this.value = txt;
  jQuery("#change-log").toggle(); });

jQuery(".lane",".board").dragsort({ dragBetween: true, dragEnd: drop_handler});
