import juego.*
import player.*
import wollok.game.*
import animator.*

class Background {

	method position() = game.at(0, 0)

	method image()

}

object backgroundInicio inherits Background {

	override method image() = "assets/Inicio.png"

}

object backgroundFinal inherits Background {

	override method image() = "assets/ganaste.png"

}

object instrucciones {

	method position() = game.at(0, 0)

	method image() = "assets/instrucciones.png"

}

object espacioParaComenzar inherits Animable(position = game.at(0, 0), animator = enemyAnimator, spriteInicial = apretaEspacio) {

	method mover() {
		animator.animate(self)
	}

}

object gameOver {

	method position() = game.center()

	method text() = "GAME OVER"

}

class NombreNivel {

	const property image

	method position() = game.at(6, 20)

}

class Vida {

	const imagen
	const objetivo
	const property position

	method image() = "assets/" + imagen + objetivo.salud() + ".png"

}

object vida inherits Vida(imagen = "hearts", position = game.at(1, juego.tamanho() * (9 / 10) + 1), objetivo = player) {

}

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

	method cuentaRegresiva(segundos) {
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

