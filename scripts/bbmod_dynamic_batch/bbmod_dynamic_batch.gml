/// @func BBMOD_DynamicBatch(_model, _size)
/// @desc A dynamic batch.
/// @param {BBMOD_Model} _model The model to create a dynamic batch of.
/// @param {real} _size Number of model instances in the batch.
/// @example
/// Following code renders all instances of a car object in batches of 64.
/// ```gml
/// /// @desc Create event
/// mod_car = new BBMOD_Model("car.bbmod");
/// mat_car = new BBMOD_Material(BBMOD_ShDefaultBatched, sprite_get_texture(SprCar, 0));
/// car_batch = new BBMOD_DynamicBatch(mod_car, 64);
///
/// /// @desc Draw event
/// car_batch.render_object(OCar, mat_car);
/// ```
function BBMOD_DynamicBatch(_model) constructor
{
	/// @var {BBMOD_Model} A model that is being batched.
	/// @readonly
	model = _model

	/// @var {real} Number of model instances in the batch.
	/// @readonly
	size = _size;

	/// @var {real} A vertex buffer.
	/// @private
	vertex_buffer = vertex_create_buffer();

	/// @var {real} The format of the vertex buffer.
	/// @private
	vertex_format = model.get_vertex_format(false, true);

	vertex_begin(vertex_buffer, vertex_format);
	_bbmod_model_to_dynamic_batch(model.model, self);
	vertex_end(vertex_buffer);

	/// @func freeze()
	/// @desc Freezes the dynamic batch. This makes it render faster.
	static freeze = function () {
		gml_pragma("forceinline");
		vertex_freeze(vertex_buffer);
	};

	/// @func render(_material, _data)
	/// @desc Submits the dynamic batch for rendering.
	/// @param {BBMOD_Material} _material A material. Must use a shader that
	/// expects ids in the vertex format.
	/// @param {array} _data An array containing data for each rendered instance.
	/// @see BBMOD_DynamicBatch.render_object
	static render = function (_material, _data) {
		if ((_material.get_render_path() & global.bbmod_render_pass) == 0)
		{
			// Do not render the mesh if it doesn't use a material that can be used
			// in the current render path.
			return;
		}
		_material.apply();
		_bbmod_shader_set_dynamic_batch_data(_material.get_shader(), _data);
		var _tex_base = _material.get_base_opacity();
		vertex_submit(vertex_buffer, pr_trianglelist, _tex_base);
	};

	/// @func default_fn(_data, _index)
	/// @desc The default function used in {@link BBMOD_DynamicBatch.render_object}.
	/// Uses instance's variables `x`, `y`, `z` for position, `image_xscale` for
	/// uniform scale and `image_angle` for rotation around the `z` axis.
	/// @param {array} _data An array to which the function will write instance
	/// data. The data layout is compatible with shader `BBMOD_ShDefaultBatched`
	/// and hence with material {@link BBMOD_MATERIAL_DEFAULT_BATCHED}.
	/// @param {real} _index An index at which the first variable will be written.
	/// @return {real} Number of slots it has written to. Always equals 8.
	/// @see BBMOD_DynamicBatch.render_object
	static default_fn = function (_data, _index) {
		// Position
		_data[@ _index] = x;
		_data[@ _index + 1] = y;
		_data[@ _index + 2] = z;
		// Uniform scale
		_data[@ _index + 3] = image_xscale;
		// Rotation
		var _quat = ce_quaternion_create_from_axisangle([0, 0, 1], image_angle);
		array_copy(_data, _index + 4, _quat, 0, 4);
		// Written 8 slots in total
		return 8;
	};

	/// @func render_object(_object, _material[, _fn])
	/// @desc Renders all instances of an object in batches of
	/// {@link BBMOD_DynamicBatch.size}.
	/// @param {real} _object An object to render.
	/// @param {BBMOD_Material} _material A material to use.
	/// @param {function} [_fn] A function that writes instance data to an array
	/// which is then passed to the material's shader. Must return number of
	/// slots it has written to. Defaults to {@link BBMOD_DynamicBatch.default_fn}.
	/// @example
	/// ```gml
	/// car_batch.render_object(OCar, mat_car, function (_data, _index) {
	///     // Position
	///     _data[@ _index] = x;
	///     _data[@ _index + 1] = y;
	///     _data[@ _index + 2] = z;
	///     // Uniform scale
	///     _data[@ _index + 3] = image_xscale;
	///     // Rotation
	///     var _quat = ce_quaternion_create_from_axisangle([0, 0, 1], image_angle);
	///     array_copy(_data, _index + 4, _quat, 0, 4);
	///     // Written 8 slots in total
	///     return 8;
	/// });
	/// ```
	/// The function defined in this example is actually the implementation of
	/// {@link BBMOD_DynamicBatch.default_fn}. You can use this to create you own
	/// variation of it.
	/// @see BBMOD_DynamicBatch.render
	/// @see BBMOD_DynamicBatch.default_fn
	static render_object = function (_object, _material, _fn) {
		var _find = 0;
		repeat (instance_number(_object) mod size)
		{
			var _data = array_create(size * 8, 0);
			var _index = 0;
			repeat (size)
			{
				var _instance = instance_find(_object, _find++);
				if (_instance == noone)
				{
					break;
				}
				_index += method(_instance, _fn)(_data, _index);
			}
			render(_material, _data);
		}
	};

	/// @func destroy()
	/// @desc Frees memory used by the dynamic batch. Use this in combination with
	/// `delete` to destroy a dynamic batch struct.
	/// @example
	/// ```gml
	/// dynamic_batch.destroy();
	/// delete dynamic_batch;
	/// ```
	static destroy = function () {
		gml_pragma("forceinline");
		vertex_delete_buffer(vertex_buffer);
	};
}