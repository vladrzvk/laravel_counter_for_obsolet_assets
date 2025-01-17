<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Laravel Clicker</title>
</head>
<body>
    <h1>Compteur de clics</h1>

    <p>Nombre de clics : <strong>{{ $count }}</strong></p>

    <form method="POST" action="{{ route('counter.click') }}">
        @csrf
        <button type="submit">Cliquez moi !</button>
    </form>
</body>
</html>
