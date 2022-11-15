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
	const property rng = [ true ]
	const property esNivelFinal = false
	const nombre
	const plataformas = [[],[]]
	const nombreNivel = new NombreNivel(image = "assets/" + nombre + ".png")
	const nivelConPlataformas = true
	
	
	
	var property objetivoMonedas = 0
	var property dropCoin = []
	
		
	method dibujar(dibujo) {
		game.addVisual(dibujo)
		juego.visuals().add(dibujo)
		return dibujo
	}

	method cargar(){
		if (nivelConPlataformas){
		const plataformasNivel = new CreadorDePlataformas (posicionesY = plataformas.first(), posicionesX = plataformas.last() )
		posPlataformas = plataformasNivel.posiciones()
		posPlataformas.forEach{ p => self.dibujar(new Plataforma (position = p))}
		self.mostrarNombreNivel()}
		dropCoin = rng.copy()
		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
		objetos.forEach({ unObjeto => juego.visuals().add(unObjeto)})
		
	}
	
	method nivelSiguiente()
	
	method mostrarNombreNivel(){
		game.addVisual(nombreNivel)
		game.schedule(2000, {game.removeVisual(nombreNivel)})
	}
	
	method limpiar(){
		[objetos, animables, enemigos, plataformas, posPlataformas].forEach({x=> x.clear()})
	}
}

