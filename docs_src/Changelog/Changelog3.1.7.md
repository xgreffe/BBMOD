# Changelog 3.1.7

## GML API:
### Core module:
* Fixed method `BBMOD_VertexFormat.get_byte_size` which returned incorrect values when the vertex format included vertex colors or bones.
* Fixed creating dynamic and static batches with models that have vertex colors.