import wollok.game.*
import player.*

class CreadorDePlataformas {

	var posicionesY
	var posicionesX

	method posiciones() {
		const posiciones = []
		(0 .. posicionesY.size() - 1).forEach({ unY => posicionesX.get(unY).forEach({ rangoX => rangoX.forEach{ n => posiciones.add(new Position(x = n, y = posicionesY.get(unY)))}})})
		return posiciones
	}

}

class Plataforma {

	var property position

	method image() = "assets/muro12.png"

	method chocar() {
	}

}

class Spikes {

	var property position

	method image() = "assets/spike B.png"

	method chocar() {
		if (player.estaVivo()) {
			player.bajarSalud(5)
			if (player.salud() > 0) {
				player.transportar(player.posicionInicial())
				game.say(player, "cuidado con los spikes, duelen mucho")
			}
		}
	}

}

class SpikesInvertidas {

	var property position

	method image() = "assets/spike A.png"

	method chocar() {
		if (player.estaVivo()) {
			player.bajarSalud(5)
			if (player.salud() > 0) {
				player.transportar(player.posicionInicial())
				game.say(player, "cuidado con los spikes, duelen mucho")
			}
		}
	}

}

