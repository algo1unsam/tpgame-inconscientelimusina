import wollok.game.*
import juego.*
import player.*
import HUD.*
import espada.*
import slime.*
import plataformas.*
import moneda.*
import teletransportadores.*
import puerta.*
import playerHit.*
import ghost.*
import librito.*

object selectorNiveles{
	
	const property listaNiveles = [nivel4, nivel2, nivel3]
}

class Nivel {

	var property posPlataformas = []
	var property objetos = []
	var property animables = []
	var property reInstanciables = []
	var property enemigos = []
	
	
	var property objetivoMonedas = 0
	var property dropCoin = []

	
	method dibujar(dibujo) {
		game.addVisual(dibujo)
		juego.visuals().add(dibujo)
		return dibujo
	}

	method cargar()
	


}

object nivel1 inherits Nivel {
	
	const property rng = [ true ]


	override method cargar() {
			
	(1 .. game.width() - 2).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
	posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
	
	const espada1 = new Espada(position = game.at(15,  1))
	const slime1 = new Slime(position = game.at(15, 1), izquierda = 9, derecha = 22)

	const nombreNivel1 = new NombreNivel(image = "assets/nivel_1.png")
	
	objetivoMonedas = 1
	dropCoin = rng.copy()
	objetos = [ vida, reloj, espada1, slime1, ataque, contadorMonedas, puerta, player, monedaHUD ]
	animables = [  reloj, player, vida, slime1, iconoEspada ]
	reInstanciables = [espada1, slime1 ]
	enemigos = [ slime1 ]
		
	objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
	

	

	
	objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
	game.addVisual(nombreNivel1)
	game.schedule(2000, {game.removeVisual(nombreNivel1)})
	}
	

}


object nivel2 inherits Nivel {
	
	const property rng = [ true, false, false ]

	override method cargar() {


		(1 .. game.width() * (3 / 15)).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
		(game.width() * (41 / 50) .. game.width() - 2).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
		(game.width() * (1 / 10) .. game.width() + 5 ).forEach{ n => posPlataformas.add(new Position(x = n, y = (2 / 5) * game.height()))}
		(game.width() * (5 / 10) .. game.width() + 5 ).forEach{ n => posPlataformas.add(new Position(x = n, y = (3 / 5) * game.height()))}
		(0 .. game.width() * (2 / 10)).forEach{ n => posPlataformas.add(new Position(x = n, y = (7 / 10) * game.height()))}
		(game.width() * (2 / 10) .. game.width() * (17 / 50)).forEach{ n => posPlataformas.add(new Position(x = n, y = (1 / 5) * game.height()))}
		(game.width() * (22 / 50) .. game.width() * (5 / 10)).forEach{ n => posPlataformas.add(new Position(x = n, y = (1 / 5) * game.height()))}
		(game.width() * (33 / 50) .. game.width() * (37 / 50)).forEach{ n => posPlataformas.add(new Position(x = n, y = (1 / 5) * game.height()))}
		(game.width() * (40 / 50) .. game.width() + 5).forEach{ n => posPlataformas.add(new Position(x = n, y = (4 / 5) * game.height()))}
		posPlataformas.forEach{ p => self.dibujar(new Plataforma(position = p))}
		
		const espada2 = new Espada(position = game.at(juego.tamanho() * (41 / 50), (4 / 5) * juego.tamanho() + 1))
		const slime1 = new Slime(position = game.at(15, (2 / 5) * juego.tamanho() + 1), izquierda = 9, derecha = 22)
		const slime2 = new Slime(position = game.at(30, (2 / 5) * juego.tamanho() + 1), izquierda = 26, derecha = 33)
		const slime3 = new Slime(position = game.at(30, (3 / 5) * juego.tamanho() + 1), izquierda = 25, derecha = 35)
		const moneda1 = new Moneda(position = game.at(juego.tamanho() * (7 / 10), (3 / 5) * juego.tamanho() + 1))
		const moneda2 = new Moneda(position = game.at(juego.tamanho() * (1 / 10), (7 / 10) * juego.tamanho() + 1))
		const moneda3 = new Moneda(position = game.at(juego.tamanho() * (3 / 10), (2 / 5) * juego.tamanho() + 1))
		const moneda4 = new Moneda(position = game.at(juego.tamanho() * (6 / 10), (2 / 5) * juego.tamanho() + 1))
		const moneda5 = new Moneda(position = game.at(juego.tamanho() * (36 / 50), (1 / 5) * juego.tamanho() + 1))
		const nombreNivel2 = new NombreNivel(image = "assets/nivel_2.png")
		const tp1 = new Teleporter(position = game.at(juego.tamanho() * (2 / 15) + 2, 1), sprite = "assets/tp1", x = juego.tamanho() - 4, y = (3 / 5) * juego.tamanho() + 1)
		const tp2 = new Teleporter(position = game.at(juego.tamanho() - 6, (2 / 5) * juego.tamanho() + 1), sprite = "assets/tp2", x = juego.tamanho() * (2 / 10), y = (1 / 5) * juego.tamanho() + 1)
		const tp3 = new Teleporter(position = game.at(juego.tamanho() * (1 / 10) + 2, (2 / 5) * juego.tamanho() + 1), sprite = "assets/tp3", x = 1, y = (7 / 10) * juego.tamanho() + 1)
		const tp4 = new Teleporter(position = game.at(juego.tamanho() - 5, 1), sprite = "assets/tp4", x = juego.tamanho() - 4, y = (4 / 5) * juego.tamanho() + 1)
		const r1 = new Receiver(teleporter = tp1)
		const r2 = new Receiver(teleporter = tp2)
		const r3 = new Receiver(teleporter = tp3)
		const r4 = new Receiver(teleporter = tp4)
		

		objetivoMonedas = 6
		objetos = [ vida, reloj, monedaHUD, contadorMonedas, ataque, espada2, slime1, slime2, slime3, moneda1, moneda2, moneda3, moneda4, moneda5, tp1, r1, tp2, r2, tp3, r3, tp4, r4, puerta, player ]
		animables = [ player, reloj, vida, slime1, slime2, slime3, iconoEspada ]
		reInstanciables = [ slime1, slime2, slime3, moneda1, moneda2, moneda3, moneda4, moneda5, espada2 ]
		enemigos = [ slime1, slime2, slime3 ]

		
		dropCoin = rng.copy()

		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
		objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
		game.addVisual(nombreNivel2)
		game.schedule(2000, { game.removeVisual(nombreNivel2)})
	}


}

