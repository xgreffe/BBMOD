/// @func BBMOD_ScaleKillModule([_min[, _max]])
///
/// @extends BBMOD_ParticleModule
///
/// @desc A particle module that kills all particles with scale below a miminum
/// value or above a maximum value.
///
/// @param {Struct.BBMOD_Vec3/Undefined} [_min] The minimum scale the particle
/// needs to have or it will be killed. Use `undefined` if you do not want to
/// use a minimum value. Defaults to `undefined`.
/// @param {Struct.BBMOD_Vec3/Undefined} [_max] The maximum scale the particle
/// needs to have or it will be killed. Use `undefined` if you do not want to
/// use a maximum value. Defaults to `undefined`.
///
/// @see BBMOD_EParticle.ScaleX
/// @see BBMOD_EParticle.ScaleY
/// @see BBMOD_EParticle.ScaleZ
function BBMOD_ScaleKillModule(_min=undefined, _max=undefined)
	: BBMOD_ParticleModule() constructor
{
	/// @var {Struct.BBMOD_Vec3/Undefined} The minimum scale the particle needs
	/// to have or it will be killed. Use `undefined` if you do not want to
	/// use a minimum value. Default value is `undefined`.
	Min = _min;

	/// @var {Struct.BBMOD_Vec3/Undefined} The maximum scale the particle needs
	/// to have or it will be killed. Use `undefined` if you do not want to
	/// use a maximum value. Default value is `undefined`.
	Max = _max;

	static on_update = function (_emitter, _deltaTime) {
		var _min = Min;
		var _max = Max;
		if (!_min && !_max)
		{
			return;
		}
		var _minX, _minY, _minZ;
		if (_min)
		{
			_minX = _min.X;
			_minY = _min.Y;
			_minZ = _min.Z;
		}
		var _maxX, _maxY, _maxZ;
		if (_min)
		{
			_maxX = _max.X;
			_maxY = _max.Y;
			_maxZ = _max.Z;
		}
		var _particles = _emitter.Particles;
		var _particleIndex = 0;
		repeat (_emitter.ParticlesAlive)
		{
			var _scaleX = _particles[# BBMOD_EParticle.ScaleX, _particleIndex];
			var _scaleY = _particles[# BBMOD_EParticle.ScaleY, _particleIndex];
			var _scaleZ = _particles[# BBMOD_EParticle.ScaleZ, _particleIndex];
			if ((_min && (_scaleX < _minX || _scaleY < _minY || _scaleZ < _minZ))
				|| (_max && (_scaleX > _maxX || _scaleY > _maxY || _scaleZ > _maxZ)))
			{
				_particles[# BBMOD_EParticle.HealthLeft, _particleIndex] = 0;
			}
			++_particleIndex;
		}
	};
}
