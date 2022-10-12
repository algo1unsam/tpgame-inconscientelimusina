
import wollok.game.*
import juego.*
import player.*

class Obtenibles{
	
	var property position
	
	method image()
	
	method chocar(){
		game.removeVisual(self)
		juego.visuals().remove(self)
	}
	
	method serAtacado(x){}
	

}

class HealPack inherits Obtenibles {

	override method image() = "assets/heal.png"

	override method chocar() {
		player.subirSalud(1)
		super()
	}

}


class Moneda inherits Obtenibles{

	override method image() = "assets/coin.png"

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

class Librito inherits Obtenibles{
	
	const blancos
	
	override method image() = "assets/librito.png"

	override method chocar() {
		blancos.forEach{unBlanco => unBlanco.morir()}
		super()
	}

	method reiniciar() {
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
		}
	}
}