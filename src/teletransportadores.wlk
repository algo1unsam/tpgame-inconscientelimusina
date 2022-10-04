import wollok.game.*
import juego.*
import player.*

class Teleporter {

	var position
	var property sprite
	var property x
	var property y
	
	method image() = sprite + ".png"
	
	method chocar() {
		player.transportar(game.at(x-2, y))
	}

	method position() = return position

	method serAtacado(danho) {
	}

}

class Receiver {

	var teleporter
	
	method position() = game.at(teleporter.x(), teleporter.y())
	
	method image() = teleporter.sprite() + "r.png"


	method chocar() {
	}

	method serAtacado(x) {
	}

}



