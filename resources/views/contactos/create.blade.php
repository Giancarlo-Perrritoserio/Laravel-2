<x-app-layout>
    <div class="bg-blue-900 text-white min-h-screen py-8">
        <div class="container mx-auto px-4">
            <!-- Título centrado y en mayor tamaño -->
            <h1 class="text-4xl font-bold mb-6 text-center font-helvetica">Nuevo Contacto</h1>
            
            <!-- Formulario para crear un nuevo contacto -->
            <form action="{{ route('contactos.store') }}" method="POST" class="bg-blue-800 p-6 rounded-lg shadow-md">
                @csrf

                <!-- Campo de nombre -->
                <div class="mb-4">
                    <label for="nombre" class="block text-white mb-2">Nombre</label>
                    <input type="text" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" id="nombre" name="nombre" required>
                </div>

                <!-- Campo de teléfono -->
                <div class="mb-4">
                    <label for="telefono" class="block text-white mb-2">Teléfono</label>
                    <input type="text" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" id="telefono" name="telefono" required>
                </div>

                <!-- Campo de correo -->
                <div class="mb-4">
                    <label for="email" class="block text-white mb-2">Correo Electrónico</label>
                    <input type="email" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" id="email" name="email">
                </div>

                <!-- Botón para guardar -->
                <button type="submit" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition duration-200">
                    Guardar
                </button>
            </form>
        </div>
    </div>
</x-app-layout>
