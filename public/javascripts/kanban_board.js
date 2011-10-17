
jQuery("#data_output").hide();

var init_states = function(states_input) {
    var states = {}
	var states_order = []
	for ( var i=0, len=states_input.length; i<len; i++ ) {
		var state = states_input[i].split(",");
		if (state.length == 2) {
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
            var story_element = jQuery("<li><div class=\"box box_" + state  + "\">" + board[state][i][1] + " " + board[state][i][2] + "</div></li>");
            story_element.data("story",  board[state][i]);
            list.append(story_element);
     	 }
	   }
	   return list
}

var create_column = function(board, state, headline) {
	   var state_column = jQuery("<div class=\"dp10" + ((! /_Q$/.test(state)) ? "" : " queue_column")+ "\"></div>");
	   state_column.append(jQuery("<div class=\"headline\">" + headline + "</div>"));
	   state_column.append(create_list(board, state));
	   state_column.data("state", state);
	   return state_column;
}

var create_board = function(app_data) {
	var table = jQuery("<div id=\"board\"></div>");
	var ids = "";
	for (j=0; j< app_data.states_order.length; j++) {
		var state = app_data.states_order[j]
		if (! /_Q$/.test(state)) {
			var queue_state = state + "_Q";
      ids += "#" + queue_state + ",";
      var queue_state_column = create_column(app_data.board, queue_state, app_data.states[state] + " Ready")
			table.append(queue_state_column)

      ids += "#" + state + ",";
			var state_column = create_column(app_data.board, state, app_data.states[state])
			table.append(state_column)
		}
	}
	jQuery(ids, table).dragsort({ dragBetween: true });
	return table;
}

var state_data = init_states(jQuery("#states").text().split("\n"));
var app_data = { board: init_board(jQuery("#stories").text().split("\n")), states: state_data.states, states_order: state_data.states_order}
jQuery("#output").empty();
jQuery("#output").append(create_board(app_data));



