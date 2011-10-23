
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

var create_list = function(board, state) {
  var list = jQuery("<ul class=\"state\" id=\"" + state + "\"></ul>");
  if (board[state]) {
    for (var i=0, len=board[state].length; i<len; i++) {
      var item_id = board[state][i][1].replace(/^S([\d]+).*/, "$1");
      var title = board[state][i][2].replace(/ /g, "_").toLowerCase();
      var story_element = jQuery("<li><div class=\"box box_" +
      state  + "\">" + board[state][i][1] + " " + board[state][i][2] + "<a class=\"edit-link item-link\" style=\"float: right;\" href=\"/items/" + item_id + "/edit\">Edit</a></div></li>");
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


