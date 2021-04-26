module main

import os
import gg
import gx
import time

struct App {
	gray gx.Color = gx.rgb(41, 44, 51)
	font_config gx.TextCfg = gx.TextCfg{
		size: 24
		color: gx.rgb(148, 162, 188)
	}
mut:
	gg &gg.Context
	pointer_toggle int
}

fn main() {
	mut app := &App{
		gg: 0
	}
	app.gg = gg.new_context(
		bg_color: app.gray
		width: 975
		height: 520
		window_title: "Vmd"
		frame_fn: frame
		user_data: app
		font_path: os.resource_abs_path("RobotoMono-Regular.ttf")
	)
	app.gg.run()
}

fn frame(mut app App) {
	app.gg.begin()
	app.main_components()
	test := "Hello World"
	for x, char in test.split("") {
		app.gg.draw_text(46 + x * 11, 520 - 32, char.str(), app.font_config)
	}
	app.draw_pointer(167)
	app.gg.end()
	time.sleep(10 * time.millisecond)
}

fn (app App) main_components() {
	app.gg.draw_rect(0, 520 - 40, 975, 40, gx.rgb(52, 56, 65)) // The input box
	app.gg.draw_convex_poly([f32(0), 520 - 32, 20, 520 - 32, 40, 520 - 20, 20, 520 - 8, 0, 520 - 8], gx.rgb(148, 162, 188)) // The arrow pointing at the input
}

fn (mut app App) draw_pointer(x int) {
	if app.pointer_toggle > 30 {
		app.gg.draw_empty_rect(x, 520 - 32, 10, 24, gx.rgb(255, 255, 255))
		if app.pointer_toggle == 60 {
			app.pointer_toggle = 0
		} else {
			app.pointer_toggle += 1
		}
	} else {
		app.gg.draw_rect(x, 520 - 32, 10, 24, gx.rgb(255, 255, 255))
		app.pointer_toggle += 1
	}
}