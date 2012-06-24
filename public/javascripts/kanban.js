var count_cards = function () {

  jQuery(".lane-count").text(function () {
    return jQuery(this).parent().parent().parent().children().size() - 1;
  });
}

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

/*
 * Add a box for a new task onto its lane, and then
 * close the new task dialog
 */
var terminate_new_item_dialog = function(transport) {
  var dialog = jQuery('#new-task-dialog');
  var lane_id = dialog.find('.item_lane').val();
  if (lane_id == '') {
    lane_id = jQuery(".kb-lane")[0].id.substr(1);
  }

  // Insert the new task just after the lane heading
  jQuery('#L' + lane_id + ' h3').after(transport.responseText);
  count_cards();
  hjq.dialog.close(dialog);

  // Initialize the fields in the dialog
  jQuery("#item_title").val("");
  jQuery(".item_milestone").val("Choose Milestone");
  jQuery(".item_lane").val("Choose Lane");
  jQuery("#item_text").val("");

  jQuery(".project-members-view .items").empty();
  jQuery(".project-members-view .disabled-option").replaceWith(function () {
    return '<option value="' + jQuery(this).attr('alt') + '">' + this.label + '</option>';
  });

  jQuery("#item_doable").attr("checked", false);
}

/*
 * Replace the card in the lane with the amended card,
 * or move it to a new lane if the lane changed.
 * Then close the dialog.
 */
var terminate_update_item_dialog = function(transport, item_id) {
  var dialog = jQuery('#item-dialog-s' + item_id);
  var lane_id = dialog.find('.item_lane').val();
  var box = jQuery('#S' + item_id);
  var current_lane_id = box.parent().attr("id").substr(1);

  if (current_lane_id != lane_id) {
    box.remove();
    jQuery('#L' + lane_id + ' h3').after(transport.responseText);
    count_cards();
  } else {
    box.replaceWith(transport.responseText);
  }

  hjq.dialog.close(dialog);
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

jQuery("#ms-toggle").click( function() {
  if (jQuery("#timeline").is(':visible')) {
    this.value = "Milestones";
  }
  else {
	this.value = "Hide Milestones";
  }
  jQuery("#timeline").toggle();
  return;
});

jQuery("#cl-toggle").click( function() {
  if (jQuery("#change-log").is(':visible')) {
    this.value = "Change Log";
    jQuery("#change-log").toggle();
    return;
  }

    var href = jQuery(".project-link").attr("href");
    Hobo.ajaxRequest( href + "/change_log",
                    [],
                    { params: { },
                      action: 'change_log',
                      controller: 'projects',
                      method: 'get',
                      message: "Please wait",

                      onSuccess: function(transport) {
                        jQuery("#change-log-div").empty();
                        jQuery("#change-log-div").append(transport.responseText);
                        jQuery("#change-log").toggle();
                        jQuery("#cl-toggle").val("Hide Change Log");
                      },

                      onFailure: function(transport) {
                      }
                    } );

});

var laneheight = window.innerHeight - (jQuery('.navigation').height() * 4) - jQuery('.timeline').height();
if (laneheight < 300) laneheight = 300;
laneheight = laneheight + "px";
jQuery(".kb-lane").css("height", laneheight);

jQuery(".kb-lane",".board").dragsort({ dragBetween: true, dragEnd: drop_handler});
count_cards();
