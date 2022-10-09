import wollok.game.*
import juego.*
import obtenibles.*
import ghost.*
import player.*



class Librito inherits Obtenibles{
	
	override method image() = "assets/librito.png"

	override method chocar() {
		ghost1.morir()
		super()
	}

	method reiniciar() {
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
		}
	}
}