import wollok.game.*
import juego.*
import player.*
import obtenibles.*

class HealPack inherits Obtenibles {

	override method image() = "assets/heal.png"

	override method chocar() {
		player.subirSalud(1)
		super()
	}

}
