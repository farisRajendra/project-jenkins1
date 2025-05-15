<?php

namespace App\Http\Controllers;

use App\Models\Contact;
use Illuminate\Http\Request;

class ContactController extends Controller
{
    public function index()
    {
        return view('contact');
    }
    
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nama' => 'required|max:255',
            'email' => 'required|email|max:255',
            'subjek' => 'required|max:255',
            'pesan' => 'required',
        ]);
        
        Contact::create($validatedData);
        
        return redirect()->back()->with('success', 'Pesan Anda telah berhasil dikirim!');
    }
}