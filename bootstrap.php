<?php
// Creates the first admin and an API token from ADMIN_EMAIL / ADMIN_PASSWORD / API_TOKEN, only when missing.
// An existing database keeps its users: changing the password in the app is never overwritten by a redeploy.
require '/var/www/html/vendor/autoload.php';
$app = require '/var/www/html/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use Laravel\Sanctum\PersonalAccessToken;

$email = getenv('ADMIN_EMAIL');
$password = getenv('ADMIN_PASSWORD');
$token = getenv('API_TOKEN');

$user = User::query()->where('email', $email)->first();
if ($user === null) {
    if (User::query()->doesntExist()) {
        $user = User::create(['name' => getenv('ADMIN_NAME') ?: 'Admin', 'email' => $email, 'password' => $password]);
        fwrite(STDOUT, "railway-bootstrap: admin $email created\n");
    } else {
        $user = User::query()->orderBy('id')->first();
        fwrite(STDOUT, "railway-bootstrap: users exist, admin not recreated\n");
    }
}

$hash = hash('sha256', $token);
if (! PersonalAccessToken::query()->where('token', $hash)->exists()) {
    $user->tokens()->forceCreate([
        'name' => 'railway-agent',
        'token' => $hash,
        'abilities' => ['*'],
    ]);
    fwrite(STDOUT, "railway-bootstrap: API token railway-agent created\n");
}
