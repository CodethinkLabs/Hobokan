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
}

var get_item_details = function(board, item_id) {
  Hobo.ajaxRequest( "/items/" + item_id + "/ajax_item",
                    [],
                    { params: { item_id: item_id },
                      action: 'ajax_item',
                      controller: 'items',
                      method: 'get',
                      message: "Please wait",

                      onSuccess: function(transport) {
                        jQuery("#edit-item-dialog").empty();
                        jQuery("#edit-item-dialog").append(transport.responseText);

                        jQuery("#edit-item-dialog").find('.hjq-annotated').each(function() {
                          var annotations = hjq.getAnnotations.call(this);
                          if (annotations.init) {
                            hjq.util.createFunction(annotations.init).call(this, annotations);
                          };
                        });

                        hjq.dialog_opener.click(this, jQuery('#item-dialog-s' + item_id));
                      },

                      onFailure: function(transport) {
                        jQuery("#edit-item-dialog").empty();
                      }
                    } );
}

jQuery("#cl-toggle").click( function() {
  this.value = jQuery("#change-log").is(':visible') ? "Change Log" : "Hide Change Log";
  jQuery("#change-log").toggle();
});

var laneheight = window.innerHeight - (jQuery('.navigation').height() * 4) - jQuery('.timeline').height() + "px";
jQuery(".kb-lane").css("height", laneheight);

jQuery(".kb-lane",".board").dragsort({ dragBetween: true, dragEnd: drop_handler});
jQuery(".lane-count").text(function () { return jQuery(this).parent().parent().parent().children().size() - 1;});
