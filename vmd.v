module main

import os
import gg
import gx
import time

struct App {
	gray        gx.Color   = gx.rgb(41, 44, 51)
	font_config gx.TextCfg = gx.TextCfg{
		size: 24
		color: gx.rgb(148, 162, 188)
	}
mut:
	gg             &gg.Context
	pointer_toggle int
	input          string
}

fn main() {
	mut app := &App{
		gg: 0
	}
	app.gg = gg.new_context(
		bg_color: app.gray
		width: 975
		height: 520
		window_title: 'Vmd'
		frame_fn: frame
		event_fn: on_event
		user_data: app
		font_path: os.resource_abs_path('RobotoMono-Regular.ttf')
	)
	app.gg.run()
}

fn on_event(e &gg.Event, app_ptr voidptr) {
	if e.typ == .char {
		mut app := &App(app_ptr)
		res := utf32_to_str(e.char_code)
		app.input = app.input + res
	}
	if e.typ == .key_down {
		handle_key_down(e, app_ptr)
	}
}

fn handle_key_down(e &gg.Event, app_ptr voidptr) {
	mut app := &App(app_ptr)
	if e.key_code == .backspace {
		if app.input.len > 0 {
			app.input = app.input.substr(0, app.input.len - 1)
		}
	}
	if e.key_code == .enter {
		app.input = ''
	}
}

fn frame(mut app App) {
	app.gg.begin()
	app.main_components()

	window_height := app.gg.window_size().height

	for x, char in app.input.split('') {
		app.gg.draw_text(46 + x * 11, window_height - 32, char.str(), app.font_config)
	}
	app.draw_pointer(46 + app.input.len * 11)
	app.gg.end()
	time.sleep(10 * time.millisecond)
}

fn (app App) main_components() {
	window_height := app.gg.window_size().height

	app.gg.draw_rect_filled(0, window_height - 40, 975, 40, gx.rgb(52, 56, 65)) // The input box
	app.gg.draw_convex_poly([f32(0), window_height - 32, 20, window_height - 32, 40,
		window_height - 20, 20, window_height - 8, 0, window_height - 8], gx.rgb(148,
		162, 188)) // The arrow pointing at the input
}

fn (mut app App) draw_pointer(x int) {
	window_height := app.gg.window_size().height

	if app.pointer_toggle > 30 {
		app.gg.draw_rect_empty(x, window_height - 32, 10, 24, gx.rgb(255, 255, 255))
		if app.pointer_toggle == 60 {
			app.pointer_toggle = 0
		} else {
			app.pointer_toggle += 1
		}
	} else {
		app.gg.draw_rect_filled(x, window_height - 32, 10, 24, gx.rgb(255, 255, 255))
		app.pointer_toggle += 1
	}
}
