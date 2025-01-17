<?php

use App\Http\Controllers\CounterController;
use Illuminate\Support\Facades\Route;


// Affichage du compteur sur /
Route::get('/', [CounterController::class, 'index'])->name('counter.index');

// Action POST pour incrémenter le compteur
Route::post('/', [CounterController::class, 'click'])->name('counter.click');
