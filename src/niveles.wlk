import wollok.game.*
import juego.*
import player.*
import HUD.*
import espada.*
import plataformas.*
import teletransportadores.*
import puerta.*
import playerHit.*
import obtenibles.*
import enemigos.*

class Nivel {

	var property posPlataformas = []
	var property posSpikes = []
	var property objetos = []
	var property animables = []
	var property enemigos = []
	const property esNivelFinal = false
	const nombre
	const nombreNivel = new NombreNivel(image = "assets/" + nombre + ".png")
	
	var property objetivoMonedas = 0
	var property dropCoin = []

	
	method dibujar(dibujo) {
		game.addVisual(dibujo)
		juego.visuals().add(dibujo)
		return dibujo
	}

	method cargar()
	
	method nivelSiguiente()
	
	method mostrarNombreNivel(){
		game.addVisual(nombreNivel)
		game.schedule(2000, {game.removeVisual(nombreNivel)})
	}
}

object pantallaInicio inherits Nivel(nombre = "inicio"){
	
	var property primeraInstanciacion = true
	
	override method nivelSiguiente() = nivel1

	override method cargar() {

	objetos = [ backgroundInicio, espacioParaComenzar ]
	animables = [  ]
	enemigos = [ espacioParaComenzar ]
		
	objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
	objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
	}
	
	method mostrarInstrucciones(){
		
		game.removeVisual(backgroundInicio)
		juego.visuals().remove(backgroundInicio)
		game.removeVisual(espacioParaComenzar)
		juego.visuals().remove(espacioParaComenzar)
		objetos = [ instrucciones ]
		enemigos = []
		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
		objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
}}



object nivel1 inherits Nivel(nombre = "nivel1") {
	
	const property rng = [ true ]

	override method nivelSiguiente() = nivel2

	override method cargar() {
		
	const plataformasNivel = new CreadorDePlataformas (posicionesY = [0],
										posicionesX = [[(1 .. game.width() - 2)]])
	posPlataformas = plataformasNivel.posiciones()
	posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
	
	const espada1 = new Espada(position = game.at(15,  1))
	const slime1 = new Slime(position = game.at(15, 1), izquierda = 9, derecha = 22)

	
	objetivoMonedas = 1
	dropCoin = rng.copy()
	
	objetos = [ vida, reloj, espada1, slime1, ataque, contadorMonedas, puerta, player,  monedaHUD]
	animables = [  reloj, player, slime1, iconoEspada]
	enemigos = [ slime1 ]
		
	objetos.forEach({ unObjeto => game.addVisual(unObjeto)})


	
	objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
	self.mostrarNombreNivel()
}
}

object nivel2 inherits Nivel(nombre ="nivel2") {
	
	const property rng = [ false ]

	override method nivelSiguiente() = nivel3

	override method cargar() {
		
	const plataformasNivel = new CreadorDePlataformas (posicionesY = [0, 3, 6, 8, 10, 11],
								posicionesX = [[(1 .. 12), (21.. 40)],
												[(13..20)],
												[(20..22)],
												[(13..18), (24..27)],
												[(9..11)],
												[(0..5), (27..45)]
												])


	posPlataformas = plataformasNivel.posiciones()

	posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
	
	const espada1 = new Espada (position = game.at(21,  7))
	const moneda1 = new Moneda (position = game.at(4,  12))
	const ghost1 = new Ghost(position = game.at(21, 1), izquierda = 23, derecha = 27)
	const libro1 = new Librito(position = game.at(30,  12), blancos = [ghost1])
	
	objetivoMonedas = 1
	dropCoin = rng.copy()
	objetos = [ vida, reloj, espada1, ghost1, ataque, contadorMonedas, puerta, player, monedaHUD, moneda1,libro1 ]
	animables = [ player, reloj,  ghost1, iconoEspada ]
	enemigos = [ ghost1 ]
		
	objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
	

	objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
	
	self.mostrarNombreNivel()
		}
	}

object nivel3 inherits Nivel(nombre ="nivel3"){
	
	const property rng = [ false ]
	
	override method nivelSiguiente() = nivel4
			
