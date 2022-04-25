/// @func BBMOD_Particle(_id)
/// @desc A single particle instance within a particle emitter.
/// @param {Real} _id The ID of the particle.
/// @see BBMOD_ParticleEmitter
function BBMOD_Particle(_id) constructor
{
	/// @var {Real} The ID of the particle.
	/// @readonly
	Id = _id;

	/// @var {Bool} If `true` then the particle is alive. Default value
	/// is `false`.
	IsAlive = false;

	/// @var {Real} The initial health of the particle. Default value is 1.
	Health = 1.0;

	/// @var {Real} The current health of the particle. The particle should
	/// die when this reaches 0.
	HealthLeft = Health;

	/// @var {Struct.BBMOD_Vec3} The world-space position of the particle.
	/// Default value is `0, 0, 0`.
	Position = new BBMOD_Vec3();

	/// @var {Struct.BBMOD_Vec3} Added to the particle's position on update.
	/// Default value is `0, 0, 0`.
	Velocity = new BBMOD_Vec3();

	/// @var {Struct.BBMOD_Quaternion} The particle's rotation.
	Rotation = new BBMOD_Quaternion();

	/// @var {Struct.BBMOD_Vec3} The scale of the particle mesh.
	/// Default value is `1, 1, 1`.
	Scale = new BBMOD_Vec3(1.0);

	/// @var {Struct.BBMOD_Color} The color of the particle. Default value is
	/// {@link BBMOD_C_WHITE}.
	Color = BBMOD_C_WHITE;

	/// @func reset()
	/// @desc Resets particle's properites to the default values.
	/// @return {Struct.BBMOD_Particle} Returns `self`.
	static reset = function () {
		gml_pragma("forceinline");
		IsAlive = false;
		Health = 1.0;
		HealthLeft = Health;
		Position = new BBMOD_Vec3();
		Velocity = new BBMOD_Vec3();
		Rotation = new BBMOD_Quaternion();
		Scale = new BBMOD_Vec3(1.0);
		Color = BBMOD_C_WHITE;
		return self;
	};

	/// @func write_data(_array, _index)
	/// @desc Writes particle's properties into an array.
	/// @param {Array<Real>} _array The array to write the properties to.
	/// @param {Real} _index The index to start writing at.
	/// @return {Struct.BBMOD_Particle} Returns `self`.
	static write_data = function (_array, _index) {
		gml_pragma("forceinline");
		if (IsAlive)
		{
			Position.ToArray(_array, _index);
			Rotation.ToArray(_array, _index + 4);
			_array[@ _index + 11] = Color.Alpha;
			Color.ToRGBM(_array, _index + 12);
		}
		Scale.Scale(IsAlive ? 1.0 : 0.0).ToArray(_array, _index + 8);
		return self;
	};
}