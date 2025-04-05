<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ContactoController;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');


    Route::get('contactos', [ContactoController::class, 'index'])->name('contactos.index');
    Route::get('contactos/create', [ContactoController::class, 'create'])->name('contactos.create');
    Route::post('contactos', [ContactoController::class, 'store'])->name('contactos.store');

    Route::get('contactos/{contacto}', [ContactoController::class, 'show'])->name('contactos.show');
    Route::get('contactos/{contacto}/edit', [ContactoController::class, 'edit'])->name('contactos.edit');
    Route::put('contactos/{contacto}', [ContactoController::class, 'update'])->name('contactos.update');
    Route::delete('contactos/{contacto}', [ContactoController::class, 'destroy'])->name('contactos.destroy');

});

require __DIR__.'/auth.php';