	override method cargar(){
		
		puerta.position(game.at(33,31))
		
		const plataformasNivel = new CreadorDePlataformas (posicionesY = [0, 7, 13, 21, 30],
												posicionesX = [[(0..6), (33.. 45)],
												[(0..9)],
												[(0..14)],
												[(0 .. 20)],
												[(0..45)]
												])

		posPlataformas = plataformasNivel.posiciones()
			
		(18 .. 18).forEach{ n => posSpikes.add(new Position(x = n, y = 31))}
		posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
		posSpikes.forEach{ p => self.dibujar(new Spikes (position = p))}
		
		const tp1 = new Teleporter(position = game.at(0, 1), sprite = "assets/tp1", x = 0,y = 8)
		const tp2 = new Teleporter(position = game.at(5,1), sprite = "assets/tp2", x = 33, y = 1)
		const tp3 = new Teleporter(position = game.at(game.width()-2,1), sprite = "assets/tp3", x = 11, y = 14)
		const tp4 = new Teleporter(position = game.at(8,8), sprite = "assets/tp4", x = 0, y = 22)
		const tp5 = new Teleporter(position = game.at(0, 14), sprite = "assets/tp5", x = 0,y =31)
		const tp6 = new Teleporter(position = game.at(19, 22), sprite = "assets/tp5", x = 0,y =31)
		const r1 = new Receiver(teleporter = tp1)
		const r2 = new Receiver(teleporter = tp2)
		const r3 = new Receiver(teleporter = tp3)
		const r4 = new Receiver(teleporter = tp4)
		const r5 = new Receiver(teleporter = tp5)
		const r6 = new Receiver(teleporter = tp6)
		const moneda1 = new Moneda (position = game.at(36, 1 ))
		const moneda2 = new Moneda (position = game.at(5, 8 ))
		const moneda3 = new Moneda (position = game.at(12, 22 ))
		const moneda4 = new Moneda (position = game.at(12, 31 ))
		const slime1 = new Slime(position = game.at(10, 14), izquierda = 2, derecha = 13)
		
		objetivoMonedas = 4
		dropCoin = rng.copy()
		objetos = [vida, reloj, ataque, contadorMonedas, puerta, player, monedaHUD,tp1,r1,tp2,r2,tp3,r3,tp4,r4,tp5,tp6,r5,r6,moneda1,moneda2,moneda3,moneda4,slime1 ]
		animables = [ player, reloj, iconoEspada,slime1]
		enemigos = [slime1]
				
		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
		objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
		
		self.mostrarNombreNivel()
	}
	}

object nivel4 inherits Nivel(nombre ="nivel4"){
	
	const property rng = [ true, false, false ]
	
	override method nivelSiguiente() = nivel5

	override method cargar() {
		
		puerta.position(game.at(32,1))	

		const plataformasNivel = new CreadorDePlataformas (posicionesY = [0, 8, 16, 24, 28, 32],
										posicionesX = [[(1 .. 7), (31.. 38)],
														[(8..14), (18..21), (26..30)],
														[(4..45)],
														[(20..45)],
														[(0..8)],
														[(32..45)]	])

		posPlataformas = plataformasNivel.posiciones()
		

		posPlataformas.forEach{ p => self.dibujar(new Plataforma(position = p))}
		
		const espada2 = new Espada(position = game.at(33, 33))
		const slime1 = new Slime(position = game.at(15, 17), izquierda = 9, derecha = 22)
		const slime2 = new Slime(position = game.at(30, 17), izquierda = 26, derecha = 33)
		const slime3 = new Slime(position = game.at(30, 25), izquierda = 25, derecha = 35)
		const moneda1 = new Moneda(position = game.at(28, 25))
		const moneda2 = new Moneda(position = game.at(4, 29))
		const moneda3 = new Moneda(position = game.at(12, 17))
		const moneda4 = new Moneda(position = game.at(24, 17))
		const moneda5 = new Moneda(position = game.at(29, 9))
		
		const tp1 = new Teleporter(position = game.at(7, 1), sprite = "assets/tp1", x = 36, y = 25)
		const tp2 = new Teleporter(position = game.at(34, 17), sprite = "assets/tp2", x = 8, y = 9)
		const tp3 = new Teleporter(position = game.at(6, 17), sprite = "assets/tp3", x = 1, y = 29)
		const tp4 = new Teleporter(position = game.at(35, 1), sprite = "assets/tp4", x = 36, y = 33)
		const r1 = new Receiver(teleporter = tp1)
		const r2 = new Receiver(teleporter = tp2)
		const r3 = new Receiver(teleporter = tp3)
		const r4 = new Receiver(teleporter = tp4)
		

		objetivoMonedas = 6
		objetos = [ vida, reloj, monedaHUD, contadorMonedas, ataque, espada2, slime1, slime2, slime3, moneda1, moneda2, moneda3, moneda4, moneda5, tp1, r1, tp2, r2, tp3, r3, tp4, r4, puerta, player ]
		animables = [ player, reloj, slime1, slime2, slime3, iconoEspada ]
		enemigos = [ slime1, slime2, slime3 ]
		
		dropCoin = rng.copy()

		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
		objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
		self.mostrarNombreNivel()
	}
}

