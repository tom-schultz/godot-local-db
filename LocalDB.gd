extends Node
class_name LocalDB

const db_path : String = "user://local_db.json"

static var _initialized : bool
static var _data : Dictionary

static func has_key(key: String):
	_initialize()
	assert(_data != null, "_data is null!")
	return _data.has(key)

static func read_key(key: String):
	_initialize()
	assert(_data != null, "_data is null!")
	assert(_data.has(key), "_data doesn't have %s!" % key)
	return _data[key]

static func write_key(key: String, value):
	_initialize()
	_data[key] = value
	_write_save()

static func delete_key(key: String):
	_initialize()
	_data.erase(key)
	_write_save()

static func _write_save():
	var json = JSON.stringify(_data)
	
	assert(json != null,
			"Could not serialize _data to JSON!\n_data: %s" \
			% [_data])
	
	var db_file = FileAccess.open(db_path, FileAccess.WRITE)
	db_file.store_string(json)

static func _initialize():
	if _initialized:
		return
	
	if not FileAccess.file_exists(db_path):
		_data = Dictionary()
		return
	
	var db_file = FileAccess.open(db_path, FileAccess.READ)
	_data = JSON.parse_string(db_file.get_as_text())
	
	assert(_data != null, "Couldn't load file: %s" % db_file.get_path_absolute())
	_initialized = true
