var count_cards = function () {

  jQuery(".lane-count").text(function () {
    return jQuery(this).parent().parent().parent().children().size() - 1;
  });
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

var laneheight = window.innerHeight - (jQuery('.navigation').height() * 4) - jQuery('.timeline').height();
if (laneheight < 300) laneheight = 300;
laneheight = laneheight + "px";
jQuery(".kb-lane").css("height", laneheight);

count_cards();
