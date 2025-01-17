<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Counter extends Model
{
    use HasFactory;

    protected $table = 'counters';

    // Par défaut Laravel s'attend à un champ 'id' auto-incrémenté
    // Le champ 'count' est un integer dans ta migration

    protected $fillable = [
        'count',
    ];
}
