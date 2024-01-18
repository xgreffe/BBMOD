# Changelog 3.20.2

* Added new interface `BBMOD_IMaterial`, which is an interface for the most basic BBMOD materials that can be used with the `BBMOD_Model.submit` method.
* Fixed method `set_pre_transform` of `BBMOD_DLL`, which accidentally controlled the "apply scale" option instead.
* Method `BBMOD_Material.from_json` now supports `undefined` and string "undefined" for shaders, in which case it removes a shader for given render pass.
* Added new function `bbmod_shader_set_globals`, which passes all global uniforms to given shader.
* Fixed disabling texture filtering via `BBMOD_Material.Filtering` not working.