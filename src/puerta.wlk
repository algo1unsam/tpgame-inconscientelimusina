import wollok.game.*
import player.*
import juego.* 

object puerta{
	
	var estaAbierta = false
	var property position = game.at(juego.tamanho() - 8, 1)
	var property image = "assets/puertaCerradaChica.png"
	
	method abrirPuerta(){
		estaAbierta = true
		image = "assets/puertaAbiertaChica.png"
	}
	
	method cerrarPuerta(){
		estaAbierta = false
		image = "assets/puertaCerradaChica.png"
	}
	
	method chocar() {
		if (estaAbierta) {
			juego.ganar()
		}
		else{
			game.say(player, "Me faltan " + (juego.nivelActual().objetivoMonedas() - juego.monedas()).toString() + " monedas")
		}
	}

	method serAtacado(x) {
	}


	
}