object pantallaInicio inherits Nivel(nombre = "inicio", nivelConPlataformas = false,
									objetos = [ backgroundInicio, espacioParaComenzar ],
									enemigos = [ espacioParaComenzar ]){
	
	var property primeraInstanciacion = true
	
	override method nivelSiguiente() = nivel1
		
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



object nivel1 inherits Nivel(nombre = "nivel1", objetivoMonedas = 1, rng = [true], plataformas = [[0], [[(1 .. game.width() - 2)]]]
) {					
	
	method initialize(){
	objetos = [ vida, reloj, new Espada(position = game.at(15,  1)), new Slime(position = game.at(15, 1), izquierda = 9, derecha = 22), ataque, contadorMonedas, puerta, player,  monedaHUD]
	animables = [  reloj, player, objetos.get(3), iconoEspada]
	enemigos = [ objetos.get(3) ]		}																
	

	override method nivelSiguiente() = nivel2


}

object nivel2 inherits Nivel(nombre ="nivel2", objetivoMonedas = 1, rng = [false], plataformas = [[0, 3, 6, 8, 10, 11], [[(1 .. 12), (21.. 40)],
																									[(13..20)],
																									[(20..22)],
																									[(13..18), (24..27)],
																									[(9..11)],
																									[(0..5), (27..45)]]]) {
	
	override method nivelSiguiente() = nivel3
	
	method initialize(){
		objetos = [ vida, reloj, new Espada (position = game.at(21,  7)), new Ghost(position = game.at(21, 1), izquierda = 19, derecha = 27), ataque, contadorMonedas, puerta, player, monedaHUD, new Moneda (position = game.at(4,  12))]
		objetos.add( new Librito(position = game.at(30,  12), blancos = [objetos.get(3)]) )
		animables = [  player, reloj,   objetos.get(3), iconoEspada ]
		enemigos = [ objetos.get(3) ]		}	

	}

object nivel3 inherits Nivel(nombre ="nivel3", objetivoMonedas = 4, rng = [false], plataformas = [[0, 7, 13, 21, 30], [[(0..6), (33.. 45)],
																									[(0..9)],
																									[(0..14)],
																									[(0 .. 20)],
																									[(0..45)]
																									]]){
	
	
	override method nivelSiguiente() = nivel4
	
	method initialize(){
		objetos = [vida, reloj, new Slime(position = game.at(10, 14), izquierda = 2, derecha = 13), ataque, contadorMonedas, puerta, player, monedaHUD,new Teleporter(position = game.at(0, 1), sprite = "assets/tp1", x = 0,y = 8), new Teleporter(position = game.at(5,1), sprite = "assets/tp2", x = 33, y = 1),new Teleporter(position = game.at(game.width()-2,1), sprite = "assets/tp3", x = 11, y = 14),new Teleporter(position = game.at(8,8), sprite = "assets/tp4", x = 0, y = 22),new Teleporter(position = game.at(0, 14), sprite = "assets/tp5", x = 0,y =31),new Teleporter(position = game.at(19, 22), sprite = "assets/tp5", x = 0,y =31),new Moneda (position = game.at(36, 1 )), new Moneda (position = game.at(5, 8 )), new Moneda (position = game.at(12, 22 )),  new Moneda (position = game.at(12, 31 ))]
		objetos.addAll([new Receiver(teleporter = objetos.get(8)), new Receiver(teleporter = objetos.get(9)), new Receiver(teleporter = objetos.get(10)), new Receiver(teleporter = objetos.get(11)), new Receiver(teleporter = objetos.get(12)), new Receiver(teleporter = objetos.get(13)) ])
		animables = [  player, reloj,   objetos.get(2), iconoEspada ]
		enemigos = [ objetos.get(2) ]	}	
	

	override method cargar(){
		
		puerta.position(game.at(33,31))
		
		(18 .. 18).forEach{ n => posSpikes.add(new Position(x = n, y = 31))}
		posSpikes.forEach{ p => self.dibujar(new Spikes (position = p))}

		super()
	}
	}

object nivel4 inherits Nivel(nombre ="nivel4", objetivoMonedas = 6, rng = [ true, false, false ], plataformas = [[0, 8, 16, 24, 28, 32], [[(1 .. 7), (31.. 38)],
																														[(8..14), (18..21), (26..30)],
																														[(4..45)],
																														[(20..45)],
																														[(0..8)],
																														[(32..45)]]]){
	
	
	method initialize(){
		objetos = [ vida, reloj, monedaHUD, contadorMonedas, ataque,  new Espada(position = game.at(33, 33)),  new Slime(position = game.at(15, 17), izquierda = 9, derecha = 22), new Slime(position = game.at(30, 17), izquierda = 26, derecha = 33), new Slime(position = game.at(30, 25), izquierda = 25, derecha = 35),new Moneda(position = game.at(28, 25)), new Moneda(position = game.at(4, 29)), new Moneda(position = game.at(12, 17)), new Moneda(position = game.at(24, 17)), new Moneda(position = game.at(29, 9)),new Teleporter(position = game.at(7, 1), sprite = "assets/tp1", x = 36, y = 25), new Teleporter(position = game.at(34, 17), sprite = "assets/tp2", x = 8, y = 9), new Teleporter(position = game.at(6, 17), sprite = "assets/tp3", x = 1, y = 29), new Teleporter(position = game.at(35, 1), sprite = "assets/tp4", x = 36, y = 33) , puerta, player ]
		objetos.addAll([new Receiver(teleporter = objetos.get(14)), new Receiver(teleporter = objetos.get(15)), new Receiver(teleporter = objetos.get(16)), new Receiver(teleporter = objetos.get(17))])
		animables = [  player, reloj,   objetos.get(6),   objetos.get(7),   objetos.get(8), iconoEspada ]
		enemigos = [ objetos.get(6),   objetos.get(7),   objetos.get(8)]	}	
	
	override method nivelSiguiente() = nivel5

	override method cargar() {
		puerta.position(game.at(32,1))	
		super()
	}
}

object nivel5 inherits Nivel(nombre ="nivel5", objetivoMonedas = 4, rng = [  true, true ], plataformas = [[0, 6, 12, 19, 25, 30], [[(0..6), (28.. 45)],
																											[(8..12), (17..20), (24..27)],
																											[(15..45)],
																											[(0 .. 4), (9 .. 12), (18..24), (29..45)],
																											[(0..9), (14..16), (20..23), (28..45)],
																											[(1..6)]
																											]]){
	
	
	method initialize(){
		objetos = [ vida, reloj, ataque, contadorMonedas, puerta, player, monedaHUD, new Teleporter(position = game.at(1, 1), sprite = "assets/tp1", x = 1,y =31),new Slime(position = game.at(30, 26), izquierda = 29, derecha = 34), new Slime(position = game.at(20, 13), izquierda = 20, derecha = 28), new Espada (position = game.at(35,  26)),new Ghost(position = game.at(29, 20), izquierda = 19, derecha = 19),new Moneda (position = game.at(32,  20)),new Moneda (position = game.at(27,  7)) ]
		objetos.addAll( [new Receiver( teleporter = objetos.get(7)), new Librito(position = game.at(1,  20), blancos = [objetos.get(11)])])
		animables = [  player, reloj,   objetos.get(8), objetos.get(9),objetos.get(11), iconoEspada ]
		enemigos = [ objetos.get(8), objetos.get(9),objetos.get(11)  ]	}	
	
	override method nivelSiguiente() = nivelFinal
	
	override method cargar() {
	

		(7.. 26).forEach{ n => posSpikes.add(new Position(x = n, y = 0))}
		posSpikes.forEach{ p => self.dibujar(new Spikes (position = p))}

		super()
			}
		}

object nivelFinal inherits Nivel(nombre ="nivelFinal", esNivelFinal = true, objetivoMonedas = 1, rng = [ true ], plataformas = [[0], [[(2..37)]]]) {


	method initialize(){
		objetos = [ vida, reloj, ataque, contadorMonedas, puerta, player, monedaHUD, new Boss(position = game.at(15,25)) ]
		objetos.add(new Vida(imagen = "bossHearts", position = game.at(29, 36), objetivo = objetos.get(7)))
		animables = [  player, reloj ]
		enemigos = [ objetos.get(7)  ]	}	
	
	override method nivelSiguiente() = nivelGanador

	override method cargar() {

	(-1 .. game.width() +1).forEach{ n => posSpikes.add(new Position(x = n, y = 26))}

	posSpikes.forEach{ p => self.dibujar(new SpikesInvertidas (position = p))}
	
	super()
	}
	

}

object nivelGanador inherits Nivel(nombre = "nivelGanador", nivelConPlataformas = false){
		
	override method nivelSiguiente() = nivel1

	override method mostrarNombreNivel(){}

	override method cargar() {


	objetos = [ backgroundFinal, ataque]
	animables = [player]
	enemigos = [ ]
	
	super()
	

	}
}


