import wollok.game.*
import juego.*
import espada.*
import playerHit.*
import animator.*


object player inherits Animable(animator = playerAnimator,
								miraDerecha = true,
								spriteInicial = idle,
								numeroDeSprite = 1,
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
			self.subir()
			game.schedule(150, { self.subir()})
			game.schedule(300, { self.subir()})
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

	method subir() {
		position = position.up(1)
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().up(1))})
	}
	
	


	method caer() {
		if (!self.grounded() and !saltando) {
			if (!cayendo) {
				animator.cambiarAnimate(self, caida)
			}
			if (self.position().y() == -4) {
					self.caerAlPozo()}
			cayendo = true
			position = position.down(1)
			hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().down(1))})
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
		if (!atacando) {
			if (tieneEspada) {
				animator.cambiarAnimate(self, idle_espada)
			} else {
				animator.cambiarAnimate(self, idle)
			}
		}
	}
	

	method caminar(direccion) {
		miraDerecha = direccion
		if (vivo and self.grounded() and !mov) {
			animator.cambiarAnimate(self, walk)
			mov = true
			3.times({ i => game.schedule(400 * (i - 1) / 2, { self.mover(direccion)})}) 
			game.schedule(400, { self.jugadorEnReposo()})
		} else if (vivo and !mov) {
			mov = true
			animator.cambiarAnimate(self, caida)			
			2.times({ i => game.schedule(500 * (i-1) / 2, { self.mover(direccion)})})
			game.schedule(500, { self.mov(false)})
		}
	}


	method animAtacar1() {
		animator.cambiarAnimate(self, att1)
		if (miraDerecha) {			
			game.schedule(150, { ataque.position(self.position().right(3))})
			ataque.danho(1)
			4.times({ i => game.schedule(150 + 150 * (i / 4), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {			
			game.schedule(150, { ataque.position(self.position().right(2))})
			ataque.danho(1)
			4.times({ i => game.schedule(150 + 150 * (i / 4), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
	}

	method animAtacar2() {
		animator.cambiarAnimate(self, att2)
		if (miraDerecha) {
			game.schedule(150, { ataque.position(self.position().right(3))})
			ataque.danho(2)
			5.times({ i => game.schedule(150 + 150 * (i / 5), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {
			game.schedule(150, { ataque.position(self.position().right(2))})
			ataque.danho(2)
			5.times({ i => game.schedule(150 + 150 * (i / 5), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
	}

	method animAtacar3() {
		animator.cambiarAnimate(self, att3)
		if (miraDerecha) {
			game.schedule(75, { ataque.position(self.position().right(3))})
			ataque.danho(5)
			10.times({ i => game.schedule(75 + 150 * (i / 10), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {
			game.schedule(75, { ataque.position(self.position().right(2))})
			ataque.danho(5)
			10.times({ i => game.schedule(75 + 150 * (i / 10), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
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

	method serAtacado(x) {
	}

}