object nivel5 inherits Nivel(nombre ="nivel5"){
	
	const property rng = [ true, true ]
	
	override method nivelSiguiente() = nivelFinal
	
	override method cargar() {
		
		
		const plataformasNivel = new CreadorDePlataformas (posicionesY = [0, 6, 12, 19, 25, 30],
								posicionesX = [[(0..6), (28.. 45)],
												[(8..12), (17..20), (24..27)],
												[(15..45)],
												[(0 .. 4), (9 .. 12), (18..24), (29..45)],
												[(0..9), (14..16), (20..23), (28..45)],
												[(1..6)]
												])


		posPlataformas = plataformasNivel.posiciones()
		(7.. 26).forEach{ n => posSpikes.add(new Position(x = n, y = 0))}
		posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
		posSpikes.forEach{ p => self.dibujar(new Spikes (position = p))}

		const slime1 = new Slime(position = game.at(30, 26), izquierda = 29, derecha = 34)
		const slime2 = new Slime(position = game.at(20, 13), izquierda = 20, derecha = 28)
		const espada1 = new Espada (position = game.at(35,  26))
		const tp1 = new Teleporter(position = game.at(1, 1), sprite = "assets/tp1", x = 1,y =31)
		const r1 = new Receiver(teleporter = tp1)
		const ghost1 = new Ghost(position = game.at(29, 20), izquierda = 19, derecha = 19)
		const libro1 = new Librito(position = game.at(1,  20), blancos = [ghost1])
		const moneda1 = new Moneda (position = game.at(32,  20))
		const moneda2 = new Moneda (position = game.at(27,  7))
	
		

		
		objetivoMonedas = 4
		dropCoin = rng.copy()
		objetos = [ vida, reloj, ataque, contadorMonedas, puerta, player, monedaHUD,tp1,r1,slime1,espada1,libro1,ghost1,moneda1,slime2,moneda2 ]
		animables = [ player, reloj, iconoEspada,slime1,ghost1,slime2 ]
		enemigos = [slime1,ghost1,slime2 ]
		
		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})

		objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
		
		self.mostrarNombreNivel()
			}
		}

object nivelFinal inherits Nivel(nombre ="nivelFinal", esNivelFinal = true) {
	const property rng = [ true ]

	override method nivelSiguiente() = nivelGanador

	override method cargar() {
	const plataformasNivel = new CreadorDePlataformas (posicionesY = [0],
													posicionesX = [[(1..38)]])
	posPlataformas = plataformasNivel.posiciones()	

	(-1 .. game.width() +1).forEach{ n => posSpikes.add(new Position(x = n, y = 26))}
	posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
	posSpikes.forEach{ p => self.dibujar(new SpikesInvertidas (position = p))}

	const boss = new Boss(position = game.at(15,25))
	const vidaBoss =new Vida(imagen = "bossHearts",
						   position = game.at(29, 36),
						   objetivo = boss)

	objetivoMonedas = 1
	dropCoin = rng.copy()
	objetos = [ vida, vidaBoss, reloj, ataque, contadorMonedas, puerta, player, monedaHUD, boss ]
	animables = [ reloj, player]
	enemigos = [boss]
	
	objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
	
	
	objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
	
	self.mostrarNombreNivel()

	}
	

}

object nivelGanador inherits Nivel(nombre = "nivelGanador"){
		
	override method nivelSiguiente() = nivel1

	override method cargar() {


	objetos = [ backgroundFinal, ataque ]
	animables = [  ]
	enemigos = [ ]
		
	objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
	objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
	

	}
}


