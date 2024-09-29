@tool
extends VisualShaderNodeCustom
class_name IdMapSampler


func _get_name():
	return "IdMapSampler"


func _get_category():
	return "Masking"


func _get_description():
	return "IdMap Masking By Sampler2D"


func _init():
	set_input_port_default_value(1, Vector3.ZERO)
	set_input_port_default_value(2, 0.05)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_TRANSFORM


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "IdMap"
		1:
			return "ColorKey"
		2:
			return "Tolerance"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SAMPLER
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR_4D
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	return "Mask"

func _get_output_port_type(port):
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_global_code(mode):
	return """

float GetMask(sampler2D idMap, vec4 colorKey, float tolerance, vec2 uv) {
	vec4 n_out2p0;
// Texture2D:2
	n_out2p0 = texture(idMap, uv);

// VectorDecompose:8
	float n_out8p0 = vec3(n_out2p0.xyz).x;
	float n_out8p1 = vec3(n_out2p0.xyz).y;
	float n_out8p2 = vec3(n_out2p0.xyz).z;


// ColorParameter:18
	vec4 n_out18p0 = colorKey;


// VectorDecompose:7
	float n_out7p0 = vec3(n_out18p0.xyz).x;
	float n_out7p1 = vec3(n_out18p0.xyz).y;
	float n_out7p2 = vec3(n_out18p0.xyz).z;


// FloatOp:9
	float n_out9p0 = n_out8p0 - n_out7p0;


// FloatParameter:19
	float n_out19p0 = tolerance;


// Compare:12
	float n_in12p1 = 0.00000;
	bool n_out12p0 = (abs(n_out9p0 - n_in12p1) < n_out19p0);

// FloatOp:10
	float n_out10p0 = n_out8p1 - n_out7p1;


// Compare:13
	float n_in13p1 = 0.00000;
	bool n_out13p0 = (abs(n_out10p0 - n_in13p1) < n_out19p0);

// FloatOp:15
	float n_out15p0 = min((n_out12p0 ? 1.0 : 0.0), (n_out13p0 ? 1.0 : 0.0));


// FloatOp:11
	float n_out11p0 = n_out8p2 - n_out7p2;


// Compare:14
	float n_in14p1 = 0.00000;
	bool n_out14p0 = (abs(n_out11p0 - n_in14p1) < n_out19p0);

// FloatOp:16
	float n_out16p0 = min(n_out15p0, (n_out14p0 ? 1.0 : 0.0));


// Output:0
	return n_out16p0;

}
	"""

func _get_code(input_vars, output_vars, mode, type):
	return output_vars[0] + " = GetMask(%s, %s, %s, UV);" % [input_vars[0], input_vars[1], input_vars[2]]
