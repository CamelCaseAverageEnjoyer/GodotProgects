extends Node2D

export var width = 50
export var height = 150
export var w_0 = 25
export var h_0 = 75
export var rarity = 20
var cell_size = 20
export var x_pos = []
export var y_pos = []

var Mario = preload("res://npc/scripts/Mario.tscn")
var Bandit = preload("res://npc/scripts/Bandit.tscn")
var Character = preload("res://npc/scripts/Character.tscn")

onready var tilemap1 = $Ground
onready var tilemap2 = $Ground_top
onready var tilemap3 = $Ground_bot
var temp = {}
var altitude = {}
var openSimplexNoise = OpenSimplexNoise.new()

func generate_map(per, oct):
	openSimplexNoise.seed = randi()
	openSimplexNoise.period = per
	openSimplexNoise.octaves = oct
	var gridName = {}
	for x in width:
		for y in height:
			var rand :=  5 * (abs(openSimplexNoise.get_noise_2d(x - w_0, y - h_0)))
			gridName[Vector2(x - w_0, y - h_0)] = rand
	return gridName

func _ready():
	temp = generate_map(300, 5)
	altitude = generate_map(300, 5)
	set_tile(width, height)
	
	var character = Character.instance()
	add_child(character)
	character.position = Vector2(cell_size*(randi()%6-3), cell_size*(randi()%6-3))
	
	var file = File.new()
	file.open("res://storage/positions.txt", File.WRITE)
	for i in range(rarity):
		var pattern = Mario.instance()
		var tmp_x = 2*cell_size*(randi()%width-w_0)
		var tmp_y = cell_size*(randi()%height-h_0)
		add_child(pattern)
		x_pos.append(tmp_x)
		y_pos.append(tmp_y)
		pattern.position = Vector2(tmp_x, tmp_y)
		# file.store_string(str(tmp_x) + ' ' + str(tmp_y) + ' ')
	for i in range(rarity):
		var pattern = Bandit.instance()
		var tmp_x = 2*cell_size*(randi()%width-w_0)
		var tmp_y = cell_size*(randi()%height-h_0)
		add_child(pattern)
		x_pos.append(tmp_x)
		y_pos.append(tmp_y)
		pattern.position = Vector2(tmp_x, tmp_y)
		file.store_string(str(tmp_x) + ' ' + str(tmp_y) + ' ')
	file.close()
	
	$MenuButton.get_popup().add_item("Pensil")
	$MenuButton.get_popup().add_item("Warrior")
	$MenuButton.get_popup().add_item("Wizard")
	
	$MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")
	
func _on_item_pressed(id):
	$Player.character = $MenuButton.get_popup().get_item_text(id)
	 
func set_tile(width, height):
	for x in width:
		for y in height:
			var pos = Vector2(x - w_0, y - h_0)
			var tmp = temp[pos]
			var alt = altitude[pos]
			
			# Ground1
			#if tmp < 0.1:
			#	tilemap1.set_cellv(pos, 1)
			#elif tmp < 0.2:
			#	tilemap1.set_cellv(pos, 0)
			#else:
			#	tilemap1.set_cellv(pos, 2)
				
			#Ground2
			var tmpx = 2 * (x - w_0) + ((2*x + y) % 2)
			var tmpy = y - h_0 
			if tmp < 0.1:
				tilemap3.set_cellv(Vector2(tmpx, tmpy), 0)
			elif tmp < 0.4:
				tilemap3.set_cellv(Vector2(tmpx, tmpy), 1)
			elif tmp < 0.7:
				tilemap3.set_cellv(Vector2(tmpx, tmpy), 2)
			else:
				tilemap3.set_cellv(Vector2(tmpx, tmpy), 3)
	
	for y in height:
		for x in width:
			var pos = Vector2(x - w_0, y - h_0)
			var tmp = temp[pos]
			var alt = altitude[pos]
			var tmpx = 2 * (x - w_0) + ((2*x + y) % 2)
			var tmpy = y - h_0 
			if x == 0 or x == width - 1 or y == 0 or y == height - 1:
				if tmp < 0.1:
					tilemap2.set_cellv(Vector2(tmpx, tmpy), 5)
				elif tmp < 0.4:
					tilemap2.set_cellv(Vector2(tmpx, tmpy), 6)
				else:
					tilemap2.set_cellv(Vector2(tmpx, tmpy), 7)
			else:
				if randi() % 200 == 1:
					if tmp < 0.1:
						tilemap2.set_cellv(Vector2(tmpx, tmpy), 8)
					elif tmp < 0.4:
						tilemap2.set_cellv(Vector2(tmpx, tmpy), 9)
					else:
						tilemap2.set_cellv(Vector2(tmpx, tmpy), 10)
