<x-app-layout>
    <div class="bg-blue-900 text-white min-h-screen py-8">
        <div class="container mx-auto px-4">
            <!-- Título centrado y en mayor tamaño -->
            <h1 class="text-5xl font-bold mb-6 text-center font-helvetica">Lista de Contactos</h1>
            
            <!-- Botón "Nuevo Contacto" -->
            <div class="text-center mb-6">
                <a href="{{ route('contactos.create') }}" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-4 focus:ring-blue-500 transition duration-200">
                    Nuevo Contacto
                </a>
            </div>
            
            <!-- Tabla con fondo transparente y texto blanco -->
            <div class="overflow-x-auto bg-transparent rounded-lg shadow-lg">
                <table class="table-auto w-full text-white">
                    <thead class="bg-blue-800 text-lg">
                        <tr>
                            <th class="px-6 py-3 text-left">Nombre</th>
                            <th class="px-6 py-3 text-left">Correo</th>
                            <th class="px-6 py-3 text-left">Teléfono</th>
                            <th class="px-6 py-3 text-left">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($contactos as $contacto)
                        <tr class="border-b border-gray-700 hover:bg-blue-700">
                            <td class="px-6 py-4">{{ $contacto->nombre }}</td>
                            <td class="px-6 py-4">{{ $contacto->email }}</td>
                            <td class="px-6 py-4">{{ $contacto->telefono }}</td>
                            <td class="px-6 py-4 space-x-2">
                                <a href="{{ route('contactos.show', $contacto) }}" class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition duration-200">Ver</a>
                                <a href="{{ route('contactos.edit', $contacto) }}" class="bg-yellow-500 text-white px-4 py-2 rounded-lg hover:bg-yellow-600 transition duration-200">Editar</a>
                                <form action="{{ route('contactos.destroy', $contacto) }}" method="POST" class="inline-block">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition duration-200" onclick="return confirm('¿Estás seguro?')">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</x-app-layout>
