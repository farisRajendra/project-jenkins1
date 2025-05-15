<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PageController;
use App\Http\Controllers\ContactController;

// Definisi route yang benar
Route::get('/', [PageController::class, 'home']);
Route::get('/about', [PageController::class, 'about']);
Route::get('/contact', [PageController::class, 'contact']);

// Route baru untuk menangani pengiriman form kontak
Route::post('/contact', [ContactController::class, 'store'])->name('contact.store');