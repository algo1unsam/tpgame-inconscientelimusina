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
	var direccionIzq = true
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

	method animar() {
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
		self.animar()
		if (direccionIzq) {
			position = position.left(1)
			if (position.x() <= izquierda) {
				direccionIzq = !direccionIzq
			}
		} else {
			position = position.right(1)
			if (position.x() >= derecha) {
				direccionIzq = !direccionIzq
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
			direccionIzq = !direccionIzq
			
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

//DISCUTIR SI BOSS DEBERIA HEREDAR O NO DE ENEMIGO, XQ SU LOGICA ES UN TANTO DISTINTA

class Boss
							 {
								
							const sprite_mov = [ "assets/boss1.png", "assets/boss2.png","assets/boss3.png","assets/boss4.png",
										"assets/boss5.png", "assets/boss6.png","assets/boss7.png", "assets/boss8.png", "assets/boss9.png"]	
							
							const sprite_mov_izquierda = [ "assets/boss1i.png", "assets/boss2i.png","assets/boss3i.png","assets/boss4i.png",
										"assets/boss5i.png", "assets/boss6i.png","assets/boss7i.png", "assets/boss8i.png", "assets/boss9i.png"]
							
							const sprites_danho = [ "assets/bossDanho.png", "assets/bossDanhoi.png" ]						
							var property salud = 10
							var property position
							var image = 1
							var sprites = sprite_mov
							var fueAtacado = false
							var spikeProb = 20
							
							method image() {
								return sprites.get(image)
							}
													
													
							
							
							method serAtacado(x){
									fueAtacado = true
									game.schedule(1000, {fueAtacado = false})
									salud -= x
									spikeProb += 5
									if (salud == 0){
										game.say(self, "auch che, duele una banda loco")
										self.dropear()
									}
								}
							
							method animate() {
									if (player.position().x() <= 15){
										sprites = sprite_mov_izquierda
									} 
									else{
										sprites = sprite_mov
									}
									if (image < sprites.size() - 1) {
										image += 1
									} else {
										image = 0
									}
								}
														
														
							method crearSpike(){
								const unSpike = new SpikeEnCaida(position = game.at((5..40).anyOne(), 24))
								game.addVisual(unSpike)
								juego.visuals().add(unSpike)
								juego.nivelActual().objetos().add(unSpike)
								juego.nivelActual().animables().add(unSpike)
								juego.enemigos().add(unSpike)
							}
							
							method crearLibro(){
								const unLibro = new LibroEnCaida(blanco = self, position = game.at((5..40).anyOne(), 33))
								game.addVisual(unLibro)
								juego.visuals().add(unLibro)
								juego.nivelActual().objetos().add(unLibro)
								juego.nivelActual().animables().add(unLibro)
								juego.enemigos().add(unLibro)
							}
							
							method mover(){
								if (!fueAtacado){
									self.animate()}
								else{
									if (player.position().x() <= 15){
									image = 1}
									else{
										image = 0
									}
									sprites = sprites_danho
								}
									const rng = (1..100).anyOne()
									if (rng <= spikeProb){
										2.times({i => self.crearSpike()})

									}
									else if (rng > 93){
										self.crearLibro()

										}

										
									
								}
								
								method dropear(){
									const dropearMoneda = juego.nivelActual().dropCoin().anyOne()
									const dropeable = new Moneda(position = game.at(20,  1))
									game.addVisual(dropeable)
									juego.visuals().add(dropeable)
									juego.nivelActual().dropCoin().remove(dropearMoneda)
								}
							}

class SpikeEnCaida {
	
	var property position
	
	method image() = "assets/spike A4.png"
	
	method iniciar() {}
	
	method mover(){
		position = position.down(1)
		if (position.y() == -3){
			self.remover()
		}
		}
		
	method remover(){
		game.removeVisual(self)
		juego.enemigos().remove(self)
		juego.visuals().remove(self)
		juego.nivelActual().objetos().remove(self)
		juego.nivelActual().animables().remove(self)
	}
	
	method chocar() {
		if (player.estaVivo()) { player.bajarSalud(1)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, ["Deberia agarrar los libros", "Cuantos pinches loco", "Esta feo el bicho ese"].anyOne())
			}
		}}
	
	method serAtacado(x) {
		}
		
	method detener(){}
	
	
	
}


