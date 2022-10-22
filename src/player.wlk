import wollok.game.*
import juego.*
import espada.*
import playerHit.*
import animator.*


object player inherits Animable(animator = playerAnimator,
								miraDerecha = true,
								spriteInicial = idle,
								position = game.at(0,2))
				{



	var vivo = true
	var property salud = 6

	var property mov = false
	var property saltando = false
	var property atacando = false
	var property ataque1 = false
	var property ataque2 = false
	var cayendo = false
	var property tieneEspada = false
	var property att_combo = false
	var property vulnerable = true
	const property hitbox = []
	



	method todaLaVida() {
		self.salud(6)
	}


	method posicionInicial() = game.at(0, 2)



	method caerAlPozo() {
		self.transportar(self.posicionInicial())
		self.bajarSalud(1)
	}

			
	method grounded() = juego.plataformas().contains(game.at(self.position().x() + 3, self.position().y() - 1)) or juego.plataformas().contains(game.at(self.position().x() + 4, self.position().y() - 1)) 
	
	method saltar() {
		if (vivo and (self.grounded() or (!cayendo and !saltando))) {  //coyote jump
			
			saltando = true
			animator.cambiarAnimate(self, salto)
			3.times(i => game.schedule((i-1)*150, {self.moverEnY(1)}))
			game.schedule(350, { self.saltando(false)})
		}
	}

	method subirSalud(x) {
		salud = (salud + x).min(6)
	}

	method bajarSalud(x) {
		salud = (salud - x).max(0)
		if (salud == 0) {
			self.morir()
		}
	}

	method moverEnY(cantidad) {
		position = position.up(cantidad)
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().up(cantidad))})
	}
	
	


	method caer() {
		if (!self.grounded() and !saltando) {
			animator.cambiarAnimate(self, caida)
			

			cayendo = true
			self.moverEnY(-1)
			if (self.position().y() == -4) {
					self.caerAlPozo()}
		}
		else if (self.grounded() and (sprites == caida)) {
			self.aterrizar()
		}
	}

	method aterrizar() {
		cayendo = false
		self.jugadorEnReposo()
	}

	method jugadorEnReposo() {
		mov = false
		if (self.grounded()){  //si no esta en el piso en ese momento su animacion deberia ser salto o caida, no idle
		if (!atacando) {
			if (tieneEspada) {
				animator.cambiarAnimate(self, idle_espada)
			} else {
				animator.cambiarAnimate(self, idle)
			}}
		}
	}
	

	method caminar(direccion) { //(vivo and !mov) chequear 1 vez
		miraDerecha = direccion
		if (vivo and !mov){
		if (self.grounded()) {
			animator.cambiarAnimate(self, walk)
			mov = true
			3.times({ i => game.schedule(400 * (i - 1) / 2, { self.mover(direccion)})}) 
			game.schedule(400, { self.jugadorEnReposo()})
		} else {
			mov = true
			animator.cambiarAnimate(self, caida)			
			2.times({ i => game.schedule(550 * (i-1) / 2, { self.mover(direccion)})})
			game.schedule(550, { self.mov(false)})
		}
		
		}
	}


	method animadorAtaques(tiempoAnimacion, cantAtaques,danho){
		if (miraDerecha){
			game.schedule(tiempoAnimacion,{ataque.position(self.position().right(3))})
			ataque.danho(danho)
			cantAtaques.times({i => game.schedule(tiempoAnimacion + 150 * (i / 4), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
			
		}
		else{
			game.schedule(tiempoAnimacion, { ataque.position(self.position().right(2))})
			ataque.danho(danho)
			cantAtaques.times({ i => game.schedule(tiempoAnimacion + 150 * (i / 4), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
			
		}
		
	}

	method animAtacar1() {   
		animator.cambiarAnimate(self, att1)
		self.animadorAtaques(150,4,1)
	}

	method animAtacar2() {
		animator.cambiarAnimate(self, att2)
		self.animadorAtaques(150,5,2)
		
	}

	method animAtacar3() {
		animator.cambiarAnimate(self, att3)
		self.animadorAtaques(75,10,5)
		
	}

	method atacando(bool) {
		if (!att_combo) {
			atacando = bool
		}
	}

	method atacar1() {
		if (self.grounded() and tieneEspada and !atacando and vivo) {

			mov = true
			atacando = true
			self.animAtacar1()
				
			game.schedule(300, { self.ataque1(true)})
			game.schedule(600, { self.mov(false)})
			game.schedule(550, { self.atacando(false)}) 
			game.schedule(575, { self.ataque1(false)})
			game.schedule(600, { self.jugadorEnReposo()}) 
		}
	}

	method atacar2() {
		if (ataque1) {
	
			mov = true
			ataque1 = false
			atacando = true
			att_combo = true
			self.animAtacar2()
			game.schedule(350/2, { self.mover(miraDerecha)})
			game.schedule(350, { self.ataque2(true)})
			//game.schedule(600, { self.mov(false)})
			game.schedule(550, { self.atacando(false)}) 
			game.schedule(575, { self.ataque2(false)})
			game.schedule(325, { self.att_combo(false)})
			game.schedule(600, { self.jugadorEnReposo()})
		}
	}

	method atacar3() {
		if (ataque2) {

			mov = true
			ataque2 = false // sacar si se quiere un combo mas buggeado pero copado
			atacando = true
			att_combo = true
			vulnerable = false
			self.animAtacar3()
				// 2.times({ i => game.schedule(150 * (i / 2), { self.mover(miraDerecha)})})
			6.times({ i => game.schedule(150 + 200 * (i / 8), { self.mover(miraDerecha)})})
			game.schedule(550, { self.mov(false)})
			game.schedule(400, { self.att_combo(false)})
			game.schedule(550, { self.atacando(false) vulnerable = true})
			game.schedule(600, { self.jugadorEnReposo()})
		}
	}


	method transportar(pos) {
		const diffX = pos.x() - position.x()
		const diffY = pos.y() - position.y()
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().right(diffX).up(diffY))})
		position = pos 
	}

	method mover(direccion) {
		if (direccion) { 
			position = position.right(1)
			hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().right(1))})
		} else {
			position = position.left(1)
			hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().left(1))})
		}
	}



	method detener() {

		if (juego.tickEvents().contains("anima")) {

			game.removeTickEvent("anima")
			juego.tickEvents().remove("anima")
		}


	}

	method morir() {
		self.quitarVida()
		animator.cambiarAnimate(self, muere)
		game.schedule(450, {game.removeTickEvent("anima")})
		game.schedule(450,{juego.tickEvents().remove("anima")})


		game.say(self, "Game Over")
		if (juego.tickEvents().contains("tiempo")) {
			game.removeTickEvent("tiempo")
			juego.tickEvents().remove("tiempo")
		}
		game.schedule(1000, { game.say(self, "Apreta R para reiniciar")})
		
	}
	

	method quitarVida(){
	vivo = false}


	method iniciar() {
		vivo = true
		self.todaLaVida()
		self.transportar(self.posicionInicial())
		tieneEspada = false
		sprites = idle

		if (!juego.tickEvents().contains("anima")){
		animator.aplicarAnimate(self, sprites)}
		
		
	}
	

		
		
	

	method estaVivo() {
		return vivo
	}

	method mostrarPosicion() {
		console.println(self.position())
	}
//
	method serAtacado(x) {	}

}



