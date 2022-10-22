import HUD.*
import wollok.game.*
import juego.*
import player.*

class Obtenibles {

	var property position
	var property image

	method chocar() {
		game.removeVisual(self)
		juego.visuals().remove(self)
	}

	method serAtacado(x) {
	}

}

class HealPack inherits Obtenibles(image = "assets/heal.png") {

	override method chocar() {
		player.subirSalud(1)
		super()
	}

}

class Moneda inherits Obtenibles (image = "assets/coin.png") {

	override method chocar() {
		juego.obtenerMoneda()
		super()
	}

	method reiniciar() {
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
		}
	}

}

class Librito inherits Obtenibles (image = "assets/librito.png") {

	const blancos

	override method chocar() {
		blancos.forEach{ unBlanco => unBlanco.morir()}
		super()
	}

	method reiniciar() {
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
		}
	}

}

class ObtenibleEnCaida inherits Obtenibles {

	method mover() {
		position = position.down(1)
		if (position.y() == -3) {
			self.remover()
		}
	}

	method remover() {
		game.removeVisual(self)
		juego.enemigos().remove(self)
		juego.visuals().remove(self)
		juego.nivelActual().objetos().remove(self)
		juego.nivelActual().animables().remove(self)
	}

}

class LibroEnCaida inherits ObtenibleEnCaida(image = "assets/libritoEnCaida.png") {

	const blanco

	override method chocar() {
		blanco.serAtacado(1)
		self.remover()
	}

}

class RelojEnCaida inherits ObtenibleEnCaida(image = "assets/cronometro.png") {

	override method chocar() {
		reloj.cuentaRegresiva(-30)
		self.remover()
	}

}

