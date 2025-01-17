use App\Http\Controllers\CounterController;

Route::get('/home', [CounterController::class, 'home'])->name('counter.home');
