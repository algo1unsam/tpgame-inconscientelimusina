
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

class LibroEnCaida inherits Obtenibles{   //libro

	
	const blanco
	
	
	override method image() = "assets/libritoEnCaida.png"
	
	override method chocar() {
		blanco.serAtacado(1)
		self.remover()
	}
	
	method mover(){

		position = position.down(1)
		if (position.y() == -3){
			self.remover()
		}}
		
	method remover(){
		game.removeVisual(self)
		juego.enemigos().remove(self)
		juego.visuals().remove(self)
		juego.nivelActual().objetos().remove(self)
		juego.nivelActual().animables().remove(self)
	}
	
	method iniciar() {}
	
	method detener(){}
	
	
}


