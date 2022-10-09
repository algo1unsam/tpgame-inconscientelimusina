import wollok.game.*
import espada.*
import juego.*
import player.*
import moneda.*
import healPack.*

class Ghost{
	
	const ghost_mov =["assets/ghost1.png","assets/ghost2.png","assets/ghost3.png","assets/ghost4.png","assets/ghost5.png","assets/ghost6.png","assets/ghost7.png","assets/ghost8.png"]
	
	var property sprites = ghost_mov
	var image = (1..7).anyOne()
	var property position
	var fueAtacado = false
	var direccion = true
	const izquierda
	const derecha
	var transpasable = false
	var vivo = true
	var vida = 1
	
	method image() {
		return sprites.get(image)
	}
	
	method chocar() {
		if (!transpasable and player.estaVivo()) { player.bajarSalud(2)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, [ "Es la parca", "Que es esa cosa?"].anyOne())
			}
		}
	}
	
	method Animate() {
		if (image < sprites.size() - 1) {
			image += 1
		} else {
			image = 0
		}
	}
	
	method serAtacado(x){
		if(player.tieneLibro()){
			vida -= x
			fueAtacado = true
			ataque.position(game.at(juego.tamanho(), juego.tamanho()))
			game.say(self,"Me muero")
			self.morir()	
		}
			else	
				game.say(self,"jajaja soy inmune a tus ataques")
		
	}
	
	method iniciar() {
		vivo = true

		sprites = ghost_mov
		transpasable = false
		fueAtacado = false
	}
	
	method reiniciar() {
		console.println("reiniciar ghost")
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
			console.println("reinicio ghost")
		}
	}
	method morir() {
		self.detener()

	}
	
	method mover() {
		if (!fueAtacado){
		self.Animate()
		if (direccion) {
			position = position.left(1)
			if (position.x() <= izquierda) {
				direccion = !direccion
			}
		} else {
			position = position.right(1)
			if (position.x() >= derecha) {
				direccion = !direccion
			}
		}
	}}
	
	method dropear(){
		
	}
	
	method detener() {
		if (vivo) {
			vivo = !vivo
			game.removeVisual(self)
			juego.visuals().remove(self)
			juego.nivelActual().enemigos().remove(self)
		}
	}
}



const ghost1 = new Ghost(position = game.at(15, 1), izquierda = 14, derecha = 23)
const ghost2 = new Ghost(position = game.at(23,1), izquierda = 23, derecha = 23)

