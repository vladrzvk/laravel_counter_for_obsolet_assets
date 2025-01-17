use App\Http\Controllers\CounterController;
use Illuminate\Support\Facades\Route;

Route::get('/click', [CounterController::class, 'getCount']);
Route::post('/click', [CounterController::class, 'incrementCount']);
