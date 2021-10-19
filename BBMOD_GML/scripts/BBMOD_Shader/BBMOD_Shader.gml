global.__bbmodShaderCurrent = BBMOD_NONE;

/// @macro {BBMOD_Shader/BBMOD_NONE} The current shader in use or {@link BBMOD_NONE}.
/// @readonly
#macro BBMOD_SHADER_CURRENT global.__bbmodShaderCurrent

/// @func BBMOD_Shader(_shader, _vertexFormat)
/// @desc A wrapper for a raw GameMaker shader resource.
/// @param {shader} _shader The shader resource.
/// @param {BBMOD_VertexFormat} _vertexFormat The vertex format required by the shader.
/// @see BBMOD_Material
/// @see BBMOD_VertexFormat
function BBMOD_Shader(_shader, _vertexFormat) constructor
{
	/// @var {shader} The shader resource.
	/// @readonly
	Raw = _shader;

	/// @var {BBMOD_VertexFormat} The vertex format required by the shader.
	/// @readonly
	VertexFormat = _vertexFormat;

	UTextureOffset = get_uniform("bbmod_TextureOffset");

	UTextureScale = get_uniform("bbmod_TextureScale");

	UBones = get_uniform("bbmod_Bones");

	UBatchData = get_uniform("bbmod_BatchData");

	UAlphaTest = get_uniform("bbmod_AlphaTest");

	/// @func get_name()
	/// @desc Retrieves the name of the shader.
	/// @return {string} The name of the shader.
	static get_name = function () {
		gml_pragma("forceinline");
		return shader_get_name(Raw);
	};

	/// @func is_compiled()
	/// @desc Checks whether the shader is compiled.
	/// @return {bool} Returns `true` if the shader is compiled.
	static is_compiled = function () {
		gml_pragma("forceinline");
		return shader_is_compiled(Raw);
	};

	/// @func get_uniform(_name)
	/// @desc Retrieves a handle of a shader uniform.
	/// @param {string} _name The name of the shader uniform.
	/// @return {real} The handle of the shader uniform.
	static get_uniform = function (_name) {
		gml_pragma("forceinline");
		return shader_get_uniform(Raw, _name);
	};

	/// @func set_uniform_f(_handle, _value)
	/// @desc Sets a `float` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {real} _value The new uniform value.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_f = function (_handle, _value) {
		gml_pragma("forceinline");
		shader_set_uniform_f(_handle, _value);
		return self;
	};

	/// @func set_uniform_f2(_handle, _val1, _val2)
	/// @desc Sets a `vec2` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {real} _val1 The first vector component.
	/// @param {real} _val2 The second vector component.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_f2 = function (_handle, _val1, _val2) {
		gml_pragma("forceinline");
		shader_set_uniform_f(_handle, _val1, _val2);
		return self;
	};

	/// @func set_uniform_f3(_handle, _val1, _val2, _val3)
	/// @desc Sets a `vec3` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {real} _val1 The first vector component.
	/// @param {real} _val2 The second vector component.
	/// @param {real} _val3 The third vector component.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_f3 = function (_handle, _val1, _val2, _val3) {
		gml_pragma("forceinline");
		shader_set_uniform_f(_handle, _val1, _val2, _val3);
		return self;
	};

	/// @func set_uniform_f4(_handle, _val1, _val2, _val3, _val4)
	/// @desc Sets a `vec4` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {real} _val1 The first vector component.
	/// @param {real} _val2 The second vector component.
	/// @param {real} _val3 The third vector component.
	/// @param {real} _val4 The fourth vector component.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_f4 = function (_handle, _val1, _val2, _val3, _val4) {
		gml_pragma("forceinline");
		shader_set_uniform_f(_handle, _val1, _val2, _val3, _val4);
		return self;
	};

	/// @func set_uniform_f_array(_handle, _array)
	/// @desc Sets a `float[]` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {real[]} _array The array of new values.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_f_array = function (_handle, _array) {
		gml_pragma("forceinline");
		shader_set_uniform_f_array(_handle, _array);
		return self;
	};

	/// @func set_uniform_i(_handle, _value)
	/// @desc Sets an `int` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {int} _value The new uniform value.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_i = function (_handle, _value) {
		gml_pragma("forceinline");
		shader_set_uniform_i(_handle, _value);
		return self;
	};

	/// @func set_uniform_i2(_handle, _val1, _val2)
	/// @desc Sets an `ivec2` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {int} _val1 The first vector component.
	/// @param {int} _val2 The second vector component.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_i2 = function (_handle, _val1, _val2) {
		gml_pragma("forceinline");
		shader_set_uniform_i(_handle, _val1, _val2);
		return self;
	};

	/// @func set_uniform_i3(_handle, _val1, _val2, _val3)
	/// @desc Sets an `ivec3` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {int} _val1 The first vector component.
	/// @param {int} _val2 The second vector component.
	/// @param {int} _val3 The third vector component.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_i3 = function (_handle, _val1, _val2, _val3) {
		gml_pragma("forceinline");
		shader_set_uniform_i(_handle, _val1, _val2, _val3);
		return self;
	};

	/// @func set_uniform_i4(_handle, _val1, _val2, _val3, _val4)
	/// @desc Sets an `ivec4` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {int} _val1 The first vector component.
	/// @param {int} _val2 The second vector component.
	/// @param {int} _val3 The third vector component.
	/// @param {int} _val4 The fourth vector component.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_i4 = function (_handle, _val1, _val2, _val3, _val4) {
		gml_pragma("forceinline");
		shader_set_uniform_i(_handle, _val1, _val2, _val3, _val4);
		return self;
	};

	/// @func set_uniform_i_array(_handle, _array)
	/// @desc Sets an `int[]` uniform.
	/// @param {real} _handle The handle of the shader uniform.
	/// @param {int[]} _array The array of new values.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_i_array = function (_handle, _array) {
		gml_pragma("forceinline");
		shader_set_uniform_i_array(_handle, _array);
		return self;
	};

	/// @func set_uniform_matrix(_handle)
	/// @desc Sets a shader uniform to the current transform matrix.
	/// @param {real} _handle The handle of the shader uniform.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_matrix = function (_handle) {
		gml_pragma("forceinline");
		shader_set_uniform_matrix(_handle);
		return self;
	};

	/// @func set_uniform_matrix_array(_hande, _array)
	/// @desc Sets a shader uniform to hold an array of matrix values.
	/// @param {real[]} _array An array of real values.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Shader.get_uniform
	static set_uniform_matrix_array = function (_handle, _array) {
		gml_pragma("forceinline");
		shader_set_uniform_matrix_array(_handle, _array);
		return self;
	};

	/// @func get_sampler_index(_name)
	/// @desc Retrieves an index of a texture sampler.
	/// @param {string} _name The name of the sampler.
	/// @return {real} The index of the texture sampler.
	static get_sampler_index = function (_name) {
		gml_pragma("forceinline");
		return shader_get_sampler_index(Raw, _name);
	};

	/// @func set_sampler(_index, _texture)
	/// @desc Sets a texture sampler to the given texture.
	/// @param {real} _index The index of the texture sampler.
	/// @param {ptr} _texture The new texture to sample.
	/// @return {BBMOD_Shader} Returns `self`.
	static set_sampler = function (_index, _texture) {
		gml_pragma("forceinline");
		texture_set_stage(_index, _texture);
		return self;
	};

	/// @func set()
	/// @desc Sets the shader as the current shader.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @throws {BBMOD_Exception} If there is another shader already in use.
	static set = function () {
		gml_pragma("forceinline");
		if (BBMOD_SHADER_CURRENT != BBMOD_NONE)
		{
			if (BBMOD_SHADER_CURRENT != self)
			{
				throw new BBMOD_Exception("Another shader is already active!");
			}
			return self;
		}
		shader_set(Raw);
		BBMOD_SHADER_CURRENT = self;
		return self;
	};

	/// @func is_current()
	/// @desc Checks if the shader is currently in use.
	/// @return {bool} Returns `true` if the shader is currently in use.
	/// @see BBMOD_Shader.set
	static is_current = function () {
		gml_pragma("forceinline");
		return (BBMOD_SHADER_CURRENT == self);
	};

	/// @func reset()
	/// @desc Unsets the shaders.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @throws {BBMOD_Exception} If the shader is not currently in use.
	static reset = function () {
		gml_pragma("forceinline");
		if (!is_current())
		{
			throw new BBMOD_Exception("Cannot reset a shader which is not active!");
		}
		shader_reset();
		BBMOD_SHADER_CURRENT = BBMOD_NONE;
		return self;
	};

	/// @func set_texture_offset(_offset)
	/// @desc Sets the `bbmod_TextureOffset` uniform to the given offset.
	/// @param {BBMOD_Vec2} _offset The new texture offset.
	/// @return {BBMOD_Shader} Returns `self`.
	static set_texture_offset = function (_offset) {
		gml_pragma("forceinline");
		return set_uniform_f2(UTextureOffset, _offset.X, _offset.Y);
	};

	/// @func set_texture_scale(_scale)
	/// @desc Sets the `bbmod_TextureScale` uniform to the given scale.
	/// @param {BBMOD_Vec2} _scale The new texture scale.
	/// @return {BBMOD_Shader} Returns `self`.
	static set_texture_scale = function (_scale) {
		gml_pragma("forceinline");
		return set_uniform_f2(UTextureScale, _scale.X, _scale.Y);
	};

	/// @func set_bones(_bones)
	/// @desc Sets the `bbmod_Bones` uniform.
	/// @param {real[]} _bones The array of new bone transforms.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_AnimationPlayer.get_transform
	static set_bones = function (_bones) {
		gml_pragma("forceinline");
		return set_uniform_f_array(UBones, _bones);
	};

	/// @func set_batch_data(_data)
	/// @desc Sets the `bbmod_BatchData` uniform.
	/// @param {real[]} _data The new dynamic batch data.
	/// @return {BBMOD_Shader} Returns `self`.
	static set_batch_data = function (_data) {
		gml_pragma("forceinline");
		return set_uniform_f_array(UBatchData, _data);
	};

	/// @func set_alpha_test(_value)
	/// @desc Sets the `bbmod_AlphaTest` uniform.
	/// @param {real} _value The new alpha test value.
	/// @return {BBMOD_Shader} Returns `self`.
	static set_alpha_test = function (_value) {
		gml_pragma("forceinline");
		return set_uniform_f(UAlphaTest, _value);
	};

	/// @func set_material(_material)
	/// @desc Sets shader uniforms using values from the material.
	/// @param {BBMOD_Material} _material The material to take the values from.
	/// @return {BBMOD_Shader} Returns `self`.
	/// @see BBMOD_Material
	static set_material = function (_material) {
		gml_pragma("forceinline");
		set_alpha_test(_material.AlphaTest);
		set_texture_offset(_material.TextureOffset);
		set_texture_scale(_material.TextureScale);
		return self;
	};
}