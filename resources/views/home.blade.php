@extends('layouts.app')

@section('title', 'Home')

@section('content')
<div class="jumbotron bg-light p-5 rounded">
    <h1 class="display-4">Selamat Datang!</h1>
    <p class="lead">Ini adalah halaman frontend sederhana untuk aplikasi Laravel Anda.</p>
    <hr class="my-4">
    <p>Gunakan template ini sebagai titik awal untuk mengembangkan frontend aplikasi Anda.</p>
    <a class="btn btn-primary btn-lg" href="#" role="button">Mulai Sekarang</a>
</div>

<div class="row mt-4">
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">Fitur 1</h5>
                <p class="card-text">Deskripsi singkat tentang fitur pertama aplikasi Anda.</p>
                <a href="#" class="btn btn-sm btn-outline-primary">Pelajari Lebih Lanjut</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">Fitur 2</h5>
                <p class="card-text">Deskripsi singkat tentang fitur kedua aplikasi Anda.</p>
                <a href="#" class="btn btn-sm btn-outline-primary">Pelajari Lebih Lanjut</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">Fitur 3</h5>
                <p class="card-text">Deskripsi singkat tentang fitur ketiga aplikasi Anda.</p>
                <a href="#" class="btn btn-sm btn-outline-primary">Pelajari Lebih Lanjut</a>
            </div>
        </div>
    </div>
</div>
@endsection