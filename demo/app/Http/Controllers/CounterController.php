<?php

namespace App\Http\Controllers;

use App\Models\Counter;

class CounterController extends Controller
{
    public function incrementCount()
    {
        // Récupère le premier enregistrement (ou crée-le s'il n'existe pas)
        $counter = Counter::first();
        if (!$counter) {
            $counter = Counter::create(['count' => 0]);
        }

        // Incrémente le champ count
        $counter->count = $counter->count + 1;
        $counter->save();

        return response()->json([
            'message' => 'Click enregistré',
            'count'   => $counter->count,
        ], 200);
    }
}
