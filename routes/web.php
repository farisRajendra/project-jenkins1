<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PageController;

// Definisi route yang benar
Route::get('/', [PageController::class, 'home']);
Route::get('/about', [PageController::class, 'about']);
Route::get('/contact', [PageController::class, 'contact']);