import wollok.game.*
import player.*

class Plataforma {

	var property position


	method image() = "assets/muro12.png"

	method chocar() {
	}

}

class Spikes {
	
	var property position
	
	method image () = "assets/spike B.png"
	
	method chocar(){
		if (player.estaVivo()) { player.bajarSalud(5)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, "cuidado con los spikes, duelen mucho")
			}
		}
	}
}

class SpikesInvertidas {
	
	var property position
	
	method image () = "assets/spike A.png"
	
	method chocar(){
		if (player.estaVivo()) { player.bajarSalud(5)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, "cuidado con los spikes, duelen mucho")
			}
		}
	}
}

