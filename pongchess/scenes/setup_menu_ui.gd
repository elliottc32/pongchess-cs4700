extends Control

@export var p1_label: Label
@export var p2_label: Label
signal begin_match_button_pressed(p1: String, p2: String)

func switch_p1():
	if p1_label.text == "Human 1":
		p1_label.text = "COM 1"
	elif p1_label.text == "COM 1":
		p1_label.text = "Human 1"

func switch_p2():
	if p2_label.text == "Human 2":
		p2_label.text = "COM 2"
	elif p2_label.text == "COM 2":
		p2_label.text = "Human 2"

func _on_p_1_left_button_pressed() -> void:
	switch_p1()

func _on_p_1_right_button_pressed() -> void:
	switch_p1()

func _on_p_2_left_button_pressed() -> void:
	switch_p2()

func _on_p_2_right_button_pressed() -> void:
	switch_p2()

func _on_begin_match_button_pressed() -> void:
	var p1: String
	var p2: String
	if p1_label.text.contains("Human"):
		p1 = "Human"
	else:
		p1 = "COM"
	if p2_label.text.contains("Human"):
		p2 = "Human"
	else:
		p2 = "COM"
	begin_match_button_pressed.emit(p1, p2)
