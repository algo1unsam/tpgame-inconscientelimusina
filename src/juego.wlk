import wollok.game.*
import player.*
import HUD.*
import espada.*
import plataformas.*
import teletransportadores.*
import puerta.*
import niveles.*
import playerHit.*

object juego {

	const property tamanho = 40
	const property visuals = []
	var property monedas = 0
	var property nivelActual = pantallaInicio
	var property nivelAnterior = nivelActual
	const property tickEvents = []

	method configurarInicio() {
		game.width(tamanho)
		game.height(tamanho)
		game.cellSize(12)
		game.title("platformero")
		keyboard.space().onPressDo{ self.PasarPantallaInicio()}
	}

	method configurar() {
		keyboard.space().onPressDo{ player.saltar()}
		keyboard.right().onPressDo{ player.caminar(true)}
		keyboard.left().onPressDo{ player.caminar(false)}
		keyboard.r().onPressDo{ self.instanciarNivel()}
		keyboard.g().onPressDo{ self.ganar()}
		keyboard.s().onPressDo{ self.finalizar()}
		keyboard.q().onPressDo{ player.atacar(1)}
		keyboard.w().onPressDo{ player.atacar(2)}
		keyboard.e().onPressDo{ player.atacar(3)}
	}

	method obtenerMoneda() {
		monedas += 1
		if (monedas == self.nivelActual().objetivoMonedas()) {
			puerta.abrirPuerta()
		}
	}

	method iniciarPantallaInicio() {
		self.configurarInicio()
		game.onTick(700, "tiempo", { nivelActual.enemigos().forEach({ unEnemigo => unEnemigo.mover()})}) // cambiar nombre de metodo
		nivelActual.cargar()
	}

	method PasarPantallaInicio() {
		if (pantallaInicio.primeraInstanciacion()) {
			nivelActual.mostrarInstrucciones()
			pantallaInicio.primeraInstanciacion(false)
		} else {
			nivelActual = nivelActual.nivelSiguiente()
			nivelAnterior = nivelActual
			game.clear()
			self.iniciar()
		}
	}

	method finalizar() {
		game.stop()
	}

	method ganar() {
		player.transportar(game.at(tamanho, tamanho))
		puerta.cerrarPuerta()
		game.say(puerta, "Yo ya gané")
		nivelActual = nivelActual.nivelSiguiente()
		self.detenerTiempo()
		game.schedule(1000, { self.instanciarNivel()})
		game.schedule(1200, { nivelAnterior += 1})
	}

	method instanciarNivel() {
		self.terminar()
		self.iniciar()
	}

	method terminar() {
		juego.tickEvents().clear()
		game.clear()
	}

	method iniciar() {
		self.configurar()
		puerta.cerrarPuerta()
		monedas = 0
		nivelActual.cargar()
		self.nivelActual().animables().forEach({ unObjeto => unObjeto.iniciar()})
		self.agregarTiempo()
		player_hit.cargar()
		if (nivelActual.esNivelFinal()) {
			player_hit.cargarHitBoxExtra()
		}
		self.colisiones()
	}

	method agregarTiempo() {
		game.onTick(1000, "tiempo", { self.pasarTiempo()})
		tickEvents.add("tiempo")
	}

	method detenerTiempo() {
		if (self.tickEvents().contains("tiempo")) {
			game.removeTickEvent("tiempo")
			self.tickEvents().remove("tiempo")
		}
	}

	method pasarTiempo() {
		reloj.cuentaRegresiva(1)
		3.times({ i => game.schedule((i - 1) * 1000 / 3, { player.caer()
			nivelActual.enemigos().forEach({ unEnemigo => unEnemigo.mover()})
		})})
	}

	method plataformas() = nivelActual.posPlataformas()

	method enemigos() = nivelActual.enemigos()

	method colisiones() {
		player.hitbox().forEach({ x => game.onCollideDo(x, { obstaculo => obstaculo.chocar()})})
		game.onCollideDo(ataque, { obstaculo => obstaculo.serAtacado(ataque.danho())})
	}

	method detener(objeto) {
		if (visuals.contains(objeto)) {
			objeto.detener()
		}
	}

}

