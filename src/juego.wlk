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
	var nivelAnterior = 0
	const property tickEvents = []
	
	
	
	method configurar() {
		game.width(tamanho)
		game.height(tamanho)
		game.cellSize(12)
		game.title("platformero")

		keyboard.space().onPressDo{ player.saltar()}
		keyboard.right().onPressDo{ player.caminar(true)}
		keyboard.left().onPressDo{ player.caminar(false)}
		keyboard.r().onPressDo{ self.InstanciarNivel()}
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
		//player.quitarVida()
		puerta.cerrarPuerta()

		game.say(player, "Yo ya gané")
		nivelActual += 1
		self.InstanciarNivel()
		nivelAnterior += 1
	}
	

	
	
	method InstanciarNivel() {
		
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
	
	method pasarTiempo(){
		
		reloj.pasoElTiempo(1)

		//player.caer()
		
		//enemigos.forEach({unEnemigo => unEnemigo.mover()})
		

		
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