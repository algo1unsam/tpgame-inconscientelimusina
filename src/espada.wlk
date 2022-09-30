import wollok.game.*
import player.*
import HUD.*
import juego.*
import obtenibles.*

class Espada inherits Obtenibles{
	
	override method image() = "assets/sword11.png"
	
	override method chocar() {
		game.addVisual(iconoEspada)
		juego.visuals().add(iconoEspada)
		player.tieneEspada(true)
		player.jugadorEnReposo()
		super()


	}
	
	method reiniciar() {
		console.println("reiniciar espada")
		if (!juego.visuals().contains(self)) {
			
			game.addVisual(self)
			juego.visuals().add(self)
			
		}
		console.println("reinicio espada")
	}
}





	
	




object ataque {

	var property position = game.at(40, 40)
	var property image = "assets/pixel.png"
	var property danho = 0

	method mover(direccion) {
		if (direccion) {
			position = position.left(1)
		} else {
			position = position.right(1)
		}
	}

	method chocar() {
	}

}

