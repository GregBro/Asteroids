extends Node

signal fire_laser(position,direction) 
signal asteroid_hit(position) 
signal asteroid_breakup(position,direction,size) 
signal score_change(score)
signal ship_change(ships)
signal ship_health(health)
signal lose_ship()
signal rebuild_asteroids()

func send_score_change(score) :
	Globals.score = Globals.score + score
	score_change.emit(Globals.score)

func send_ships_change() :
	#print("send ship change : Ships " + str(Globals.ships))
	ship_change.emit(Globals.ships)

func send_laser_signal(position,direction):
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

