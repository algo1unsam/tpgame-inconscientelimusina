import wollok.game.*
import player.*

class Plataforma {

	var property position


	method image() = "assets/muro12.png"

	method chocar() {
	}

}

class Spikes inherits Plataforma{
	
	override method image () = "assets/spike B.png"
	
	override method chocar(){
		if (player.estaVivo()) { player.bajarSalud(5)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, "cuidado con los spikes, duelen mucho")
			}
		}
	}
}

