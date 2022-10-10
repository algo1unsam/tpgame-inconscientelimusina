import wollok.game.*
import player.*
import HUD.*
import espada.*
import slime.*
import plataformas.* 
import moneda.*
import teletransportadores.*
import puerta.*
import niveles.*
import playerHit.*
import ghost.*
import librito.*

object juego {

	const property tamanho = 40

	const property visuals = []
	var property monedas = 0

	var property nivelActual = 0
	var nivelAnterior = nivelActual
	const property tickEvents = []
	
	
	
	method configurar() {
		game.width(tamanho)
		game.height(tamanho)
		game.cellSize(12)
		game.title("platformero")

		keyboard.space().onPressDo{ player.saltar()}
		keyboard.right().onPressDo{ player.caminar(true)}
		keyboard.left().onPressDo{ player.caminar(false)}
		keyboard.r().onPressDo{ self.instanciarNivel()}
		keyboard.g().onPressDo{ self.ganar()}

		
		keyboard.q().onPressDo{ player.atacar1()}
		keyboard.w().onPressDo{ player.atacar2()}
		keyboard.e().onPressDo{ player.atacar3()}
	}

	method obtenerMoneda(){
		monedas += 1
		if (monedas == self.nivelActual().objetivoMonedas()){
			puerta.abrirPuerta()
		}
	}
	
	method nivelActual() = selectorNiveles.listaNiveles().get(nivelActual)
	
	method nivelAnterior() = selectorNiveles.listaNiveles().get(nivelAnterior)
	
	method ganar(){
		player.transportar(game.at(tamanho, tamanho))
		puerta.cerrarPuerta()

		game.say(puerta, "Yo ya gané")
		nivelActual += 1
		self.detenerTiempo()
		game.schedule(1000, {self.reInstanciarNivel()})
		game.schedule(1200, {nivelAnterior += 1})
	}
	
	method reInstanciarNivel() {
		
		self.nivelAnterior().animables().forEach({ unObjeto => self.detener(unObjeto)})
		
		game.clear()
		
		self.configurar()
		puerta.cerrarPuerta()
		monedas = 0
		
		
		self.nivelActual().cargar()
		
		self.iniciar()
		player_hit.cargar()
		self.colisiones()
		
		 
	}
	
	
	method instanciarNivel() {
		
		self.nivelAnterior().animables().forEach({ unObjeto => self.detener(unObjeto)})
		
		game.clear()
		self.configurar()
		puerta.cerrarPuerta()
		monedas = 0
		
		
		self.nivelActual().cargar()
		
		self.iniciar()
		player_hit.cargar()
		self.colisiones()
		
		
	}
	
	method iniciar() {
		self.nivelActual().animables().forEach({ unObjeto => unObjeto.iniciar()})
		game.onTick(1000, "tiempo", { self.pasarTiempo()})

		tickEvents.add("tiempo")
	}
	
	method detenerTiempo(){
	
			if (juego.tickEvents().contains("tiempo")) {
			game.removeTickEvent("tiempo")
			juego.tickEvents().remove("tiempo")}
			}
		
	
	method pasarTiempo(){
		
		reloj.pasoElTiempo(1)
		
		
		3.times({i => game.schedule( (i-1) * 1000/3, { player.caer()})})
			
		3.times({i => game.schedule( (i-1) * 1000/3, { self.nivelActual().enemigos().forEach({unEnemigo => unEnemigo.mover()})})})


	}
		
	method plataformas() = 	selectorNiveles.listaNiveles().get(nivelActual).posPlataformas()
	

	method colisiones() {
		player.hitbox().forEach({ x => game.onCollideDo(x, { obstaculo => obstaculo.chocar()})})
		game.onCollideDo(ataque, { obstaculo => obstaculo.serAtacado(ataque.danho())})
	}


	method detener(objeto){
		if (visuals.contains(objeto)){
			objeto.detener()
		}
	}


}