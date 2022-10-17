import juego.*
import player.*
import wollok.game.*

object gameOver {

	method position() = game.center()

	method text() = "GAME OVER"

}

class NombreNivel{
	
	const property image
	
	method position() = game.at(6,20)
	
}

class Vida{
	
	const imagenes
	
	const objetivo
	
	const property position
	
	method image() {
		return imagenes.get(objetivo.salud())
	}
	

}


object vida inherits Vida( imagenes = [ "assets/hearts0.png", "assets/hearts1.png", "assets/hearts2.png", "assets/hearts3.png", "assets/hearts4.png", 
										"assets/hearts5.png", "assets/hearts6.png" ],
						   position = game.at(1, juego.tamanho() * (9 / 10) + 1),
						   objetivo = player){}
	


object monedaHUD {

	method image() = "assets/coinPequenha.png"
	
	method position() = game.at(1, juego.tamanho() * (9 / 10) - 1)
	
	

}

object contadorMonedas {

	method text() = juego.monedas().toString() + "/ " + juego.nivelActual().objetivoMonedas()

	method position() = game.at(2, juego.tamanho() * (9 / 10) - 3)

}

object reloj {

	
	var tiempo = 100
	
	method cuentaRegresiva(segundos){
		tiempo -= segundos
		if (tiempo < 0) {
			player.morir()
		}
	}

	method text() = tiempo.roundUp().toString()

	method position() = game.at(juego.tamanho() / 2, game.height() - juego.tamanho() / 10)



	method iniciar() {
		tiempo = 100

	}

	method detener() {

		}
	



}

object iconoEspada {

	var property image = "assets/sword11.png"
	var property position = game.at(6, juego.tamanho() * (9 / 10) - 1)

	method iniciar() {
	}

	method detener() {
		game.removeVisual(self)
		juego.visuals().remove(self)
	}

}


