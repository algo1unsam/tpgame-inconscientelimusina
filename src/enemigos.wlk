import wollok.game.*
import espada.*
import juego.*
import player.*
import obtenibles.*

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
		if (player.estaVivo() && player.vulnerable()) { player.bajarSalud(danho)
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

class Ghost inherits Enemigo( danho = 2,
							  mensaje = [ "Es la parca", "Que es esa cosa?"], 
							  sprite_mov =["assets/ghost1.png","assets/ghost2.png","assets/ghost3.png","assets/ghost4.png","assets/ghost5.png",
											"assets/ghost6.png","assets/ghost7.png","assets/ghost8.png"])
{
	
	override method serAtacado(x){	
				game.say(self,"jajaja soy inmune a tus ataques")
		
	}
	

}


class Slime inherits Enemigo(danho = 2,
							mensaje = [ "Más cuidado che", "Otra vez al comienzo..", "ouch...", "aaAaH!!!" ], 
							sprite_mov = [ "assets/slime (1).png", "assets/slime (2).png", "assets/slime (3).png", "assets/slime (4).png", "assets/slime (5).png", 
											"assets/slime (6).png", "assets/slime (7).png", "assets/slime (8).png", "assets/slime (9).png", "assets/slime (10).png" ]
							) {

	const sprite_danho = [ "assets/slime_red1.png", "assets/slime_red2.png", "assets/slime_red3.png", "assets/slime_red4.png", "assets/slime_red5.png", "assets/slime_red6.png", "assets/slime_red7.png", "assets/slime_red8.png", "assets/slime_red9.png", "assets/slime_red10.png", "slime_red11.png" ]
	var fueAtacado = false
	var vida = 5
	var transpasable = false



	override method chocar() {
		if (!transpasable){
			super()
		}
				}
		



	override method iniciar() {
		super()
		transpasable = false
		fueAtacado = false
	}


	override method mover() {
		if (!fueAtacado){
			super()}}

	override method serAtacado(x) {
		vida -= x
		fueAtacado = true
		ataque.position(game.at(juego.tamanho(), juego.tamanho()))
		sprites = sprite_danho
		transpasable = true
		if (vida <= 0) {
			self.morir()
		}
		else{
			direccion = !direccion
			
			game.schedule(450, { self.iniciar() })
		}

	}

	override method morir() {
		super()
		self.dropear()

	}

	method dropear(){
		const dropearMoneda = juego.nivelActual().dropCoin().anyOne()
		if (dropearMoneda) {
			const dropeable = new Moneda(position = self.position())
		} else {
			const dropeable = new HealPack(position = self.position())
		}
		game.addVisual(dropeable)
		juego.visuals().add(dropeable)
		juego.nivelActual().dropCoin().remove(dropearMoneda)
	}



}


class Boss inherits Enemigo(danho = 0,
							position = game.at(15, 20),
							derecha = 16,
							izquierda = 14,
							mensaje = [ "no deberias estar aquí..."], 
							sprite_mov = [ "assets/bossRight1.png", "assets/bossRight2.png" ]
							) {}


