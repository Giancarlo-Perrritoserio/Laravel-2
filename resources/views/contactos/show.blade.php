<x-app-layout>
    <div class="bg-blue-900 text-white min-h-screen py-8">
        <div class="container mx-auto px-4">
            <!-- Título centrado y en mayor tamaño -->
            <h1 class="text-4xl font-bold mb-6 text-center font-helvetica">Detalles del Contacto</h1>
            
            <!-- Card de detalles del contacto -->
            <div class="bg-blue-800 rounded-lg shadow-lg p-6">
                <h5 class="text-2xl font-semibold mb-4 text-white">Nombre: {{ $contacto->nombre }}</h5>
                <p class="text-lg mb-4 text-white">Correo: {{ $contacto->email }}</p>
                <p class="text-lg mb-6 text-white">Teléfono: {{ $contacto->telefono }}</p>
                
                <!-- Botón de vuelta -->
                <a href="{{ route('contactos.index') }}" 
                    class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition duration-200">
                    Volver
                </a>
            </div>
        </div>
    </div>
</x-app-layout>
