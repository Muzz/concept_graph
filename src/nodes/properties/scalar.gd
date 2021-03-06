tool
extends ConceptNode


func _init() -> void:
	unique_id = "inspector_scalar"
	display_name = "Scalar property"
	category = "Inspector properties"
	description = "Expose a Scalar value to the inspector"

	var opts = {
		"disable_slot": true,
		"max_value": 1000,
		"min_value": -1000,
		"allow_greater": true,
		"allow_lesser": true,
		"value": 1,
	}

	set_input(0, "Name", ConceptGraphDataType.STRING, {"disable_slot": true})
	set_input(1, "Default", ConceptGraphDataType.SCALAR, opts)
	set_output(0, "", ConceptGraphDataType.SCALAR)


func _ready() -> void:
	connect("input_changed", self, "_on_input_changed")


func _generate_outputs() -> void:
	var name: String = get_input_single(0, "")
	var value = get_parent().get_value_from_inspector(name)

	if not value:
		value =  get_input_single(1, 1.0)

	output[0] = value


func get_exposed_variables() -> Array:
	var name: String = get_input_single(0, "")
	if not name:
		return []

	return [{
		"name": name,
		"type": ConceptGraphDataType.SCALAR,
		"default_value": get_input_single(1, 1.0),
		}]


func _on_input_changed(slot: int, _value) -> void:
	if slot == 0:
		get_parent().update_exposed_variables()
