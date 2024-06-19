extends Node

signal fire_laser(position,direction) 
signal asteroid_hit(position) 
signal asteroid_breakup(position,direction,size) 
signal score_change(score)
signal ship_change(ships)
signal ship_health(health)
signal lose_ship()
signal rebuild_asteroids()
signal level_change()
signal start_game()
signal weapon_heat()
signal start_music()
signal stop_music()

func send_start_game() :
	start_game.emit()

func send_weapon_heat() :
	weapon_heat.emit(Globals.weapon_heat)

func send_level_change() :
	level_change.emit(Globals.level)

func send_score_change() :
	score_change.emit(Globals.score)

func send_ships_change() :
	#print("send ship change : Ships " + str(Globals.ships))
	ship_change.emit(Globals.ships)

func send_fire_laser(position,direction):
	fire_laser.emit(position,direction)

func send_asteroid_hit(position) :
	asteroid_hit.emit(position)
	
func send_asteroid_breakup(position, direction, size) :
	#print("MSGQueue sending asteroid_breakup")
	asteroid_breakup.emit(position, direction, size)

func send_ship_health():
	#print("Sending Health Signal")
	ship_health.emit(Globals.ship_health)

func send_lose_ship() :
	lose_ship.emit()

func send_rebuild_asteroids() :
	rebuild_asteroids.emit()

func send_start_music():
	start_music.emit()

func send_stop_music() :
	stop_music.emit()
