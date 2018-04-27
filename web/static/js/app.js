// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import $ from "jquery";

import flatpickr from "flatpickr";

import initializeSimpleDatepickers from "./simple_datepicker"
initializeSimpleDatepickers();

import initializeDatetimepickers from "./datetimepicker"
initializeDatetimepickers();

// import selectTwo from "select2";
import select2 from 'select2';

//Hook up select2 to jQuery
select2($);

import initializeSimpleSelect2 from "./simple_select2"
initializeSimpleSelect2();

import vis from "vis";

import initializeVisInteractive from "./vis_interactive"
initializeVisInteractive(vis);
