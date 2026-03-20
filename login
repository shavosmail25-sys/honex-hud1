
<!DOCTYPE html>
<html lang="ka">
<head>
    <meta charset="UTF-8">
    <title>Login - HONEX RP</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@700;900&family=Rajdhani:wght@500;700&family=Montserrat:wght@800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        html, body {
            margin: 0; padding: 0; background: transparent; overflow: hidden;
            width: 100%; height: 100%; font-family: 'Rajdhani', sans-serif; color: white;
        }

        :root {
            --main-gold: #ffcc00;
            --glow-gold: rgba(255, 204, 0, 0.7);
            --bg-color: rgba(15, 15, 18, 0.85);
            --border-color: rgba(255, 204, 0, 0.3);
            --error-color: #f44336;
        }

        /* ბნელი ფონი მთელ ეკრანზე */
        #login-overlay {
            display: none; 
            position: absolute; top: 0; left: 0; 
            width: 100%; height: 100%; 
            background: rgba(0,0,0,0.75); 
            backdrop-filter: blur(8px); 
            z-index: 10000;
        }

        /* --- ლოგინის პანელი (აბსოლუტური ცენტრი და დაპატარავებული ზომა) --- */
        #login-panel {
            position: absolute;
            top: 50%;
            left: 50%;
            /* translate(-50%, -50%) სვამს ზუსტად შუაში ყველა ეკრანზე */
            transform: translate(-50%, -50%); 
            
            width: 280px; /* იყო 380px, საგრძნობლად დაპატარავდა */
            padding: 25px; /* იყო 40px */
            
            background: var(--bg-color);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.7);
            
            display: flex; flex-direction: column; gap: 15px; /* დაშორებები შემცირდა */
            text-align: center;
            border-top: 4px solid var(--main-gold);
            
            animation: fadeInCenter 0.5s ease-out forwards;
            opacity: 0;
        }

        .logo-forge {
            font-family: 'Orbitron', sans-serif; font-size: 24px; font-weight: 900; 
            color: var(--main-gold); text-shadow: 0 0 10px var(--glow-gold); 
            font-style: italic; margin: 0;
        }

        .welcome-text { font-size: 13px; color: #bdc3c7; margin: 0; margin-top: 3px; }

        .username-container {
            font-size: 18px; font-weight: 800; color: white;
            background: rgba(255, 255, 255, 0.05);
            padding: 10px; border-radius: 5px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .input-wrapper { text-align: left; }
        .input-wrapper label { font-size: 12px; color: var(--main-gold); font-weight: 700; margin-bottom: 5px; display: inline-block; }
        
        .password-field {
            width: 100%; box-sizing: border-box; padding: 10px;
            background: rgba(0,0,0,0.6); border: 1px solid var(--border-color);
            color: white; border-radius: 4px; outline: none;
            font-family: 'Rajdhani', sans-serif; font-size: 15px; font-weight: bold; text-align: center;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .password-field:focus { border-color: var(--main-gold); box-shadow: 0 0 8px var(--glow-gold); }

        .error-message { font-size: 13px; color: var(--error-color); font-weight: 700; min-height: 15px; }
        .attempts-counter { font-size: 13px; color: #fff; opacity: 0.8; }

        .login-btn {
            background: linear-gradient(90deg, #b38f00, #ffcc00);
            border: none; padding: 12px;
            color: black; font-weight: 900;
            font-family: 'Montserrat', sans-serif; font-size: 15px;
            border-radius: 4px; cursor: pointer; text-transform: uppercase;
            box-shadow: 0 4px 10px rgba(255, 204, 0, 0.3);
            transition: transform 0.2s, background 0.3s;
        }
        
        .login-btn:hover { background: linear-gradient(90deg, #d4af37, #ffcc00); transform: translateY(-1px); }
        .login-btn:active { transform: translateY(1px); }

        /* ახალი ანიმაცია, რომელიც ცენტრშივე ამოდის */
        @keyframes fadeInCenter {
            0% { opacity: 0; transform: translate(-50%, -45%); }
            100% { opacity: 1; transform: translate(-50%, -50%); }
        }

    </style>
</head>
<body>

    <div id="login-overlay">
        <div id="login-panel">
            <div>
                <h1 class="logo-forge">HONEX RP</h1>
                <p class="welcome-text">მოგესალმებით სერვერზე!</p>
            </div>
            
            <div class="username-container" id="login-username">Player_Name</div>
            
            <div class="input-wrapper">
                <label><i class="fas fa-lock"></i> შეიყვანეთ პაროლი</label>
                <input type="password" id="login-password" class="password-field" placeholder="••••••••">
            </div>
            
            <div class="error-message" id="login-error"></div>
            <div class="attempts-counter" id="login-attempts">დარჩენილია 4 ცდა</div>
            
            <button onclick="submitLogin()" class="login-btn">ავტორიზაცია <i class="fas fa-sign-in-alt"></i></button>
        </div>
    </div>

    <script>
        function submitLogin() {
            const pass = document.getElementById("login-password").value;
            const errorField = document.getElementById("login-error");

            if(pass.length < 1) {
                errorField.innerText = "შეიყვანეთ პაროლი!";
                return;
            }

            if (typeof cef !== 'undefined') {
                cef.emit("server:verifyLogin", pass);
                errorField.innerText = ""; 
            }
        }

        document.getElementById("login-password").addEventListener("keypress", function(event) {
            if (event.key === "Enter") {
                event.preventDefault();
                submitLogin();
            }
        });

        if (typeof cef !== 'undefined') {
            cef.on("showLoginPanel", function(playerName, attempts) {
                document.getElementById("login-overlay").style.display = "block"; // flex-ის მაგივრად block, რადგან absolute-ით ვსვამთ შუაში
                document.getElementById("login-username").innerText = playerName;
                document.getElementById("login-attempts").innerText = "დარჩენილია " + attempts + " ცდა";
                
                setTimeout(() => { document.getElementById("login-password").focus(); }, 100);
            });
        }
    </script>
</body>
</html>
