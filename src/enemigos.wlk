import wollok.game.*
import espada.*
import juego.*
import player.*
import moneda.*
import healPack.*

class Enemigo {

	var sprite_mov
	var property sprites = sprite_mov
	var image = (1..sprite_mov.size()).anyOne()
	var property position
	var direccion = true
	const izquierda
	const derecha
	var vivo = true
	const danho 
	const mensaje


	method image() {
		return sprites.get(image)
	}



	method chocar() {
		if (player.estaVivo()) { player.bajarSalud(danho)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, mensaje.anyOne())
			}
		}
	}

	method animate() {
		if (image < sprites.size() - 1) {
			image += 1
		} else {
			image = 0
		}
	}


	method iniciar() {
		vivo = true
		sprites = sprite_mov
	}

	method mover() {
		self.animate()
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
	}

	method serAtacado(x) {
		}



	method morir() {
		self.detener()


	}


	method detener() {
		if (vivo) {
			vivo = !vivo
			game.removeVisual(self)
			juego.visuals().remove(self)
			juego.nivelAnterior().enemigos().remove(self)
		}
	}

}





