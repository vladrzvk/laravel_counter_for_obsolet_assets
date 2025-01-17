<?php

namespace App\Http\Controllers;

use App\Models\Counter;
use Illuminate\Http\Request;

class CounterController extends Controller
{
    public function index()
    {
        // On récupère le premier enregistrement ou on le crée
        $counter = Counter::first();
        if (!$counter) {
            $counter = Counter::create(['count' => 0]);
        }

        // On retourne une vue avec la valeur du compteur
        return view('counter.index', [
            'count' => $counter->count,
        ]);
    }

    public function click(Request $request)
    {
        // Récupère le premier enregistrement
        $counter = Counter::first();
        if (!$counter) {
            $counter = Counter::create(['count' => 0]);
        }

        // Incrémente
        $counter->count = $counter->count + 1;
        $counter->save();

        // Redirige vers la page d’accueil
        return redirect('/');
    }
}
