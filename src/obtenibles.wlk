import HUD.*
import wollok.game.*
import juego.*
import player.*

class Obtenibles {

	var property position
	var property image
	
	method remover(){
		game.removeVisual(self)
		juego.visuals().remove(self)
	}
	
	method chocar() {
		self.remover()
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

	method relocalizar(unaPosicion){
		position = unaPosicion
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

class ObtenibleEnCaida inherits Obtenibles{

	const tipoDeObtenibleEnCaida
	
	const property blanco

	method mover() {
		position = position.down(1)
		if (position.y() == -3) {
			self.remover()
		}
	}

	override method remover() {
		super()
		juego.enemigos().remove(self)
	}

	override method chocar(){
		tipoDeObtenibleEnCaida.chocar(self)
	}
}

class TipoDeObtenibleEnCaida{
	
	const property limiteIzquierda = 7
	const property limiteDerecha = 34
	const property altura = 33

	method chocar(unObjeto)
}

object tipoHealPack inherits TipoDeObtenibleEnCaida{

	const property image = "assets/heal.png"

	override method chocar(unObjeto) {
		player.subirSalud(1)
		unObjeto.remover()
	}
}

object tipoReloj inherits TipoDeObtenibleEnCaida{

	const property image = "assets/cronometro.png"

	override method chocar(unObjeto) {
		reloj.cuentaRegresiva(-20)
		unObjeto.remover()
	}

}

object tipoLibro inherits TipoDeObtenibleEnCaida{
	
	const property image = "assets/libritoEnCaida.png"
	
	override method chocar(unObjeto) {
		unObjeto.blanco().serAtacado(1)
		unObjeto.remover()
	}
}

