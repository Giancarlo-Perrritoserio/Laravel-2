<?php

namespace App\Http\Controllers;

use App\Models\Contacto;
use Illuminate\Http\Request;

class ContactoController extends Controller
{
    // Mostrar todos los contactos (solo para el index)
    public function index()
    {
        $contactos = Contacto::all(); // Obtener todos los contactos
        return view('contactos.index', compact('contactos'));
    }

    // Mostrar el formulario para crear un nuevo contacto
    public function create()
    {
        return view('contactos.create');
    }

    // Guardar el nuevo contacto
    public function store(Request $request)
    {
        $request->validate([
            'nombre' => 'required|string|max:255',
            'telefono' => 'required|string|max:20',
            'email' => 'nullable|email|max:255',
        ]);

        Contacto::create($request->all()); // Crear el contacto

        return redirect()->route('contactos.index')->with('success', 'Contacto creado correctamente.');
    }

    public function show(Contacto $contacto)
    {
        return view('contactos.show', compact('contacto'));
    }


    public function edit(Contacto $contacto)
    {
        return view('contactos.edit', compact('contacto'));
    }


    public function destroy(Contacto $contacto)
    {
        $contacto->delete(); // Eliminar el contacto

        return redirect()->route('contactos.index')->with('success', 'Contacto eliminado correctamente.');
    }

}
