/// @func BBMOD_ParticleEmitter(_position, _system)
/// @desc Emits particles at a specific position in the world. The behavior of
/// the emitter particles is defined by a particle system.
/// @param {Struct.BBMOD_Vec3} _position The emitter's position in world-space.
/// @param {Struct.BBMOD_ParticleSystem} _system The particle system that defines
/// behavior of emitted particles.
/// @see BBBMOD_ParticleSystem
function BBMOD_ParticleEmitter(_position, _system) constructor
{
	/// @var {Struct.BBMOD_Vec3} The emitter's position in world-space.
	Position = _position;

	/// @var {Struct.BBMOD_ParticleSystem} The system of particles that this
	/// emitter emits.
	/// @readonly
	System = _system;

	/// @var {Id.DsGrid} Grid of particle data.
	/// @readonly
	Particles = ds_grid_create(BBMOD_EParticle.SIZE, System.ParticleCount);

	ds_grid_clear(Particles, 0.0);

	/// @var {Array<Real>} Ids of particles to be spawned.
	/// @private
	ParticlesToSpawn = [];

	/// @var {Array<Real>} Ids of alive particles.
	/// @private
	ParticlesAlive = [];

	/// @var {Array<Real>} Ids of dead particles that can be spawned.
	/// @private
	ParticlesDead = [];

	for (var _particleId = 0; _particleId < System.ParticleCount; ++_particleId)
	{
		array_push(ParticlesDead, _particleId);
	}

	/// @var {Real}
	/// @private
	Time = 0.0;

	/// @func spawn_particle()
	/// @desc Spawns a particle if the maximum particle count defined in the
	/// particle system has not been reached yet.
	/// @return {Bool} Returns `true` if a particle was spawned.
	static spawn_particle = function () {
		gml_pragma("forceinline");
		if (Time < System.Duration
			&& array_length(ParticlesDead) > 0)
		{
			array_push(ParticlesToSpawn, ParticlesDead[0]);
			array_delete(ParticlesDead, 0, 1);
			return true;
		}
		return false;
	};

	_gridTemp = ds_grid_create(3, System.ParticleCount);

	/// @func update(_deltaTime)
	/// @desc Updates the emitter and all its particles.
	/// @param {Real} _deltaTime How much time has passed since the last frame
	/// (in microseconds).
	/// @return {Struct.BBMOD_ParticleEmitter} Returns `self`.
	static update = function (_deltaTime) {
		if (finished(true))
		{
			return self;
		}

		var _deltaTimeS = _deltaTime * 0.000001;
		var _modules = System.Modules;
		var _particlesAlive = ParticlesAlive;

		var _timeStart = (Time == 0.0);
		Time += _deltaTimeS;
		var _timeOut = (Time >= System.Duration);
		if (_timeOut && System.Loop)
		{
			Time = 0.0;
		}

		//var _gridTemp = ds_grid_create(3, System.ParticleCount);
		var _temp1 = _deltaTimeS * 0.5;
		var _temp2 = _deltaTimeS * _deltaTimeS * 0.5;

		////////////////////////////////////////////////////////////////////////
		// Kill particles
		for (var i = array_length(_particlesAlive) - 1; i >= 0; --i)
		{
			var _particleId = _particlesAlive[i];
			if (Particles[# BBMOD_EParticle.HealthLeft, _particleId] <= 0.0)
			{
				Particles[# BBMOD_EParticle.IsAlive, _particleId] = false;
				array_delete(_particlesAlive, i, 1);
				array_push(ParticlesDead, _particleId);

				var m = 0;
				repeat (array_length(_modules))
				{
					var _module = _modules[m++];
					if (_module.Enabled && _module.on_particle_finish)
					{
						_module.on_particle_finish(self, _particleId);
					}
				}
			}
		}

		////////////////////////////////////////////////////////////////////////
		// Spawn particles
		var p = 0;
		repeat (array_length(ParticlesToSpawn))
		{
			var _particleId = ParticlesToSpawn[p++];

			Particles[# BBMOD_EParticle.IsAlive, _particleId] = true;
			Particles[# BBMOD_EParticle.Health, _particleId] = 1.0;
			Particles[# BBMOD_EParticle.HealthLeft, _particleId] = 1.0;
			Particles[# BBMOD_EParticle.PositionX, _particleId] = Position.X;
			Particles[# BBMOD_EParticle.PositionY, _particleId] = Position.Y;
			Particles[# BBMOD_EParticle.PositionZ, _particleId] = Position.Z;
			Particles[# BBMOD_EParticle.VelocityX, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.VelocityY, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.VelocityZ, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.AccelerationX, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.AccelerationY, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.AccelerationZ, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.AccelerationRealX, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.AccelerationRealY, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.AccelerationRealZ, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.RotationX, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.RotationY, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.RotationZ, _particleId] = 0.0;
			Particles[# BBMOD_EParticle.RotationW, _particleId] = 1.0;
			Particles[# BBMOD_EParticle.ScaleX, _particleId] = 1.0;
			Particles[# BBMOD_EParticle.ScaleY, _particleId] = 1.0;
			Particles[# BBMOD_EParticle.ScaleZ, _particleId] = 1.0;
			Particles[# BBMOD_EParticle.ColorR, _particleId] = 255.0;
			Particles[# BBMOD_EParticle.ColorG, _particleId] = 255.0;
			Particles[# BBMOD_EParticle.ColorB, _particleId] = 255.0;
			Particles[# BBMOD_EParticle.ColorA, _particleId] = 1.0;

			array_push(ParticlesAlive, _particleId);

			var m = 0;
			repeat (array_length(_modules))
			{
				var _module = _modules[m++];
				if (_module.Enabled && _module.on_particle_start)
				{
					_module.on_particle_start(self, _particleId);
				}
			}
		}
		ParticlesToSpawn = [];

		////////////////////////////////////////////////////////////////////////
		// Particle pre physics simulation

		// position += velocity * _deltaTimeS:
		ds_grid_set_grid_region(
			_gridTemp,
			Particles,
			BBMOD_EParticle.VelocityX, 0,
			BBMOD_EParticle.VelocityZ, System.ParticleCount - 1,
			0, 0
			);

		ds_grid_multiply_region(
			_gridTemp,
			0, 0,
			2, System.ParticleCount - 1,
			_deltaTimeS
			);

		ds_grid_add_grid_region(
			Particles,
			_gridTemp,
			0, 0,
			2, System.ParticleCount - 1,
			BBMOD_EParticle.PositionX, 0
			);

		// position += accelerationReal * _temp2:
		ds_grid_set_grid_region(
			_gridTemp,
			Particles,
			BBMOD_EParticle.AccelerationRealX, 0,
			BBMOD_EParticle.AccelerationRealZ, System.ParticleCount - 1,
			0, 0
			);

		ds_grid_multiply_region(
			_gridTemp,
			0, 0,
			2, System.ParticleCount - 1,
			_temp2
			);

		ds_grid_add_grid_region(
			Particles,
			_gridTemp,
			0, 0,
			2, System.ParticleCount - 1,
			BBMOD_EParticle.PositionX, 0
			);

		// acceleration = (0, 0, 0)
		ds_grid_set_region(
			Particles,
			BBMOD_EParticle.AccelerationX, 0,
			BBMOD_EParticle.AccelerationZ, System.ParticleCount - 1,
			0.0
			);

		////////////////////////////////////////////////////////////////////////
		// Execute modules
		var m = 0;
		repeat (array_length(_modules))
		{
			var _module = _modules[m++];
			if (_module.Enabled)
			{
				// Emitter start
				if (_timeStart && _module.on_start)
				{
					_module.on_start(self);
				}

				// Emitter update
				if (_module.on_update)
				{
					_module.on_update(self, _deltaTime);
				}

				// Emitter finish
				if (_timeOut && _module.on_finish)
				{
					_module.on_finish(self);
				}
			}
		}

		////////////////////////////////////////////////////////////////////////
		// Particle simulate physics

		// velocity += (accelerationReal + acceleration) * _temp1
		ds_grid_set_grid_region(
			_gridTemp,
			Particles,
			BBMOD_EParticle.AccelerationRealX, 0,
			BBMOD_EParticle.AccelerationRealZ, System.ParticleCount - 1,
			0, 0
			);

		ds_grid_add_grid_region(
			_gridTemp,
			Particles,
			BBMOD_EParticle.AccelerationX, 0,
			BBMOD_EParticle.AccelerationZ, System.ParticleCount - 1,
			0, 0
			);

		ds_grid_multiply_region(
			_gridTemp,
			0, 0,
			2, System.ParticleCount - 1,
			_temp1
			);

		ds_grid_add_grid_region(
			Particles,
			_gridTemp,
			0, 0,
			2, System.ParticleCount - 1,
			BBMOD_EParticle.VelocityX, 0
			);

		// accelerationReal = acceleration
		ds_grid_set_grid_region(
			Particles,
			Particles,
			BBMOD_EParticle.AccelerationX, 0,
			BBMOD_EParticle.AccelerationZ, System.ParticleCount - 1,
			BBMOD_EParticle.AccelerationRealX, 0
			);

		////////////////////////////////////////////////////////////////////////
		// Sort particles alive back-to-front by their dostance from the camera

		//if (System.Sort)
		//{
		//	array_sort(_particlesAlive, method(self, function (_p1, _p2) {
		//		var _camPos = global.__bbmodCameraPosition;
		//		var _d1 = point_distance_3d(
		//			_p1.Position.X,
		//			_p1.Position.Y,
		//			_p1.Position.Z,
		//			_camPos.X,
		//			_camPos.Y,
		//			_camPos.Z);
		//		var _d2 = point_distance_3d(
		//			_p2.Position.X,
		//			_p2.Position.Y,
		//			_p2.Position.Z,
		//			_camPos.X,
		//			_camPos.Y,
		//			_camPos.Z);
		//		// Same as:
		//		//var _d1 = _p1.Position.Sub(_camPos).Length();
		//		//var _d2 = _p2.Position.Sub(_camPos).Length();
		//		if (_d2 > _d1) return +1;
		//		if (_d2 < _d1) return -1;
		//		return 0;
		//	}));
		//}

		//ds_grid_destroy(_gridTemp);

		return self;
	};

	/// @func finished([_particlesDead])
	/// @desc Checks if the emitter cycle has finished.
	/// @param {Bool} [_particlesDead] Also check if there are no particles
	/// alive. Defaults to `false.`
	/// @return {Bool} Returns `true` if the emitter cycle has finished
	/// (and there are no particles alive). Aalways returns `false` if the
	/// emitted particle system is looping.
	static finished = function (_particlesDead=false) {
		gml_pragma("forceinline");
		if (System.Loop)
		{
			return false;
		}
		if (Time >= System.Duration)
		{
			if (!_particlesDead
				|| array_length(ParticlesAlive) == 0)
			{
				return true;
			}
		}
		return false;
	};

	static _draw = function (_method, _material=undefined) {
		gml_pragma("forceinline");

		var _dynamicBatch = System.DynamicBatch;
		var _batchSize = _dynamicBatch.Size;
		_material ??= System.Material;

		matrix_set(matrix_world, matrix_build_identity());

		var _particles = Particles;
		var _particleCount = System.ParticleCount;
		var _particleId = 0;
		while (_particleCount > 0)
		{
			var _data = array_create(_batchSize * 16, 0);
			var d = 0;
			repeat (min(_particleCount, _batchSize))
			{
				var _isAlive = _particles[# BBMOD_EParticle.IsAlive, _particleId];

				if (_isAlive)
				{
					_data[d + 0] = _particles[# BBMOD_EParticle.PositionX, _particleId];
					_data[d + 1] = _particles[# BBMOD_EParticle.PositionY, _particleId];
					_data[d + 2] = _particles[# BBMOD_EParticle.PositionZ, _particleId];

					_data[d + 4] = _particles[# BBMOD_EParticle.RotationX, _particleId];
					_data[d + 5] = _particles[# BBMOD_EParticle.RotationY, _particleId];
					_data[d + 6] = _particles[# BBMOD_EParticle.RotationZ, _particleId];
					_data[d + 7] = _particles[# BBMOD_EParticle.RotationW, _particleId];

					_data[d + 11] = _particles[# BBMOD_EParticle.ColorA, _particleId];

					var _colorR = _particles[# BBMOD_EParticle.ColorR, _particleId];
					var _colorG = _particles[# BBMOD_EParticle.ColorG, _particleId];
					var _colorB = _particles[# BBMOD_EParticle.ColorB, _particleId];

					new BBMOD_Color(_colorR, _colorG, _colorB).ToRGBM(_data, d + 12);
				}

				_data[d + 8]  = _particles[# BBMOD_EParticle.ScaleX, _particleId] * _isAlive;
				_data[d + 9]  = _particles[# BBMOD_EParticle.ScaleY, _particleId] * _isAlive;
				_data[d + 10] = _particles[# BBMOD_EParticle.ScaleZ, _particleId] * _isAlive;

				++_particleId;
				d += 16;
			}
			_particleCount -= _batchSize;
			_method(_material, _data);
		}
	};

	/// @func submit([_material])
	/// @desc Immediately submits particles for rendering.
	/// @param {Struct.BBMOD_Material/Undefined} [_material] The material to use
	/// instead of the one defined in the particle system.
	/// @return {Struct.BBMOD_ParticleEmitter} Returns `self`.
	static submit = function (_material=undefined) {
		var _dynamicBatch = System.DynamicBatch;
		_draw(method(_dynamicBatch, _dynamicBatch.submit), _material);
		return self;
	};

	/// @func render([_material])
	/// @desc Enqueus particles for rendering.
	/// @param {Struct.BBMOD_Material/Undefined} [_material] The material to use
	/// instead of the one defined in the particle system.
	/// @return {Struct.BBMOD_ParticleEmitter} Returns `self`.
	static render = function (_material=undefined) {
		var _dynamicBatch = System.DynamicBatch;
		_draw(method(_dynamicBatch, _dynamicBatch.render), _material);
		return self;
	};
}