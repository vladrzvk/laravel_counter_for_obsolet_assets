<?php
use App\Http\Controllers\CounterController;
use Illuminate\Support\Facades\Route;

Route::get('/home', [CounterController::class, 'home'])->name('counter.index');

