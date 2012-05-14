
var drop_handler = function() {
  // Get the length of the lane, excluding the 'h3' heading
  var lane_length = jQuery(this).parent().children().length - 1;
  // The positions of the item rows in the database are from 1 to
  // the lane length in descending order, whereas in the kanban
  // board they start at 0 and go in ascending order.
  var item_position = lane_length - this.attr("data-itemidx");
  var item_id = this.attr("id").substr(1);
  var lane_id = this.parent().attr("id").substr(1);

  var startchar = "?"
  if (window.location.href.indexOf("?") != -1) startchar = "&"

  Hobo.ajaxRequest( window.location.href + startchar +
                    "lane_id=" + lane_id +
                    "&item_id=" + item_id +
                    "&item_position=" + item_position,
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
