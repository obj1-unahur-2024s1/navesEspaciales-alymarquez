
class Nave {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method acelerar(cantidad){
		velocidad = 100000.min(velocidad + cantidad)
	}
	
	method desacelerar(cantidad){
		velocidad = 0.max(velocidad - cantidad)
	}
	
	method velocidad() = velocidad
	
	method irHaciaElSol(){
		direccion = 10
	}
	
	method escaparDelSol(){
		direccion = -10
	}
	
	method ponerseParaleloAlSol(){
		direccion = 0
	}
	
	method acercarseUnPocoAlSol(){
		direccion = 10.min(direccion + 1)
	}
	
	method alejarseUnPocoDelSol(){
		direccion = -10.max(direccion - 1)
	}
	
	method direccion() = direccion
	
	method cargarCombustible(cantidad){
		combustible += cantidad
	}
	
	method descargarCombustible(cantidad){
		combustible = (combustible - cantidad).max(0)
	}
	
	method combustible() = combustible
	
	method estaTranquila() = combustible >= 400 and velocidad <= 12000
	
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	method escapar(){}
	
	method avisar(){}
	
	method tienePocaActividad() = true
	
	method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()
	
}


class NaveBaliza inherits Nave{
	var property colorBaliza
	var cambioColor = false
	
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		cambioColor = true
	}
	
	override method prepararViaje(){
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
		super()
	}
	
	override method estaTranquila() =
		super() and colorBaliza != "rojo"
		
	override method escapar(){
		self.irHaciaElSol()
	}
	
	override method avisar(){
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method tienePocaActividad() = not cambioColor
}


class NavePasajeros inherits Nave{
	var property cantidadPasajeros = 0
	var property racionesComida = 0
	var property racionesBebida = 0
	var comidaServida = 0
	
	method cargarComida(cantidad){
		racionesComida += cantidad
	}
	
	method descargarComida(cantidad){
		racionesComida -= (racionesComida - cantidad).max(0)
	}
	
	method cargarBebida(cantidad){
		racionesBebida += cantidad
	}
	
	method descargarBebida(cantidad){
		racionesBebida -= (racionesBebida - cantidad).max(0)
	}
	
	method servirComida(cantidad){
		comidaServida += cantidad.min(racionesComida)
		self.descargarComida(cantidad)
	}
	
	override method prepararViaje(){
		self.cargarComida(4 * cantidadPasajeros)
		self.cargarBebida(6 * cantidadPasajeros)
		self.acercarseUnPocoAlSol()
		super()
	}
	
	override method escapar(){
		self.acelerar(velocidad * 2)
	}
	
	override method avisar(){
		self.servirComida(cantidadPasajeros)
		self.descargarBebida(cantidadPasajeros*2)
	}
	
	override method tienePocaActividad() = comidaServida < 50

}


class NaveCombate inherits Nave{
	
	var property estaInvisible
	var property misilesDesplegados
	const mensajes = []
	
	method ponerseVisible(){
		estaInvisible = false
	}
	
	method ponerseInvisible(){
		estaInvisible = true
	}
	
	method desplegarMisiles(){
		misilesDesplegados = true
	}
	
	method replegarMisiles(){
		misilesDesplegados = false
	}
	
	method emitirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	
	method mensajesEmitidos() = mensajes
	
	method primerMensajeEmitido() = mensajes.first()
	
	method ultimoMensajeEmitido() = mensajes.last()
	
	method esEscueta() = not mensajes.any({x => x.size() > 30})
	
	method emitioMensaje(mensaje){
		mensajes.constain(mensaje)
	}
	
	override method prepararViaje(){
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
		super()
	}
	
	override method estaTranquila() =
		super() and not misilesDesplegados
		
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method tienePocaActividad() = self.esEscueta()
}


class NaveHospital inherits NavePasajeros{
	var property quirofanoPreparado
	
	method prepararQuirofanos(){
		quirofanoPreparado = true
	}
	
	override method estaTranquila() =
		super() and not quirofanoPreparado 
	
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()
	}
	
}


class NaveCombateSigilosa inherits NaveCombate{
	override method estaTranquila() =
		super() and not estaInvisible
	
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}


