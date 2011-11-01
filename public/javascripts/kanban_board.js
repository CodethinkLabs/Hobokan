/*
 * This software application is Twitter-Ware. If you like it,
     use it, or have something to say, follow and tell me on Twitter
   at @codemonkeyism
   http://twitter.com/codemonkeyism
   Blog at http://www.codemonkeyism.com

   Webssite http://www.simple-kanban.com
     See MIT license at bottom.

   Copyright (c) 2009 Stephan Schmidt

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE
*/

/*
 * Modified for use with a Rails/Hobo app by Codethink Ltd
 *
 * Copyright (c) 2011 Codethink Ltd
 */

jQuery("#data_output").hide();

var init_states = function(states_input) {
  var states = {}
  var states_order = []
  for ( var i=0, len=states_input.length; i<len; i++ ) {
    var state = states_input[i].split(",");
    if (state.length == 4) {
      states[state[0]] = state[1];
      states_order.push(state[0]);
    }
  }

  return {states: states, states_order: states_order};
}

var init_board = function(stories) {
  var board = {};
  for ( var i=0, len=stories.length; i<len; i++ ) {
    var story = stories[i].split(",");
    var state = story[0];
    if (story.length == 3) {
      if (! board[state]) {
        board[state] = [];
      }
      board[state].push(story);
    }
  }
  return board;
}

var show_item_details = function(transport) {
  jQuery("#edit-item-dialog").empty();
  jQuery("#edit-item-dialog").append(transport.responseText);

  jQuery("#edit-item-dialog").find('.hjq-annotated').each(function() {
    var annotations = hjq.getAnnotations.call(this);
    if(annotations.init) {
      hjq.util.createFunction(annotations.init).call(this, annotations);
    };
  });

  hjq.dialog_opener.click(this, jQuery('#item-dialog'));
}

var get_item_details = function(board, item_id) {
  Hobo.ajaxRequest( "/items/" + item_id + "/ajax_item",
                    [],
                    { params: { item_id: item_id },
                      action: 'ajax_item',
                      controller: 'items',
                      method: 'get',
                      message: "Please wait",
                      onComplete: show_item_details
                    } );
}

var create_list = function(board, state) {
  var list = jQuery("<ul class=\"state\" id=\"" + state + "\" style=\"height:600px;overflow:auto;padding:5px;\"></ul>");
  if (board[state]) {
    for (var i=0, len=board[state].length; i<len; i++) {
      var item_id = board[state][i][1].replace(/^S([\d]+).*/, "$1");
      var title = board[state][i][2].replace(/ /g, "_").toLowerCase();
      var click_handler = "<a class=\"edit-link item-link\" style=\"border-bottom:none\"" +
        " href=\"javascript:get_item_details(this, " + item_id + ");\">" + board[state][i][2] + "</a>";
      var story_element = jQuery("<li><div class=\"box box_" +
      state  + "\">" + board[state][i][1] + " " + click_handler + "</div></li>");
      story_element.data("story",  board[state][i]);
      list.append(story_element);
    }
  }
  return list
}

var create_column = function(board, state, headline) {
  var state_column = jQuery("<div class=\"dp10" + "\"></div>");
  state_column.append(jQuery("<div class=\"headline\">" + headline + "</div>"));
  state_column.append(create_list(board, state));
  state_column.data("state", state);
  return state_column;
}

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

var create_board = function(app_data) {
  var table = jQuery("<div id=\"board\"></div>");
  var ids = "";
  for (j=0; j< app_data.states_order.length; j++) {
    var state = app_data.states_order[j]
    ids += "#" + state + ",";
    var state_column = create_column(app_data.board, state, app_data.states[state])
    table.append(state_column)
  }
  jQuery(ids, table).dragsort({ dragBetween: true, dragEnd: drop_handler });
  return table;
}

var create_box_colors = function(states_input) {
  var styles = jQuery('<style type="text/css"><!-- --></style>');
  for ( var i=0, len=states_input.length; i<len; i++ ) {
    var state = states_input[i].split(",");
    if (state.length == 4) {
      styles.append("#" + state[0] + " .box { background-color: " + state[2] + " ; color: " + state[3] + ";}");
    }
  }

  return styles;
}

var state_data = init_states(jQuery("#states").text().split("\n"));
var app_data = { board: init_board(jQuery("#stories").text().split("\n")), states: state_data.states, states_order: state_data.states_order}
jQuery("#output").empty();
jQuery("#output").append(create_box_colors(jQuery("#states").text().split("\n")));
jQuery("#output").append(create_board(app_data));


