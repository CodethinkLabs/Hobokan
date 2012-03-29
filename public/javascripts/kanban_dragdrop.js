var drop_handler = function() {

  var item_position = "";

  item_position = "&item_position=" + jQuery(this).parent().children().filter('li').index(this)

  var item_id = this.attr("id").substr(1);
  var lane_id = this.parent().attr("id").substr(1);

  var startchar = "?"
  if (window.location.href.indexOf("?") != -1) startchar = "&"

  Hobo.ajaxRequest( window.location.href + startchar + "lane_id=" + lane_id + "&item_id=" + item_id + item_position,
                    [],
                    { params: { lane_id: lane_id, item_id: item_id },
                      action: 'show',
                      controller: 'projects',
                      method: 'get',
                      message: "Please wait"
                    } );
  count_cards ();
}

jQuery(".kb-lane",".board").dragsort({ dragBetween: true, dragEnd: drop_handler});
