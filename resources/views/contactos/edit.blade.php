<x-app-layout>
    <div class="bg-blue-900 text-white min-h-screen py-8">
        <div class="container mx-auto px-4">
            <!-- Título centrado y en mayor tamaño -->
            <h1 class="text-4xl font-bold mb-6 text-center font-helvetica">Editar Contacto</h1>
            
            <!-- Formulario -->
            <form action="{{ route('contactos.update', $contacto) }}" method="POST" class="bg-blue-800 p-6 rounded-lg shadow-lg">
                @csrf
                @method('PUT')
                <div class="mb-4">
                    <label for="nombre" class="block text-white mb-2">Nombre</label>
                    <input type="text" id="nombre" name="nombre" value="{{ $contacto->nombre }}" 
                        class="w-full px-4 py-2 border border-blue-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-blue-900 text-white">
                </div>
                <div class="mb-4">
                    <label for="email" class="block text-white mb-2">Correo</label>
                    <input type="email" id="email" name="email" value="{{ $contacto->email }}" 
                        class="w-full px-4 py-2 border border-blue-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-blue-900 text-white">
                </div>
                <div class="text-center">
                    <button type="submit" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition duration-200">
                        Actualizar
                    </button>
                </div>
            </form>
        </div>
    </div>
</x-app-layout>
