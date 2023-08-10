draw_clear(c_black);
OPlayer.camera.apply();
renderer.render();

if (terrainEditor.Enabled)
{
	terrainEditor.draw();
}

if (debugOverlay)
{
	matrix_set(matrix_world, matrix_build_identity());

	with (OZombie)
	{
		collider.DrawDebug();
	}
}