object nivel3 inherits Nivel {
	
	const property rng = [ false ]


	override method cargar() {
		
	
			
	(1 .. 12).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
	(21 .. game.width()).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
	(13 .. 20).forEach{ n => posPlataformas.add(new Position(x = n, y = 3))}
	(20 .. 22).forEach{ n => posPlataformas.add(new Position(x = n, y = 6))}
	(13 .. 18).forEach{ n => posPlataformas.add(new Position(x = n, y = 9))}
	(9 .. 11).forEach{ n => posPlataformas.add(new Position(x = n, y = 11))}
	(0 .. 5).forEach{ n => posPlataformas.add(new Position(x = n, y = 11))}
	(24 .. 27).forEach{ n => posPlataformas.add(new Position(x = n, y = 9))}
	(27 .. game.width()).forEach{ n => posPlataformas.add(new Position(x = n, y = 11))}
	posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
	
	const espada1 = new Espada (position = game.at(21,  7))
	const moneda1 = new Moneda (position = game.at(4,  12))
	const ghost1 = new Ghost(position = game.at(21, 1), izquierda = 23, derecha = 27)
	const libro1 = new Librito(position = game.at(30,  12), blancos = [ghost1])
	
	
	objetivoMonedas = 1
	dropCoin = rng.copy()
	objetos = [ vida, reloj, espada1, ghost1, ataque, contadorMonedas, puerta, player, monedaHUD, moneda1,libro1 ]
	animables = [ player, reloj, vida, ghost1, iconoEspada ]
	reInstanciables = [espada1, ghost1, moneda1, libro1 ]
	enemigos = [ ghost1 ]
		
	objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
	

	

	
	objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
	
	}
	

}

object nivel4 inherits Nivel{
	

	var property posPlataformas2 = []
	
	const property rng = [ true, true ]
	
	override method cargar() {
		
		(0 .. 6).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
		(1 .. 6).forEach{ n => posPlataformas.add(new Position(x = n, y = 33))}
		(0 .. 9).forEach{ n => posPlataformas.add(new Position(x = n, y = 28))}
		(14 .. 16).forEach{ n => posPlataformas.add(new Position(x = n, y = 28))}
		(20.. 23).forEach{ n => posPlataformas.add(new Position(x = n, y = 28))}
		(29.. game.width()).forEach{ n => posPlataformas.add(new Position(x = n, y = 28))}
		(28 .. game.width()).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
		(9 .. 12).forEach{ n => posPlataformas.add(new Position(x = n, y = 22))}
		(0 .. 4).forEach{ n => posPlataformas.add(new Position(x = n, y = 22))}
		(18 .. 24).forEach{ n => posPlataformas.add(new Position(x = n, y = 22))}
		(29 .. game.width()).forEach{ n => posPlataformas.add(new Position(x = n, y = 22))}
		(15 .. game.width()).forEach{ n => posPlataformas.add(new Position(x = n, y = 15))}
		(8 .. 12).forEach{ n => posPlataformas.add(new Position(x = n, y = 8))}
		(18 .. 20).forEach{ n => posPlataformas.add(new Position(x = n, y = 8))}
		(25 .. 28).forEach{ n => posPlataformas.add(new Position(x = n, y = 8))}
		(7.. 26).forEach{ n => posPlataformas2.add(new Position(x = n, y = 0))}
		posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
		posPlataformas2.forEach{ p => self.dibujar(new Spikes (position = p))}
		
		
		
		const slime1 = new Slime(position = game.at(30, 29), izquierda = 29, derecha = 34)
		const slime2 = new Slime(position = game.at(20, 16), izquierda = 20, derecha = 28)
		const espada1 = new Espada (position = game.at(35,  29))
		const tp1 = new Teleporter(position = game.at(1, 1), sprite = "assets/tp1", x = 1,y =34)
		const r1 = new Receiver(teleporter = tp1)
		const ghost1 = new Ghost(position = game.at(29, 23), izquierda = 19, derecha = 19)
		const libro1 = new Librito(position = game.at(1,  23), blancos = [ghost1])
		const moneda1 = new Moneda (position = game.at(32,  23))
		const moneda2 = new Moneda (position = game.at(27,  9))
		
		objetivoMonedas = 4
		dropCoin = rng.copy()
		objetos = [ vida, reloj, ataque, contadorMonedas, puerta, player, monedaHUD,tp1,r1,slime1,espada1,libro1,ghost1,moneda1,slime2,moneda2 ]
		animables = [ player, reloj, vida, iconoEspada,slime1,ghost1,slime2 ]
		reInstanciables = [ slime1,espada1,libro1,ghost1,moneda1,slime2,moneda2]
		enemigos = [slime1,ghost1,slime2 ]
		
		
		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})

		objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
		
	}
	
	
}
