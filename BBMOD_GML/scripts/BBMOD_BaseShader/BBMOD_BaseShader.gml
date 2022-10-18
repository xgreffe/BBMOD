/// @func BBMOD_BaseShader(_shader, _vertexFormat)
///
/// @extends BBMOD_Shader
///
/// @desc Base class for BBMOD shaders.
///
/// @param {Asset.GMShader} _shader The shader resource.
/// @param {Struct.BBMOD_VertexFormat} _vertexFormat The vertex format required
/// by the shader.
///
/// @see BBMOD_VertexFormat
function BBMOD_BaseShader(_shader, _vertexFormat)
	: BBMOD_Shader(_shader, _vertexFormat) constructor
{
	/// @var {Real} Maximum number of point lights in the shader. This must
	/// match with value defined in the raw GameMaker shader!
	/// @obsolete This was replaced with {@link BBMOD_BaseShader.MaxPunctualLights}!
	MaxPointLights = 8;

	/// @var {Real} Maximum number of punctual lights in the shader. This must
	/// match with value defined in the raw GameMaker shader!
	MaxPunctualLights = 8;

	UBaseOpacityMultiplier = get_uniform("bbmod_BaseOpacityMultiplier");

	UTextureOffset = get_uniform("bbmod_TextureOffset");

	UTextureScale = get_uniform("bbmod_TextureScale");

	UBones = get_uniform("bbmod_Bones");

	UBatchData = get_uniform("bbmod_BatchData");

	UAlphaTest = get_uniform("bbmod_AlphaTest");

	UCamPos = get_uniform("bbmod_CamPos");

	UExposure = get_uniform("bbmod_Exposure");

	UInstanceID = get_uniform("bbmod_InstanceID");

	UMaterialIndex = get_uniform("bbmod_MaterialIndex");

	UIBL = get_sampler_index("bbmod_IBL");

	UIBLTexel = get_uniform("bbmod_IBLTexel");

	ULightAmbientUp = get_uniform("bbmod_LightAmbientUp");

	ULightAmbientDown = get_uniform("bbmod_LightAmbientDown");

	ULightDirectionalDir = get_uniform("bbmod_LightDirectionalDir");

	ULightDirectionalColor = get_uniform("bbmod_LightDirectionalColor");

	ULightPunctualData = get_uniform("bbmod_LightPunctualData");

	UFogColor = get_uniform("bbmod_FogColor");

	UFogIntensity = get_uniform("bbmod_FogIntensity");

	UFogStart = get_uniform("bbmod_FogStart");

	UFogRcpRange = get_uniform("bbmod_FogRcpRange");

	UShadowmapBias = get_uniform("bbmod_ShadowmapBias");

	USSAO = get_sampler_index("bbmod_SSAO");

	/// @func set_texture_offset(_offset)
	///
	/// @desc Sets the `bbmod_TextureOffset` uniform to the given offset.
	///
	/// @param {Struct.BBMOD_Vec2} _offset The texture offset.
	///
	/// @return {Struct.BBMOD_Shader} Returns `self`.
	static set_texture_offset = function (_offset) {
		gml_pragma("forceinline");
		shader_set_uniform_f(UTextureOffset, _offset.X, _offset.Y);
		return self;
	};

	/// @func set_texture_scale(_scale)
	///
	/// @desc Sets the `bbmod_TextureScale` uniform to the given scale.
	///
	/// @param {Struct.BBMOD_Vec2} _scale The texture scale.
	///
	/// @return {Struct.BBMOD_Shader} Returns `self`.
	static set_texture_scale = function (_scale) {
		gml_pragma("forceinline");
		shader_set_uniform_f(UTextureScale, _scale.X, _scale.Y);
		return self;
	};

	/// @func set_bones(_bones)
	///
	/// @desc Sets the `bbmod_Bones` uniform.
	///
	/// @param {Array<Real>} _bones The array of bone transforms.
	///
	/// @return {Struct.BBMOD_Shader} Returns `self`.
	///
	/// @see BBMOD_AnimationPlayer.get_transform
	static set_bones = function (_bones) {
		gml_pragma("forceinline");
		shader_set_uniform_f_array(UBones, _bones);
		return self;
	};

	/// @func set_batch_data(_data)
	///
	/// @desc Sets the `bbmod_BatchData` uniform.
	///
	/// @param {Array<Real>} _data The dynamic batch data.
	///
	/// @return {Struct.BBMOD_Shader} Returns `self`.
	static set_batch_data = function (_data) {
		gml_pragma("forceinline");
		shader_set_uniform_f_array(UBatchData, _data);
		return self;
	};

	/// @func set_alpha_test(_value)
	///
	/// @desc Sets the `bbmod_AlphaTest` uniform.
	///
	/// @param {Real} _value The alpha test value.
	///
	/// @return {Struct.BBMOD_Shader} Returns `self`.
	static set_alpha_test = function (_value) {
		gml_pragma("forceinline");
		shader_set_uniform_f(UAlphaTest, _value);
		return self;
	};

	/// @func set_cam_pos([_pos])
	///
	/// @desc Sets a fragment shader uniform `bbmod_CamPos` to the given position.
	///
	/// @param {Struct.BBMOD_Vec3} [_pos] The camera position. If `undefined`,
	/// then the value set by {@link bbmod_camera_set_position} is used.
	///
	/// @return {Struct.BBMOD_Shader} Returns `self`.
	static set_cam_pos = function (_pos=undefined) {
		gml_pragma("forceinline");
		_pos ??= global.__bbmodCameraPosition;
		shader_set_uniform_f(UCamPos, _pos.X, _pos.Y, _pos.Z);
		return self;
	};

	/// @func set_exposure([_value])
	///
	/// @desc Sets the `bbmod_Exposure` uniform.
	///
	/// @param {Real} [_value] The camera exposure. If `undefined`,
	/// then the value set by {@link bbmod_camera_set_exposure} is used.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	static set_exposure = function (_value=undefined) {
		gml_pragma("forceinline");
		_value ??= global.__bbmodCameraExposure;
		shader_set_uniform_f(UExposure, _value);
		return self;
	};

	/// @func set_instance_id([_id])
	///
	/// @desc Sets the `bbmod_InstanceID` uniform.
	///
	/// @param {Id.Instance} [_id] The instance ID. If `undefined`,
	/// then the value set by {@link bbmod_set_instance_id} is used.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	static set_instance_id = function (_id=undefined) {
		gml_pragma("forceinline");
		_id ??= global.__bbmodInstanceID;
		shader_set_uniform_f(
			UInstanceID,
			((_id & $000000FF) >> 0) / 255,
			((_id & $0000FF00) >> 8) / 255,
			((_id & $00FF0000) >> 16) / 255,
			((_id & $FF000000) >> 24) / 255);
		return self;
	};

	/// @func set_material_index(_index)
	///
	/// @desc Sets the `bbmod_MaterialIndex` uniform.
	///
	/// @param {Real} [_index] The index of the current material.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	static set_material_index = function (_index) {
		gml_pragma("forceinline");
		shader_set_uniform_f(UMaterialIndex, _index);
		return self;
	};

	/// @func set_ibl([_ibl])
	///
	/// @desc Sets a fragment shader uniform `bbmod_IBLTexel` and samplers
	/// `bbmod_IBL` and `bbmod_BRDF`. These are required for image based
	/// lighting.
	///
	/// @param {Struct.BBMOD_ImageBasedLight} [_ibl] The image based light.
	/// If `undefined`, then the value set by {@link bbmod_ibl_set} is used. If
	/// the light is not enabled, then it is not passed.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	static set_ibl = function (_ibl=undefined) {
		gml_pragma("forceinline");

		static _iblNull = sprite_get_texture(BBMOD_SprBlack, 0);
		var _texture = _iblNull;
		var _texel = 0.0;

		_ibl ??= global.__bbmodImageBasedLight;
		if (_ibl != undefined && _ibl.Enabled)
		{
			_texture = _ibl.Texture;
			_texel = _ibl.Texel;
		}

		texture_set_stage(UIBL, _texture);
		gpu_set_tex_mip_enable_ext(UIBL, mip_off)
		gpu_set_tex_filter_ext(UIBL, true);
		gpu_set_tex_repeat_ext(UIBL, false);
		shader_set_uniform_f(UIBLTexel, _texel, _texel);

		return self;
	};

	/// @func set_ambient_light([_up[, _down]])
	///
	/// @desc Sets the `bbmod_LightAmbientUp`, `bbmod_LightAmbientDown` uniforms.
	///
	/// @param {Struct.BBMOD_Color} [_up] RGBM encoded ambient light color on
	/// the upper hemisphere. If `undefined`, then the value set by
	/// {@link bbmod_light_ambient_set_up} is used.
	/// @param {Struct.BBMOD_Color} [_down] RGBM encoded ambient light color on
	/// the lower hemisphere. If `undefined`, then the value set by
	/// {@link bbmod_light_ambient_set_down} is used.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	static set_ambient_light = function (_up=undefined, _down=undefined) {
		gml_pragma("forceinline");
		_up ??= global.__bbmodAmbientLightUp;
		_down ??= global.__bbmodAmbientLightDown;
		shader_set_uniform_f(ULightAmbientUp,
			_up.Red / 255.0, _up.Green / 255.0, _up.Blue / 255.0, _up.Alpha);
		shader_set_uniform_f(ULightAmbientDown,
			_down.Red / 255.0, _down.Green / 255.0, _down.Blue / 255.0, _down.Alpha);
		return self;
	};

	/// @func set_directional_light([_light])
	///
	/// @desc Sets uniforms `bbmod_LightDirectionalDir` and
	/// `bbmod_LightDirectionalColor`.
	///
	/// @param {Struct.BBMOD_DirectionalLight} [_light] The directional light.
	/// If `undefined`, then the value set by {@link bbmod_light_directional_set}
	/// is used. If the light is not enabled then it is not passed.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	///
	/// @see BBMOD_DirectionalLight
	static set_directional_light = function (_light=undefined) {
		gml_pragma("forceinline");
		_light ??= global.__bbmodDirectionalLight;
		if (_light != undefined	&& _light.Enabled)
		{
			var _direction = _light.Direction;
			shader_set_uniform_f(ULightDirectionalDir,
				_direction.X, _direction.Y, _direction.Z);
			var _color = _light.Color;
			shader_set_uniform_f(ULightDirectionalColor,
				_color.Red / 255.0,
				_color.Green / 255.0,
				_color.Blue / 255.0,
				_color.Alpha);
		}
		else
		{
			shader_set_uniform_f(ULightDirectionalDir, 0.0, 0.0, -1.0);
			shader_set_uniform_f(ULightDirectionalColor, 0.0, 0.0, 0.0, 0.0);
		}
		return self;
	};

	/// @func set_point_lights([_lights])
	///
	/// @desc Sets uniform `bbmod_LightPunctualData`.
	///
	/// @param {Array<Struct.BBMOD_PointLight>} [_lights] An array of point
	/// lights. If `undefined`, then the lights defined using
	/// {@link bbmod_light_point_add} are passed. Only enabled lights will be used!
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	///
	/// @deprecated Please use {@link set_punctual_lights} instead.
	static set_point_lights = function (_lights=undefined) {
		gml_pragma("forceinline");
		set_punctual_lights(_lights);
		return self;
	};

	/// @func set_punctual_lights([_lights])
	///
	/// @desc Sets uniform `bbmod_LightPunctualData`.
	///
	/// @param {Array<Struct.BBMOD_PunctualLight>} [_lights] An array of punctual
	/// lights. If `undefined`, then the lights defined using
	/// {@link bbmod_light_punctual_add} are passed. Only enabled lights will be used!
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	static set_punctual_lights = function (_lights=undefined) {
		gml_pragma("forceinline");
		_lights ??= global.__bbmodPunctualLights;
		var _maxLights = MaxPunctualLights;
		var _index = 0;
		var _indexMax = _maxLights * 8;
		var _data = array_create(_indexMax, 0.0);
		var i = 0;
		repeat (array_length(_lights))
		{
			var _light = _lights[i++];
			if (_light.Enabled)
			{
				_light.Position.ToArray(_data, _index);
				_data[@ _index + 3] = _light.Range;
				var _color = _light.Color;
				_data[@ _index + 4] = _color.Red / 255.0;
				_data[@ _index + 5] = _color.Green / 255.0;
				_data[@ _index + 6] = _color.Blue / 255.0;
				_data[@ _index + 7] = _color.Alpha;
				_index += 8;
				if (_index >= _indexMax)
				{
					break;
				}
			}
		}
		shader_set_uniform_f_array(ULightPunctualData, _data);
		return self;
	};

	/// @func set_fog([_color[, _intensity[, _start[, _end]]]])
	///
	/// @desc Sets uniforms `bbmod_FogColor`, `bbmod_FogIntensity`,
	/// `bbmod_FogStart` and `bbmod_FogRcpRange`.
	///
	/// @param {Struct.BBMOD_Color} [_color] The color of the fog. If `undefined`,
	/// then the value set by {@link bbmod_fog_set_color} is used.
	/// @param {Real} [_intensity] The fog intensity. If `undefined`, then the
	/// value set by {@link bbmod_fog_set_intensity} is used.
	/// @param {Real} [_start] The distance at which the fog starts. If
	/// `undefined`, then the value set by {@link bbmod_fog_set_start} is used.
	/// @param {Real} [_end] The distance at which the fog has maximum intensity.
	/// If `undefined`, then the value set by {@link bbmod_fog_set_end} is used.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	static set_fog = function (_color=undefined, _intensity=undefined, _start=undefined, _end=undefined) {
		gml_pragma("forceinline");
		_color ??= global.__bbmodFogColor;
		_intensity ??= global.__bbmodFogIntensity;
		_start ??= global.__bbmodFogStart;
		_end ??= global.__bbmodFogEnd;
		var _rcpFogRange = 1.0 / (_end - _start);
		shader_set_uniform_f(UFogColor,
			_color.Red / 255.0,
			_color.Green / 255.0,
			_color.Blue / 255.0,
			_color.Alpha);
		shader_set_uniform_f(UFogIntensity, _intensity);
		shader_set_uniform_f(UFogStart, _start);
		shader_set_uniform_f(UFogRcpRange, _rcpFogRange);
		return self;
	};

	static on_set = function () {
		gml_pragma("forceinline");
		set_cam_pos();
		set_exposure();
		set_ibl();
		set_ambient_light();
		set_directional_light();
		set_punctual_lights();
		set_fog();
		texture_set_stage(USSAO, sprite_get_texture(BBMOD_SprWhite, 0));
	};

	/// @func set_material(_material)
	///
	/// @desc Sets shader uniforms using values from the material.
	/// @param {Struct.BBMOD_BaseMaterial} _material The material to take the
	/// values from.
	///
	/// @return {Struct.BBMOD_BaseShader} Returns `self`.
	///
	/// @see BBMOD_BaseMaterial
	static set_material = function (_material) {
		gml_pragma("forceinline");
		shader_set_uniform_f(
			UBaseOpacityMultiplier,
			_material.BaseOpacityMultiplier.Red / 255.0,
			_material.BaseOpacityMultiplier.Green / 255.0,
			_material.BaseOpacityMultiplier.Blue / 255.0,
			_material.BaseOpacityMultiplier.Alpha);
		set_alpha_test(_material.AlphaTest);
		set_texture_offset(_material.TextureOffset);
		set_texture_scale(_material.TextureScale);
		shader_set_uniform_f(UShadowmapBias, _material.ShadowmapBias);
		return self;
	};
}
